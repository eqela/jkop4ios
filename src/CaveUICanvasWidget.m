
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
#import "CaveUIWidgetWithLayout.h"
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CaveUICanvasWidget.h"

@implementation CaveUICanvasWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	CaveColor* widgetColor;
	BOOL widgetRounded;
	NSString* widgetRoundingRadius;
	CaveColor* widgetOutlineColor;
	NSString* widgetOutlineWidth;
}

- (CaveUICanvasWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetOutlineWidth = nil;
	self->widgetOutlineColor = nil;
	self->widgetRoundingRadius = nil;
	self->widgetRounded = FALSE;
	self->widgetColor = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUICanvasWidget*) forColor:(id<CaveGuiApplicationContext>)context color:(CaveColor*)color {
	CaveUICanvasWidget* v = [[CaveUICanvasWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetColor:color];
	return(v);
}

- (CaveUICanvasWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetOutlineWidth = nil;
	self->widgetOutlineColor = nil;
	self->widgetRoundingRadius = nil;
	self->widgetRounded = FALSE;
	self->widgetColor = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	self->widgetColor = [CaveColor black];
	self->widgetOutlineColor = [CaveColor black];
	return(self);
}

- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force {
	[CaveUIWidget setLayoutSize:((UIView*)self) width:widthConstraint height:0];
	return(TRUE);
}

- (void) setWidgetColor:(CaveColor*)color {
	self->widgetColor = color;
	if(self->widgetColor == nil) {
		self.backgroundColor = nil;
	}
	else {
		self.backgroundColor = [color toUIColor];
	}
}

- (CaveColor*) getWidgetColor {
	return(self->widgetColor);
}

- (void) setWidgetOutlineColor:(CaveColor*)color {
	self->widgetOutlineColor = color;
	NSLog(@"%@", @"[cave.ui.CanvasWidget.setWidgetOutlineColor] (CanvasWidget.sling:134:2): Not implemented");
}

- (CaveColor*) getWidgetOutlineColor {
	return(self->widgetOutlineColor);
}

- (void) setWidgetOutlineWidth:(NSString*)width {
	self->widgetOutlineWidth = width;
	NSLog(@"%@", @"[cave.ui.CanvasWidget.setWidgetOutlineWidth] (CanvasWidget.sling:150:2): Not implemented");
}

- (NSString*) getWidgetOutlineWidth {
	return(self->widgetOutlineWidth);
}

- (void) setWidgetRounded:(BOOL)rounded {
	self->widgetRounded = rounded;
	NSLog(@"%@", @"[cave.ui.CanvasWidget.setWidgetRounded] (CanvasWidget.sling:174:2): Not implemented");
}

- (BOOL) getWidgetRounded {
	return(self->widgetRounded);
}

- (void) setWidgetRoundingRadius:(NSString*)radius {
	self->widgetRoundingRadius = radius;
	NSLog(@"%@", @"[cave.ui.CanvasWidget.setWidgetRoundingRadius] (CanvasWidget.sling:195:2): Not implemented");
}

- (NSString*) getWidgetRoundingRadius {
	return(self->widgetRoundingRadius);
}

@end
