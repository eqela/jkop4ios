
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

extern int CaveUITextInputWidgetTYPE_DEFAULT;
extern int CaveUITextInputWidgetTYPE_NONASSISTED;
extern int CaveUITextInputWidgetTYPE_NAME;
extern int CaveUITextInputWidgetTYPE_EMAIL_ADDRESS;
extern int CaveUITextInputWidgetTYPE_URL;
extern int CaveUITextInputWidgetTYPE_PHONE_NUMBER;
extern int CaveUITextInputWidgetTYPE_PASSWORD;
extern int CaveUITextInputWidgetTYPE_INTEGER;
extern int CaveUITextInputWidgetTYPE_FLOAT;
extern int CaveUITextInputWidgetTYPE_STREET_ADDRESS;

@interface CaveUITextInputWidget : UITextField <CaveUIWidgetWithValue, UITextFieldDelegate>
- (CaveUITextInputWidget*) init;
+ (CaveUITextInputWidget*) forType:(id<CaveGuiApplicationContext>)context type:(int)type placeholder:(NSString*)placeholder;
- (CaveUITextInputWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (CaveUITextInputWidget*) setWidgetTextColor:(CaveColor*)color;
- (CaveColor*) getWidgetTextColor;
- (CaveUITextInputWidget*) setWidgetBackgroundColor:(CaveColor*)color;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveUITextInputWidget*) setWidgetType:(int)type;
- (int) getWidgetType;
- (CaveUITextInputWidget*) setWidgetText:(NSString*)text;
- (NSString*) getWidgetText;
- (CaveUITextInputWidget*) setWidgetPlaceholder:(NSString*)placeholder;
- (NSString*) getWidgetPlaceholder;
- (void) setWidgetPaddingWithSignedInteger:(int)padding;
- (void) setWidgetPaddingWithSignedIntegerAndSignedInteger:(int)x y:(int)y;
- (CaveUITextInputWidget*) setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:(int)l t:(int)t r:(int)r b:(int)b;
- (CaveUITextInputWidget*) setWidgetFontFamily:(NSString*)family;
- (CaveUITextInputWidget*) setWidgetFontSize:(double)fontSize;
- (void) setWidgetValue:(id)value;
- (id) getWidgetValue;
@end
