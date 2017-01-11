
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
#import "CapexRGBAPixelIntegerBuffer.h"
#import "CapeBuffer.h"
#import "CapexPixelRegionBuffer.h"

@implementation CapexPixelRegionBuffer

{
	CapexRGBAPixelIntegerBuffer* src;
	int rangew;
	int rangeh;
	NSMutableData* cache;
}

- (CapexPixelRegionBuffer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->cache = nil;
	self->rangeh = 0;
	self->rangew = 0;
	self->src = nil;
	return(self);
}

+ (CapexPixelRegionBuffer*) forRgbaPixels:(CapexRGBAPixelIntegerBuffer*)src w:(int)w h:(int)h {
	CapexPixelRegionBuffer* v = [[CapexPixelRegionBuffer alloc] init];
	v->src = src;
	v->rangew = w;
	v->rangeh = h;
	return(v);
}

- (int) getStride {
	return(self->rangew * 4);
}

- (NSMutableData*) getBufferRegion:(int)x y:(int)y newbuffer:(BOOL)newbuffer {
	if(self->cache == nil && newbuffer == FALSE) {
		self->cache = [NSMutableData dataWithLength:self->rangew * self->rangeh * 4];
	}
	NSMutableData* v = self->cache;
	if(newbuffer) {
		v = [NSMutableData dataWithLength:self->rangew * self->rangeh * 4];
	}
	NSMutableData* p = v;
	if(p == nil) {
		return(nil);
	}
	int i = 0;
	int j = 0;
	for(i = 0 ; i < self->rangeh ; i++) {
		for(j = 0 ; j < self->rangew ; j++) {
			NSMutableArray* pix = [self->src getRgbaPixel:x + j y:y + i newbuffer:FALSE];
			[CapeBuffer setByte:p offset:((long long)((i * self->rangew + j) * 4 + 0)) value:((uint8_t)(int)({ NSNumber* _v = (NSNumber*)[pix objectAtIndex:0]; _v == nil ? 0 : _v.intValue; }))];
			[CapeBuffer setByte:p offset:((long long)((i * self->rangew + j) * 4 + 1)) value:((uint8_t)(int)({ NSNumber* _v = (NSNumber*)[pix objectAtIndex:1]; _v == nil ? 0 : _v.intValue; }))];
			[CapeBuffer setByte:p offset:((long long)((i * self->rangew + j) * 4 + 2)) value:((uint8_t)(int)({ NSNumber* _v = (NSNumber*)[pix objectAtIndex:2]; _v == nil ? 0 : _v.intValue; }))];
			[CapeBuffer setByte:p offset:((long long)((i * self->rangew + j) * 4 + 3)) value:((uint8_t)(int)({ NSNumber* _v = (NSNumber*)[pix objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }))];
		}
	}
	return(v);
}

@end
