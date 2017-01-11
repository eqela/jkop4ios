
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
#import "CaveUIScreenAwareWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUILabelWidget.h"
#import "CaveUIImageButtonWidget.h"
#import "CaveUIHorizontalBoxWidget.h"
#import "CapeString.h"
#import "CaveUIScreenForWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUITopMarginLayerWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUIActionBarWidget.h"

@implementation CaveUIActionBarWidget

{
	CaveColor* widgetBackgroundColor;
	CaveColor* widgetTextColor;
	NSString* widgetTitle;
	NSString* widgetLeftIconResource;
	void (^widgetLeftAction)(void);
	NSString* widgetRightIconResource;
	void (^widgetRightAction)(void);
	CaveUILabelWidget* label;
	CaveUIImageButtonWidget* leftButton;
	CaveUIImageButtonWidget* rightButton;
	CaveUIHorizontalBoxWidget* box;
}

- (CaveUIActionBarWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->box = nil;
	self->rightButton = nil;
	self->leftButton = nil;
	self->label = nil;
	self->widgetRightAction = nil;
	self->widgetRightIconResource = nil;
	self->widgetLeftAction = nil;
	self->widgetLeftIconResource = nil;
	self->widgetTitle = nil;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	return(self);
}

- (CaveUIActionBarWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->box = nil;
	self->rightButton = nil;
	self->leftButton = nil;
	self->label = nil;
	self->widgetRightAction = nil;
	self->widgetRightIconResource = nil;
	self->widgetLeftAction = nil;
	self->widgetLeftIconResource = nil;
	self->widgetTitle = nil;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (CaveUIActionBarWidget*) setWidgetTitle:(NSString*)value {
	self->widgetTitle = value;
	if(self->label != nil) {
		[self->label setWidgetText:self->widgetTitle];
	}
	return(self);
}

- (NSString*) getWidgetTitle {
	return(self->widgetTitle);
}

- (void) configureLeftButton:(NSString*)iconResource action:(void(^)(void))action {
	self->widgetLeftIconResource = iconResource;
	self->widgetLeftAction = action;
	[self updateLeftButton];
}

- (void) configureRightButton:(NSString*)iconResource action:(void(^)(void))action {
	self->widgetRightIconResource = iconResource;
	self->widgetRightAction = action;
	[self updateRightButton];
}

- (void) updateLeftButton {
	if(self->leftButton == nil) {
		return;
	}
	if([CapeString isEmpty:self->widgetLeftIconResource] == FALSE) {
		[self->leftButton setWidgetImageResource:self->widgetLeftIconResource];
		[self->leftButton setWidgetClickHandler:self->widgetLeftAction];
	}
	else {
		[self->leftButton setWidgetImageResource:nil];
		[self->leftButton setWidgetClickHandler:nil];
	}
}

- (void) updateRightButton {
	if(self->rightButton == nil) {
		return;
	}
	if([CapeString isEmpty:self->widgetRightIconResource] == FALSE) {
		[self->rightButton setWidgetImageResource:self->widgetRightIconResource];
		[self->rightButton setWidgetClickHandler:self->widgetRightAction];
	}
	else {
		[self->rightButton setWidgetImageResource:nil];
		[self->rightButton setWidgetClickHandler:nil];
	}
}

- (CaveColor*) getWidgetTextColor {
	CaveColor* wtc = self->widgetTextColor;
	if(wtc == nil) {
		wtc = [CaveColor forRGB:255 g:255 b:255];
	}
	return(wtc);
}

- (void) onWidgetAddedToScreen:(CaveUIScreenForWidget*)screen {
	CaveColor* wtc = [self getWidgetTextColor];
	if(wtc != nil && [wtc isLightColor]) {
		[screen enableLightStatusBarStyle];
	}
}

- (void) onWidgetRemovedFromScreen:(CaveUIScreenForWidget*)screen {
	[screen enableDefaultStatusBarStyle];
}

- (void) initializeWidget {
	[super initializeWidget];
	CaveColor* bgc = self->widgetBackgroundColor;
	if(bgc != nil) {
		[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
	}
	CaveUITopMarginLayerWidget* tml = [[CaveUITopMarginLayerWidget alloc] initWithGuiApplicationContext:self->context];
	self->label = [CaveUILabelWidget forText:self->context text:self->widgetTitle];
	[self->label setWidgetFontFamily:@"Arial"];
	CaveColor* wtc = [self getWidgetTextColor];
	[self->label setWidgetTextColor:wtc];
	[tml addWidget:((UIView*)[CaveUIAlignWidget forWidget:self->context widget:((UIView*)self->label) alignX:0.5 alignY:0.5 margin:0])];
	self->box = [CaveUIHorizontalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	[self->box setWidgetMargin:[self->context getWidthValue:@"1mm"]];
	[self->box setWidgetSpacing:[self->context getWidthValue:@"1mm"]];
	self->leftButton = [[CaveUIImageButtonWidget alloc] initWithGuiApplicationContext:self->context];
	[self->leftButton setWidgetButtonHeight:[self->context getHeightValue:@"6mm"]];
	[self->box addWidget:((UIView*)self->leftButton) weight:0.0];
	[self updateLeftButton];
	[self->box addWidget:((UIView*)[[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context]) weight:1.0];
	self->rightButton = [[CaveUIImageButtonWidget alloc] initWithGuiApplicationContext:self->context];
	[self->rightButton setWidgetButtonHeight:[self->context getHeightValue:@"6mm"]];
	[self->box addWidget:((UIView*)self->rightButton) weight:0.0];
	[self updateRightButton];
	[tml addWidget:((UIView*)self->box)];
	[self addWidget:((UIView*)tml)];
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveUIActionBarWidget*) setWidgetBackgroundColor:(CaveColor*)v {
	self->widgetBackgroundColor = v;
	return(self);
}

- (CaveUIActionBarWidget*) setWidgetTextColor:(CaveColor*)v {
	self->widgetTextColor = v;
	return(self);
}

@end
