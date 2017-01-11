
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
#import "CapeWriter.h"
#import "CapeBuffer.h"
#import "CapeBufferWriter.h"

@implementation CapeBufferWriter

{
	NSMutableData* buffer;
	int pos;
}

- (CapeBufferWriter*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->pos = 0;
	self->buffer = nil;
	return(self);
}

+ (CapeBufferWriter*) forBuffer:(NSMutableData*)buf {
	CapeBufferWriter* v = [[CapeBufferWriter alloc] init];
	v->buffer = buf;
	return(v);
}

- (int) getBufferSize {
	return(((int)[CapeBuffer getSize:self->buffer]));
}

- (int) getBufferPos {
	return(0);
}

- (NSMutableData*) getBuffer {
	return(self->buffer);
}

- (int) write:(NSMutableData*)src ssize:(int)ssize {
	if(src == nil) {
		return(0);
	}
	int size = ssize;
	if(size < 0) {
		size = ((int)[CapeBuffer getSize:src]);
	}
	if(size < 1) {
		return(0);
	}
	if(self->buffer == nil) {
		self->buffer = [NSMutableData dataWithLength:size];
		if(self->buffer == nil) {
			return(0);
		}
		[CapeBuffer copyFrom:self->buffer src:src soffset:((long long)0) doffset:((long long)0) size:((long long)size)];
		self->pos = size;
	}
	else {
		if(self->pos + size <= [CapeBuffer getSize:self->buffer]) {
			[CapeBuffer copyFrom:self->buffer src:src soffset:((long long)0) doffset:((long long)self->pos) size:((long long)size)];
			self->pos += size;
		}
		else {
			NSMutableData* nb = [CapeBuffer resize:self->buffer newSize:((long long)(self->pos + size))];
			if(nb == nil) {
				return(0);
			}
			self->buffer = nb;
			[CapeBuffer copyFrom:self->buffer src:src soffset:((long long)0) doffset:((long long)self->pos) size:((long long)size)];
			self->pos += size;
		}
	}
	return(size);
}

@end
