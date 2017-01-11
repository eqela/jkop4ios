
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
#import "CaveUIWidgetWithValue.h"

@protocol CaveGuiApplicationContext;
@class CaveColor;

@interface CaveUITextAreaWidget : UITextView <CaveUIWidgetWithValue>
- (CaveUITextAreaWidget*) init;
+ (CaveUITextAreaWidget*) forPlaceholder:(id<CaveGuiApplicationContext>)context placeholder:(NSString*)placeholder rows:(int)rows;
- (CaveUITextAreaWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (void) configureMonospaceFont;
- (CaveUITextAreaWidget*) setWidgetFontFamily:(NSString*)family;
- (CaveUITextAreaWidget*) setWidgetFontSize:(double)fontSize;
- (CaveUITextAreaWidget*) setWidgetTextColor:(CaveColor*)color;
- (CaveColor*) getWidgetTextColor;
- (CaveUITextAreaWidget*) setWidgetBackgroundColor:(CaveColor*)color;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveUITextAreaWidget*) setWidgetRows:(int)row;
- (CaveUITextAreaWidget*) setWidgetText:(NSString*)text;
- (CaveUITextAreaWidget*) setWidgetPlaceholder:(NSString*)placeholder;
- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedInteger:(int)padding;
- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedIntegerAndSignedInteger:(int)lr tb:(int)tb;
- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:(int)l t:(int)t r:(int)r b:(int)b;
- (NSString*) getWidgetText;
- (NSString*) getWidgetPlaceholder;
- (CaveUITextAreaWidget*) setWidgetFontStyle:(NSString*)resName;
- (void) setWidgetValue:(id)value;
- (id) getWidgetValue;
@end
