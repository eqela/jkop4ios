
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
#import "CaveUIWidgetWithValue.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUISelectWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CapeDateTime.h"
#import "CapeKeyValueList.h"
#import "CapeString.h"
#import "CaveUIHorizontalBoxWidget.h"
#import "CapeStringBuilder.h"
#import "CaveUIDateSelectorWidget.h"

@implementation CaveUIDateSelectorWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	CaveUISelectWidget* dayBox;
	CaveUISelectWidget* monthBox;
	CaveUISelectWidget* yearBox;
	NSString* value;
	int skipYears;
}

- (CaveUIDateSelectorWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->skipYears = 0;
	self->value = nil;
	self->yearBox = nil;
	self->monthBox = nil;
	self->dayBox = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIDateSelectorWidget*) forContext:(id<CaveGuiApplicationContext>)context {
	CaveUIDateSelectorWidget* v = [[CaveUIDateSelectorWidget alloc] initWithGuiApplicationContext:context];
	return(v);
}

- (CaveUIDateSelectorWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->skipYears = 0;
	self->value = nil;
	self->yearBox = nil;
	self->monthBox = nil;
	self->dayBox = nil;
	self->widgetContext = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->widgetContext = ctx;
	return(self);
}

- (void) initializeWidget {
	[super initializeWidget];
	self->dayBox = [CaveUISelectWidget forStringListWithGuiApplicationContextAndArrayOfString:self->context options:[NSMutableArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", nil]];
	self->monthBox = [CaveUISelectWidget forKeyValueStringsWithGuiApplicationContextAndArrayOfString:self->context options:[NSMutableArray arrayWithObjects: @"1:January", @"2:February", @"3:March", @"4:April", @"5:May", @"6:June", @"7:July", @"8:August", @"9:September", @"10:October", @"11:November", @"12:December", nil]];
	int cy = [[CapeDateTime forNow] getYear];
	if(cy < 1) {
		cy = 2016;
	}
	cy -= self->skipYears;
	CapeKeyValueList* yearOptions = [[CapeKeyValueList alloc] init];
	for(int i = cy ; i >= 1920 ; i--) {
		NSString* str = [CapeString forInteger:i];
		[yearOptions addDynamicAndDynamic:((id)str) val:((id)str)];
	}
	self->yearBox = [CaveUISelectWidget forKeyValueList:self->context options:yearOptions];
	CaveUIHorizontalBoxWidget* box = [CaveUIHorizontalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	[box setWidgetSpacing:[self->context getHeightValue:@"1mm"]];
	[box addWidget:((UIView*)self->dayBox) weight:((double)1)];
	[box addWidget:((UIView*)self->monthBox) weight:((double)2)];
	[box addWidget:((UIView*)self->yearBox) weight:((double)1)];
	[self addWidget:((UIView*)box)];
	[self applyValueToWidgets];
}

- (void) applyValueToWidgets {
	if(self->dayBox == nil || self->monthBox == nil || self->yearBox == nil) {
		return;
	}
	if(({ NSString* _s1 = self->value; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	NSString* year = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:self->value start:0 length:4];
	NSString* month = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:self->value start:4 length:2];
	NSString* day = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:self->value start:6 length:2];
	if([CapeString startsWith:day str2:@"0" offset:0]) {
		day = [CapeString getSubStringWithStringAndSignedInteger:day start:1];
	}
	if([CapeString startsWith:month str2:@"0" offset:0]) {
		month = [CapeString getSubStringWithStringAndSignedInteger:month start:1];
	}
	[self->yearBox setWidgetValue:((id)year)];
	[self->monthBox setWidgetValue:((id)month)];
	[self->dayBox setWidgetValue:((id)day)];
}

- (void) getValueFromWidgets {
	if(self->dayBox == nil || self->monthBox == nil || self->yearBox == nil) {
		return;
	}
	NSString* year = [CapeString asStringWithObject:[self->yearBox getWidgetValue]];
	NSString* month = [CapeString asStringWithObject:[self->monthBox getWidgetValue]];
	NSString* day = [CapeString asStringWithObject:[self->dayBox getWidgetValue]];
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:year];
	if([CapeString getLength:month] == 1) {
		[sb appendCharacter:'0'];
	}
	[sb appendString:month];
	if([CapeString getLength:day] == 1) {
		[sb appendCharacter:'0'];
	}
	[sb appendString:day];
	self->value = [sb toString];
}

- (void) setWidgetValue:(id)value {
	self->value = ((NSString*)({ id _v = value; [_v isKindOfClass:[NSString class]] ? _v : nil; }));
	[self applyValueToWidgets];
}

- (id) getWidgetValue {
	[self getValueFromWidgets];
	return(((id)self->value));
}

- (int) getSkipYears {
	return(self->skipYears);
}

- (CaveUIDateSelectorWidget*) setSkipYears:(int)v {
	self->skipYears = v;
	return(self);
}

@end
