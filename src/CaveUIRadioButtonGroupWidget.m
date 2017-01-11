
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
#import "CapeVector.h"
#import "CapeIntegerObject.h"
#import "CaveUIRadioButtonGroupWidget.h"

int CaveUIRadioButtonGroupWidgetHORIZONTAL = 0;
int CaveUIRadioButtonGroupWidgetVERTICAL = 1;

@implementation CaveUIRadioButtonGroupWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetName;
	NSString* widgetSelectedValue;
	NSMutableArray* widgetItems;
	void (^widgetChangeHandler)(void);
}

- (CaveUIRadioButtonGroupWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetChangeHandler = nil;
	self->widgetItems = nil;
	self->widgetSelectedValue = nil;
	self->widgetName = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIRadioButtonGroupWidget*) forGroup:(id<CaveGuiApplicationContext>)context group:(NSString*)group items:(NSMutableArray*)items {
	CaveUIRadioButtonGroupWidget* v = [[CaveUIRadioButtonGroupWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetName:group];
	for(int i = 0 ; i < [CapeVector getSize:items] ; i++) {
		[v addWidgetItem:[CapeVector get:items index:i] index:i];
	}
	return(v);
}

- (CaveUIRadioButtonGroupWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetChangeHandler = nil;
	self->widgetItems = nil;
	self->widgetSelectedValue = nil;
	self->widgetName = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	return(self);
}

- (void) addWidgetItem:(NSString*)text index:(int)index {
	if(self->widgetItems == nil) {
		self->widgetItems = [[NSMutableArray alloc] init];
	}
	[self->widgetItems addObject:text];
	NSLog(@"%@", @"[cave.ui.RadioButtonGroupWidget.addWidgetItem] (RadioButtonGroupWidget.sling:137:2): Not implemented");
}

- (void) setWidgetSelectedValue:(int)indx {
	NSLog(@"%@", @"[cave.ui.RadioButtonGroupWidget.setWidgetSelectedValue] (RadioButtonGroupWidget.sling:156:2): Not implemented");
}

- (void) setWidgetName:(NSString*)name {
	self->widgetName = name;
}

- (void) setWidgetOrientation:(int)orientation {
	if(orientation == CaveUIRadioButtonGroupWidgetHORIZONTAL) {
		NSLog(@"%@", @"[cave.ui.RadioButtonGroupWidget.setWidgetOrientation] (RadioButtonGroupWidget.sling:186:3): Not implemented");
	}
	else {
		if(orientation == CaveUIRadioButtonGroupWidgetVERTICAL) {
			NSLog(@"%@", @"[cave.ui.RadioButtonGroupWidget.setWidgetOrientation] (RadioButtonGroupWidget.sling:203:3): Not implemented");
		}
	}
}

- (NSString*) getWidgetSelectedValue {
	return(self->widgetSelectedValue);
}

- (void) onChangeSelectedItem {
	if(self->widgetChangeHandler != nil) {
		self->widgetChangeHandler();
	}
}

- (void) setWidgetValue:(id)value {
	if([((NSObject*)value) conformsToProtocol:@protocol(CapeIntegerObject)]) {
		[self setWidgetSelectedValue:[((id<CapeIntegerObject>)({ id _v = value; [((NSObject*)_v) conformsToProtocol:@protocol(CapeIntegerObject)] ? _v : nil; })) toInteger]];
	}
}

- (id) getWidgetValue {
	return(((id)[self getWidgetSelectedValue]));
}

- (void(^)(void)) getWidgetChangeHandler {
	return(self->widgetChangeHandler);
}

- (CaveUIRadioButtonGroupWidget*) setWidgetChangeHandler:(void(^)(void))v {
	self->widgetChangeHandler = v;
	return(self);
}

@end
