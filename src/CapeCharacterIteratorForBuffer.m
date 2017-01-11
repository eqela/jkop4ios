
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
#import "CapeCharacterDecoder.h"
#import "CapeDuplicateable.h"
#import "CapeBuffer.h"
#import "CapeCharacterIteratorForBuffer.h"

@implementation CapeCharacterIteratorForBuffer

{
	NSMutableData* buffer;
	int currentPosition;
}

- (CapeCharacterIteratorForBuffer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->currentPosition = -1;
	self->buffer = nil;
	return(self);
}

- (CapeCharacterIteratorForBuffer*) initWithBuffer:(NSMutableData*)buffer {
	if([super init] == nil) {
		return(nil);
	}
	self->currentPosition = -1;
	self->buffer = nil;
	self->buffer = buffer;
	return(self);
}

- (BOOL) moveToPreviousByte {
	if(self->currentPosition < 1) {
		return(FALSE);
	}
	self->currentPosition--;
	return(TRUE);
}

- (BOOL) moveToNextByte {
	if(self->currentPosition + 1 >= [CapeBuffer getSize:self->buffer]) {
		return(FALSE);
	}
	self->currentPosition++;
	return(TRUE);
}

- (int) getCurrentByte {
	return(((int)[CapeBuffer getByte:self->buffer offset:((long long)self->currentPosition)]));
}

- (id) duplicate {
	CapeCharacterIteratorForBuffer* v = [[CapeCharacterIteratorForBuffer alloc] init];
	[super copyTo:((CapeCharacterDecoder*)v)];
	v->buffer = self->buffer;
	v->currentPosition = self->currentPosition;
	return(((id)v));
}

@end
