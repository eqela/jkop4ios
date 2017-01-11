
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

extern double CapeMathM_PI;
extern double CapeMathM_PI_2;
extern double CapeMathM_PI_4;
extern double CapeMathM_1_PI;
extern double CapeMathM_2_PI;
extern double CapeMathM_2_SQRTPI;
extern double CapeMathM_SQRT2;
extern double CapeMathM_SQRT1_2;

@interface CapeMath : NSObject
- (CapeMath*) init;
+ (double) absDouble:(double)d;
+ (float) absFloat:(float)f;
+ (int32_t) absSigned32bitInteger:(int32_t)i;
+ (int64_t) absSigned64bitInteger:(int64_t)l;
+ (double) acos:(double)d;
+ (double) asin:(double)d;
+ (double) atan:(double)d;
+ (double) atan2:(double)y x:(double)x;
+ (double) ceil:(double)d;
+ (double) cos:(double)d;
+ (double) cosh:(double)d;
+ (double) exp:(double)d;
+ (double) floor:(double)d;
+ (double) remainder:(double)x y:(double)y;
+ (double) log:(double)d;
+ (double) log10:(double)d;
+ (double) maxDoubleAndDouble:(double)d1 d2:(double)d2;
+ (float) maxFloatAndFloat:(float)f1 f2:(float)f2;
+ (int32_t) maxSigned32bitIntegerAndSigned32bitInteger:(int32_t)i1 i2:(int32_t)i2;
+ (int64_t) maxSigned64bitIntegerAndSigned64bitInteger:(int64_t)l1 l2:(int64_t)l2;
+ (double) minDoubleAndDouble:(double)d1 d2:(double)d2;
+ (float) minFloatAndFloat:(float)f1 f2:(float)f2;
+ (int32_t) minSigned32bitIntegerAndSigned32bitInteger:(int32_t)i1 i2:(int32_t)i2;
+ (int64_t) minSigned64bitIntegerAndSigned64bitInteger:(int64_t)l1 l2:(int64_t)l2;
+ (double) pow:(double)x y:(double)y;
+ (double) round:(double)d;
+ (double) sin:(double)d;
+ (double) sinh:(double)d;
+ (double) sqrt:(double)d;
+ (double) tan:(double)d;
+ (double) tanh:(double)d;
+ (double) rint:(double)n;
@end
