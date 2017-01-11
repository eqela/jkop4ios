
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
#import "CapeSeekableWriter.h"
#import "CapexBlockCipher.h"
#import "CapeBuffer.h"
#import "CapexBlockCipherWriter.h"

@implementation CapexBlockCipherWriter

{
	CapexBlockCipher* cipher;
	id<CapeWriter> writer;
	int bsize;
	int bcurr;
	NSMutableData* bdata;
	NSMutableData* outbuf;
}

-(void)dealloc {
	[self close];
}

- (CapexBlockCipherWriter*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->outbuf = nil;
	self->bdata = nil;
	self->bcurr = 0;
	self->bsize = 0;
	self->writer = nil;
	self->cipher = nil;
	return(self);
}

+ (CapexBlockCipherWriter*) create:(id<CapeWriter>)writer cipher:(CapexBlockCipher*)cipher {
	if(writer == nil || cipher == nil) {
		return(nil);
	}
	CapexBlockCipherWriter* v = [[CapexBlockCipherWriter alloc] init];
	v->writer = writer;
	v->cipher = cipher;
	v->bsize = [cipher getBlockSize];
	v->bcurr = 0;
	v->bdata = [CapeBuffer allocate:((long long)[cipher getBlockSize])];
	v->outbuf = [CapeBuffer allocate:((long long)[cipher getBlockSize])];
	return(v);
}

- (void) close {
	if(self->writer != nil && self->bdata != nil) {
		NSMutableData* bb = [CapeBuffer allocate:((long long)1)];
		NSMutableData* bbptr = bb;
		if(self->bcurr > 0) {
			int n = 0;
			for(n = self->bcurr ; n < self->bsize ; n++) {
				[CapeBuffer setByte:self->bdata offset:((long long)n) value:((uint8_t)0)];
			}
			[self writeCompleteBlock:self->bdata];
			[CapeBuffer setByte:bbptr offset:((long long)0) value:((uint8_t)(self->bsize - self->bcurr))];
			[self->writer write:bb size:-1];
		}
		else {
			[CapeBuffer setByte:bbptr offset:((long long)0) value:((uint8_t)0)];
			[self->writer write:bb size:-1];
		}
	}
	self->writer = nil;
	self->cipher = nil;
	self->bdata = nil;
}

- (BOOL) setCurrentPosition:(int64_t)n {
	if(self->writer != nil && [((NSObject*)self->writer) conformsToProtocol:@protocol(CapeSeekableWriter)]) {
		return([((id<CapeSeekableWriter>)self->writer) setCurrentPosition:n]);
	}
	return(FALSE);
}

- (int64_t) getCurrentPosition {
	if(self->writer != nil && [((NSObject*)self->writer) conformsToProtocol:@protocol(CapeSeekableWriter)]) {
		return([((id<CapeSeekableWriter>)self->writer) getCurrentPosition]);
	}
	return(((int64_t)-1));
}

- (BOOL) writeCompleteBlock:(NSMutableData*)buf {
	[self->cipher encryptBlock:buf dest:self->outbuf];
	if([self->writer write:self->outbuf size:-1] == [CapeBuffer getSize:self->outbuf]) {
		return(TRUE);
	}
	return(FALSE);
}

- (int) writeBlock:(NSMutableData*)buf {
	long long size = [CapeBuffer getSize:buf];
	if(self->bcurr + size < self->bsize) {
		NSMutableData* bufptr = buf;
		[CapeBuffer copyFrom:bufptr src:self->bdata soffset:((long long)0) doffset:((long long)self->bcurr) size:size];
		self->bcurr += ((int)size);
		return(((int)size));
	}
	if(self->bcurr > 0) {
		NSMutableData* bufptr = buf;
		int x = self->bsize - self->bcurr;
		[CapeBuffer copyFrom:bufptr src:self->bdata soffset:((long long)0) doffset:((long long)self->bcurr) size:((long long)x)];
		if([self writeCompleteBlock:self->bdata] == FALSE) {
			return(0);
		}
		self->bcurr = 0;
		if(x == size) {
			return(x);
		}
		return(x + [self writeBlock:[CapeBuffer getSubBuffer:buf offset:((long long)x) size:size - x alwaysNewBuffer:FALSE]]);
	}
	if([self writeCompleteBlock:buf] == FALSE) {
		return(0);
	}
	return(self->bsize);
}

- (int) write:(NSMutableData*)buf asize:(int)asize {
	if(buf == nil) {
		return(0);
	}
	NSMutableData* bufptr = buf;
	if(bufptr == nil) {
		return(0);
	}
	int size = asize;
	if(size < 0) {
		size = ((int)[CapeBuffer getSize:buf]);
	}
	if(size < 1) {
		return(0);
	}
	int v = 0;
	int n = 0;
	for(n = 0 ; n < size ; n += self->bsize) {
		int x = self->bsize;
		if(n + x > size) {
			x = size - n;
		}
		v += [self writeBlock:[CapeBuffer getSubBuffer:buf offset:((long long)n) size:((long long)x) alwaysNewBuffer:FALSE]];
	}
	return(v);
}

@end
