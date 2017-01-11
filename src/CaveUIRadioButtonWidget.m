
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
#import "CaveUIRadioButtonWidget.h"

@implementation CaveUIRadioButtonWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetText;
	NSString* widgetValue;
	void (^widgetClickHandler)(void);
}

- (CaveUIRadioButtonWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetClickHandler = nil;
	self->widgetValue = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIRadioButtonWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text {
	CaveUIRadioButtonWidget* v = [[CaveUIRadioButtonWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetText:text];
	return(v);
}

- (CaveUIRadioButtonWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetClickHandler = nil;
	self->widgetValue = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	return(self);
}

- (void) setWidgetText:(NSString*)text {
	self->widgetText = text;
	NSLog(@"%@", @"[cave.ui.RadioButtonWidget.setWidgetText] (RadioButtonWidget.sling:60:2): Not implemented");
}

- (NSString*) getWidgetText {
	return(self->widgetText);
}

- (void) setWidgetValue:(NSString*)value {
	self->widgetValue = value;
	NSLog(@"%@", @"[cave.ui.RadioButtonWidget.setWidgetValue] (RadioButtonWidget.sling:78:2): Not implemented");
}

- (NSString*) getWidgetValue {
	return(self->widgetValue);
}

- (void) setWidgetClickHandler:(void(^)(void))handler {
	self->widgetClickHandler = handler;
	NSLog(@"%@", @"[cave.ui.RadioButtonWidget.setWidgetClickHandler] (RadioButtonWidget.sling:97:2): Not implemented");
}

- (BOOL) isWidgetSelected {
	return(FALSE);
}

@end
