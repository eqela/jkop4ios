
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

@class CapexBitmapBuffer;
@class CapexMatrix33;
@class CapexRGBAPixelIntegerBuffer;
@class CapexImageResizerIndexMovingBuffer;
@class CapexPixelRegionBuffer;
@class CapexImageResizer;

@interface CapexImageResizerIndexMovingBuffer : NSObject
- (CapexImageResizerIndexMovingBuffer*) init;
- (CapexImageResizerIndexMovingBuffer*) move:(int)n;
- (NSMutableData*) getBuf;
- (CapexImageResizerIndexMovingBuffer*) setBuf:(NSMutableData*)v;
- (long long) getIndex;
- (CapexImageResizerIndexMovingBuffer*) setIndex:(long long)v;
@end

extern int CapexImageResizerFIXED_SHIFT;

@interface CapexImageResizer : NSObject
- (CapexImageResizer*) init;
+ (int) li:(double)src1 src2:(double)src2 a:(double)a;
+ (double) bilinearInterpolation:(int)q11 q21:(int)q21 q12:(int)q12 q22:(int)q22 tx:(double)tx ty:(double)ty;
+ (CapexBitmapBuffer*) resizeBilinear:(CapexBitmapBuffer*)bmpbuf anw:(int)anw anh:(int)anh;
+ (void) untransformCoords:(CapexMatrix33*)m ix:(int)ix iy:(int)iy tu:(NSMutableArray*)tu tv:(NSMutableArray*)tv tw:(NSMutableArray*)tw;
+ (void) normalizeCoords:(int)count tu:(NSMutableArray*)tu tv:(NSMutableArray*)tv tw:(NSMutableArray*)tw su:(NSMutableArray*)su sv:(NSMutableArray*)sv;
+ (void) initFixedUnit;
+ (int) double2Fixed:(double)val;
+ (double) fixed2Double:(double)val;
+ (BOOL) superSampleDtest:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3;
+ (BOOL) supersampleTest:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3;
+ (int) lerp:(int)v1 v2:(int)v2 r:(int)r;
+ (void) sampleBi:(CapexRGBAPixelIntegerBuffer*)pixels x:(int)x y:(int)y color:(NSMutableArray*)color;
+ (void) getSample:(CapexRGBAPixelIntegerBuffer*)pixels xc:(int)xc yc:(int)yc x0:(int)x0 y0:(int)y0 x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 x3:(int)x3 y3:(int)y3 cciv:(int)cciv level:(int)level color:(NSMutableArray*)color;
+ (void) sampleAdapt:(CapexRGBAPixelIntegerBuffer*)src xc:(double)xc yc:(double)yc x0:(double)x0 y0:(double)y0 x1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2 x3:(double)x3 y3:(double)y3 dest:(CapexImageResizerIndexMovingBuffer*)dest;
+ (double) drawableTransformCubic:(double)x jm1:(int)jm1 j:(int)j jp1:(int)jp1 jp2:(int)jp2;
+ (int) cubicRow:(double)dx row:(CapexImageResizerIndexMovingBuffer*)row;
+ (int) cubicScaledRow:(double)dx row:(CapexImageResizerIndexMovingBuffer*)row arow:(CapexImageResizerIndexMovingBuffer*)arow;
+ (void) sampleCubic:(CapexPixelRegionBuffer*)src su:(double)su sv:(double)sv dest:(CapexImageResizerIndexMovingBuffer*)dest;
+ (CapexBitmapBuffer*) resizeBicubic:(CapexBitmapBuffer*)bb anw:(int)anw anh:(int)anh;
@end
