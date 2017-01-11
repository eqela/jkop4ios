
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
#import "CapeCharacterIterator.h"
#import "CapeString.h"
#import "CaveLength.h"

int CaveLengthUNIT_POINT = 0;
int CaveLengthUNIT_MILLIMETER = 1;
int CaveLengthUNIT_MICROMETER = 2;
int CaveLengthUNIT_NANOMETER = 3;
int CaveLengthUNIT_INCH = 4;

@implementation CaveLength

{
	double value;
	int unit;
}

- (CaveLength*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->unit = 0;
	self->value = 0.0;
	return(self);
}

+ (int) asPoints:(NSString*)value ppi:(int)ppi {
	return([[CaveLength forString:value] toPoints:ppi]);
}

+ (CaveLength*) forString:(NSString*)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v parse:value];
	return(v);
}

+ (CaveLength*) forPoints:(double)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:CaveLengthUNIT_POINT];
	return(v);
}

+ (CaveLength*) forMilliMeters:(double)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:CaveLengthUNIT_MILLIMETER];
	return(v);
}

+ (CaveLength*) forMicroMeters:(double)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:CaveLengthUNIT_MICROMETER];
	return(v);
}

+ (CaveLength*) forNanoMeters:(double)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:CaveLengthUNIT_NANOMETER];
	return(v);
}

+ (CaveLength*) forInches:(double)value {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:CaveLengthUNIT_INCH];
	return(v);
}

+ (CaveLength*) forValue:(double)value unit:(int)unit {
	CaveLength* v = [[CaveLength alloc] init];
	[v setValue:value];
	[v setUnit:unit];
	return(v);
}

+ (CaveLength*) forStringAsPoints:(NSString*)value ppi:(int)ppi {
	CaveLength* v = [[CaveLength alloc] init];
	[v parse:value];
	[v setValue:((double)[v toPoints:ppi])];
	[v setUnit:CaveLengthUNIT_POINT];
	return(v);
}

- (void) parse:(NSString*)value {
	if(({ NSString* _s1 = value; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->value = ((double)0);
		self->unit = CaveLengthUNIT_POINT;
		return;
	}
	int i = 0;
	int n = 0;
	id<CapeCharacterIterator> it = [CapeString iterate:value];
	while(TRUE) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		else {
			if(c >= '0' && c <= '9') {
				i *= 10;
				i += ((int)(c - '0'));
			}
			else {
				break;
			}
		}
		n++;
	}
	self->value = ((double)i);
	NSString* suffix = [CapeString subStringWithStringAndSignedInteger:value start:n];
	if([CapeString isEmpty:suffix]) {
		self->unit = CaveLengthUNIT_POINT;
	}
	else {
		if(({ NSString* _s1 = suffix; NSString* _s2 = @"pt"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = suffix; NSString* _s2 = @"px"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			self->unit = CaveLengthUNIT_POINT;
		}
		else {
			if(({ NSString* _s1 = suffix; NSString* _s2 = @"mm"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				self->unit = CaveLengthUNIT_MILLIMETER;
			}
			else {
				if(({ NSString* _s1 = suffix; NSString* _s2 = @"um"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					self->unit = CaveLengthUNIT_MICROMETER;
				}
				else {
					if(({ NSString* _s1 = suffix; NSString* _s2 = @"nm"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						self->unit = CaveLengthUNIT_NANOMETER;
					}
					else {
						if(({ NSString* _s1 = suffix; NSString* _s2 = @"in"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							self->unit = CaveLengthUNIT_INCH;
						}
						else {
							self->unit = CaveLengthUNIT_POINT;
						}
					}
				}
			}
		}
	}
}

- (int) toPoints:(int)ppi {
	if(self->unit == CaveLengthUNIT_POINT) {
		return(((int)self->value));
	}
	if(self->unit == CaveLengthUNIT_MILLIMETER) {
		double v = self->value * ppi / 25;
		if(self->value > 0 && v < 1) {
			v = ((double)1);
		}
		return(((int)v));
	}
	if(self->unit == CaveLengthUNIT_MICROMETER) {
		double v = self->value * ppi / 25000;
		if(self->value > 0 && v < 1) {
			v = ((double)1);
		}
		return(((int)v));
	}
	if(self->unit == CaveLengthUNIT_NANOMETER) {
		double v = self->value * ppi / 25000000;
		if(self->value > 0 && v < 1) {
			v = ((double)1);
		}
		return(((int)v));
	}
	if(self->unit == CaveLengthUNIT_INCH) {
		double v = self->value * ppi;
		if(self->value > 0 && v < 1) {
			v = ((double)1);
		}
		return(((int)v));
	}
	return(0);
}

- (double) getValue {
	return(self->value);
}

- (CaveLength*) setValue:(double)v {
	self->value = v;
	return(self);
}

- (int) getUnit {
	return(self->unit);
}

- (CaveLength*) setUnit:(int)v {
	self->unit = v;
	return(self);
}

@end
