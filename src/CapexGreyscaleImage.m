
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
#import "CapeBuffer.h"
#import "CapexImageFilterUtil.h"
#import "CapexGreyscaleImage.h"

@implementation CapexGreyscaleImage

- (CapexGreyscaleImage*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapexBitmapBuffer*) createGreyscale:(CapexBitmapBuffer*)bmpbuf rf:(double)rf gf:(double)gf bf:(double)bf af:(double)af {
	int w = [bmpbuf getWidth];
	int h = [bmpbuf getHeight];
	NSMutableData* srcbuf = [bmpbuf getBuffer];
	if(srcbuf == nil || w < 1 || h < 1) {
		return(nil);
	}
	NSMutableData* desbuf = [NSMutableData dataWithLength:w * h * 4];
	if(desbuf == nil) {
		return(nil);
	}
	int ss = ((int)[CapeBuffer getSize:srcbuf]);
	NSMutableData* srcptr = srcbuf;
	NSMutableData* desptr = desbuf;
	int x = 0;
	int y = 0;
	for(y = 0 ; y < h ; y++) {
		for(x = 0 ; x < w ; x++) {
			double sr = ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:ss idx:(y * w + x) * 4 + 0] * 0.2126));
			double sg = ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:ss idx:(y * w + x) * 4 + 1] * 0.7152));
			double sb = ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:ss idx:(y * w + x) * 4 + 2] * 0.0722));
			double sa = ((double)[CapexImageFilterUtil getSafeByte:srcptr sz:ss idx:(y * w + x) * 4 + 3]);
			int sbnw = ((int)(sr + sg + sb));
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 0)) value:((uint8_t)[CapexImageFilterUtil clamp:((double)(sbnw * rf))])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 1)) value:((uint8_t)[CapexImageFilterUtil clamp:((double)(sbnw * gf))])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 2)) value:((uint8_t)[CapexImageFilterUtil clamp:((double)(sbnw * bf))])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 3)) value:((uint8_t)[CapexImageFilterUtil clamp:sa * af])];
		}
	}
	return([CapexBitmapBuffer create:desbuf w:w h:h]);
}

+ (CapexBitmapBuffer*) createRedSepia:(CapexBitmapBuffer*)imgbuf {
	return([CapexGreyscaleImage createGreyscale:imgbuf rf:110.0 / 255.0 + 1.0 gf:66.0 / 255.0 + 1.0 bf:20.0 / 255.0 + 1.0 af:1.0]);
}

@end
