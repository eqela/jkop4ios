
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

extern int CaveLengthUNIT_POINT;
extern int CaveLengthUNIT_MILLIMETER;
extern int CaveLengthUNIT_MICROMETER;
extern int CaveLengthUNIT_NANOMETER;
extern int CaveLengthUNIT_INCH;

@interface CaveLength : NSObject
- (CaveLength*) init;
+ (int) asPoints:(NSString*)value ppi:(int)ppi;
+ (CaveLength*) forString:(NSString*)value;
+ (CaveLength*) forPoints:(double)value;
+ (CaveLength*) forMilliMeters:(double)value;
+ (CaveLength*) forMicroMeters:(double)value;
+ (CaveLength*) forNanoMeters:(double)value;
+ (CaveLength*) forInches:(double)value;
+ (CaveLength*) forValue:(double)value unit:(int)unit;
+ (CaveLength*) forStringAsPoints:(NSString*)value ppi:(int)ppi;
- (int) toPoints:(int)ppi;
- (double) getValue;
- (CaveLength*) setValue:(double)v;
- (int) getUnit;
- (CaveLength*) setUnit:(int)v;
@end
