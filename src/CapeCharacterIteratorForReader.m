
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
#import "CapeReader.h"
#import "CapeSeekableReader.h"
#import "CapeBuffer.h"
#import "CapeCharacterIteratorForReader.h"

@implementation CapeCharacterIteratorForReader

{
	id<CapeReader> reader;
	NSMutableData* buffer;
	long long bufferStart;
	long long bufferSize;
	long long bufferDataSize;
	long long currentPos;
	long long readPos;
}

- (CapeCharacterIteratorForReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->readPos = ((long long)0);
	self->currentPos = ((long long)-1);
	self->bufferDataSize = ((long long)0);
	self->bufferSize = ((long long)0);
	self->bufferStart = ((long long)-1);
	self->buffer = nil;
	self->reader = nil;
	return(self);
}

- (CapeCharacterIteratorForReader*) initWithReader:(id<CapeReader>)reader {
	if([super init] == nil) {
		return(nil);
	}
	self->readPos = ((long long)0);
	self->currentPos = ((long long)-1);
	self->bufferDataSize = ((long long)0);
	self->bufferSize = ((long long)0);
	self->bufferStart = ((long long)-1);
	self->buffer = nil;
	self->reader = nil;
	self->reader = reader;
	self->buffer = [NSMutableData dataWithLength:1024];
	self->bufferSize = ((long long)1024);
	return(self);
}

- (CapeCharacterIteratorForReader*) initWithReaderAndSignedLongInteger:(id<CapeReader>)reader bufferSize:(long long)bufferSize {
	if([super init] == nil) {
		return(nil);
	}
	self->readPos = ((long long)0);
	self->currentPos = ((long long)-1);
	self->bufferDataSize = ((long long)0);
	self->bufferSize = ((long long)0);
	self->bufferStart = ((long long)-1);
	self->buffer = nil;
	self->reader = nil;
	self->reader = reader;
	self->buffer = [NSMutableData dataWithLength:bufferSize];
	self->bufferSize = bufferSize;
	return(self);
}

- (BOOL) makeDataAvailable:(long long)n {
	if(n >= self->bufferStart && n < self->bufferStart + self->bufferDataSize) {
		return(TRUE);
	}
	if([((NSObject*)self->reader) conformsToProtocol:@protocol(CapeSeekableReader)]) {
		long long block = n / self->bufferSize;
		long long blockPos = block * self->bufferSize;
		if(self->readPos != blockPos) {
			if([((id<CapeSeekableReader>)self->reader) setCurrentPosition:((int64_t)blockPos)] == FALSE) {
				return(FALSE);
			}
			self->readPos = blockPos;
		}
	}
	self->bufferDataSize = ((long long)[self->reader read:self->buffer]);
	self->bufferStart = self->readPos;
	self->readPos += self->bufferDataSize;
	if(n >= self->bufferStart && n < self->bufferStart + self->bufferDataSize) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) moveToPreviousByte {
	if([self makeDataAvailable:self->currentPos - 1] == FALSE) {
		return(FALSE);
	}
	self->currentPos--;
	return(TRUE);
}

- (BOOL) moveToNextByte {
	if([self makeDataAvailable:self->currentPos + 1] == FALSE) {
		return(FALSE);
	}
	self->currentPos++;
	return(TRUE);
}

- (int) getCurrentByte {
	return(((int)[CapeBuffer getByte:self->buffer offset:self->currentPos - self->bufferStart]));
}

@end
