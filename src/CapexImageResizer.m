
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
#import "CapexMatrix33.h"
#import "CapeMath.h"
#import "CapexRGBAPixelIntegerBuffer.h"
#import "CapexPixelRegionBuffer.h"
#import "CapexImageResizer.h"

@class CapexImageResizerIndexMovingBuffer;

@implementation CapexImageResizerIndexMovingBuffer

{
	NSMutableData* buf;
	long long index;
}

- (CapexImageResizerIndexMovingBuffer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->index = ((long long)0);
	self->buf = nil;
	return(self);
}

- (CapexImageResizerIndexMovingBuffer*) move:(int)n {
	CapexImageResizerIndexMovingBuffer* v = [[CapexImageResizerIndexMovingBuffer alloc] init];
	[v setBuf:self->buf];
	[v setIndex:[v getIndex] + n];
	return(v);
}

- (NSMutableData*) getBuf {
	return(self->buf);
}

- (CapexImageResizerIndexMovingBuffer*) setBuf:(NSMutableData*)v {
	self->buf = v;
	return(self);
}

- (long long) getIndex {
	return(self->index);
}

- (CapexImageResizerIndexMovingBuffer*) setIndex:(long long)v {
	self->index = v;
	return(self);
}

@end

int CapexImageResizerFIXED_SHIFT = 10;
int CapexImageResizerUnit = 0;

@implementation CapexImageResizer

- (CapexImageResizer*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (int) li:(double)src1 src2:(double)src2 a:(double)a {
	return(((int)(a * src2 + (1 - a) * src1)));
}

+ (double) bilinearInterpolation:(int)q11 q21:(int)q21 q12:(int)q12 q22:(int)q22 tx:(double)tx ty:(double)ty {
	return(((double)[CapexImageResizer li:((double)[CapexImageResizer li:((double)q11) src2:((double)q21) a:tx]) src2:((double)[CapexImageResizer li:((double)q12) src2:((double)q22) a:tx]) a:ty]));
}

+ (CapexBitmapBuffer*) resizeBilinear:(CapexBitmapBuffer*)bmpbuf anw:(int)anw anh:(int)anh {
	if(anw == 0 || anh == 0) {
		return(nil);
	}
	if(anw < 0 && anh < 0) {
		return(bmpbuf);
	}
	NSMutableData* src = [bmpbuf getBuffer];
	if(src == nil) {
		return(nil);
	}
	int sz = ((int)[CapeBuffer getSize:src]);
	int ow = [bmpbuf getWidth];
	int oh = [bmpbuf getHeight];
	if(ow == anw && oh == anh) {
		return(bmpbuf);
	}
	if(sz != ow * oh * 4) {
		return(nil);
	}
	int nw = anw;
	int nh = anh;
	double scaler = 1.0;
	if(nw < 0) {
		scaler = ((double)nh) / ((double)oh);
	}
	else {
		if(nh < 0) {
			scaler = ((double)nw) / ((double)ow);
		}
	}
	if(scaler != 1.0) {
		nw = ((int)(((double)ow) * scaler));
		nh = ((int)(((double)oh) * scaler));
	}
	NSMutableData* dest = [NSMutableData dataWithLength:nw * nh * 4];
	if(dest == nil) {
		return(nil);
	}
	NSMutableData* desp = dest;
	NSMutableData* srcp = src;
	int dx = 0;
	int dy = 0;
	double stepx = ((double)((ow - 1.0) / (nw - 1.0)));
	double stepy = ((double)((oh - 1.0) / (nh - 1.0)));
	for(dy = 0 ; dy < nh ; dy++) {
		for(dx = 0 ; dx < nw ; dx++) {
			double ptx = ((double)(dx * stepx));
			double pty = ((double)(dy * stepy));
			int ix = ((int)ptx);
			int iy = ((int)pty);
			int q11i = (iy * ow + ix) * 4;
			int q21i = (iy * ow + ix + 1) * 4;
			int q12i = ((iy + 1) * ow + ix) * 4;
			int q22i = ((iy + 1) * ow + ix + 1) * 4;
			int rq11 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q11i + 0];
			int gq11 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q11i + 1];
			int bq11 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q11i + 2];
			int aq11 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q11i + 3];
			int rq21 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q21i + 0];
			int gq21 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q21i + 1];
			int bq21 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q21i + 2];
			int aq21 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q21i + 3];
			int rq12 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q12i + 0];
			int gq12 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q12i + 1];
			int bq12 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q12i + 2];
			int aq12 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q12i + 3];
			int rq22 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q22i + 0];
			int gq22 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q22i + 1];
			int bq22 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q22i + 2];
			int aq22 = [CapexImageFilterUtil getSafeByte:srcp sz:sz idx:q22i + 3];
			int resr = ((int)([CapexImageResizer bilinearInterpolation:rq11 q21:rq21 q12:rq12 q22:rq22 tx:ptx - ix ty:pty - iy]));
			int resg = ((int)([CapexImageResizer bilinearInterpolation:gq11 q21:gq21 q12:gq12 q22:gq22 tx:ptx - ix ty:pty - iy]));
			int resb = ((int)([CapexImageResizer bilinearInterpolation:bq11 q21:bq21 q12:bq12 q22:bq22 tx:ptx - ix ty:pty - iy]));
			int resa = ((int)([CapexImageResizer bilinearInterpolation:aq11 q21:aq21 q12:aq12 q22:aq22 tx:ptx - ix ty:pty - iy]));
			[CapeBuffer setByte:desp offset:((long long)((dy * nw + dx) * 4 + 0)) value:((uint8_t)resr)];
			[CapeBuffer setByte:desp offset:((long long)((dy * nw + dx) * 4 + 1)) value:((uint8_t)resg)];
			[CapeBuffer setByte:desp offset:((long long)((dy * nw + dx) * 4 + 2)) value:((uint8_t)resb)];
			[CapeBuffer setByte:desp offset:((long long)((dy * nw + dx) * 4 + 3)) value:((uint8_t)resa)];
		}
	}
	return([CapexBitmapBuffer create:dest w:nw h:nh]);
}

+ (void) untransformCoords:(CapexMatrix33*)m ix:(int)ix iy:(int)iy tu:(NSMutableArray*)tu tv:(NSMutableArray*)tv tw:(NSMutableArray*)tw {
	double x = ((double)(ix + 0.5));
	double y = ((double)(iy + 0.5));
	[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:0];
	[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:0];
	[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:0];
	[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (x - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:1];
	[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (x - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:1];
	[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (x - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:1];
	[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (y - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:2];
	[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (y - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:2];
	[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (y - 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:2];
	[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (x + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:3];
	[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (x + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:3];
	[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (x + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (y + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:3];
	[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (y + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:4];
	[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (y + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:4];
	[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (x + 0) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (y + 1) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:4];
}

+ (void) normalizeCoords:(int)count tu:(NSMutableArray*)tu tv:(NSMutableArray*)tv tw:(NSMutableArray*)tw su:(NSMutableArray*)su sv:(NSMutableArray*)sv {
	int i = 0;
	for(i = 0 ; i < count ; i++) {
		if((double)({ NSNumber* _v = (NSNumber*)[tw objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) != 0.0) {
			[su insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tu objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) / (double)({ NSNumber* _v = (NSNumber*)[tw objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) - 0.5) atIndex:i];
			[sv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tv objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) / (double)({ NSNumber* _v = (NSNumber*)[tw objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) - 0.5) atIndex:i];
		}
		else {
			[su insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tu objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; })) atIndex:i];
			[sv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tv objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; })) atIndex:i];
		}
	}
}

+ (void) initFixedUnit {
	CapexImageResizerUnit = 1 << CapexImageResizerFIXED_SHIFT;
}

+ (int) double2Fixed:(double)val {
	[CapexImageResizer initFixedUnit];
	return(((int)(val * CapexImageResizerUnit)));
}

+ (double) fixed2Double:(double)val {
	[CapexImageResizer initFixedUnit];
	return(val / CapexImageResizerUnit);
}

+ (BOOL) superSampleDtest:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3 {
	return([CapeMath absDouble:x0 - x1] > CapeMathM_SQRT2 || [CapeMath absDouble:x1 - x2] > CapeMathM_SQRT2 || [CapeMath absDouble:x2 - x3] > CapeMathM_SQRT2 || [CapeMath absDouble:x3 - x0] > CapeMathM_SQRT2 || [CapeMath absDouble:y0 - y1] > CapeMathM_SQRT2 || [CapeMath absDouble:y1 - y2] > CapeMathM_SQRT2 || [CapeMath absDouble:y2 - y3] > CapeMathM_SQRT2 || [CapeMath absDouble:y3 - y0] > CapeMathM_SQRT2);
}

+ (BOOL) supersampleTest:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3 {
	[CapexImageResizer initFixedUnit];
	return([CapeMath absDouble:x0 - x1] > CapexImageResizerUnit || [CapeMath absDouble:x1 - x2] > CapexImageResizerUnit || [CapeMath absDouble:x2 - x3] > CapexImageResizerUnit || [CapeMath absDouble:x3 - x0] > CapexImageResizerUnit || [CapeMath absDouble:y0 - y1] > CapexImageResizerUnit || [CapeMath absDouble:y1 - y2] > CapexImageResizerUnit || [CapeMath absDouble:y2 - y3] > CapexImageResizerUnit || [CapeMath absDouble:y3 - y0] > CapexImageResizerUnit);
}

+ (int) lerp:(int)v1 v2:(int)v2 r:(int)r {
	[CapexImageResizer initFixedUnit];
	return(v1 * (CapexImageResizerUnit - r) + v2 * r >> CapexImageResizerFIXED_SHIFT);
}

+ (void) sampleBi:(CapexRGBAPixelIntegerBuffer*)pixels x:(int)x y:(int)y color:(NSMutableArray*)color {
	[CapexImageResizer initFixedUnit];
	int xscale = x & CapexImageResizerUnit - 1;
	int yscale = y & CapexImageResizerUnit - 1;
	int x0 = x >> CapexImageResizerFIXED_SHIFT;
	int y0 = y >> CapexImageResizerFIXED_SHIFT;
	int x1 = x0 + 1;
	int y1 = y0 + 1;
	int i = 0;
	NSMutableArray* c0 = [pixels getRgbaPixel:x0 y:y0 newbuffer:TRUE];
	NSMutableArray* c1 = [pixels getRgbaPixel:x1 y:y0 newbuffer:TRUE];
	NSMutableArray* c2 = [pixels getRgbaPixel:x0 y:y1 newbuffer:TRUE];
	NSMutableArray* c3 = [pixels getRgbaPixel:x1 y:y1 newbuffer:TRUE];
	[color insertObject:@([CapexImageResizer lerp:[CapexImageResizer lerp:(int)({ NSNumber* _v = (NSNumber*)[c0 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) v2:(int)({ NSNumber* _v = (NSNumber*)[c1 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) r:yscale] v2:[CapexImageResizer lerp:(int)({ NSNumber* _v = (NSNumber*)[c2 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) v2:(int)({ NSNumber* _v = (NSNumber*)[c3 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) r:yscale] r:xscale]) atIndex:3];
	if((int)({ NSNumber* _v = (NSNumber*)[color objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) != 0) {
		for(i = 0 ; i < 3 ; i++) {
			[color insertObject:@([CapexImageResizer lerp:[CapexImageResizer lerp:(int)({ NSNumber* _v = (NSNumber*)[c0 objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) * (int)({ NSNumber* _v = (NSNumber*)[c0 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) / 255 v2:(int)({ NSNumber* _v = (NSNumber*)[c1 objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) * (int)({ NSNumber* _v = (NSNumber*)[c1 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) / 255 r:yscale] v2:[CapexImageResizer lerp:(int)({ NSNumber* _v = (NSNumber*)[c2 objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) * (int)({ NSNumber* _v = (NSNumber*)[c2 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) / 255 v2:(int)({ NSNumber* _v = (NSNumber*)[c3 objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) * (int)({ NSNumber* _v = (NSNumber*)[c3 objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) / 255 r:yscale] r:xscale]) atIndex:i];
		}
	}
	else {
		for(i = 0 ; i < 3 ; i++) {
			[color insertObject:@(0) atIndex:i];
		}
	}
}

+ (void) getSample:(CapexRGBAPixelIntegerBuffer*)pixels xc:(int)xc yc:(int)yc x0:(int)x0 y0:(int)y0 x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 x3:(int)x3 y3:(int)y3 cciv:(int)cciv level:(int)level color:(NSMutableArray*)color {
	if(level == 0 || [CapexImageResizer supersampleTest:((double)x0) y0:((double)y0) x1:((double)x1) y1:((double)y1) x2:((double)x2) y2:((double)y2) x3:((double)x3) y3:((double)y3)] == FALSE) {
		int i = 0;
		NSMutableArray* c = [[NSMutableArray alloc] initWithCapacity:4];
		[CapexImageResizer sampleBi:pixels x:xc y:yc color:c];
		for(i = 0 ; i < 4 ; i++) {
			[color insertObject:@((int)({ NSNumber* _v = (NSNumber*)[color objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) + (int)({ NSNumber* _v = (NSNumber*)[c objectAtIndex:i]; _v == nil ? 0 : _v.intValue; })) atIndex:i];
		}
	}
	else {
		int tx = 0;
		int lx = 0;
		int rx = 0;
		int bx = 0;
		int tlx = 0;
		int trx = 0;
		int blx = 0;
		int brx = 0;
		int ty = 0;
		int ly = 0;
		int ry = 0;
		int by = 0;
		int tly = 0;
		int trz = 0;
		int bly = 0;
		int bry = 0;
		tx = (x0 + x1) / 2;
		tlx = (x0 + xc) / 2;
		trx = (x1 + xc) / 2;
		lx = (x0 + x3) / 2;
		rx = (x1 + x2) / 2;
		blx = (x2 + xc) / 2;
		brx = (x3 + xc) / 2;
		bx = (x3 + x2) / 2;
		ty = (y0 + y1) / 2;
		tly = (y0 + yc) / 2;
		trz = (y1 + yc) / 2;
		ly = (y0 + y3) / 2;
		ry = (y1 + y2) / 2;
		bly = (y3 + yc) / 2;
		bry = (y2 + yc) / 2;
		by = (y3 + y2) / 2;
		[CapexImageResizer getSample:pixels xc:tlx yc:tly x0:x0 y0:y0 x1:tx y1:ty x2:xc y2:yc x3:lx y3:ly cciv:cciv level:level - 1 color:color];
		[CapexImageResizer getSample:pixels xc:trx yc:trz x0:tx y0:ty x1:x1 y1:y1 x2:rx y2:ry x3:xc y3:yc cciv:cciv level:level - 1 color:color];
		[CapexImageResizer getSample:pixels xc:brx yc:bry x0:xc y0:yc x1:rx y1:ry x2:x2 y2:y2 x3:bx y3:by cciv:cciv level:level - 1 color:color];
		[CapexImageResizer getSample:pixels xc:blx yc:bly x0:lx y0:ly x1:xc y1:yc x2:bx y2:by x3:x3 y3:y3 cciv:cciv level:level - 1 color:color];
	}
}

+ (void) sampleAdapt:(CapexRGBAPixelIntegerBuffer*)src xc:(double)xc yc:(double)yc x0:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3 dest:(CapexImageResizerIndexMovingBuffer*)dest {
	int cc = 0;
	int i = 0;
	NSMutableArray* c = [[NSMutableArray alloc] initWithCapacity:4];
	int cciv = 0;
	[CapexImageResizer getSample:src xc:[CapexImageResizer double2Fixed:xc] yc:[CapexImageResizer double2Fixed:yc] x0:[CapexImageResizer double2Fixed:x0] y0:[CapexImageResizer double2Fixed:y0] x1:[CapexImageResizer double2Fixed:x1] y1:[CapexImageResizer double2Fixed:y1] x2:[CapexImageResizer double2Fixed:x2] y2:[CapexImageResizer double2Fixed:y2] x3:[CapexImageResizer double2Fixed:x3] y3:[CapexImageResizer double2Fixed:y3] cciv:cciv level:3 color:c];
	cc = cciv;
	if(cc == 0) {
		cc = 1;
	}
	int aa = (int)({ NSNumber* _v = (NSNumber*)[c objectAtIndex:3]; _v == nil ? 0 : _v.intValue; }) / cc;
	[CapeBuffer setByte:[dest getBuf] offset:((long long)3) value:((uint8_t)aa)];
	if(aa != 0) {
		for(i = 0 ; i < 3 ; i++) {
			[CapeBuffer setByte:[dest getBuf] offset:((long long)i) value:((uint8_t)((int)({ NSNumber* _v = (NSNumber*)[c objectAtIndex:i]; _v == nil ? 0 : _v.intValue; }) / cc * 255 / aa))];
		}
	}
	else {
		for(i = 0 ; i < 3 ; i++) {
			[CapeBuffer setByte:[dest getBuf] offset:((long long)i) value:((uint8_t)0)];
		}
	}
}

+ (double) drawableTransformCubic:(double)x jm1:(int)jm1 j:(int)j jp1:(int)jp1 jp2:(int)jp2 {
	return(((double)(j + 0.5 * x * (jp1 - jm1 + x * (2.0 * jm1 - 5.0 * j + 4.0 * jp1 - jp2 + x * (3.0 * (j - jp1) + jp2 - jm1))))));
}

+ (int) cubicRow:(double)dx row:(CapexImageResizerIndexMovingBuffer*)row {
	return(((int)([CapexImageResizer drawableTransformCubic:dx jm1:((int)[CapeBuffer getByte:[row getBuf] offset:((long long)0)]) j:((int)[CapeBuffer getByte:[row getBuf] offset:((long long)4)]) jp1:((int)[CapeBuffer getByte:[row getBuf] offset:((long long)8)]) jp2:((int)[CapeBuffer getByte:[row getBuf] offset:((long long)12)])])));
}

+ (int) cubicScaledRow:(double)dx row:(CapexImageResizerIndexMovingBuffer*)row arow:(CapexImageResizerIndexMovingBuffer*)arow {
	return(((int)([CapexImageResizer drawableTransformCubic:dx jm1:((int)([CapeBuffer getByte:[row getBuf] offset:((long long)0)] * [CapeBuffer getByte:[arow getBuf] offset:((long long)0)])) j:((int)([CapeBuffer getByte:[row getBuf] offset:((long long)4)] * [CapeBuffer getByte:[arow getBuf] offset:((long long)4)])) jp1:((int)([CapeBuffer getByte:[row getBuf] offset:((long long)8)] * [CapeBuffer getByte:[arow getBuf] offset:((long long)8)])) jp2:((int)([CapeBuffer getByte:[row getBuf] offset:((long long)12)] * [CapeBuffer getByte:[arow getBuf] offset:((long long)12)]))])));
}

+ (void) sampleCubic:(CapexPixelRegionBuffer*)src su:(double)su sv:(double)sv dest:(CapexImageResizerIndexMovingBuffer*)dest {
	double aval = 0.0;
	double arecip = 0.0;
	int i = 0;
	int iu = ((int)([CapeMath floor:su]));
	int iv = ((int)([CapeMath floor:sv]));
	int stride = [src getStride];
	double du = 0.0;
	double dv = 0.0;
	NSMutableData* br = [src getBufferRegion:iu - 1 y:iv - 1 newbuffer:FALSE];
	if(br == nil) {
		return;
	}
	[dest setBuf:br];
	du = su - iu;
	dv = sv - iv;
	aval = [CapexImageResizer drawableTransformCubic:dv jm1:[CapexImageResizer cubicRow:du row:[dest move:3 + stride * 0]] j:[CapexImageResizer cubicRow:du row:[dest move:3 + stride * 1]] jp1:[CapexImageResizer cubicRow:du row:[dest move:3 + stride * 2]] jp2:[CapexImageResizer cubicRow:du row:[dest move:3 + stride * 3]]];
	if(aval <= 0) {
		arecip = 0.0;
		[CapeBuffer setByte:[dest getBuf] offset:((long long)3) value:((uint8_t)0)];
	}
	else {
		if(aval > 255.0) {
			arecip = 1.0 / aval;
			[CapeBuffer setByte:[dest getBuf] offset:((long long)3) value:((uint8_t)255)];
		}
		else {
			arecip = 1.0 / aval;
			[CapeBuffer setByte:[dest getBuf] offset:((long long)3) value:((uint8_t)((int)([CapeMath rint:aval])))];
		}
	}
	for(i = 0 ; i < 3 ; i++) {
		int v = ((int)([CapeMath rint:arecip * [CapexImageResizer drawableTransformCubic:dv jm1:[CapexImageResizer cubicScaledRow:du row:[dest move:i + stride * 0] arow:[dest move:3 + stride * 0]] j:[CapexImageResizer cubicScaledRow:du row:[dest move:i + stride * 1] arow:[dest move:3 + stride * 1]] jp1:[CapexImageResizer cubicScaledRow:du row:[dest move:i + stride * 2] arow:[dest move:3 + stride * 2]] jp2:[CapexImageResizer cubicScaledRow:du row:[dest move:i + stride * 3] arow:[dest move:3 + stride * 3]]]]));
		[CapeBuffer setByte:[dest getBuf] offset:((long long)i) value:((uint8_t)[CapexImageFilterUtil clamp:((double)v)])];
	}
}

+ (CapexBitmapBuffer*) resizeBicubic:(CapexBitmapBuffer*)bb anw:(int)anw anh:(int)anh {
	if(anw == 0 || anh == 0) {
		return(nil);
	}
	if(anw < 0 && anh < 0) {
		return(bb);
	}
	NSMutableData* sb = [bb getBuffer];
	if(sb == nil) {
		return(nil);
	}
	int w = [bb getWidth];
	int h = [bb getHeight];
	double scaler = 1.0;
	int nw = anw;
	int nh = anh;
	if(nw < 0) {
		scaler = ((double)nh) / ((double)h);
	}
	else {
		if(nh < 0) {
			scaler = ((double)nw) / ((double)w);
		}
	}
	if(scaler != 1.0) {
		nw = ((int)(((double)w) * scaler));
		nh = ((int)(((double)h) * scaler));
	}
	NSMutableData* v = [NSMutableData dataWithLength:nw * nh * 4];
	CapexImageResizerIndexMovingBuffer* destp = nil;
	[destp setBuf:v];
	int y = 0;
	double sx = ((double)nw) / ((double)w);
	double sy = ((double)nh) / ((double)h);
	CapexMatrix33* matrix = [CapexMatrix33 forScale:sx scaleY:sy];
	matrix = [CapexMatrix33 invertMatrix:matrix];
	double uinc = (double)({ NSNumber* _v = (NSNumber*)[matrix->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; });
	double vinc = (double)({ NSNumber* _v = (NSNumber*)[matrix->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; });
	double winc = (double)({ NSNumber* _v = (NSNumber*)[matrix->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; });
	CapexRGBAPixelIntegerBuffer* pixels = [CapexRGBAPixelIntegerBuffer create:sb w:w h:h];
	CapexPixelRegionBuffer* pixrgn = [CapexPixelRegionBuffer forRgbaPixels:pixels w:4 h:4];
	NSMutableArray* tu = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* tv = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* tw = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* su = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* sv = [[NSMutableArray alloc] initWithCapacity:5];
	for(y = 0 ; y < nh ; y++) {
		[CapexImageResizer untransformCoords:matrix ix:0 iy:y tu:tu tv:tv tw:tw];
		int width = nw;
		while(width-- > 0) {
			int i = 0;
			[CapexImageResizer normalizeCoords:5 tu:tu tv:tv tw:tw su:su sv:sv];
			if([CapexImageResizer superSampleDtest:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) y0:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) x1:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) y1:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) x2:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) y2:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) x3:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) y3:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; })]) {
				[CapexImageResizer sampleAdapt:pixels xc:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) yc:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) x0:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) y0:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) x1:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) y1:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) x2:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) y2:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) x3:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) y3:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) dest:destp];
			}
			else {
				[CapexImageResizer sampleCubic:pixrgn su:(double)({ NSNumber* _v = (NSNumber*)[su objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) sv:(double)({ NSNumber* _v = (NSNumber*)[sv objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) dest:destp];
			}
			destp = [destp move:4];
			for(i = 0 ; i < 5 ; i++) {
				[tu insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tu objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) + uinc) atIndex:i];
				[tv insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tv objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) + vinc) atIndex:i];
				[tw insertObject:@((double)({ NSNumber* _v = (NSNumber*)[tw objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; }) + winc) atIndex:i];
			}
		}
	}
	return([CapexBitmapBuffer create:v w:nw h:nh]);
}

@end
