
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
#import "CaveUIVerticalBoxWidget.h"
#import "CaveUITitledWidget.h"
#import "CaveUIDisplayAwareWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUIVerticalScrollerWidget.h"
#import "CaveUIWidget.h"
#import "CapeDynamicMap.h"
#import "CapeVector.h"
#import "CaveUIAlignWidget.h"
#import "CaveUILabelWidget.h"
#import "CaveUIListItemWidget.h"

@implementation CaveUIListItemWidget

{
	CaveUIVerticalBoxWidget* list;
}

- (CaveUIListItemWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->list = nil;
	return(self);
}

- (CaveUIListItemWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->list = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (NSString*) getWidgetTitle {
	return(nil);
}

- (void) onWidgetDisplayed {
	[self onGetData];
}

- (void) initializeWidget {
	[super initializeWidget];
	UIView* shw = [self getSubHeaderWidget];
	if(shw != nil) {
		[self addWidget:shw weight:0.0];
	}
	[self setWidgetMargin:[self->context getHeightValue:@"1mm"]];
	[self setWidgetSpacing:[self->context getHeightValue:@"1mm"]];
	self->list = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:[self->context getHeightValue:@"1mm"]];
	[self addWidget:((UIView*)[CaveUIVerticalScrollerWidget forWidget:self->context widget:((UIView*)self->list)]) weight:1.0];
}

- (void) onGetData {
	[CaveUIWidget removeChildrenOf:((UIView*)self->list)];
	[self startDataQuery:^void(NSMutableArray* response) {
		if(response == nil || [CapeVector getSize:response] < 1) {
			[self onNoDataReceived];
			return;
		}
		[self onDataReceived:response];
	}];
}

- (void) onNoDataReceived {
	[self->list addWidget:((UIView*)[CaveUIAlignWidget forWidget:self->context widget:((UIView*)[CaveUILabelWidget forText:self->context text:@"No data found"]) alignX:0.5 alignY:0.5 margin:0]) weight:0.0];
}

- (void) onDataReceived:(NSMutableArray*)data {
	if(data != nil) {
		int n = 0;
		int m = [data count];
		for(n = 0 ; n < m ; n++) {
			CapeDynamicMap* record = ((CapeDynamicMap*)[data objectAtIndex:n]);
			if(record != nil) {
				UIView* widget = [self createWidgetForRecord:record];
				if(widget != nil) {
					[self->list addWidget:widget weight:0.0];
				}
			}
		}
	}
}

- (UIView*) getSubHeaderWidget {
	return(nil);
}

- (UIView*) createWidgetForRecord:(CapeDynamicMap*)record {
	return(nil);
}

- (void) startDataQuery:(void(^)(NSMutableArray*))callback {
}

@end
