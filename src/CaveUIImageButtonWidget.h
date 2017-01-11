
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

@protocol CaveGuiApplicationContext;
@class CaveImage;
@class CaveUIImageWidget;

@interface CaveUIImageButtonWidget : CaveUILayerWidget
- (CaveUIImageButtonWidget*) init;
+ (CaveUIImageButtonWidget*) forImage:(id<CaveGuiApplicationContext>)context image:(CaveImage*)image handler:(void(^)(void))handler;
+ (CaveUIImageButtonWidget*) forImageResource:(id<CaveGuiApplicationContext>)context resName:(NSString*)resName handler:(void(^)(void))handler;
- (CaveUIImageButtonWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx;
- (CaveUIImageButtonWidget*) setWidgetImage:(CaveImage*)image;
- (CaveUIImageButtonWidget*) setWidgetImageResource:(NSString*)resName;
- (CaveUIImageButtonWidget*) setWidgetClickHandler:(void(^)(void))handler;
- (void) initializeWidget;
- (int) getWidgetButtonWidth;
- (CaveUIImageButtonWidget*) setWidgetButtonWidth:(int)v;
- (int) getWidgetButtonHeight;
- (CaveUIImageButtonWidget*) setWidgetButtonHeight:(int)v;
@end
