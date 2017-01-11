
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

@class CapexVector2;

@interface CapexMatrix33 : NSObject
{
	@public NSMutableArray* v;
}
- (CapexMatrix33*) init;
+ (CapexMatrix33*) forZero;
+ (CapexMatrix33*) forIdentity;
+ (CapexMatrix33*) invertMatrix:(CapexMatrix33*)m;
+ (CapexMatrix33*) forTranslate:(double)translateX translateY:(double)translateY;
+ (CapexMatrix33*) forRotation:(double)angle;
+ (CapexMatrix33*) forRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY;
+ (CapexMatrix33*) forSkew:(double)skewX skewY:(double)skewY;
+ (CapexMatrix33*) forScale:(double)scaleX scaleY:(double)scaleY;
+ (CapexMatrix33*) forFlip:(BOOL)flipX flipY:(BOOL)flipY;
+ (CapexMatrix33*) forValues:(NSMutableArray*)mv;
+ (CapexMatrix33*) multiplyScalar:(double)v mm:(CapexMatrix33*)mm;
+ (CapexMatrix33*) multiplyMatrix:(CapexMatrix33*)a b:(CapexMatrix33*)b;
+ (CapexVector2*) multiplyVector:(CapexMatrix33*)a b:(CapexVector2*)b;
@end
