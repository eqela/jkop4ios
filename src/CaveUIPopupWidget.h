
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
@class CaveUICanvasWidget;
@class CaveColor;

@interface CaveUIPopupWidget : CaveUILayerWidget
- (CaveUIPopupWidget*) init;
+ (CaveUIPopupWidget*) forContentWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget;
- (CaveUIPopupWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (void) setWidgetContainerBackgroundColor:(CaveColor*)color;
- (void) setWidgetContent:(UIView*)widget;
- (CaveUICanvasWidget*) getWidgetContainerBackgroundColor;
- (UIView*) getWidgetContent;
- (void) initializeWidget;
- (void) onWidgetHeightChanged:(int)height;
- (void) computeWidgetLayout:(int)widthConstraint;
- (void) showPopup:(UIView*)widget;
- (void) hidePopup;
@end
