
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
@class CapeKeyValueList;
@class CaveColor;

@interface CaveUISelectWidget : UITextField <CaveUIWidgetWithValue, UIPickerViewDelegate>
- (CaveUISelectWidget*) init;
+ (CaveUISelectWidget*) forKeyValueList:(id<CaveGuiApplicationContext>)context options:(CapeKeyValueList*)options;
+ (CaveUISelectWidget*) forKeyValueStringsWithGuiApplicationContextAndArrayOfString:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options;
+ (CaveUISelectWidget*) forKeyValueStringsWithGuiApplicationContextAndVector:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options;
+ (CaveUISelectWidget*) forStringListWithGuiApplicationContextAndArrayOfString:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options;
+ (CaveUISelectWidget*) forStringListWithGuiApplicationContextAndVector:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options;
- (CaveUISelectWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (CaveUISelectWidget*) setWidgetFontFamily:(NSString*)family;
- (CaveUISelectWidget*) setWidgetFontSize:(double)fontSize;
- (CaveUISelectWidget*) setWidgetPadding:(int)value;
- (int) getWidgetPadding;
- (CaveUISelectWidget*) setWidgetTextColor:(CaveColor*)color;
- (CaveColor*) getWidgetTextColor;
- (CaveUISelectWidget*) setWidgetBackgroundColor:(CaveColor*)color;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveColor*) getActualWidgetTextColor;
- (void) onPickerDone;
- (void) setWidgetItemsAsKeyValueList:(CapeKeyValueList*)items;
- (void) setWidgetItemsAsKeyValueStringsWithVector:(NSMutableArray*)options;
- (void) setWidgetItemsAsKeyValueStringsWithArrayOfString:(NSMutableArray*)options;
- (void) setWidgetItemsAsStringListWithVector:(NSMutableArray*)options;
- (void) setWidgetItemsAsStringListWithArrayOfString:(NSMutableArray*)options;
- (int) adjustSelectedWidgetItemIndex:(int)index;
- (int) getSelectedWidgetIndex;
- (void) setSelectedWidgetIndex:(int)index;
- (void) setSelectedWidgetValue:(NSString*)_x_id;
- (NSString*) getSelectedWidgetValue;
- (void) setWidgetValue:(id)value;
- (id) getWidgetValue;
- (void) setWidgetValueChangeHandler:(void(^)(void))handler;
- (void) onWidgetSelectionChanged;
@end
