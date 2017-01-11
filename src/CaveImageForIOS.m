
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
#import "CapeFile.h"
#import "CapeString.h"
#import "CaveImageForIOS.h"

@implementation CaveImageForIOS

- (CaveImageForIOS*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->uiImage = nil;
	return(self);
}

+ (CaveImageForIOS*) forFile:(id<CapeFile>)file {
	CaveImageForIOS* v = [[CaveImageForIOS alloc] init];
	if([v readFromFile:file] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (CaveImageForIOS*) forUIImage:(UIImage*)uiImage {
	CaveImageForIOS* v = [[CaveImageForIOS alloc] init];
	v->uiImage = uiImage;
	return(v);
}

- (BOOL) readFromFile:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	NSString* pp = [file getPath];
	if([CapeString isEmpty:pp]) {
		return(FALSE);
	}
	UIImage* img = nil;
	img = [UIImage imageWithContentsOfFile:pp];
	if(img == nil) {
		return(FALSE);
	}
	self->uiImage = img;
	return(TRUE);
}

- (int) getPixelWidth {
	if(self->uiImage == nil) {
		return(0);
	}
	int v = 0;
	v = uiImage.size.width;
	return(v);
}

- (int) getPixelHeight {
	if(self->uiImage == nil) {
		return(0);
	}
	int v = 0;
	v = uiImage.size.height;
	return(v);
}

- (CaveImage*) scaleToSize:(int)w h:(int)h {
	NSLog(@"%@", @"--- stub --- cave.ImageForIOS :: scaleToSize");
	return(nil);
}

- (CaveImage*) scaleToWidth:(int)w {
	NSLog(@"%@", @"--- stub --- cave.ImageForIOS :: scaleToWidth");
	return(nil);
}

- (CaveImage*) scaleToHeight:(int)h {
	NSLog(@"%@", @"--- stub --- cave.ImageForIOS :: scaleToHeight");
	return(nil);
}

- (CaveImage*) crop:(int)x y:(int)y w:(int)w h:(int)h {
	NSLog(@"%@", @"--- stub --- cave.ImageForIOS :: crop");
	return(nil);
}

- (NSMutableData*) toRGBAData {
	NSLog(@"%@", @"--- stub --- cave.ImageForIOS :: toRGBAData");
	return(nil);
}

- (NSMutableData*) toJPGData {
	if(self->uiImage == nil) {
		return(nil);
	}
	NSMutableData* v = nil;
	v = UIImageJPEGRepresentation(uiImage, 1.0);
	return(v);
}

- (NSMutableData*) toPNGData {
	if(self->uiImage == nil) {
		return(nil);
	}
	NSMutableData* v = nil;
	v = [NSData dataWithData:UIImagePNGRepresentation(uiImage)];
	return(v);
}

- (void) releaseImage {
	self->uiImage = nil;
}

@end
