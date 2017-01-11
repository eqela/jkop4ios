
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
#import <objc/runtime.h>
#import "CaveUIWidgetWithLayout.h"
#import "CaveGuiApplicationContext.h"
#import "CaveImage.h"
#import "CapeLog.h"
#import "CapeLoggingContext.h"
#import "CapeString.h"
#import "CaveImageForIOS.h"
#import "CaveUIWidget.h"
#import "CaveUIImageWidget.h"

int CaveUIImageWidgetSTRETCH = 0;
int CaveUIImageWidgetFIT = 1;
int CaveUIImageWidgetFILL = 2;

@implementation CaveUIImageWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	CaveImage* widgetImage;
	int widgetImageWidth;
	int widgetImageHeight;
	int widgetImageScaleMethod;
}

- (CaveUIImageWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetImageScaleMethod = 0;
	self->widgetImageHeight = 0;
	self->widgetImageWidth = 0;
	self->widgetImage = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIImageWidget*) forImage:(id<CaveGuiApplicationContext>)context image:(CaveImage*)image {
	CaveUIImageWidget* v = [[CaveUIImageWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetImage:image];
	return(v);
}

+ (CaveUIImageWidget*) forImageResource:(id<CaveGuiApplicationContext>)context resName:(NSString*)resName {
	CaveUIImageWidget* v = [[CaveUIImageWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetImageResource:resName];
	return(v);
}

- (CaveUIImageWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetImageScaleMethod = 0;
	self->widgetImageHeight = 0;
	self->widgetImageWidth = 0;
	self->widgetImage = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	[self setWidgetImageScaleMethod:CaveUIImageWidgetSTRETCH];
	return(self);
}

- (void) setWidgetImageScaleMethod:(int)method {
	self->widgetImageScaleMethod = method;
	if(method == CaveUIImageWidgetFIT) {
		[self setContentMode:UIViewContentModeScaleAspectFit];
	}
	else {
		if(method == CaveUIImageWidgetFILL) {
			[self setContentMode:UIViewContentModeScaleAspectFill];
		}
		else {
			if(method != CaveUIImageWidgetSTRETCH) {
				[CapeLog warning:((id<CapeLoggingContext>)self->widgetContext) message:[@"Unsupported image scale method: " stringByAppendingString:([CapeString forInteger:method])]];
			}
			[self setContentMode:UIViewContentModeScaleToFill];
		}
	}
}

- (void) setWidgetImage:(CaveImage*)image {
	self->widgetImage = image;
	UIImage* uiImage = nil;
	CaveImageForIOS* img = ((CaveImageForIOS*)({ id _v = image; [_v isKindOfClass:[CaveImageForIOS class]] ? _v : nil; }));
	if(img != nil) {
		uiImage = img->uiImage;
	}
	[self setImage:uiImage];
	[CaveUIWidget onChanged:((UIView*)self)];
}

- (void) setWidgetImageResource:(NSString*)resName {
	CaveImage* img = nil;
	if([CapeString isEmpty:resName] == FALSE && self->widgetContext != nil) {
		img = [self->widgetContext getResourceImage:resName];
		if(img == nil) {
			[CapeLog error:((id<CapeLoggingContext>)self->widgetContext) message:[[@"Failed to get resource image: `" stringByAppendingString:resName] stringByAppendingString:@"'"]];
		}
	}
	[self setWidgetImage:img];
}

- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force {
	if(self->widgetImage == nil) {
		[CaveUIWidget setLayoutSize:((UIView*)self) width:self->widgetImageWidth height:self->widgetImageHeight];
		return(TRUE);
	}
	if(widthConstraint < 0 && self->widgetImageWidth < 1 && self->widgetImageHeight < 1) {
		return(FALSE);
	}
	int width = -1;
	int height = -1;
	if(self->widgetImageWidth > 0 && self->widgetImageHeight > 0) {
		width = self->widgetImageWidth;
		height = self->widgetImageHeight;
	}
	else {
		if(self->widgetImageWidth > 0) {
			width = self->widgetImageWidth;
		}
		else {
			if(self->widgetImageHeight > 0) {
				height = self->widgetImageHeight;
			}
			else {
				width = widthConstraint;
			}
		}
	}
	if(width > 0 && widthConstraint >= 0 && width > widthConstraint) {
		width = widthConstraint;
		height = -1;
	}
	if(height < 0) {
		height = [self->widgetImage getPixelHeight] * width / [self->widgetImage getPixelWidth];
	}
	if(width < 0) {
		width = [self->widgetImage getPixelWidth] * height / [self->widgetImage getPixelHeight];
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:width height:height];
	return(TRUE);
}

- (int) getWidgetImageWidth {
	return(self->widgetImageWidth);
}

- (CaveUIImageWidget*) setWidgetImageWidth:(int)v {
	self->widgetImageWidth = v;
	return(self);
}

- (int) getWidgetImageHeight {
	return(self->widgetImageHeight);
}

- (CaveUIImageWidget*) setWidgetImageHeight:(int)v {
	self->widgetImageHeight = v;
	return(self);
}

@end
