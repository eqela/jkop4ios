
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
#import "CaveImage.h"
#import "CapeVector.h"
#import "CaveImageSheet.h"

@implementation CaveImageSheet

{
	CaveImage* sheet;
	int cols;
	int rows;
	int sourceSkipX;
	int sourceSkipY;
	int sourceImageWidth;
	int sourceImageHeight;
	int maxImages;
}

- (CaveImageSheet*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->maxImages = -1;
	self->sourceImageHeight = -1;
	self->sourceImageWidth = -1;
	self->sourceSkipY = 0;
	self->sourceSkipX = 0;
	self->rows = -1;
	self->cols = -1;
	self->sheet = nil;
	return(self);
}

- (NSMutableArray*) toImages:(int)resizeToWidth resizeToHeight:(int)resizeToHeight {
	if(self->sheet == nil) {
		return(nil);
	}
	int cols = self->cols;
	int rows = self->rows;
	int fwidth = self->sourceImageWidth;
	if(fwidth < 1) {
		fwidth = ([self->sheet getPixelWidth] - self->sourceSkipX) / cols;
	}
	else {
		cols = ([self->sheet getPixelWidth] - self->sourceSkipX) / fwidth;
	}
	int fheight = self->sourceImageHeight;
	if(fheight < 1) {
		fheight = ([self->sheet getPixelHeight] - self->sourceSkipY) / rows;
	}
	else {
		rows = ([self->sheet getPixelHeight] - self->sourceSkipY) / fheight;
	}
	NSMutableArray* frames = [[NSMutableArray alloc] init];
	int x = 0;
	int y = 0;
	for(y = 0 ; y < rows ; y++) {
		for(x = 0 ; x < cols ; x++) {
			CaveImage* img = [self->sheet crop:x * fwidth y:y * fheight w:fwidth h:fheight];
			if(resizeToWidth > 0) {
				img = [img scaleToSize:resizeToWidth h:resizeToHeight];
			}
			[frames addObject:img];
			if(self->maxImages > 0 && [CapeVector getSize:frames] >= self->maxImages) {
				return(frames);
			}
		}
	}
	return(frames);
}

- (CaveImage*) getSheet {
	return(self->sheet);
}

- (CaveImageSheet*) setSheet:(CaveImage*)v {
	self->sheet = v;
	return(self);
}

- (int) getCols {
	return(self->cols);
}

- (CaveImageSheet*) setCols:(int)v {
	self->cols = v;
	return(self);
}

- (int) getRows {
	return(self->rows);
}

- (CaveImageSheet*) setRows:(int)v {
	self->rows = v;
	return(self);
}

- (int) getSourceSkipX {
	return(self->sourceSkipX);
}

- (CaveImageSheet*) setSourceSkipX:(int)v {
	self->sourceSkipX = v;
	return(self);
}

- (int) getSourceSkipY {
	return(self->sourceSkipY);
}

- (CaveImageSheet*) setSourceSkipY:(int)v {
	self->sourceSkipY = v;
	return(self);
}

- (int) getSourceImageWidth {
	return(self->sourceImageWidth);
}

- (CaveImageSheet*) setSourceImageWidth:(int)v {
	self->sourceImageWidth = v;
	return(self);
}

- (int) getSourceImageHeight {
	return(self->sourceImageHeight);
}

- (CaveImageSheet*) setSourceImageHeight:(int)v {
	self->sourceImageHeight = v;
	return(self);
}

- (int) getMaxImages {
	return(self->maxImages);
}

- (CaveImageSheet*) setMaxImages:(int)v {
	self->maxImages = v;
	return(self);
}

@end
