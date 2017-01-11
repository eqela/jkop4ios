
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
#import "CaveImage.h"
#import "CaveUIButtonWidget.h"

@implementation CaveUIButtonWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetText;
	CaveColor* widgetTextColor;
	CaveColor* widgetBackgroundColor;
	CaveImage* widgetIcon;
	void (^widgetClickHandler)(void);
	NSString* widgetFont;
	double widgetFontSize;
}

- (CaveUIButtonWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFont = nil;
	self->widgetClickHandler = nil;
	self->widgetIcon = nil;
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIButtonWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text handler:(void(^)(void))handler {
	CaveUIButtonWidget* v = [[CaveUIButtonWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetText:text];
	[v setWidgetClickHandler:handler];
	return(v);
}

- (CaveUIButtonWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFont = nil;
	self->widgetClickHandler = nil;
	self->widgetIcon = nil;
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	return(self);
}

- (void) setWidgetText:(NSString*)text {
	self->widgetText = text;
	[self setTitle:text forState:UIControlStateNormal];
}

- (NSString*) getWidgetText {
	return(self->widgetText);
}

- (void) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	if(color != nil) {
		CaveColor* highlightColor = [color dup:nil];
		[highlightColor setAlpha:0.5];
		[self setTitleColor:[color toUIColor] forState:UIControlStateNormal];
		[self setTitleColor:[highlightColor toUIColor] forState:UIControlStateHighlighted];
	}
	else {
		[self setTitleColor:nil forState:UIControlStateNormal];
	}
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (void) setWidgetBackgroundColor:(CaveColor*)color {
	self->widgetBackgroundColor = color;
	if(color != nil) {
		[self setBackgroundColor:[color toUIColor]];
	}
	else {
		[self setBackgroundColor:nil];
	}
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (void) onWidgetClicked {
	if(self->widgetClickHandler != nil) {
		self->widgetClickHandler();
	}
}

- (void) setWidgetClickHandler:(void(^)(void))handler {
	self->widgetClickHandler = handler;
	[self addTarget:self action:@selector(onWidgetClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setWidgetIcon:(CaveImage*)icon {
	self->widgetIcon = icon;
	NSLog(@"%@", @"[cave.ui.ButtonWidget.setWidgetIcon] (ButtonWidget.sling:243:2): Not implemented");
}

- (CaveImage*) getWidgetIcon {
	return(self->widgetIcon);
}

- (void) setWidgetFont:(NSString*)font {
	self->widgetFont = font;
	NSLog(@"%@", @"[cave.ui.ButtonWidget.setWidgetFont] (ButtonWidget.sling:268:2): Not implemented");
}

- (void) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	NSLog(@"%@", @"[cave.ui.ButtonWidget.setWidgetFontSize] (ButtonWidget.sling:284:2): Not implemented");
}

@end
