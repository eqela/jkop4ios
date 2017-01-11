
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
#import "CaveUILayerWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveImage.h"
#import "CaveUIImageWidget.h"
#import "CaveUIWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUIImageButtonWidget.h"

@implementation CaveUIImageButtonWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	CaveImage* widgetImage;
	NSString* widgetImageResource;
	void (^widgetClickHandler)(void);
	int widgetButtonWidth;
	int widgetButtonHeight;
	CaveUIImageWidget* imageWidget;
}

- (CaveUIImageButtonWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->imageWidget = nil;
	self->widgetButtonHeight = 0;
	self->widgetButtonWidth = 0;
	self->widgetClickHandler = nil;
	self->widgetImageResource = nil;
	self->widgetImage = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIImageButtonWidget*) forImage:(id<CaveGuiApplicationContext>)context image:(CaveImage*)image handler:(void(^)(void))handler {
	CaveUIImageButtonWidget* v = [[CaveUIImageButtonWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetImage:image];
	[v setWidgetClickHandler:handler];
	return(v);
}

+ (CaveUIImageButtonWidget*) forImageResource:(id<CaveGuiApplicationContext>)context resName:(NSString*)resName handler:(void(^)(void))handler {
	CaveUIImageButtonWidget* v = [[CaveUIImageButtonWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetImageResource:resName];
	[v setWidgetClickHandler:handler];
	return(v);
}

- (CaveUIImageButtonWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->imageWidget = nil;
	self->widgetButtonHeight = 0;
	self->widgetButtonWidth = 0;
	self->widgetClickHandler = nil;
	self->widgetImageResource = nil;
	self->widgetImage = nil;
	self->widgetContext = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->widgetContext = ctx;
	return(self);
}

- (CaveUIImageButtonWidget*) setWidgetImage:(CaveImage*)image {
	self->widgetImage = image;
	self->widgetImageResource = nil;
	[self updateImageWidget];
	return(self);
}

- (CaveUIImageButtonWidget*) setWidgetImageResource:(NSString*)resName {
	self->widgetImageResource = resName;
	self->widgetImage = nil;
	[self updateImageWidget];
	return(self);
}

- (CaveUIImageButtonWidget*) setWidgetClickHandler:(void(^)(void))handler {
	self->widgetClickHandler = handler;
	[CaveUIWidget setWidgetClickHandler:((UIView*)self) handler:handler];
	return(self);
}

- (void) updateImageWidget {
	if(self->imageWidget == nil) {
		return;
	}
	if(self->widgetImage != nil) {
		[self->imageWidget setWidgetImage:self->widgetImage];
	}
	else {
		[self->imageWidget setWidgetImageResource:self->widgetImageResource];
	}
}

- (void) initializeWidget {
	[super initializeWidget];
	self->imageWidget = [[CaveUIImageWidget alloc] initWithGuiApplicationContext:self->context];
	[self->imageWidget setWidgetImageWidth:self->widgetButtonWidth];
	[self->imageWidget setWidgetImageHeight:self->widgetButtonHeight];
	[self addWidget:((UIView*)self->imageWidget)];
	[self updateImageWidget];
}

- (int) getWidgetButtonWidth {
	return(self->widgetButtonWidth);
}

- (CaveUIImageButtonWidget*) setWidgetButtonWidth:(int)v {
	self->widgetButtonWidth = v;
	return(self);
}

- (int) getWidgetButtonHeight {
	return(self->widgetButtonHeight);
}

- (CaveUIImageButtonWidget*) setWidgetButtonHeight:(int)v {
	self->widgetButtonHeight = v;
	return(self);
}

@end
