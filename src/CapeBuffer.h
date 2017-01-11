
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

@protocol CapeBufferObject;
@class CapeBufferMyBufferObject;
@protocol CapeReader;

/*
 * The Buffer class provides convenience methods for dealing with data buffers
 * (arbitrary sequences of bytes).
 */

@interface CapeBuffer : NSObject
- (CapeBuffer*) init;

/*
 * Returns the given array as a BufferObject (which is an object type) that can be
 * used wherever an object or a class instance is required.
 */

+ (id<CapeBufferObject>) asObject:(NSMutableData*)buffer;
+ (NSMutableData*) asBuffer:(id)obj;
+ (NSMutableData*) forInt8Array:(NSMutableArray*)buf;
+ (NSMutableArray*) toInt8Array:(NSMutableData*)buf;
+ (NSMutableData*) getSubBuffer:(NSMutableData*)buffer offset:(long long)offset size:(long long)size alwaysNewBuffer:(BOOL)alwaysNewBuffer;
+ (uint8_t) getInt8:(NSMutableData*)buffer offset:(long long)offset;
+ (void) copyFrom:(NSMutableData*)array src:(NSMutableData*)src soffset:(long long)soffset doffset:(long long)doffset size:(long long)size;
+ (uint16_t) getInt16LE:(NSMutableData*)buffer offset:(long long)offset;
+ (uint16_t) getInt16BE:(NSMutableData*)buffer offset:(long long)offset;
+ (uint32_t) getInt32LE:(NSMutableData*)buffer offset:(long long)offset;
+ (uint32_t) getInt32BE:(NSMutableData*)buffer offset:(long long)offset;
+ (long long) getSize:(NSMutableData*)buffer;
+ (uint8_t) getByte:(NSMutableData*)buffer offset:(long long)offset;
+ (void) setByte:(NSMutableData*)buffer offset:(long long)offset value:(uint8_t)value;
+ (NSMutableData*) allocate:(long long)size;
+ (NSMutableData*) resize:(NSMutableData*)buffer newSize:(long long)newSize;
+ (NSMutableData*) append:(NSMutableData*)original toAppend:(NSMutableData*)toAppend size:(long long)size;
+ (NSMutableData*) forHexString:(NSString*)str;
+ (NSMutableData*) readFrom:(id<CapeReader>)reader;
@end
