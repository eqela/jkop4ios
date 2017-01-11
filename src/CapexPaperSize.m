
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
#import "CapeStringObject.h"
#import "CapeVector.h"
#import "CapexPaperSize.h"

int CapexPaperSizeLETTER = 0;
int CapexPaperSizeLEGAL = 1;
int CapexPaperSizeA3 = 2;
int CapexPaperSizeA4 = 3;
int CapexPaperSizeA5 = 4;
int CapexPaperSizeB4 = 5;
int CapexPaperSizeB5 = 6;
int CapexPaperSizeCOUNT = 7;

@implementation CapexPaperSize

{
	int value;
}

- (CapexPaperSize*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->value = 0;
	return(self);
}

+ (NSMutableArray*) getAll {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	int n = 0;
	for(n = 0 ; n < CapexPaperSizeCOUNT ; n++) {
		[CapeVector append:v object:[CapexPaperSize forValue:n]];
	}
	return(v);
}

+ (BOOL) matches:(CapexPaperSize*)sz value:(int)value {
	if(sz != nil && [sz getValue] == value) {
		return(TRUE);
	}
	return(FALSE);
}

+ (CapexPaperSize*) forValue:(int)value {
	return([[[CapexPaperSize alloc] init] setValue:value]);
}

- (NSString*) toString {
	if(self->value == CapexPaperSizeLETTER) {
		return(@"US Letter");
	}
	if(self->value == CapexPaperSizeLEGAL) {
		return(@"US Legal");
	}
	if(self->value == CapexPaperSizeA3) {
		return(@"A3");
	}
	if(self->value == CapexPaperSizeA4) {
		return(@"A4");
	}
	if(self->value == CapexPaperSizeA5) {
		return(@"A5");
	}
	if(self->value == CapexPaperSizeB4) {
		return(@"B4");
	}
	if(self->value == CapexPaperSizeB5) {
		return(@"B5");
	}
	return(@"Unknown paper size");
}

- (int) getValue {
	return(self->value);
}

- (CapexPaperSize*) setValue:(int)v {
	self->value = v;
	return(self);
}

@end
