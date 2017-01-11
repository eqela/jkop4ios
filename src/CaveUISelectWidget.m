
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
#import <objc/runtime.h>
#import "CaveUIWidgetWithValue.h"
#import "CaveGuiApplicationContext.h"
#import "CapeKeyValueList.h"
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CapeString.h"
#import "CapeVector.h"
#import "CapeIterator.h"
#import "CapeKeyValuePair.h"
#import "CaveUISelectWidget.h"

@implementation CaveUISelectWidget

{
	UIPickerView* pickerView;
	id<CaveGuiApplicationContext> widgetContext;
	CapeKeyValueList* widgetItems;
	void (^widgetValueChangeHandler)(void);
	CaveColor* widgetBackgroundColor;
	CaveColor* widgetTextColor;
	int widgetPadding;
	NSString* widgetFontFamily;
	double widgetFontSize;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return([self getWidgetItemCount]);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return([self getWidgetTextForIndex:row]);
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self onWidgetSelectionChanged];
}
- (CGRect)caretRectForPosition:(UITextPosition *)position {
	return CGRectZero;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, widgetPadding, widgetPadding);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, widgetPadding, widgetPadding);
}

- (CaveUISelectWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetPadding = 0;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	self->widgetValueChangeHandler = nil;
	self->widgetItems = nil;
	self->widgetContext = nil;
	self->pickerView = nil;
	return(self);
}

+ (CaveUISelectWidget*) forKeyValueList:(id<CaveGuiApplicationContext>)context options:(CapeKeyValueList*)options {
	CaveUISelectWidget* v = [[CaveUISelectWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetItemsAsKeyValueList:options];
	return(v);
}

+ (CaveUISelectWidget*) forKeyValueStringsWithGuiApplicationContextAndArrayOfString:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options {
	CaveUISelectWidget* v = [[CaveUISelectWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetItemsAsKeyValueStringsWithArrayOfString:options];
	return(v);
}

+ (CaveUISelectWidget*) forKeyValueStringsWithGuiApplicationContextAndVector:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options {
	CaveUISelectWidget* v = [[CaveUISelectWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetItemsAsKeyValueStringsWithVector:options];
	return(v);
}

+ (CaveUISelectWidget*) forStringListWithGuiApplicationContextAndArrayOfString:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options {
	CaveUISelectWidget* v = [[CaveUISelectWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetItemsAsStringListWithArrayOfString:options];
	return(v);
}

+ (CaveUISelectWidget*) forStringListWithGuiApplicationContextAndVector:(id<CaveGuiApplicationContext>)context options:(NSMutableArray*)options {
	CaveUISelectWidget* v = [[CaveUISelectWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetItemsAsStringListWithVector:options];
	return(v);
}

- (CaveUISelectWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetPadding = 0;
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	self->widgetValueChangeHandler = nil;
	self->widgetItems = nil;
	self->widgetContext = nil;
	self->pickerView = nil;
	self->widgetContext = context;
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = ((double)[context getHeightValue:@"3mm"]);
	UIPickerView *picker = [[UIPickerView alloc] init];
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	self.inputView = picker;
	[self setPlaceholder:@"(select)"];
	UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	[toolBar setBarStyle:UIBarStyleDefault];
	UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onPickerDone)];
	toolBar.items = @[flexButton, barButtonDone];
	toolBar.userInteractionEnabled = YES;
	self.inputAccessoryView = toolBar;
	pickerView = picker;
	[self updateWidgetAppearance];
	return(self);
}

- (CaveUISelectWidget*) setWidgetFontFamily:(NSString*)family {
	self->widgetFontFamily = family;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUISelectWidget*) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (void) updateWidgetFont {
	[self setMinimumFontSize:widgetFontSize];
}

- (CaveUISelectWidget*) setWidgetPadding:(int)value {
	self->widgetPadding = value;
	[self updateWidgetAppearance];
	return(self);
}

- (int) getWidgetPadding {
	return(self->widgetPadding);
}

- (CaveUISelectWidget*) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	[self updateWidgetAppearance];
	return(self);
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (CaveUISelectWidget*) setWidgetBackgroundColor:(CaveColor*)color {
	self->widgetBackgroundColor = color;
	[self updateWidgetAppearance];
	return(self);
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveColor*) getActualWidgetTextColor {
	CaveColor* textColor = self->widgetTextColor;
	if(textColor == nil) {
		if(self->widgetBackgroundColor != nil) {
			if([self->widgetBackgroundColor isLightColor]) {
				textColor = [CaveColor black];
			}
			else {
				textColor = [CaveColor white];
			}
		}
		else {
			textColor = [CaveColor black];
		}
	}
	return(textColor);
}

- (void) updateWidgetAppearance {
	CaveColor* textColor = [self getActualWidgetTextColor];
	CaveColor* bgc = self->widgetBackgroundColor;
	if(bgc != nil) {
		self.backgroundColor = [bgc toUIColor];
	}
	else {
		self.backgroundColor = nil;
	}
	self.textColor = [textColor toUIColor];
	// Padding is used automatically: See above
	[CaveUIWidget onChanged:((UIView*)self)];
}

- (void) onPickerDone {
	int index = [self getSelectedWidgetIndex];
	NSString* text = [self getWidgetTextForIndex:index];
	[self setText:text];
	[self resignFirstResponder];
}

- (void) setWidgetItemsAsKeyValueList:(CapeKeyValueList*)items {
	int selectedIndex = [self getSelectedWidgetIndex];
	self->widgetItems = items;
	[pickerView reloadAllComponents];
	[self setSelectedWidgetIndex:selectedIndex];
}

- (void) setWidgetItemsAsKeyValueStringsWithVector:(NSMutableArray*)options {
	CapeKeyValueList* list = [[CapeKeyValueList alloc] init];
	if(options != nil) {
		if(options != nil) {
			int n = 0;
			int m = [options count];
			for(n = 0 ; n < m ; n++) {
				NSString* option = ((NSString*)[options objectAtIndex:n]);
				if(option != nil) {
					NSMutableArray* comps = [CapeString split:option delim:':' max:2];
					NSString* kk = [CapeVector get:comps index:0];
					NSString* vv = [CapeVector get:comps index:1];
					if(({ NSString* _s1 = vv; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						vv = kk;
					}
					[list addDynamicAndDynamic:((id)kk) val:((id)vv)];
				}
			}
		}
	}
	[self setWidgetItemsAsKeyValueList:list];
}

- (void) setWidgetItemsAsKeyValueStringsWithArrayOfString:(NSMutableArray*)options {
	CapeKeyValueList* list = [[CapeKeyValueList alloc] init];
	if(options != nil) {
		if(options != nil) {
			int n = 0;
			int m = [options count];
			for(n = 0 ; n < m ; n++) {
				NSString* option = ((NSString*)[options objectAtIndex:n]);
				if(option != nil) {
					NSMutableArray* comps = [CapeString split:option delim:':' max:2];
					NSString* kk = [CapeVector get:comps index:0];
					NSString* vv = [CapeVector get:comps index:1];
					if(({ NSString* _s1 = vv; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						vv = kk;
					}
					[list addDynamicAndDynamic:((id)kk) val:((id)vv)];
				}
			}
		}
	}
	[self setWidgetItemsAsKeyValueList:list];
}

- (void) setWidgetItemsAsStringListWithVector:(NSMutableArray*)options {
	CapeKeyValueList* list = [[CapeKeyValueList alloc] init];
	if(options != nil) {
		if(options != nil) {
			int n = 0;
			int m = [options count];
			for(n = 0 ; n < m ; n++) {
				NSString* option = ((NSString*)[options objectAtIndex:n]);
				if(option != nil) {
					[list addDynamicAndDynamic:((id)option) val:((id)option)];
				}
			}
		}
	}
	[self setWidgetItemsAsKeyValueList:list];
}

- (void) setWidgetItemsAsStringListWithArrayOfString:(NSMutableArray*)options {
	CapeKeyValueList* list = [[CapeKeyValueList alloc] init];
	if(options != nil) {
		if(options != nil) {
			int n = 0;
			int m = [options count];
			for(n = 0 ; n < m ; n++) {
				NSString* option = ((NSString*)[options objectAtIndex:n]);
				if(option != nil) {
					[list addDynamicAndDynamic:((id)option) val:((id)option)];
				}
			}
		}
	}
	[self setWidgetItemsAsKeyValueList:list];
}

- (int) adjustSelectedWidgetItemIndex:(int)index {
	if(self->widgetItems == nil || [self->widgetItems count] < 1) {
		return(-1);
	}
	if(index < 0) {
		return(0);
	}
	if(index >= [self->widgetItems count]) {
		return([self->widgetItems count] - 1);
	}
	return(index);
}

- (int) findIndexForWidgetValue:(NSString*)_x_id {
	int v = -1;
	if(self->widgetItems != nil) {
		int n = 0;
		id<CapeIterator> it = [self->widgetItems iterate];
		while(it != nil) {
			CapeKeyValuePair* item = ((CapeKeyValuePair*)[it next]);
			if(item == nil) {
				break;
			}
			if(({ NSString* _s1 = item->key; NSString* _s2 = _x_id; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				v = n;
				break;
			}
			n++;
		}
	}
	return(v);
}

- (int) getWidgetItemCount {
	if(self->widgetItems == nil) {
		return(0);
	}
	return([self->widgetItems count]);
}

- (NSString*) getWidgetTextForIndex:(int)index {
	if(self->widgetItems == nil) {
		return(nil);
	}
	return([self->widgetItems getValue:index]);
}

- (int) getSelectedWidgetIndex {
	return([pickerView selectedRowInComponent:0]);
}

- (void) setSelectedWidgetIndex:(int)index {
	int v = [self adjustSelectedWidgetItemIndex:index];
	NSString* txt = [self getWidgetTextForIndex:v];
	if(({ NSString* _s1 = txt; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		txt = @"";
	}
	[self setText:txt];
	if(index >= 0 && index < [self getWidgetItemCount]) {
		[pickerView selectRow:index inComponent:0 animated:NO];
	}
}

- (void) setSelectedWidgetValue:(NSString*)_x_id {
	[self setSelectedWidgetIndex:[self findIndexForWidgetValue:_x_id]];
}

- (NSString*) getSelectedWidgetValue {
	int index = [self getSelectedWidgetIndex];
	if(self->widgetItems == nil || index < 0) {
		return(nil);
	}
	return([self->widgetItems getKey:index]);
}

- (void) setWidgetValue:(id)value {
	[self setSelectedWidgetValue:[CapeString asStringWithObject:value]];
}

- (id) getWidgetValue {
	return(((id)[self getSelectedWidgetValue]));
}

- (void) setWidgetValueChangeHandler:(void(^)(void))handler {
	self->widgetValueChangeHandler = handler;
}

- (void) onWidgetSelectionChanged {
	if(self->widgetValueChangeHandler != nil) {
		self->widgetValueChangeHandler();
	}
}

@end
