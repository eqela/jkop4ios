
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
#import "CapexBitmapBuffer.h"
#import "CapexImageResizer.h"
#import "CapexGreyscaleImage.h"
#import "CapexImageFilterUtil.h"
#import "CapexImageFilter.h"

int CapexImageFilterRESIZE_TYPE_BILINEAR = 0;
int CapexImageFilterRESIZE_TYPE_BICUBIC = 1;

@implementation CapexImageFilter

- (CapexImageFilter*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapexBitmapBuffer*) resizeImage:(CapexBitmapBuffer*)bmpbuf nw:(int)nw nh:(int)nh type:(int)type {
	if(bmpbuf == nil) {
		return(nil);
	}
	if(type == CapexImageFilterRESIZE_TYPE_BICUBIC) {
		return([CapexImageResizer resizeBicubic:bmpbuf anw:nw anh:nh]);
	}
	return([CapexImageResizer resizeBilinear:bmpbuf anw:nw anh:nh]);
}

+ (CapexBitmapBuffer*) filterGreyscale:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	return([CapexGreyscaleImage createGreyscale:bmpbuf rf:1.0 gf:1.0 bf:1.0 af:1.0]);
}

+ (CapexBitmapBuffer*) filterRedSepia:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	return([CapexGreyscaleImage createRedSepia:bmpbuf]);
}

+ (CapexBitmapBuffer*) filterBlur:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	NSMutableArray* array = [NSMutableArray arrayWithObjects: @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), @(1.0), @(1.0), @(0.0), @(1.0), @(1.0), @(1.0), @(1.0), @(1.0), @(0.0), @(1.0), @(1.0), @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), nil];
	return([CapexImageFilterUtil createForArrayFilter:bmpbuf filterArray:array fw:5 fh:5 factor:1.0 / 13.0 bias:1.0]);
}

+ (CapexBitmapBuffer*) filterSharpen:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	NSMutableArray* array = [NSMutableArray arrayWithObjects: @(-1.0), @(-1.0), @(-1.0), @(-1.0), @(9.0), @(-1.0), @(-1.0), @(-1.0), @(-1.0), nil];
	return([CapexImageFilterUtil createForArrayFilter:bmpbuf filterArray:array fw:3 fh:3 factor:1.0 bias:1.0]);
}

+ (CapexBitmapBuffer*) filterEmboss:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	NSMutableArray* array = [NSMutableArray arrayWithObjects: @(-2.0), @(-1.0), @(0.0), @(-1.0), @(1.0), @(1.0), @(0.0), @(1.0), @(2.0), nil];
	return([CapexImageFilterUtil createForArrayFilter:bmpbuf filterArray:array fw:3 fh:3 factor:2.0 bias:0.0]);
}

+ (CapexBitmapBuffer*) filterMotionBlur:(CapexBitmapBuffer*)bmpbuf {
	if(bmpbuf == nil) {
		return(nil);
	}
	NSMutableArray* array = [NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil];
	return([CapexImageFilterUtil createForArrayFilter:bmpbuf filterArray:array fw:9 fh:9 factor:1.0 / 9.0 bias:1.0]);
}

@end
