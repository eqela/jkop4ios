
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
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CaveColor.h"

CaveColor* CaveColorColorBlack = nil;
CaveColor* CaveColorColorWhite = nil;

@implementation CaveColor

{
	double red;
	double green;
	double blue;
	double alpha;
}

+ (CaveColor*) black {
	if(CaveColorColorBlack == nil) {
		CaveColorColorBlack = [CaveColor instance:@"black"];
	}
	return(CaveColorColorBlack);
}

+ (CaveColor*) white {
	if(CaveColorColorWhite == nil) {
		CaveColorColorWhite = [CaveColor instance:@"white"];
	}
	return(CaveColorColorWhite);
}

+ (CaveColor*) asColorWithString:(NSString*)o {
	return([[CaveColor alloc] initWithString:o]);
}

+ (CaveColor*) asColorWithObject:(id)o {
	if(o == nil) {
		return(nil);
	}
	if([o isKindOfClass:[CaveColor class]]) {
		return(((CaveColor*)o));
	}
	return(nil);
}

+ (CaveColor*) instance:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = @"none"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CaveColor* v = [[CaveColor alloc] init];
	if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([v parse:str] == FALSE) {
			v = nil;
		}
	}
	return(v);
}

+ (CaveColor*) forString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = @"none"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CaveColor* v = [[CaveColor alloc] init];
	if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([v parse:str] == FALSE) {
			v = nil;
		}
	}
	return(v);
}

+ (CaveColor*) forRGBDouble:(double)r g:(double)g b:(double)b {
	CaveColor* v = [[CaveColor alloc] init];
	[v setRed:r];
	[v setGreen:g];
	[v setBlue:b];
	[v setAlpha:1.0];
	return(v);
}

+ (CaveColor*) forRGBADouble:(double)r g:(double)g b:(double)b a:(double)a {
	CaveColor* v = [[CaveColor alloc] init];
	[v setRed:r];
	[v setGreen:g];
	[v setBlue:b];
	[v setAlpha:a];
	return(v);
}

+ (CaveColor*) forRGB:(int)r g:(int)g b:(int)b {
	CaveColor* v = [[CaveColor alloc] init];
	[v setRed:((double)(r / 255.0))];
	[v setGreen:((double)(g / 255.0))];
	[v setBlue:((double)(b / 255.0))];
	[v setAlpha:1.0];
	return(v);
}

+ (CaveColor*) forRGBA:(int)r g:(int)g b:(int)b a:(int)a {
	CaveColor* v = [[CaveColor alloc] init];
	[v setRed:((double)(r / 255.0))];
	[v setGreen:((double)(g / 255.0))];
	[v setBlue:((double)(b / 255.0))];
	[v setAlpha:((double)(a / 255.0))];
	return(v);
}

- (CaveColor*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->alpha = 0.0;
	self->blue = 0.0;
	self->green = 0.0;
	self->red = 0.0;
	return(self);
}

- (CaveColor*) initWithString:(NSString*)str {
	if([super init] == nil) {
		return(nil);
	}
	self->alpha = 0.0;
	self->blue = 0.0;
	self->green = 0.0;
	self->red = 0.0;
	[self parse:str];
	return(self);
}

- (BOOL) isWhite {
	if(self->red + self->green + self->blue >= 3.0) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isBlack {
	if(self->red + self->green + self->blue <= 0) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isLightColor {
	if(self->red + self->green + self->blue >= 1.5) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isDarkColor {
	return(![self isLightColor]);
}

- (int) hexCharToInt:(int)c {
	if(c >= '0' && c <= '9') {
		return(((int)c) - ((int)'0'));
	}
	if(c >= 'a' && c <= 'f') {
		return(10 + ((int)c) - ((int)'a'));
	}
	if(c >= 'A' && c <= 'F') {
		return(10 + ((int)c) - ((int)'A'));
	}
	return(0);
}

- (int) hexDigitToInt:(NSString*)hx {
	if([CapeString isEmpty:hx]) {
		return(0);
	}
	int c0 = [self hexCharToInt:[CapeString charAt:hx index:0]];
	if([CapeString getLength:hx] < 2) {
		return(c0);
	}
	return(c0 * 16 + [self hexCharToInt:[CapeString charAt:hx index:1]]);
}

- (BOOL) parse:(NSString*)s {
	if(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->red = 0.0;
		self->green = 0.0;
		self->blue = 0.0;
		self->alpha = 1.0;
		return(TRUE);
	}
	BOOL v = TRUE;
	self->alpha = 1.0;
	if([CapeString charAt:s index:0] == '#') {
		int slength = [CapeString getLength:s];
		if(slength == 7 || slength == 9) {
			self->red = ((double)([self hexDigitToInt:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:s start:1 length:2]] / 255.0));
			self->green = ((double)([self hexDigitToInt:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:s start:3 length:2]] / 255.0));
			self->blue = ((double)([self hexDigitToInt:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:s start:5 length:2]] / 255.0));
			if(slength == 9) {
				self->alpha = ((double)([self hexDigitToInt:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:s start:7 length:2]] / 255.0));
			}
			v = TRUE;
		}
		else {
			self->red = self->green = self->blue = 0.0;
			v = FALSE;
		}
	}
	else {
		if(({ NSString* _s1 = s; NSString* _s2 = @"black"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			self->red = 0.0;
			self->green = 0.0;
			self->blue = 0.0;
		}
		else {
			if(({ NSString* _s1 = s; NSString* _s2 = @"white"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				self->red = 1.0;
				self->green = 1.0;
				self->blue = 1.0;
			}
			else {
				if(({ NSString* _s1 = s; NSString* _s2 = @"red"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					self->red = 1.0;
					self->green = 0.0;
					self->blue = 0.0;
				}
				else {
					if(({ NSString* _s1 = s; NSString* _s2 = @"green"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						self->red = 0.0;
						self->green = 1.0;
						self->blue = 0.0;
					}
					else {
						if(({ NSString* _s1 = s; NSString* _s2 = @"blue"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							self->red = 0.0;
							self->green = 0.0;
							self->blue = 1.0;
						}
						else {
							if(({ NSString* _s1 = s; NSString* _s2 = @"lightred"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								self->red = 0.6;
								self->green = 0.4;
								self->blue = 0.4;
							}
							else {
								if(({ NSString* _s1 = s; NSString* _s2 = @"lightgreen"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									self->red = 0.4;
									self->green = 0.6;
									self->blue = 0.4;
								}
								else {
									if(({ NSString* _s1 = s; NSString* _s2 = @"lightblue"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										self->red = 0.4;
										self->green = 0.4;
										self->blue = 0.6;
									}
									else {
										if(({ NSString* _s1 = s; NSString* _s2 = @"yellow"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
											self->red = 1.0;
											self->green = 1.0;
											self->blue = 0.0;
										}
										else {
											if(({ NSString* _s1 = s; NSString* _s2 = @"cyan"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
												self->red = 0.0;
												self->green = 1.0;
												self->blue = 1.0;
											}
											else {
												if(({ NSString* _s1 = s; NSString* _s2 = @"orange"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
													self->red = 1.0;
													self->green = 0.5;
													self->blue = 0.0;
												}
												else {
													v = FALSE;
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return(v);
}

- (int) decimalStringToInteger:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(0);
	}
	int v = 0;
	int m = [CapeString getLength:str];
	int n = 0;
	for(n = 0 ; n < m ; n++) {
		int c = [CapeString charAt:str index:n];
		if(c >= '0' && c <= '9') {
			v = v * 10;
			v += ((int)(c - '0'));
		}
		else {
			break;
		}
	}
	return(v);
}

- (CaveColor*) dup:(NSString*)arg {
	double f = 1.0;
	if(!(({ NSString* _s1 = arg; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(({ NSString* _s1 = arg; NSString* _s2 = @"light"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			f = 1.2;
		}
		else {
			if(({ NSString* _s1 = arg; NSString* _s2 = @"dark"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				f = 0.8;
			}
			else {
				if([CapeString endsWith:arg str2:@"%"]) {
					f = ((double)([self decimalStringToInteger:arg])) / 100.0;
				}
			}
		}
	}
	CaveColor* v = [[CaveColor alloc] init];
	if(f > 1.0) {
		[v setRed:self->red + (1.0 - self->red) * (f - 1.0)];
		[v setGreen:self->green + (1.0 - self->green) * (f - 1.0)];
		[v setBlue:self->blue + (1.0 - self->blue) * (f - 1.0)];
	}
	else {
		if(f < 1.0) {
			[v setRed:self->red * f];
			[v setGreen:self->green * f];
			[v setBlue:self->blue * f];
		}
		else {
			[v setRed:self->red];
			[v setGreen:self->green];
			[v setBlue:self->blue];
		}
	}
	[v setAlpha:self->alpha];
	return(v);
}

- (int32_t) toRGBAInt32 {
	int32_t v = ((int32_t)0);
	v |= ((int32_t)(((int32_t)(self->red * 255)) & 255)) << 24;
	v |= ((int32_t)(((int32_t)(self->green * 255)) & 255)) << 16;
	v |= ((int32_t)(((int32_t)(self->blue * 255)) & 255)) << 8;
	v |= ((int32_t)(((int32_t)(self->alpha * 255)) & 255));
	return(v);
}

- (int32_t) toARGBInt32 {
	int32_t v = ((int32_t)0);
	v |= ((int32_t)(((int32_t)(self->alpha * 255)) & 255)) << 24;
	v |= ((int32_t)(((int32_t)(self->red * 255)) & 255)) << 16;
	v |= ((int32_t)(((int32_t)(self->green * 255)) & 255)) << 8;
	v |= ((int32_t)(((int32_t)(self->blue * 255)) & 255));
	return(v);
}

- (NSString*) toString {
	return([self toRgbaString]);
}

- (NSString*) toRgbString {
	NSString* r = [CapeString forIntegerHex:((int)(self->red * 255))];
	NSString* g = [CapeString forIntegerHex:((int)(self->green * 255))];
	NSString* b = [CapeString forIntegerHex:((int)(self->blue * 255))];
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"#"];
	[self to2Digits:r sb:sb];
	[self to2Digits:g sb:sb];
	[self to2Digits:b sb:sb];
	return([sb toString]);
}

- (NSString*) toRgbaString {
	NSString* a = [CapeString forIntegerHex:((int)(self->alpha * 255))];
	return([([self toRgbString]) stringByAppendingString:a]);
}

- (void) to2Digits:(NSString*)val sb:(CapeStringBuilder*)sb {
	if([CapeString getLength:val] == 1) {
		[sb appendCharacter:'0'];
	}
	[sb appendString:val];
}

- (UIColor*) toUIColor {
	return([UIColor colorWithRed:red green:green blue:blue alpha:alpha]);
}

- (double) getRed {
	return(self->red);
}

- (CaveColor*) setRed:(double)v {
	self->red = v;
	return(self);
}

- (double) getGreen {
	return(self->green);
}

- (CaveColor*) setGreen:(double)v {
	self->green = v;
	return(self);
}

- (double) getBlue {
	return(self->blue);
}

- (CaveColor*) setBlue:(double)v {
	self->blue = v;
	return(self);
}

- (double) getAlpha {
	return(self->alpha);
}

- (CaveColor*) setAlpha:(double)v {
	self->alpha = v;
	return(self);
}

@end
