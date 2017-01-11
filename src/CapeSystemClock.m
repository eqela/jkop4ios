
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
#import "CapeSystemClock.h"

@implementation CapeSystemClock

#include <time.h>
#include <sys/time.h>

- (CapeSystemClock*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (long long) asSeconds {
	long long v = ((long long)0);
	v = time(NULL);
	return(v);
}

+ (CapeTimeValue*) asTimeValue {
	CapeTimeValue* v = [[CapeTimeValue alloc] init];
	[CapeSystemClock update:v];
	return(v);
}

+ (void) update:(CapeTimeValue*)v {
	if(v == nil) {
		return;
	}
	int sec = 0;
	int usec = 0;
	struct timeval tv;
	gettimeofday(&tv, (void*)0);
	sec = tv.tv_sec;
	usec = tv.tv_usec;
	[v setSeconds:((long long)sec)];
	[v setMicroSeconds:((long long)usec)];
}

@end
