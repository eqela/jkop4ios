
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

@protocol CaveGuiApplicationContext;
@class CaveColor;

extern int CaveUILabelWidgetALIGN_LEFT;
extern int CaveUILabelWidgetALIGN_CENTER;
extern int CaveUILabelWidgetALIGN_RIGHT;
extern int CaveUILabelWidgetALIGN_JUSTIFY;

@interface CaveUILabelWidget : UILabel
- (CaveUILabelWidget*) init;
+ (CaveUILabelWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text;
- (CaveUILabelWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (CaveUILabelWidget*) setWidgetText:(NSString*)text;
- (NSString*) getWidgetText;
- (CaveUILabelWidget*) setWidgetTextAlign:(int)align;
- (int) getWidgetTextAlign;
- (CaveUILabelWidget*) setWidgetTextColor:(CaveColor*)color;
- (CaveColor*) getWidgetTextColor;
- (CaveUILabelWidget*) setWidgetFontSize:(double)fontSize;
- (double) getFontSize;
- (CaveUILabelWidget*) setWidgetFontBold:(BOOL)bold;
- (CaveUILabelWidget*) setWidgetFontFamily:(NSString*)font;
@end
