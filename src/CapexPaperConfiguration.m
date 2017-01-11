
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
#import "CapexPaperSize.h"
#import "CapexPaperOrientation.h"
#import "CapexPaperConfiguration.h"

@class CapexPaperConfigurationSize;

@implementation CapexPaperConfigurationSize

- (CapexPaperConfigurationSize*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->height = 0.0;
	self->width = 0.0;
	self->width = 0.0;
	self->height = 0.0;
	return(self);
}

- (CapexPaperConfigurationSize*) initWithDoubleAndDouble:(double)w h:(double)h {
	if([super init] == nil) {
		return(nil);
	}
	self->height = 0.0;
	self->width = 0.0;
	self->width = w;
	self->height = h;
	return(self);
}

- (double) getHeight {
	return(self->height);
}

- (double) getWidth {
	return(self->width);
}

@end

@implementation CapexPaperConfiguration

{
	CapexPaperSize* size;
	CapexPaperOrientation* orientation;
}

- (CapexPaperConfiguration*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->orientation = nil;
	self->size = nil;
	return(self);
}

+ (CapexPaperConfiguration*) forDefault {
	return([CapexPaperConfiguration forA4Portrait]);
}

+ (CapexPaperConfiguration*) forA4Portrait {
	CapexPaperConfiguration* v = [[CapexPaperConfiguration alloc] init];
	[v setSize:[CapexPaperSize forValue:CapexPaperSizeA4]];
	[v setOrientation:[CapexPaperOrientation forValue:CapexPaperOrientationPORTRAIT]];
	return(v);
}

+ (CapexPaperConfiguration*) forA4Landscape {
	CapexPaperConfiguration* v = [[CapexPaperConfiguration alloc] init];
	[v setSize:[CapexPaperSize forValue:CapexPaperSizeA4]];
	[v setOrientation:[CapexPaperOrientation forValue:CapexPaperOrientationLANDSCAPE]];
	return(v);
}

- (CapexPaperConfigurationSize*) getSizeInches {
	CapexPaperConfigurationSize* sz = [self getRawSizeInches];
	if([CapexPaperOrientation matches:self->orientation value:CapexPaperOrientationLANDSCAPE]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:[sz getHeight] h:[sz getWidth]]);
	}
	return(sz);
}

- (CapexPaperConfigurationSize*) getRawSizeInches {
	if([CapexPaperSize matches:self->size value:CapexPaperSizeLETTER]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:8.5 h:((double)11)]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeLEGAL]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:8.5 h:((double)14)]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeA3]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:11.7 h:16.5]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeA4]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:8.27 h:11.7]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeA5]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:5.8 h:8.3]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeB4]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:9.8 h:13.9]);
	}
	if([CapexPaperSize matches:self->size value:CapexPaperSizeB5]) {
		return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:6.9 h:9.8]);
	}
	return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:8.27 h:11.7]);
}

- (CapexPaperConfigurationSize*) getSizeDots:(int)dpi {
	CapexPaperConfigurationSize* szi = [self getSizeInches];
	return([[CapexPaperConfigurationSize alloc] initWithDoubleAndDouble:[szi getWidth] * dpi h:[szi getHeight] * dpi]);
}

- (CapexPaperSize*) getSize {
	return(self->size);
}

- (CapexPaperConfiguration*) setSize:(CapexPaperSize*)v {
	self->size = v;
	return(self);
}

- (CapexPaperOrientation*) getOrientation {
	return(self->orientation);
}

- (CapexPaperConfiguration*) setOrientation:(CapexPaperOrientation*)v {
	self->orientation = v;
	return(self);
}

@end
