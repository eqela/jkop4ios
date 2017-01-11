
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

@protocol CaveGuiApplicationContext;
@class CaveColor;

@interface CaveUISidebarWidget : CaveUILayerWidget
- (CaveUISidebarWidget*) init;
- (CaveUISidebarWidget*) forItems:(id<CaveGuiApplicationContext>)ctx items:(NSMutableArray*)items color:(CaveColor*)color;
- (CaveUISidebarWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (void) addToWidgetItems:(UIView*)widget;
- (CaveColor*) determineBackgroundColor;
- (UIView*) addLabelItem:(NSString*)text bold:(BOOL)bold backgroundColor:(CaveColor*)backgroundColor textColor:(CaveColor*)textColor;
- (UIView*) addActionItem:(NSString*)text handler:(void(^)(void))handler bold:(BOOL)bold backgroundColor:(CaveColor*)backgroundColor textColor:(CaveColor*)textColor;
- (void) initializeWidget;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveUISidebarWidget*) setWidgetBackgroundColor:(CaveColor*)v;
- (CaveColor*) getDefaultActionItemWidgetBackgroundColor;
- (CaveUISidebarWidget*) setDefaultActionItemWidgetBackgroundColor:(CaveColor*)v;
- (CaveColor*) getDefaultActionItemWidgetTextColor;
- (CaveUISidebarWidget*) setDefaultActionItemWidgetTextColor:(CaveColor*)v;
- (CaveColor*) getDefaultLabelItemWidgetBackgroundColor;
- (CaveUISidebarWidget*) setDefaultLabelItemWidgetBackgroundColor:(CaveColor*)v;
- (CaveColor*) getDefaultLabelItemWidgetTextColor;
- (CaveUISidebarWidget*) setDefaultLabelItemWidgetTextColor:(CaveColor*)v;
- (NSMutableArray*) getWidgetItems;
- (CaveUISidebarWidget*) setWidgetItems:(NSMutableArray*)v;
@end
