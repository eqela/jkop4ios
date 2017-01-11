
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
#import "CaveUILayerWidget.h"
#import "CaveUITitleContainerWidget.h"
#import "CaveKeyListener.h"

@class CaveUISwitcherLayerWidget;
@class CaveUIActionBarWidget;
@class CapeStack;
@class CaveColor;
@protocol CaveGuiApplicationContext;
@class CaveKeyEvent;

@interface CaveUINavigationWidget : CaveUILayerWidget <CaveUITitleContainerWidget, CaveKeyListener>
{
	@protected CaveUIActionBarWidget* actionBar;
}
- (CaveUINavigationWidget*) init;
+ (BOOL) switchToContainer:(UIView*)widget newWidget:(UIView*)newWidget;
+ (BOOL) pushToContainer:(UIView*)widget newWidget:(UIView*)newWidget;
+ (UIView*) popFromContainer:(UIView*)widget;
+ (CaveUINavigationWidget*) findNavigationWidget:(UIView*)widget;
- (CaveUINavigationWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (void) onKeyEvent:(CaveKeyEvent*)event;
- (void(^)(void)) getMenuHandler;
- (NSString*) getAppIconResource;
- (void(^)(void)) getAppMenuHandler;
- (UIView*) createMainWidget;
- (void) updateMenuButton;
- (UIView*) createSidebarWidget;
- (void) computeWidgetLayout:(int)widthConstraint;
- (void) displaySidebarWidget:(BOOL)animated;
- (void) hideSidebarWidget:(BOOL)animated;
- (void) createBackground;
- (void) initializeWidget;
- (void) updateWidgetTitle:(NSString*)title;
- (BOOL) pushWidget:(UIView*)widget;
- (BOOL) switchWidget:(UIView*)widget;
- (UIView*) popWidget;
- (BOOL) getEnableSidebar;
- (CaveUINavigationWidget*) setEnableSidebar:(BOOL)v;
- (BOOL) getEnableActionBar;
- (CaveUINavigationWidget*) setEnableActionBar:(BOOL)v;
- (BOOL) getActionBarIsFloating;
- (CaveUINavigationWidget*) setActionBarIsFloating:(BOOL)v;
- (CaveColor*) getActionBarBackgroundColor;
- (CaveUINavigationWidget*) setActionBarBackgroundColor:(CaveColor*)v;
- (CaveColor*) getActionBarTextColor;
- (CaveUINavigationWidget*) setActionBarTextColor:(CaveColor*)v;
- (CaveColor*) getBackgroundColor;
- (CaveUINavigationWidget*) setBackgroundColor:(CaveColor*)v;
- (NSString*) getBackImageResourceName;
- (CaveUINavigationWidget*) setBackImageResourceName:(NSString*)v;
- (NSString*) getBurgerMenuImageResourceName;
- (CaveUINavigationWidget*) setBurgerMenuImageResourceName:(NSString*)v;
@end
