
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
#import "CapeBufferObject.h"
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapeCharacterIterator.h"
#import "CapeReader.h"
#import "CapeBuffer.h"

@class CapeBufferMyBufferObject;

@interface CapeBufferMyBufferObject : NSObject <CapeBufferObject>
- (CapeBufferMyBufferObject*) init;
- (NSMutableData*) toBuffer;
- (NSMutableData*) getBuffer;
- (CapeBufferMyBufferObject*) setBuffer:(NSMutableData*)v;
@end

@implementation CapeBufferMyBufferObject

{
	NSMutableData* buffer;
}

- (CapeBufferMyBufferObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->buffer = nil;
	return(self);
}

- (NSMutableData*) toBuffer {
	return(self->buffer);
}

- (NSMutableData*) getBuffer {
	return(self->buffer);
}

- (CapeBufferMyBufferObject*) setBuffer:(NSMutableData*)v {
	self->buffer = v;
	return(self);
}

@end

@implementation CapeBuffer

- (CapeBuffer*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeBufferObject>) asObject:(NSMutableData*)buffer {
	CapeBufferMyBufferObject* v = [[CapeBufferMyBufferObject alloc] init];
	[v setBuffer:buffer];
	return(((id<CapeBufferObject>)v));
}

+ (NSMutableData*) asBuffer:(id)obj {
	if(obj == nil) {
		return(nil);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeBufferObject)]) {
		return([((id<CapeBufferObject>)obj) toBuffer]);
	}
	return(nil);
}

+ (NSMutableData*) forInt8Array:(NSMutableArray*)buf {
	return(nil);
}

+ (NSMutableArray*) toInt8Array:(NSMutableData*)buf {
	return(nil);
}

+ (NSMutableData*) getSubBuffer:(NSMutableData*)buffer offset:(long long)offset size:(long long)size alwaysNewBuffer:(BOOL)alwaysNewBuffer {
	if(alwaysNewBuffer == FALSE && offset == 0 && size < 0) {
		return(buffer);
	}
	long long bsz = [CapeBuffer getSize:buffer];
	long long sz = size;
	if(sz < 0) {
		sz = bsz - offset;
	}
	if(alwaysNewBuffer == FALSE && offset == 0 && sz == bsz) {
		return(buffer);
	}
	if(sz < 1) {
		return(nil);
	}
	NSMutableData* v = [NSMutableData dataWithLength:sz];
	[CapeBuffer copyFrom:v src:buffer soffset:offset doffset:((long long)0) size:sz];
	return(v);
}

+ (uint8_t) getInt8:(NSMutableData*)buffer offset:(long long)offset {
	uint8_t v = ((uint8_t)0);
	[buffer getBytes:&v range:NSMakeRange(offset, 1)];
	return(v);
}

+ (void) copyFrom:(NSMutableData*)array src:(NSMutableData*)src soffset:(long long)soffset doffset:(long long)doffset size:(long long)size {
	[array replaceBytesInRange:NSMakeRange(doffset, size) withBytes:[src bytes]+soffset length:size];
}

+ (uint16_t) getInt16LE:(NSMutableData*)buffer offset:(long long)offset {
	uint16_t v = ((uint16_t)0);
	[buffer getBytes:&v range:NSMakeRange(offset, 2)];
	v = CFSwapInt16LittleToHost(v);
	return(v);
}

+ (uint16_t) getInt16BE:(NSMutableData*)buffer offset:(long long)offset {
	uint16_t v = ((uint16_t)0);
	[buffer getBytes:&v range:NSMakeRange(offset, 2)];
	v = CFSwapInt16BigToHost(v);
	return(v);
}

+ (uint32_t) getInt32LE:(NSMutableData*)buffer offset:(long long)offset {
	uint32_t v = ((uint32_t)0);
	[buffer getBytes:&v range:NSMakeRange(offset, 4)];
	v = CFSwapInt32LittleToHost(v);
	return(v);
}

+ (uint32_t) getInt32BE:(NSMutableData*)buffer offset:(long long)offset {
	uint32_t v = ((uint32_t)0);
	[buffer getBytes:&v range:NSMakeRange(offset, 4)];
	v = CFSwapInt32BigToHost(v);
	return(v);
}

+ (long long) getSize:(NSMutableData*)buffer {
	if(buffer == nil) {
		return(((long long)0));
	}
	return(((long long)[buffer length]));
}

+ (uint8_t) getByte:(NSMutableData*)buffer offset:(long long)offset {
	return([CapeBuffer getInt8:buffer offset:offset]);
}

+ (void) setByte:(NSMutableData*)buffer offset:(long long)offset value:(uint8_t)value {
	((uint8_t*)[buffer mutableBytes])[offset] = value;
}

+ (NSMutableData*) allocate:(long long)size {
	return([NSMutableData dataWithLength:size]);
}

+ (NSMutableData*) resize:(NSMutableData*)buffer newSize:(long long)newSize {
	if(buffer == nil) {
		return([CapeBuffer allocate:newSize]);
	}
	NSLog(@"%@", @"[cape.Buffer.resize] (Buffer.sling:373:2): Not implemented");
	return(nil);
}

+ (NSMutableData*) append:(NSMutableData*)original toAppend:(NSMutableData*)toAppend size:(long long)size {
	if(toAppend == nil || size == 0) {
		return(original);
	}
	long long sz = size;
	long long os = [CapeBuffer getSize:original];
	long long oas = [CapeBuffer getSize:toAppend];
	if(sz >= 0) {
		oas = sz;
	}
	long long nl = os + oas;
	NSMutableData* nb = [CapeBuffer resize:original newSize:nl];
	[CapeBuffer copyFrom:nb src:toAppend soffset:((long long)0) doffset:os size:oas];
	return(nb);
}

+ (NSMutableData*) forHexString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:str] % 2 != 0) {
		return(nil);
	}
	CapeStringBuilder* sb = nil;
	NSMutableData* b = [CapeBuffer allocate:((long long)([CapeString getLength:str] / 2))];
	int n = 0;
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	while(it != nil) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		if(sb == nil) {
			sb = [[CapeStringBuilder alloc] init];
		}
		if(c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F' || c >= '0' && c <= '9') {
			[sb appendCharacter:c];
			if([sb count] == 2) {
				[CapeBuffer setByte:b offset:((long long)n++) value:((uint8_t)[CapeString toIntegerFromHex:[sb toString]])];
				[sb clear];
			}
		}
		else {
			return(nil);
		}
	}
	return(b);
}

+ (NSMutableData*) readFrom:(id<CapeReader>)reader {
	if(reader == nil) {
		return(nil);
	}
	NSMutableData* v = nil;
	NSMutableData* tmp = [NSMutableData dataWithLength:1024];
	while(TRUE) {
		int r = [reader read:tmp];
		if(r < 1) {
			break;
		}
		v = [CapeBuffer append:v toAppend:tmp size:((long long)r)];
		if(v == nil) {
			break;
		}
	}
	return(v);
}

@end
