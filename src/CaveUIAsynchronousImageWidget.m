
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
#import <objc/runtime.h>
#import "CaveUILayerWidget.h"
#import "CaveImage.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUIImageWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CaveUIAsynchronousImageWidget.h"

@implementation CaveUIAsynchronousImageWidget

{
	UIView* overlay;
	int widgetImageWidth;
	int widgetImageHeight;
	int widgetImageScaleMethod;
	CaveImage* widgetPlaceholderImage;
}

- (CaveUIAsynchronousImageWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetPlaceholderImage = nil;
	self->widgetImageScaleMethod = 0;
	self->widgetImageHeight = 0;
	self->widgetImageWidth = 0;
	self->overlay = nil;
	return(self);
}

- (CaveUIAsynchronousImageWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	self->widgetPlaceholderImage = nil;
	self->widgetImageScaleMethod = 0;
	self->widgetImageHeight = 0;
	self->widgetImageWidth = 0;
	self->overlay = nil;
	if([super initWithGuiApplicationContext:context] == nil) {
		return(nil);
	}
	return(self);
}

- (void) configureImageWidgetProperties:(CaveUIImageWidget*)imageWidget {
	[imageWidget setWidgetImageWidth:self->widgetImageWidth];
	[imageWidget setWidgetImageHeight:self->widgetImageHeight];
	[imageWidget setWidgetImageScaleMethod:self->widgetImageScaleMethod];
}

- (CaveUIImageWidget*) onStartLoading:(BOOL)useOverlay {
	[self removeAllChildren];
	CaveUIImageWidget* v = [[CaveUIImageWidget alloc] initWithGuiApplicationContext:self->context];
	[self configureImageWidgetProperties:v];
	if(self->widgetPlaceholderImage != nil) {
		[v setWidgetImage:self->widgetPlaceholderImage];
	}
	[self addWidget:((UIView*)v)];
	if(useOverlay) {
		self->overlay = ((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor forRGBA:0 g:0 b:0 a:200]]);
		[self addWidget:self->overlay];
	}
	return(v);
}

- (void) onEndLoading {
	if(self->overlay != nil) {
		[CaveUIWidget removeFromParent:self->overlay];
		self->overlay = nil;
	}
}

- (int) getWidgetImageWidth {
	return(self->widgetImageWidth);
}

- (CaveUIAsynchronousImageWidget*) setWidgetImageWidth:(int)v {
	self->widgetImageWidth = v;
	return(self);
}

- (int) getWidgetImageHeight {
	return(self->widgetImageHeight);
}

- (CaveUIAsynchronousImageWidget*) setWidgetImageHeight:(int)v {
	self->widgetImageHeight = v;
	return(self);
}

- (int) getWidgetImageScaleMethod {
	return(self->widgetImageScaleMethod);
}

- (CaveUIAsynchronousImageWidget*) setWidgetImageScaleMethod:(int)v {
	self->widgetImageScaleMethod = v;
	return(self);
}

- (CaveImage*) getWidgetPlaceholderImage {
	return(self->widgetPlaceholderImage);
}

- (CaveUIAsynchronousImageWidget*) setWidgetPlaceholderImage:(CaveImage*)v {
	self->widgetPlaceholderImage = v;
	return(self);
}

@end
