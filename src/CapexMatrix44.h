
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

@class CapexVector3;

@interface CapexMatrix44 : NSObject
{
	@public NSMutableArray* v;
}
- (CapexMatrix44*) init;
+ (CapexMatrix44*) forZero;
+ (CapexMatrix44*) forIdentity;
+ (CapexMatrix44*) forTranslate:(double)translateX translateY:(double)translateY translateZ:(double)translateZ;
+ (CapexMatrix44*) forXRotation:(double)angle;
+ (CapexMatrix44*) forYRotation:(double)angle;
+ (CapexMatrix44*) forZRotation:(double)angle;
+ (CapexMatrix44*) forSkew:(double)vx vy:(double)vy vz:(double)vz;
+ (CapexMatrix44*) forXRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ;
+ (CapexMatrix44*) forYRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ;
+ (CapexMatrix44*) forZRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ;
+ (CapexMatrix44*) forScale:(double)scaleX scaleY:(double)scaleY scaleZ:(double)scaleZ;
+ (CapexMatrix44*) forFlipXY:(BOOL)flipXY;
+ (CapexMatrix44*) forFlipXZ:(BOOL)flipXZ;
+ (CapexMatrix44*) forFlipYZ:(BOOL)flipYZ;
+ (CapexMatrix44*) forValues:(NSMutableArray*)mv;
+ (CapexMatrix44*) multiplyScalar:(double)v mm:(CapexMatrix44*)mm;
+ (CapexMatrix44*) multiplyMatrix:(CapexMatrix44*)a b:(CapexMatrix44*)b;
+ (CapexVector3*) multiplyVector:(CapexMatrix44*)a b:(CapexVector3*)b;
@end
