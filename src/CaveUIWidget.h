
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

@class CaveUIScreenForWidget;
@class CaveUICustomContainerWidget;
@class CaveUIWidgetWidgetClickForwarder;

@interface CaveUIWidget : NSObject
- (CaveUIWidget*) init;
+ (void) onWidgetAddedToParent:(UIView*)widget;
+ (void) onWidgetRemovedFromParent:(UIView*)widget;
+ (void) notifyOnAddedToScreen:(UIView*)widget screen:(CaveUIScreenForWidget*)screen;
+ (void) notifyOnRemovedFromScreen:(UIView*)widget screen:(CaveUIScreenForWidget*)screen;
+ (void) addChild:(UIView*)parent child:(UIView*)child;
+ (UIView*) removeFromParent:(UIView*)child;
+ (BOOL) hasParent:(UIView*)widget;
+ (UIView*) getParent:(UIView*)widget;
+ (NSMutableArray*) getChildren:(UIView*)widget;
+ (int) getX:(UIView*)widget;
+ (int) getY:(UIView*)widget;
+ (int) getWidth:(UIView*)widget;
+ (int) getHeight:(UIView*)widget;
+ (void) move:(UIView*)widget x:(int)x y:(int)y;
+ (BOOL) isRootWidget:(UIView*)widget;
+ (UIViewController*) findScreen:(UIView*)widget;
+ (CaveUICustomContainerWidget*) findRootWidget:(UIView*)widget;
+ (BOOL) setLayoutSize:(UIView*)widget width:(int)width height:(int)height;
+ (BOOL) resizeHeight:(UIView*)widget height:(int)height;
+ (void) layout:(UIView*)widget widthConstraint:(int)widthConstraint force:(BOOL)force;
+ (void) setWidgetClickHandler:(UIView*)widget handler:(void(^)(void))handler;
+ (void) removeChildrenOf:(UIView*)widget;
+ (void) onChanged:(UIView*)widget;
+ (void) setAlpha:(UIView*)widget alpha:(double)alpha;
@end
