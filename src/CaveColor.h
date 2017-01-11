
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
#import <UIKit/UIKit.h>

@class CapeStringBuilder;

@interface CaveColor : NSObject
+ (CaveColor*) black;
+ (CaveColor*) white;
+ (CaveColor*) asColorWithString:(NSString*)o;
+ (CaveColor*) asColorWithObject:(id)o;
+ (CaveColor*) instance:(NSString*)str;
+ (CaveColor*) forString:(NSString*)str;
+ (CaveColor*) forRGBDouble:(double)r g:(double)g b:(double)b;
+ (CaveColor*) forRGBADouble:(double)r g:(double)g b:(double)b a:(double)a;
+ (CaveColor*) forRGB:(int)r g:(int)g b:(int)b;
+ (CaveColor*) forRGBA:(int)r g:(int)g b:(int)b a:(int)a;
- (CaveColor*) init;
- (CaveColor*) initWithString:(NSString*)str;
- (BOOL) isWhite;
- (BOOL) isBlack;
- (BOOL) isLightColor;
- (BOOL) isDarkColor;
- (BOOL) parse:(NSString*)s;
- (CaveColor*) dup:(NSString*)arg;
- (int32_t) toRGBAInt32;
- (int32_t) toARGBInt32;
- (NSString*) toString;
- (NSString*) toRgbString;
- (NSString*) toRgbaString;
- (void) to2Digits:(NSString*)val sb:(CapeStringBuilder*)sb;
- (UIColor*) toUIColor;
- (double) getRed;
- (CaveColor*) setRed:(double)v;
- (double) getGreen;
- (CaveColor*) setGreen:(double)v;
- (double) getBlue;
- (CaveColor*) setBlue:(double)v;
- (double) getAlpha;
- (CaveColor*) setAlpha:(double)v;
@end
