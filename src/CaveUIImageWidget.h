
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

@protocol CaveGuiApplicationContext;
@class CaveImage;

extern int CaveUIImageWidgetSTRETCH;
extern int CaveUIImageWidgetFIT;
extern int CaveUIImageWidgetFILL;

@interface CaveUIImageWidget : UIImageView <CaveUIWidgetWithLayout>
- (CaveUIImageWidget*) init;
+ (CaveUIImageWidget*) forImage:(id<CaveGuiApplicationContext>)context image:(CaveImage*)image;
+ (CaveUIImageWidget*) forImageResource:(id<CaveGuiApplicationContext>)context resName:(NSString*)resName;
- (CaveUIImageWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (void) setWidgetImageScaleMethod:(int)method;
- (void) setWidgetImage:(CaveImage*)image;
- (void) setWidgetImageResource:(NSString*)resName;
- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force;
- (int) getWidgetImageWidth;
- (CaveUIImageWidget*) setWidgetImageWidth:(int)v;
- (int) getWidgetImageHeight;
- (CaveUIImageWidget*) setWidgetImageHeight:(int)v;
@end
