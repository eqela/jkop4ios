
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
#import "CapeBuffer.h"
#import "CapexRGBAPixelIntegerBuffer.h"

@implementation CapexRGBAPixelIntegerBuffer

{
	NSMutableData* buffer;
	NSMutableData* pointer;
	int width;
	int height;
	NSMutableArray* cache;
}

- (CapexRGBAPixelIntegerBuffer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->cache = nil;
	self->height = 0;
	self->width = 0;
	self->pointer = nil;
	self->buffer = nil;
	return(self);
}

+ (CapexRGBAPixelIntegerBuffer*) create:(NSMutableData*)b w:(int)w h:(int)h {
	CapexRGBAPixelIntegerBuffer* v = [[CapexRGBAPixelIntegerBuffer alloc] init];
	v->buffer = b;
	v->width = w;
	v->height = h;
	v->pointer = b;
	return(v);
}

- (int) getWidth {
	return(self->width);
}

- (int) getHeight {
	return(self->height);
}

- (NSMutableArray*) getRgbaPixel:(int)x y:(int)y newbuffer:(BOOL)newbuffer {
	if(self->cache == nil && newbuffer == FALSE) {
		self->cache = [[NSMutableArray alloc] initWithCapacity:4];
	}
	NSMutableArray* v = self->cache;
	if(newbuffer) {
		v = [[NSMutableArray alloc] initWithCapacity:4];
	}
	int i = 0;
	if(x < 0 || x >= self->width || y < 0 || y >= self->height) {
		return(v);
	}
	for(i = 0 ; i < 4 ; i++) {
		[v insertObject:@(((int)[CapeBuffer getByte:self->pointer offset:((long long)((y * self->width + x) * 4 + i))])) atIndex:i];
	}
	return(v);
}

@end
