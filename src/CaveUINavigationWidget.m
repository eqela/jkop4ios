
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
#import "CaveUITitleContainerWidget.h"
#import "CaveKeyListener.h"
#import "CaveUIWidget.h"
#import "CaveUISwitcherLayerWidget.h"
#import "CaveUIActionBarWidget.h"
#import "CapeStack.h"
#import "CaveColor.h"
#import "CaveGuiApplicationContext.h"
#import "CaveKeyEvent.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUIHorizontalBoxWidget.h"
#import "CaveUIWidgetAnimation.h"
#import "CaveUIVerticalBoxWidget.h"
#import "CapeString.h"
#import "CapeVector.h"
#import "CaveUIDisplayAwareWidget.h"
#import "CaveUITitledWidget.h"
#import "CaveUINavigationWidget.h"

@implementation CaveUINavigationWidget

{
	CaveUISwitcherLayerWidget* contentArea;
	CapeStack* widgetStack;
	UIView* dimWidget;
	UIView* sidebarWidget;
	CaveUILayerWidget* sidebarSlotLeft;
	BOOL sidebarIsFixed;
	BOOL sidebarIsDisplayed;
	BOOL enableSidebar;
	BOOL enableActionBar;
	BOOL actionBarIsFloating;
	CaveColor* actionBarBackgroundColor;
	CaveColor* actionBarTextColor;
	CaveColor* backgroundColor;
	NSString* backImageResourceName;
	NSString* burgerMenuImageResourceName;
}

- (CaveUINavigationWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->burgerMenuImageResourceName = @"burger";
	self->backImageResourceName = @"backarrow";
	self->backgroundColor = nil;
	self->actionBarTextColor = nil;
	self->actionBarBackgroundColor = nil;
	self->actionBarIsFloating = FALSE;
	self->enableActionBar = TRUE;
	self->enableSidebar = TRUE;
	self->sidebarIsDisplayed = FALSE;
	self->sidebarIsFixed = FALSE;
	self->sidebarSlotLeft = nil;
	self->sidebarWidget = nil;
	self->dimWidget = nil;
	self->widgetStack = nil;
	self->actionBar = nil;
	self->contentArea = nil;
	return(self);
}

+ (BOOL) switchToContainer:(UIView*)widget newWidget:(UIView*)newWidget {
	CaveUINavigationWidget* ng = nil;
	UIView* pp = [CaveUIWidget getParent:widget];
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUINavigationWidget class]]) {
			ng = ((CaveUINavigationWidget*)pp);
			break;
		}
		pp = [CaveUIWidget getParent:pp];
	}
	if(ng == nil) {
		return(FALSE);
	}
	return([ng switchWidget:newWidget]);
}

+ (BOOL) pushToContainer:(UIView*)widget newWidget:(UIView*)newWidget {
	CaveUINavigationWidget* ng = nil;
	UIView* pp = [CaveUIWidget getParent:widget];
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUINavigationWidget class]]) {
			ng = ((CaveUINavigationWidget*)pp);
			break;
		}
		pp = [CaveUIWidget getParent:pp];
	}
	if(ng == nil) {
		return(FALSE);
	}
	return([ng pushWidget:newWidget]);
}

+ (UIView*) popFromContainer:(UIView*)widget {
	CaveUINavigationWidget* ng = nil;
	UIView* pp = [CaveUIWidget getParent:widget];
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUINavigationWidget class]]) {
			ng = ((CaveUINavigationWidget*)pp);
			break;
		}
		pp = [CaveUIWidget getParent:pp];
	}
	if(ng == nil) {
		return(nil);
	}
	return([ng popWidget]);
}

+ (CaveUINavigationWidget*) findNavigationWidget:(UIView*)widget {
	UIView* pp = [CaveUIWidget getParent:widget];
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUINavigationWidget class]]) {
			return(((CaveUINavigationWidget*)pp));
		}
		pp = [CaveUIWidget getParent:pp];
	}
	return(nil);
}

- (CaveUINavigationWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->burgerMenuImageResourceName = @"burger";
	self->backImageResourceName = @"backarrow";
	self->backgroundColor = nil;
	self->actionBarTextColor = nil;
	self->actionBarBackgroundColor = nil;
	self->actionBarIsFloating = FALSE;
	self->enableActionBar = TRUE;
	self->enableSidebar = TRUE;
	self->sidebarIsDisplayed = FALSE;
	self->sidebarIsFixed = FALSE;
	self->sidebarSlotLeft = nil;
	self->sidebarWidget = nil;
	self->dimWidget = nil;
	self->widgetStack = nil;
	self->actionBar = nil;
	self->contentArea = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->widgetStack = [[CapeStack alloc] init];
	self->actionBarBackgroundColor = [CaveColor black];
	self->actionBarTextColor = [CaveColor white];
	return(self);
}

- (void) onKeyEvent:(CaveKeyEvent*)event {
	if([event isKeyPress:CaveKeyEventKEY_BACK]) {
		if(self->widgetStack != nil && [self->widgetStack getSize] > 1) {
			if([self popWidget] != nil) {
				[event consume];
			}
		}
	}
}

- (void(^)(void)) getMenuHandler {
	return(nil);
}

- (NSString*) getAppIconResource {
	return(nil);
}

- (void(^)(void)) getAppMenuHandler {
	return(nil);
}

- (UIView*) createMainWidget {
	return(nil);
}

- (void) updateMenuButton {
	if(self->actionBar == nil) {
		return;
	}
	void (^handler)(void) = [self getMenuHandler];
	if(self->widgetStack != nil && [self->widgetStack getSize] > 1) {
		[self->actionBar configureLeftButton:self->backImageResourceName action:^void() {
			[self popWidget];
		}];
	}
	else {
		if(self->enableSidebar == FALSE) {
			[self->actionBar configureLeftButton:nil action:nil];
		}
		else {
			if(handler == nil) {
				if(self->sidebarIsFixed == FALSE) {
					[self->actionBar configureLeftButton:self->burgerMenuImageResourceName action:^void() {
						[self displaySidebarWidget:TRUE];
					}];
				}
				else {
					[self->actionBar configureLeftButton:nil action:nil];
				}
			}
			else {
				[self->actionBar configureLeftButton:self->burgerMenuImageResourceName action:handler];
			}
		}
	}
}

- (UIView*) createSidebarWidget {
	return(nil);
}

- (void) enableFixedSidebar {
	if(self->sidebarWidget == nil || self->sidebarSlotLeft == nil || self->sidebarIsFixed) {
		return;
	}
	[self hideSidebarWidget:FALSE];
	self->sidebarIsFixed = TRUE;
	[self->sidebarSlotLeft addWidget:self->sidebarWidget];
	[self updateMenuButton];
}

- (void) disableFixedSidebar {
	if(self->sidebarIsDisplayed || self->sidebarIsFixed == FALSE) {
		return;
	}
	[CaveUIWidget removeFromParent:self->sidebarWidget];
	self->sidebarIsFixed = FALSE;
	[self updateMenuButton];
}

- (int) updateSidebarWidthRequest:(int)sz {
	int v = 0;
	if(self->sidebarIsFixed == FALSE && self->sidebarIsDisplayed && self->sidebarWidget != nil) {
		CaveUILayerWidget* layer = ((CaveUILayerWidget*)({ id _v = [CaveUIWidget getParent:self->sidebarWidget]; [_v isKindOfClass:[CaveUILayerWidget class]] ? _v : nil; }));
		if(layer != nil) {
			v = ((int)(0.8 * sz));
			[layer setWidgetMaximumWidthRequest:v];
		}
	}
	return(v);
}

- (void) computeWidgetLayout:(int)widthConstraint {
	if(widthConstraint > [self->context getWidthValue:@"200mm"]) {
		[self enableFixedSidebar];
	}
	else {
		[self disableFixedSidebar];
	}
	[super computeWidgetLayout:widthConstraint];
}

- (void) displaySidebarWidget:(BOOL)animated {
	if(self->sidebarIsFixed || self->sidebarIsDisplayed || self->sidebarWidget == nil) {
		return;
	}
	if(self->dimWidget == nil) {
		self->dimWidget = ((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor forRGBADouble:0.0 g:0.0 b:0.0 a:0.8]]);
	}
	[self addWidget:self->dimWidget];
	self->sidebarIsDisplayed = TRUE;
	CaveUIHorizontalBoxWidget* box = [[CaveUIHorizontalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[box addWidget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:self->sidebarWidget margin:0]) weight:0.0];
	CaveUILayerWidget* filler = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	[CaveUIWidget setWidgetClickHandler:((UIView*)filler) handler:^void() {
		[self hideSidebarWidget:TRUE];
	}];
	[box addWidget:((UIView*)filler) weight:((double)1)];
	int sidebarWidthRequest = [self updateSidebarWidthRequest:[CaveUIWidget getWidth:((UIView*)self)]];
	[self addWidget:((UIView*)box)];
	if(animated) {
		[CaveUIWidget setAlpha:((UIView*)box) alpha:0.0];
		int sx = -sidebarWidthRequest;
		[CaveUIWidget move:((UIView*)box) x:sx y:[CaveUIWidget getY:((UIView*)box)]];
		[CaveUIWidget setAlpha:self->dimWidget alpha:0.0];
		CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)250)];
		[anim addCallback:^void(double completion) {
			int dx = ((int)(sx + (0 - sx) * completion));
			if(dx > 0) {
				dx = 0;
			}
			[CaveUIWidget move:((UIView*)box) x:dx y:[CaveUIWidget getY:((UIView*)box)]];
			[CaveUIWidget setAlpha:self->dimWidget alpha:completion];
			[CaveUIWidget setAlpha:((UIView*)box) alpha:completion];
		}];
		[anim start];
	}
}

- (void) hideSidebarWidget:(BOOL)animated {
	if(self->sidebarIsDisplayed == FALSE) {
		return;
	}
	self->sidebarIsDisplayed = FALSE;
	UIView* box = [CaveUIWidget getParent:[CaveUIWidget getParent:self->sidebarWidget]];
	if(animated) {
		int fx = -[CaveUIWidget getWidth:self->sidebarWidget];
		CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)250)];
		[anim addCallback:^void(double completion) {
			int dx = ((int)(fx * completion));
			[CaveUIWidget move:box x:dx y:[CaveUIWidget getY:box]];
			[CaveUIWidget setAlpha:self->dimWidget alpha:1.0 - completion];
		}];
		[anim setEndListener:^void() {
			[CaveUIWidget removeFromParent:self->sidebarWidget];
			[CaveUIWidget removeFromParent:box];
			[CaveUIWidget removeFromParent:self->dimWidget];
		}];
		[anim start];
	}
	else {
		[CaveUIWidget removeFromParent:self->sidebarWidget];
		[CaveUIWidget removeFromParent:box];
		[CaveUIWidget removeFromParent:self->dimWidget];
	}
}

- (void) createBackground {
	CaveColor* bgc = [self getBackgroundColor];
	if(bgc != nil) {
		[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
	}
}

- (void) initializeWidget {
	[super initializeWidget];
	[self createBackground];
	CaveUIVerticalBoxWidget* mainContainer = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	if(self->enableActionBar) {
		self->actionBar = [[CaveUIActionBarWidget alloc] initWithGuiApplicationContext:self->context];
		[self->actionBar setWidgetBackgroundColor:self->actionBarBackgroundColor];
		[self->actionBar setWidgetTextColor:self->actionBarTextColor];
		NSString* appIcon = [self getAppIconResource];
		if([CapeString isEmpty:appIcon] == FALSE) {
			[self->actionBar configureRightButton:appIcon action:[self getAppMenuHandler]];
		}
	}
	if(self->actionBar != nil && self->actionBarIsFloating == FALSE) {
		[mainContainer addWidget:((UIView*)self->actionBar) weight:0.0];
	}
	self->contentArea = [[CaveUISwitcherLayerWidget alloc] initWithGuiApplicationContext:self->context];
	if(self->actionBar != nil && self->actionBarIsFloating == TRUE) {
		CaveUILayerWidget* ll = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
		[ll addWidget:((UIView*)self->contentArea)];
		[ll addWidget:((UIView*)[[[CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0] addWidget:((UIView*)self->actionBar) weight:0.0] addWidget:((UIView*)[[CaveUICustomContainerWidget alloc] initWithGuiApplicationContext:self->context]) weight:1.0])];
		[mainContainer addWidget:((UIView*)ll) weight:1.0];
	}
	else {
		[mainContainer addWidget:((UIView*)self->contentArea) weight:1.0];
	}
	CaveUIHorizontalBoxWidget* superMainContainer = [CaveUIHorizontalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	self->sidebarSlotLeft = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	[superMainContainer addWidget:((UIView*)self->sidebarSlotLeft) weight:0.0];
	[superMainContainer addWidget:((UIView*)mainContainer) weight:((double)1)];
	[self addWidget:((UIView*)superMainContainer)];
	self->sidebarWidget = [self createSidebarWidget];
	[self updateMenuButton];
	UIView* main = [self createMainWidget];
	if(main != nil) {
		[self pushWidget:main];
	}
}

- (void) updateWidgetTitle:(NSString*)title {
	if(self->actionBar != nil) {
		[self->actionBar setWidgetTitle:title];
	}
}

- (void) onCurrentWidgetChanged {
	if(self->contentArea == nil) {
		return;
	}
	UIView* widget = nil;
	NSMutableArray* widgets = [CaveUIWidget getChildren:((UIView*)self->contentArea)];
	if(widgets != nil && [CapeVector getSize:widgets] > 0) {
		widget = ((UIView*)[CapeVector get:widgets index:[CapeVector getSize:widgets] - 1]);
	}
	if(widget != nil && [((NSObject*)widget) conformsToProtocol:@protocol(CaveUIDisplayAwareWidget)]) {
		[((id<CaveUIDisplayAwareWidget>)widget) onWidgetDisplayed];
	}
	if(widget != nil && [((NSObject*)widget) conformsToProtocol:@protocol(CaveUITitledWidget)]) {
		[self updateWidgetTitle:[((id<CaveUITitledWidget>)widget) getWidgetTitle]];
	}
	else {
		[self updateWidgetTitle:@""];
	}
	[self updateMenuButton];
}

- (BOOL) pushWidget:(UIView*)widget {
	if(self->contentArea == nil || widget == nil) {
		return(FALSE);
	}
	[self->widgetStack push:((id)widget)];
	[self->contentArea addWidget:widget];
	[self onCurrentWidgetChanged];
	return(TRUE);
}

- (BOOL) switchWidget:(UIView*)widget {
	if(widget == nil) {
		return(FALSE);
	}
	[self popWidget];
	return([self pushWidget:widget]);
}

- (UIView*) popWidget {
	if(self->contentArea == nil) {
		return(nil);
	}
	UIView* topmost = ((UIView*)[self->widgetStack pop]);
	if(topmost == nil) {
		return(nil);
	}
	[CaveUIWidget removeFromParent:topmost];
	[self onCurrentWidgetChanged];
	return(topmost);
}

- (BOOL) getEnableSidebar {
	return(self->enableSidebar);
}

- (CaveUINavigationWidget*) setEnableSidebar:(BOOL)v {
	self->enableSidebar = v;
	return(self);
}

- (BOOL) getEnableActionBar {
	return(self->enableActionBar);
}

- (CaveUINavigationWidget*) setEnableActionBar:(BOOL)v {
	self->enableActionBar = v;
	return(self);
}

- (BOOL) getActionBarIsFloating {
	return(self->actionBarIsFloating);
}

- (CaveUINavigationWidget*) setActionBarIsFloating:(BOOL)v {
	self->actionBarIsFloating = v;
	return(self);
}

- (CaveColor*) getActionBarBackgroundColor {
	return(self->actionBarBackgroundColor);
}

- (CaveUINavigationWidget*) setActionBarBackgroundColor:(CaveColor*)v {
	self->actionBarBackgroundColor = v;
	return(self);
}

- (CaveColor*) getActionBarTextColor {
	return(self->actionBarTextColor);
}

- (CaveUINavigationWidget*) setActionBarTextColor:(CaveColor*)v {
	self->actionBarTextColor = v;
	return(self);
}

- (CaveColor*) getBackgroundColor {
	return(self->backgroundColor);
}

- (CaveUINavigationWidget*) setBackgroundColor:(CaveColor*)v {
	self->backgroundColor = v;
	return(self);
}

- (NSString*) getBackImageResourceName {
	return(self->backImageResourceName);
}

- (CaveUINavigationWidget*) setBackImageResourceName:(NSString*)v {
	self->backImageResourceName = v;
	return(self);
}

- (NSString*) getBurgerMenuImageResourceName {
	return(self->burgerMenuImageResourceName);
}

- (CaveUINavigationWidget*) setBurgerMenuImageResourceName:(NSString*)v {
	self->burgerMenuImageResourceName = v;
	return(self);
}

@end
