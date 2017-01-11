
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
#import "CapeVector.h"
#import "CapeStack.h"

@implementation CapeStack

{
	NSMutableArray* data;
}

- (CapeStack*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	self->data = [[NSMutableArray alloc] init];
	return(self);
}

- (void) push:(id)o {
	[CapeVector append:self->data object:o];
}

- (id) pop {
	int sz = [CapeVector getSize:self->data];
	if(sz < 1) {
		return(nil);
	}
	id v = [CapeVector getAt:self->data index:sz - 1];
	[CapeVector remove:self->data index:sz - 1];
	return(v);
}

- (id) peek {
	int sz = [CapeVector getSize:self->data];
	if(sz < 1) {
		return(nil);
	}
	return([CapeVector getAt:self->data index:sz - 1]);
}

- (BOOL) isEmpty {
	return([self getSize] < 1);
}

- (int) getSize {
	return([CapeVector getSize:self->data]);
}

- (NSMutableArray*) getData {
	return(self->data);
}

- (CapeStack*) setData:(NSMutableArray*)v {
	self->data = v;
	return(self);
}

@end
