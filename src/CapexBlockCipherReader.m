
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
#import "CapexBlockCipher.h"
#import "CapeBuffer.h"
#import "CapexBlockCipherReader.h"

@implementation CapexBlockCipherReader

{
	CapexBlockCipher* cipher;
	id<CapeSizedReader> reader;
	NSMutableData* bcurrent;
	int csize;
	int cindex;
	NSMutableData* bnext;
	int nsize;
	NSMutableData* ddata;
}

- (CapexBlockCipherReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->ddata = nil;
	self->nsize = 0;
	self->bnext = nil;
	self->cindex = 0;
	self->csize = 0;
	self->bcurrent = nil;
	self->reader = nil;
	self->cipher = nil;
	return(self);
}

+ (id<CapeSizedReader>) create:(id<CapeSizedReader>)reader cipher:(CapexBlockCipher*)cipher {
	if(reader == nil) {
		return(nil);
	}
	if(cipher == nil) {
		return(reader);
	}
	CapexBlockCipherReader* v = [[CapexBlockCipherReader alloc] init];
	v->reader = reader;
	v->cipher = cipher;
	v->bcurrent = [CapeBuffer allocate:((long long)[cipher getBlockSize])];
	v->bnext = [CapeBuffer allocate:((long long)[cipher getBlockSize])];
	v->ddata = [CapeBuffer allocate:((long long)[cipher getBlockSize])];
	v->csize = 0;
	v->cindex = 0;
	v->nsize = 0;
	return(((id<CapeSizedReader>)v));
}

- (int) getSize {
	if(self->reader != nil) {
		return([self->reader getSize]);
	}
	return(0);
}

- (BOOL) setCurrentPosition:(int64_t)n {
	int rem = ((int)(n % [self->cipher getBlockSize]));
	int ss = ((int)(n - rem));
	self->csize = 0;
	self->cindex = 0;
	self->nsize = 0;
	BOOL v = FALSE;
	if(self->reader != nil && [((NSObject*)self->reader) conformsToProtocol:@protocol(CapeSeekableReader)]) {
		v = [((id<CapeSeekableReader>)self->reader) setCurrentPosition:((int64_t)ss)];
	}
	if(v && rem > 0) {
		NSMutableData* bb = [CapeBuffer allocate:((long long)rem)];
		if([self read:bb] != rem) {
			v = FALSE;
		}
	}
	return(v);
}

- (int64_t) getCurrentPosition {
	if(self->reader != nil && [((NSObject*)self->reader) conformsToProtocol:@protocol(CapeSeekableReader)]) {
		return([((id<CapeSeekableReader>)self->reader) getCurrentPosition]);
	}
	return(((int64_t)-1));
}

- (int) read:(NSMutableData*)buf {
	if(buf == nil || [CapeBuffer getSize:buf] < 1) {
		return(0);
	}
	NSMutableData* ptr = buf;
	if(ptr == nil) {
		return(0);
	}
	int v = 0;
	int bs = [self->cipher getBlockSize];
	while(v < [CapeBuffer getSize:buf]) {
		int x = bs;
		if(v + x > [CapeBuffer getSize:buf]) {
			x = ((int)([CapeBuffer getSize:buf] - v));
		}
		int r = [self readBlock:ptr offset:v size:x];
		if(r < 1) {
			break;
		}
		v += r;
	}
	return(v);
}

- (int) readAndDecrypt:(NSMutableData*)buf {
	int v = [self->reader read:self->ddata];
	if(v == [self->cipher getBlockSize]) {
		[self->cipher decryptBlock:self->ddata dest:buf];
	}
	else {
		[CapeBuffer copyFrom:self->ddata src:buf soffset:((long long)0) doffset:((long long)0) size:((long long)v)];
	}
	return(v);
}

- (int) readBlock:(NSMutableData*)ptr offset:(int)offset size:(int)size {
	if(self->cindex >= self->csize) {
		self->csize = 0;
	}
	if(self->nsize < 1) {
		self->nsize = [self readAndDecrypt:self->bnext];
	}
	if(self->csize < 1) {
		if(self->nsize < [self->cipher getBlockSize]) {
			return(0);
		}
		NSMutableData* nn = self->bcurrent;
		self->bcurrent = self->bnext;
		self->csize = self->nsize;
		self->cindex = 0;
		self->bnext = nn;
		self->nsize = [self readAndDecrypt:self->bnext];
	}
	int data = [self->cipher getBlockSize];
	if(self->nsize < [self->cipher getBlockSize]) {
		NSMutableData* ptr2 = self->bnext;
		if(ptr2 != nil) {
			data -= ((int)[CapeBuffer getByte:ptr2 offset:((long long)0)]);
		}
	}
	data -= self->cindex;
	if(data < 1) {
		self->csize = 0;
		return([self readBlock:ptr offset:offset size:size]);
	}
	if(data < size) {
		[CapeBuffer copyFrom:self->bcurrent src:ptr soffset:((long long)self->cindex) doffset:((long long)offset) size:((long long)data)];
		self->cindex += data;
		return(data);
	}
	[CapeBuffer copyFrom:self->bcurrent src:ptr soffset:((long long)self->cindex) doffset:((long long)offset) size:((long long)size)];
	self->cindex += size;
	return(size);
}

@end
