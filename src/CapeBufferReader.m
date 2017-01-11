
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
#import "CapeReader.h"
#import "CapeSizedReader.h"
#import "CapeSeekableReader.h"
#import "CapeBuffer.h"
#import "CapeBufferReader.h"

@implementation CapeBufferReader

{
	NSMutableData* buffer;
	int pos;
}

- (CapeBufferReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->pos = 0;
	self->buffer = nil;
	return(self);
}

+ (CapeBufferReader*) forBuffer:(NSMutableData*)buf {
	return([[[CapeBufferReader alloc] init] setBuffer:buf]);
}

- (BOOL) setCurrentPosition:(int64_t)n {
	self->pos = ((int)n);
	return(TRUE);
}

- (int64_t) getCurrentPosition {
	return(((int64_t)self->pos));
}

- (NSMutableData*) getBuffer {
	return(self->buffer);
}

- (CapeBufferReader*) setBuffer:(NSMutableData*)buf {
	self->buffer = buf;
	self->pos = 0;
	return(self);
}

- (void) rewind {
	self->pos = 0;
}

- (int) getSize {
	if(self->buffer == nil) {
		return(0);
	}
	return([self->buffer length]);
}

- (int) read:(NSMutableData*)buf {
	if(buf == nil || self->buffer == nil) {
		return(0);
	}
	int buffersz = [self->buffer length];
	if(self->pos >= buffersz) {
		return(0);
	}
	int size = [buf length];
	if(size > buffersz - self->pos) {
		size = buffersz - self->pos;
	}
	[CapeBuffer copyFrom:buf src:self->buffer soffset:((long long)self->pos) doffset:((long long)0) size:((long long)size)];
	self->pos += size;
	return(size);
}

- (int) getPos {
	return(self->pos);
}

- (CapeBufferReader*) setPos:(int)v {
	self->pos = v;
	return(self);
}

@end
