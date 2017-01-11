
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
#import "CapexBitmapBuffer.h"
#import "CapexImageFilterUtil.h"

@implementation CapexImageFilterUtil

- (CapexImageFilterUtil*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (int) clamp:(double)v {
	if(v > 255) {
		return(255);
	}
	if(v < 0) {
		return(0);
	}
	return(((int)v));
}

+ (int) getSafeByte:(NSMutableData*)p sz:(int)sz idx:(int)idx {
	int i = idx;
	if(i >= sz) {
		i = sz - 1;
	}
	else {
		if(i < 0) {
			i = 0;
		}
	}
	return(((int)[CapeBuffer getByte:p offset:((long long)i)]));
}

+ (CapexBitmapBuffer*) createForArrayFilter:(CapexBitmapBuffer*)bmpbuf filterArray:(NSMutableArray*)filterArray fw:(int)fw fh:(int)fh factor:(double)factor bias:(double)bias {
	NSMutableData* srcbuf = [bmpbuf getBuffer];
	int w = [bmpbuf getWidth];
	int h = [bmpbuf getHeight];
	if(w < 1 || h < 1) {
		return(nil);
	}
	NSMutableData* desbuf = [NSMutableData dataWithLength:w * h * 4];
	int x = 0;
	int y = 0;
	NSMutableData* srcptr = srcbuf;
	NSMutableData* desptr = desbuf;
	int sz = ((int)[CapeBuffer getSize:srcbuf]);
	for(x = 0 ; x < w ; x++) {
		for(y = 0 ; y < h ; y++) {
			double sr = 0.0;
			double sg = 0.0;
			double sb = 0.0;
			double sa = 0.0;
			int fx = 0;
			int fy = 0;
			for(fy = 0 ; fy < fh ; fy++) {
				for(fx = 0 ; fx < fw ; fx++) {
					int ix = x - fw / 2 + fx;
					int iy = y - fh / 2 + fy;
					sr += ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:sz idx:(iy * w + ix) * 4 + 0] * (double)({ NSNumber* _v = (NSNumber*)[filterArray objectAtIndex:fy * fw + fx]; _v == nil ? 0 : _v.doubleValue; })));
					sg += ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:sz idx:(iy * w + ix) * 4 + 1] * (double)({ NSNumber* _v = (NSNumber*)[filterArray objectAtIndex:fy * fw + fx]; _v == nil ? 0 : _v.doubleValue; })));
					sb += ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:sz idx:(iy * w + ix) * 4 + 2] * (double)({ NSNumber* _v = (NSNumber*)[filterArray objectAtIndex:fy * fw + fx]; _v == nil ? 0 : _v.doubleValue; })));
					sa += ((double)([CapexImageFilterUtil getSafeByte:srcptr sz:sz idx:(iy * w + ix) * 4 + 3] * (double)({ NSNumber* _v = (NSNumber*)[filterArray objectAtIndex:fy * fw + fx]; _v == nil ? 0 : _v.doubleValue; })));
				}
			}
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 0)) value:((uint8_t)[CapexImageFilterUtil clamp:factor * sr + bias])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 1)) value:((uint8_t)[CapexImageFilterUtil clamp:factor * sg + bias])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 2)) value:((uint8_t)[CapexImageFilterUtil clamp:factor * sb + bias])];
			[CapeBuffer setByte:desptr offset:((long long)((y * w + x) * 4 + 3)) value:((uint8_t)[CapexImageFilterUtil clamp:factor * sa + bias])];
		}
	}
	return([CapexBitmapBuffer create:desbuf w:w h:h]);
}

@end
