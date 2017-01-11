
/*
 * This file is part of Jkop for iOS
 * Copyright (c) 2016-2017 Job and Esther Technologies, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "CapeTimeValue.h"

@implementation CapeTimeValue

{
	long long seconds;
	long long microSeconds;
}

- (CapeTimeValue*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->microSeconds = ((long long)0);
	self->seconds = ((long long)0);
	return(self);
}

+ (CapeTimeValue*) forSeconds:(long long)seconds {
	CapeTimeValue* v = [[CapeTimeValue alloc] init];
	v->seconds = seconds;
	return(v);
}

- (CapeTimeValue*) dup {
	CapeTimeValue* v = [[CapeTimeValue alloc] init];
	[v copyFrom:self];
	return(v);
}

- (void) reset {
	self->seconds = ((long long)0);
	self->microSeconds = ((long long)0);
}

- (void) copyFrom:(CapeTimeValue*)tv {
	self->seconds = tv->seconds;
	self->microSeconds = tv->microSeconds;
}

- (void) set:(CapeTimeValue*)tv {
	self->seconds = [tv getSeconds];
	self->microSeconds = [tv getMicroSeconds];
}

- (void) setSeconds:(long long)value {
	self->seconds = value;
}

- (void) setMilliSeconds:(long long)value {
	self->microSeconds = value * 1000;
}

- (void) setMicroSeconds:(long long)value {
	self->microSeconds = value;
}

- (CapeTimeValue*) addSignedLongIntegerAndSignedLongInteger:(long long)s us:(long long)us {
	long long ts = [self getSeconds] + s;
	long long tus = [self getMicroSeconds] + us;
	if(tus > 1000000) {
		ts += tus / 1000000;
		tus = tus % 1000000;
	}
	while(tus < 0) {
		ts--;
		tus += ((long long)1000000);
	}
	CapeTimeValue* v = [[CapeTimeValue alloc] init];
	v->seconds = ts;
	v->microSeconds = tus;
	return(v);
}

- (CapeTimeValue*) addTimeValue:(CapeTimeValue*)tv {
	if(tv == nil) {
		return(self);
	}
	return([self addSignedLongIntegerAndSignedLongInteger:[tv getSeconds] us:[tv getMicroSeconds]]);
}

- (CapeTimeValue*) subtract:(CapeTimeValue*)tv {
	if(tv == nil) {
		return(self);
	}
	return([self addSignedLongIntegerAndSignedLongInteger:-[tv getSeconds] us:-[tv getMicroSeconds]]);
}

- (long long) asMicroSeconds {
	return(((long long)([self getSeconds] * 1000000 + [self getMicroSeconds])));
}

+ (long long) diff:(CapeTimeValue*)a b:(CapeTimeValue*)b {
	if(a == nil && b == nil) {
		return(((long long)0));
	}
	if(a == nil) {
		return([b asMicroSeconds]);
	}
	if(b == nil) {
		return([a asMicroSeconds]);
	}
	long long r = (a->seconds - b->seconds) * 1000000 + a->microSeconds - b->microSeconds;
	return(r);
}

+ (double) diffDouble:(CapeTimeValue*)a b:(CapeTimeValue*)b {
	return(((double)([CapeTimeValue diff:a b:b] / 1000000.0)));
}

- (long long) getSeconds {
	return(self->seconds);
}

- (long long) getMicroSeconds {
	return(self->microSeconds);
}

@end
