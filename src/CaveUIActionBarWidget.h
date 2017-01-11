
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

@protocol CaveGuiApplicationContext;
@class CaveColor;
@class CaveUILabelWidget;
@class CaveUIImageButtonWidget;
@class CaveUIHorizontalBoxWidget;
@class CaveUIScreenForWidget;

@interface CaveUIActionBarWidget : CaveUILayerWidget <CaveUIScreenAwareWidget>
- (CaveUIActionBarWidget*) init;
- (CaveUIActionBarWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (CaveUIActionBarWidget*) setWidgetTitle:(NSString*)value;
- (NSString*) getWidgetTitle;
- (void) configureLeftButton:(NSString*)iconResource action:(void(^)(void))action;
- (void) configureRightButton:(NSString*)iconResource action:(void(^)(void))action;
- (CaveColor*) getWidgetTextColor;
- (void) onWidgetAddedToScreen:(CaveUIScreenForWidget*)screen;
- (void) onWidgetRemovedFromScreen:(CaveUIScreenForWidget*)screen;
- (void) initializeWidget;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveUIActionBarWidget*) setWidgetBackgroundColor:(CaveColor*)v;
- (CaveUIActionBarWidget*) setWidgetTextColor:(CaveColor*)v;
@end
