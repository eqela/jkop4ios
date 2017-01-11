
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
#import "CapeMath.h"

double CapeMathM_PI = 3.14159265358979;
double CapeMathM_PI_2 = 1.5707963267949;
double CapeMathM_PI_4 = 0.785398163397448;
double CapeMathM_1_PI = 0.318309886183791;
double CapeMathM_2_PI = 0.636619772367581;
double CapeMathM_2_SQRTPI = 1.12837916709551;
double CapeMathM_SQRT2 = 1.4142135623731;
double CapeMathM_SQRT1_2 = 0.707106781186548;

@implementation CapeMath

- (CapeMath*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (double) absDouble:(double)d {
	return(abs(d));
}

+ (float) absFloat:(float)f {
	return(abs(f));
}

+ (int32_t) absSigned32bitInteger:(int32_t)i {
	return(abs(i));
}

+ (int64_t) absSigned64bitInteger:(int64_t)l {
	return(abs(l));
}

+ (double) acos:(double)d {
	return(acos(d));
}

+ (double) asin:(double)d {
	return(asin(d));
}

+ (double) atan:(double)d {
	return(atan(d));
}

+ (double) atan2:(double)y x:(double)x {
	return(atan2(y, x));
}

+ (double) ceil:(double)d {
	return(ceil(d));
}

+ (double) cos:(double)d {
	return(cos(d));
}

+ (double) cosh:(double)d {
	return(cosh(d));
}

+ (double) exp:(double)d {
	return(exp(d));
}

+ (double) floor:(double)d {
	return(floor(d));
}

+ (double) remainder:(double)x y:(double)y {
	return(fmod(x, y));
}

+ (double) log:(double)d {
	return(log(d));
}

+ (double) log10:(double)d {
	return(log10(d));
}

+ (double) maxDoubleAndDouble:(double)d1 d2:(double)d2 {
	double v = d1;
	if(d1 < d2) {
		v = d2;
	}
	return(v);
}

+ (float) maxFloatAndFloat:(float)f1 f2:(float)f2 {
	float v = f1;
	if(f1 < f2) {
		v = f2;
	}
	return(v);
}

+ (int32_t) maxSigned32bitIntegerAndSigned32bitInteger:(int32_t)i1 i2:(int32_t)i2 {
	int32_t v = i1;
	if(i1 < i2) {
		v = i2;
	}
	return(v);
}

+ (int64_t) maxSigned64bitIntegerAndSigned64bitInteger:(int64_t)l1 l2:(int64_t)l2 {
	int64_t v = l1;
	if(l1 < l2) {
		v = l2;
	}
	return(v);
}

+ (double) minDoubleAndDouble:(double)d1 d2:(double)d2 {
	double v = d1;
	if(d1 > d2) {
		v = d2;
	}
	return(v);
}

+ (float) minFloatAndFloat:(float)f1 f2:(float)f2 {
	float v = f1;
	if(f1 > f2) {
		v = f2;
	}
	return(v);
}

+ (int32_t) minSigned32bitIntegerAndSigned32bitInteger:(int32_t)i1 i2:(int32_t)i2 {
	int32_t v = i1;
	if(i1 > i2) {
		v = i2;
	}
	return(v);
}

+ (int64_t) minSigned64bitIntegerAndSigned64bitInteger:(int64_t)l1 l2:(int64_t)l2 {
	int64_t v = l1;
	if(l1 > l2) {
		v = l2;
	}
	return(v);
}

+ (double) pow:(double)x y:(double)y {
	return(pow(x, y));
}

+ (double) round:(double)d {
	return(round(d));
}

+ (double) sin:(double)d {
	return(sin(d));
}

+ (double) sinh:(double)d {
	return(sinh(d));
}

+ (double) sqrt:(double)d {
	return(sqrt(d));
}

+ (double) tan:(double)d {
	return(tan(d));
}

+ (double) tanh:(double)d {
	return(tanh(d));
}

+ (double) rint:(double)n {
	return(rint(n));
}

@end
