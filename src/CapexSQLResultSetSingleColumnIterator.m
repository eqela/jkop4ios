
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
#import "CapeDynamicIterator.h"
#import "CapeStringIterator.h"
#import "CapeIntegerIterator.h"
#import "CapeDoubleIterator.h"
#import "CapeBooleanIterator.h"
#import "CapeIterator.h"
#import "CapexSQLResultSetIterator.h"
#import "CapeDynamicMap.h"
#import "CapexSQLResultSetSingleColumnIterator.h"

@implementation CapexSQLResultSetSingleColumnIterator

{
	CapexSQLResultSetIterator* iterator;
	NSString* columnName;
}

- (CapexSQLResultSetSingleColumnIterator*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->columnName = nil;
	self->iterator = nil;
	return(self);
}

- (CapeDynamicMap*) nextMap {
	if(self->iterator == nil) {
		return(nil);
	}
	CapeDynamicMap* r = [self->iterator next];
	if(r == nil) {
		return(nil);
	}
	return(r);
}

- (id) next {
	CapeDynamicMap* m = [self nextMap];
	if(m == nil) {
		return(nil);
	}
	return([m get:self->columnName]);
}

- (NSString*) nextString {
	CapeDynamicMap* m = [self nextMap];
	if(m == nil) {
		return(nil);
	}
	return([m getString:self->columnName defval:nil]);
}

- (int) nextInteger {
	CapeDynamicMap* m = [self nextMap];
	if(m == nil) {
		return(0);
	}
	return([m getInteger:self->columnName defval:0]);
}

- (double) nextDouble {
	CapeDynamicMap* m = [self nextMap];
	if(m == nil) {
		return(0.0);
	}
	return([m getDouble:self->columnName defval:0.0]);
}

- (BOOL) nextBoolean {
	CapeDynamicMap* m = [self nextMap];
	if(m == nil) {
		return(FALSE);
	}
	return([m getBoolean:self->columnName defval:FALSE]);
}

- (CapexSQLResultSetIterator*) getIterator {
	return(self->iterator);
}

- (CapexSQLResultSetSingleColumnIterator*) setIterator:(CapexSQLResultSetIterator*)v {
	self->iterator = v;
	return(self);
}

- (NSString*) getColumnName {
	return(self->columnName);
}

- (CapexSQLResultSetSingleColumnIterator*) setColumnName:(NSString*)v {
	self->columnName = v;
	return(self);
}

@end
