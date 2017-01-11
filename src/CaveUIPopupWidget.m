
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
#import "CaveGuiApplicationContext.h"
#import "CaveUICanvasWidget.h"
#import "CaveColor.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUIWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUIWidgetAnimation.h"
#import "CaveUIPopupWidget.h"

@implementation CaveUIPopupWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	CaveUICanvasWidget* widgetContainerBackgroundColor;
	UIView* widgetContent;
	int animationDestY;
}

- (CaveUIPopupWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->animationDestY = 0;
	self->widgetContent = nil;
	self->widgetContainerBackgroundColor = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIPopupWidget*) forContentWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget {
	CaveUIPopupWidget* v = [[CaveUIPopupWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetContent:widget];
	return(v);
}

- (CaveUIPopupWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->animationDestY = 0;
	self->widgetContent = nil;
	self->widgetContainerBackgroundColor = nil;
	self->widgetContext = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->widgetContext = ctx;
	return(self);
}

- (void) setWidgetContainerBackgroundColor:(CaveColor*)color {
	if(color != nil) {
		self->widgetContainerBackgroundColor = [CaveUICanvasWidget forColor:self->widgetContext color:color];
	}
}

- (void) setWidgetContent:(UIView*)widget {
	if(widget != nil) {
		self->widgetContent = widget;
	}
}

- (CaveUICanvasWidget*) getWidgetContainerBackgroundColor {
	return(self->widgetContainerBackgroundColor);
}

- (UIView*) getWidgetContent {
	return(self->widgetContent);
}

- (void) initializeWidget {
	[super initializeWidget];
	if(self->widgetContainerBackgroundColor == nil) {
		self->widgetContainerBackgroundColor = [CaveUICanvasWidget forColor:self->widgetContext color:[CaveColor forRGBADouble:((double)0) g:((double)0) b:((double)0) a:0.8]];
		[CaveUIWidget setWidgetClickHandler:((UIView*)self->widgetContainerBackgroundColor) handler:^void() {
			;
		}];
	}
	[self addWidget:((UIView*)self->widgetContainerBackgroundColor)];
	if(self->widgetContent != nil) {
		[self addWidget:((UIView*)[CaveUIAlignWidget forWidget:self->widgetContext widget:self->widgetContent alignX:0.5 alignY:0.5 margin:0])];
	}
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	self->animationDestY = [CaveUIWidget getY:self->widgetContent];
}

- (void) computeWidgetLayout:(int)widthConstraint {
	[super computeWidgetLayout:widthConstraint];
	self->animationDestY = [CaveUIWidget getY:self->widgetContent];
}

- (void) showPopup:(UIView*)widget {
	CaveUILayerWidget* parentLayer = nil;
	UIView* parent = widget;
	while(parent != nil) {
		if([parent isKindOfClass:[CaveUILayerWidget class]]) {
			parentLayer = ((CaveUILayerWidget*)parent);
		}
		parent = [CaveUIWidget getParent:parent];
	}
	if(parentLayer == nil) {
		NSLog(@"%@", @"[cave.ui.PopupWidget.showPopup] (PopupWidget.sling:124:3): No LayerWidget was found in the widget tree. Cannot show popup!");
		return;
	}
	[parentLayer addWidget:((UIView*)self)];
	[CaveUIWidget setAlpha:((UIView*)self->widgetContainerBackgroundColor) alpha:((double)0)];
	[CaveUIWidget setAlpha:self->widgetContent alpha:((double)0)];
	self->animationDestY = [CaveUIWidget getY:self->widgetContent];
	int ay = [self->context getHeightValue:@"3mm"];
	[CaveUIWidget move:self->widgetContent x:[CaveUIWidget getX:self->widgetContent] y:((int)(self->animationDestY + ay))];
	CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)300)];
	[anim addCallback:^void(double completion) {
		double bgf = completion * 1.5;
		if(bgf > 1.0) {
			bgf = 1.0;
		}
		[CaveUIWidget setAlpha:((UIView*)self->widgetContainerBackgroundColor) alpha:bgf];
		[CaveUIWidget setAlpha:self->widgetContent alpha:completion];
		[CaveUIWidget move:self->widgetContent x:[CaveUIWidget getX:self->widgetContent] y:((int)(self->animationDestY + (1.0 - completion) * ay))];
	}];
	[anim setEndListener:^void() {
		;
	}];
	[anim start];
}

- (void) hidePopup {
	CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)300)];
	[anim addFadeOut:((UIView*)self) removeAfter:TRUE];
	[anim start];
}

@end
