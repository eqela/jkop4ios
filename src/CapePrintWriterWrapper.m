
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
#import "CapePrintWriter.h"
#import "CapeClosable.h"
#import "CapeFlushableWriter.h"
#import "CapeString.h"
#import "CapeBuffer.h"
#import "CapePrintWriterWrapper.h"

@implementation CapePrintWriterWrapper

{
	id<CapeWriter> writer;
}

- (CapePrintWriterWrapper*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->writer = nil;
	return(self);
}

+ (id<CapePrintWriter>) forWriter:(id<CapeWriter>)writer {
	if(writer == nil) {
		return(nil);
	}
	if([((NSObject*)writer) conformsToProtocol:@protocol(CapePrintWriter)]) {
		return(((id<CapePrintWriter>)writer));
	}
	CapePrintWriterWrapper* v = [[CapePrintWriterWrapper alloc] init];
	[v setWriter:writer];
	return(((id<CapePrintWriter>)v));
}

- (BOOL) print:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	NSMutableData* buffer = [CapeString toUTF8Buffer:str];
	if(buffer == nil) {
		return(FALSE);
	}
	int sz = ((int)([CapeBuffer getSize:buffer]));
	if([self->writer write:buffer size:-1] != sz) {
		return(FALSE);
	}
	return(TRUE);
}

- (BOOL) println:(NSString*)str {
	return([self print:[str stringByAppendingString:@"\n"]]);
}

- (int) write:(NSMutableData*)buf size:(int)size {
	if(self->writer == nil) {
		return(-1);
	}
	return([self->writer write:buf size:size]);
}

- (void) close {
	id<CapeClosable> cw = ((id<CapeClosable>)({ id _v = self->writer; [((NSObject*)_v) conformsToProtocol:@protocol(CapeClosable)] ? _v : nil; }));
	if(cw != nil) {
		[cw close];
	}
}

- (void) flush {
	id<CapeFlushableWriter> cw = ((id<CapeFlushableWriter>)({ id _v = self->writer; [((NSObject*)_v) conformsToProtocol:@protocol(CapeFlushableWriter)] ? _v : nil; }));
	if(cw != nil) {
		[cw flush];
	}
}

- (id<CapeWriter>) getWriter {
	return(self->writer);
}

- (CapePrintWriterWrapper*) setWriter:(id<CapeWriter>)v {
	self->writer = v;
	return(self);
}

@end
