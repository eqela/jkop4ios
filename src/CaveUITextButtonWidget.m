
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
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUILabelWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUITextButtonWidget.h"

@implementation CaveUITextButtonWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	void (^widgetClickHandler)(void);
	NSString* widgetText;
	CaveColor* widgetBackgroundColor;
	CaveColor* widgetTextColor;
	int widgetFontSize;
	NSString* widgetFontFamily;
	int padding;
}

- (CaveUITextButtonWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->padding = -1;
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = 0;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	self->widgetText = nil;
	self->widgetClickHandler = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUITextButtonWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text handler:(void(^)(void))handler {
	CaveUITextButtonWidget* v = [[CaveUITextButtonWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetText:text];
	[v setWidgetClickHandler:handler];
	return(v);
}

- (CaveUITextButtonWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->padding = -1;
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = 0;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	self->widgetText = nil;
	self->widgetClickHandler = nil;
	self->widgetContext = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->widgetContext = ctx;
	return(self);
}

- (CaveUITextButtonWidget*) setWidgetClickHandler:(void(^)(void))handler {
	self->widgetClickHandler = handler;
	[CaveUIWidget setWidgetClickHandler:((UIView*)self) handler:handler];
	return(self);
}

- (void) initializeWidget {
	[super initializeWidget];
	CaveColor* bgc = self->widgetBackgroundColor;
	if(bgc == nil) {
		bgc = [CaveColor forRGBDouble:0.6 g:0.6 b:0.6];
	}
	CaveColor* fgc = self->widgetTextColor;
	if(fgc == nil) {
		if([bgc isLightColor]) {
			fgc = [CaveColor forRGB:0 g:0 b:0];
		}
		else {
			fgc = [CaveColor forRGB:255 g:255 b:255];
		}
	}
	int padding = self->padding;
	if(padding < 0) {
		padding = [self->context getHeightValue:@"2mm"];
	}
	CaveUICanvasWidget* canvas = [CaveUICanvasWidget forColor:self->context color:bgc];
	[self addWidget:((UIView*)canvas)];
	CaveUILabelWidget* label = [CaveUILabelWidget forText:self->context text:self->widgetText];
	[label setWidgetTextColor:fgc];
	[label setWidgetFontFamily:self->widgetFontFamily];
	if(self->widgetFontSize > 0) {
		[label setWidgetFontSize:((double)self->widgetFontSize)];
	}
	[self addWidget:((UIView*)[CaveUIAlignWidget forWidget:self->context widget:((UIView*)label) alignX:0.5 alignY:0.5 margin:padding])];
}

- (NSString*) getWidgetText {
	return(self->widgetText);
}

- (CaveUITextButtonWidget*) setWidgetText:(NSString*)v {
	self->widgetText = v;
	return(self);
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveUITextButtonWidget*) setWidgetBackgroundColor:(CaveColor*)v {
	self->widgetBackgroundColor = v;
	return(self);
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (CaveUITextButtonWidget*) setWidgetTextColor:(CaveColor*)v {
	self->widgetTextColor = v;
	return(self);
}

- (int) getWidgetFontSize {
	return(self->widgetFontSize);
}

- (CaveUITextButtonWidget*) setWidgetFontSize:(int)v {
	self->widgetFontSize = v;
	return(self);
}

- (NSString*) getWidgetFontFamily {
	return(self->widgetFontFamily);
}

- (CaveUITextButtonWidget*) setWidgetFontFamily:(NSString*)v {
	self->widgetFontFamily = v;
	return(self);
}

- (int) getPadding {
	return(self->padding);
}

- (CaveUITextButtonWidget*) setPadding:(int)v {
	self->padding = v;
	return(self);
}

@end
