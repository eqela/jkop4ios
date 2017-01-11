
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
#import <UIKit/UIKit.h>
#import "CaveUIWidgetWithLayout.h"
#import "CaveUIHeightAwareWidget.h"

@protocol CaveGuiApplicationContext;

@interface CaveUICustomContainerWidget : UIView <CaveUIWidgetWithLayout, CaveUIHeightAwareWidget>
{
	@protected id<CaveGuiApplicationContext> context;
}
- (CaveUICustomContainerWidget*) init;
- (void) layoutSubviews;
- (CaveUICustomContainerWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (void) togglePointerEventHandling:(BOOL)active;
- (void) onNativelyResized;
- (BOOL) hasSize;
- (void) tryInitializeWidget;
- (void) initializeWidget;
- (CaveUICustomContainerWidget*) addWidget:(UIView*)widget;
- (void) onChildWidgetAdded:(UIView*)widget;
- (void) onChildWidgetRemoved:(UIView*)widget;
- (void) onWidgetAddedToParent;
- (void) onWidgetRemovedFromParent;
- (void) onWidgetHeightChanged:(int)height;
- (void) computeWidgetLayout:(int)widthConstraint;
- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force;
- (void) scheduleLayout;
- (void) executeLayout;
- (BOOL) getAllowResize;
- (CaveUICustomContainerWidget*) setAllowResize:(BOOL)v;
- (UIViewController*) getScreenForWidget;
- (CaveUICustomContainerWidget*) setScreenForWidget:(UIViewController*)v;
- (BOOL) getInitialized;
- (CaveUICustomContainerWidget*) setInitialized:(BOOL)v;
- (BOOL) getWidgetChanged;
- (CaveUICustomContainerWidget*) setWidgetChanged:(BOOL)v;
@end
