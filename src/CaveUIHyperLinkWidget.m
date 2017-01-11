
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
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CaveUIHyperLinkWidget.h"

@implementation CaveUIHyperLinkWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetText;
	CaveColor* widgetTextColor;
	double widgetFontSize;
	void (^widgetClickHandler)(void);
	NSString* widgetUrl;
}

- (CaveUIHyperLinkWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetUrl = nil;
	self->widgetClickHandler = nil;
	self->widgetFontSize = 0.0;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIHyperLinkWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text handler:(void(^)(void))handler {
	CaveUIHyperLinkWidget* v = [[CaveUIHyperLinkWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetText:text];
	[v setWidgetClickHandler:handler];
	return(v);
}

- (CaveUIHyperLinkWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetUrl = nil;
	self->widgetClickHandler = nil;
	self->widgetFontSize = 0.0;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	[self setWidgetTextColor:[CaveColor forRGB:0 g:0 b:255]];
	[self setWidgetFontSize:((double)[context getHeightValue:@"3mm"])];
	[self setNumberOfLines:0];
	[self setTextAlignment:UITextAlignmentLeft];
	return(self);
}

- (void) setWidgetText:(NSString*)text {
	self->widgetText = text;
	[self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
}

- (NSString*) getWidgetText {
	return(self->widgetText);
}

- (void) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	if(color != nil) {
		[self setTextColor:[color toUIColor]];
	}
	else {
		[self setTextColor:nil];
	}
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (void) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	[self setFont:[UIFont fontWithName:@"Arial" size:widgetFontSize]];
}

- (double) getFontSize {
	return(self->widgetFontSize);
}

- (void) setWidgetClickHandler:(void(^)(void))handler {
	self->widgetClickHandler = handler;
	[CaveUIWidget setWidgetClickHandler:((UIView*)self) handler:handler];
}

- (void) setWidgetUrl:(NSString*)url {
	self->widgetUrl = url;
}

- (NSString*) getWidgetUrl {
	return(self->widgetUrl);
}

@end
