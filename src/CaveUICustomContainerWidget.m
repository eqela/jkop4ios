
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
#import "CaveUIHeightAwareWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUIWidget.h"
#import "CaveUICustomContainerWidget.h"

@implementation CaveUICustomContainerWidget

{
	BOOL allowResize;
	UIViewController* screenForWidget;
	BOOL receivePointerEvents;
	BOOL initialized;
	BOOL widgetChanged;
	int lastWidthConstraint;
	int lastLayoutWidth;
	BOOL isLayoutScheduled;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	if(self->receivePointerEvents) {
		return([super pointInside:point withEvent:event]);
	}
	for (UIView *view in self.subviews) {
		if(!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
		return(YES);
	}
	return(NO);
}

- (CaveUICustomContainerWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isLayoutScheduled = FALSE;
	self->lastLayoutWidth = -1;
	self->lastWidthConstraint = -2;
	self->widgetChanged = TRUE;
	self->initialized = FALSE;
	self->receivePointerEvents = FALSE;
	self->screenForWidget = nil;
	self->allowResize = TRUE;
	self->context = nil;
	return(self);
}

- (void) layoutSubviews {
	[self onNativelyResized];
}

- (CaveUICustomContainerWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	if([super init] == nil) {
		return(nil);
	}
	self->isLayoutScheduled = FALSE;
	self->lastLayoutWidth = -1;
	self->lastWidthConstraint = -2;
	self->widgetChanged = TRUE;
	self->initialized = FALSE;
	self->receivePointerEvents = FALSE;
	self->screenForWidget = nil;
	self->allowResize = TRUE;
	self->context = nil;
	self->context = ctx;
	[self togglePointerEventHandling:FALSE];
	return(self);
}

- (void) togglePointerEventHandling:(BOOL)active {
	if(active) {
		[self setUserInteractionEnabled:YES];
		self->receivePointerEvents = TRUE;
	}
	else {
		self->receivePointerEvents = FALSE;
	}
}

- (void) onNativelyResized {
	if([CaveUIWidget isRootWidget:((UIView*)self)]) {
		[CaveUIWidget layout:((UIView*)self) widthConstraint:[CaveUIWidget getWidth:((UIView*)self)] force:FALSE];
		[self onWidgetHeightChanged:[CaveUIWidget getHeight:((UIView*)self)]];
	}
}

- (BOOL) hasSize {
	if([CaveUIWidget getWidth:((UIView*)self)] > 0 || [CaveUIWidget getHeight:((UIView*)self)] > 0) {
		return(TRUE);
	}
	return(FALSE);
}

- (void) tryInitializeWidget {
	if(self->initialized) {
		return;
	}
	[self setInitialized:TRUE];
	[self initializeWidget];
}

- (void) initializeWidget {
}

- (CaveUICustomContainerWidget*) addWidget:(UIView*)widget {
	[CaveUIWidget addChild:((UIView*)self) child:widget];
	return(self);
}

- (void) onChildWidgetAdded:(UIView*)widget {
	[CaveUIWidget onChanged:((UIView*)self)];
}

- (void) onChildWidgetRemoved:(UIView*)widget {
	[CaveUIWidget onChanged:((UIView*)self)];
}

- (void) onWidgetAddedToParent {
	[CaveUIWidget onChanged:((UIView*)self)];
}

- (void) onWidgetRemovedFromParent {
}

- (void) onWidgetHeightChanged:(int)height {
}

- (void) computeWidgetLayout:(int)widthConstraint {
}

- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force {
	if(force || self->widgetChanged || widthConstraint != self->lastWidthConstraint) {
		if(force == FALSE && self->widgetChanged == FALSE && widthConstraint >= 0 && widthConstraint == self->lastLayoutWidth) {
			;
		}
		else {
			self->widgetChanged = FALSE;
			[self computeWidgetLayout:widthConstraint];
			self->lastWidthConstraint = widthConstraint;
			self->lastLayoutWidth = [CaveUIWidget getWidth:((UIView*)self)];
		}
	}
	return(TRUE);
}

- (void) scheduleLayout {
	if(self->isLayoutScheduled) {
		return;
	}
	self->isLayoutScheduled = TRUE;
	[self->context startTimer:((long long)0) callback:^void() {
		[self executeLayout];
	}];
}

- (void) executeLayout {
	self->isLayoutScheduled = FALSE;
	int ww = [CaveUIWidget getWidth:((UIView*)self)];
	if(ww == 0 && self->allowResize) {
		ww = -1;
	}
	[CaveUIWidget layout:((UIView*)self) widthConstraint:ww force:FALSE];
}

- (BOOL) getAllowResize {
	return(self->allowResize);
}

- (CaveUICustomContainerWidget*) setAllowResize:(BOOL)v {
	self->allowResize = v;
	return(self);
}

- (UIViewController*) getScreenForWidget {
	return(self->screenForWidget);
}

- (CaveUICustomContainerWidget*) setScreenForWidget:(UIViewController*)v {
	self->screenForWidget = v;
	return(self);
}

- (BOOL) getInitialized {
	return(self->initialized);
}

- (CaveUICustomContainerWidget*) setInitialized:(BOOL)v {
	self->initialized = v;
	return(self);
}

- (BOOL) getWidgetChanged {
	return(self->widgetChanged);
}

- (CaveUICustomContainerWidget*) setWidgetChanged:(BOOL)v {
	self->widgetChanged = v;
	return(self);
}

@end
