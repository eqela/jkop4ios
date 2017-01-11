
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
#import "CaveUILayerWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUILabelWidget.h"
#import "CaveUIWidget.h"
#import "CaveUIVerticalBoxWidget.h"
#import "CapeVector.h"
#import "CaveUITopMarginLayerWidget.h"
#import "CaveUIVerticalScrollerWidget.h"
#import "CaveUISidebarWidget.h"

@implementation CaveUISidebarWidget

{
	CaveColor* widgetBackgroundColor;
	CaveColor* defaultActionItemWidgetBackgroundColor;
	CaveColor* defaultActionItemWidgetTextColor;
	CaveColor* defaultLabelItemWidgetBackgroundColor;
	CaveColor* defaultLabelItemWidgetTextColor;
	NSMutableArray* widgetItems;
}

- (CaveUISidebarWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetItems = nil;
	self->defaultLabelItemWidgetTextColor = nil;
	self->defaultLabelItemWidgetBackgroundColor = nil;
	self->defaultActionItemWidgetTextColor = nil;
	self->defaultActionItemWidgetBackgroundColor = nil;
	self->widgetBackgroundColor = nil;
	return(self);
}

- (CaveUISidebarWidget*) forItems:(id<CaveGuiApplicationContext>)ctx items:(NSMutableArray*)items color:(CaveColor*)color {
	CaveUISidebarWidget* v = [[CaveUISidebarWidget alloc] initWithGuiApplicationContext:ctx];
	[v setWidgetBackgroundColor:color];
	[v setWidgetItems:items];
	return(v);
}

- (CaveUISidebarWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->widgetItems = nil;
	self->defaultLabelItemWidgetTextColor = nil;
	self->defaultLabelItemWidgetBackgroundColor = nil;
	self->defaultActionItemWidgetTextColor = nil;
	self->defaultActionItemWidgetBackgroundColor = nil;
	self->widgetBackgroundColor = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (void) addToWidgetItems:(UIView*)widget {
	if(widget == nil) {
		return;
	}
	if(self->widgetItems == nil) {
		self->widgetItems = [[NSMutableArray alloc] init];
	}
	[self->widgetItems addObject:widget];
}

- (CaveColor*) determineBackgroundColor {
	CaveColor* wc = self->widgetBackgroundColor;
	if(wc == nil) {
		wc = [CaveColor white];
	}
	return(wc);
}

- (CaveColor*) determineTextColor:(CaveColor*)backgroundColor textColor:(CaveColor*)textColor defaultTextColor:(CaveColor*)defaultTextColor lowerBackgroundColor:(CaveColor*)lowerBackgroundColor {
	CaveColor* tc = textColor;
	if(tc == nil) {
		tc = defaultTextColor;
	}
	if(tc == nil) {
		CaveColor* cc = lowerBackgroundColor;
		if(cc == nil) {
			cc = [self determineBackgroundColor];
		}
		if([cc isDarkColor]) {
			tc = [CaveColor white];
		}
		else {
			tc = [CaveColor black];
		}
	}
	return(tc);
}

- (UIView*) addLabelItem:(NSString*)text bold:(BOOL)bold backgroundColor:(CaveColor*)backgroundColor textColor:(CaveColor*)textColor {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	CaveColor* bgc = backgroundColor;
	if(bgc == nil) {
		bgc = self->defaultLabelItemWidgetBackgroundColor;
	}
	CaveColor* tc = [self determineTextColor:backgroundColor textColor:textColor defaultTextColor:self->defaultLabelItemWidgetTextColor lowerBackgroundColor:bgc];
	if(bgc != nil) {
		[v addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
	}
	int mm3 = [self->context getHeightValue:@"3mm"];
	CaveUILabelWidget* lbl = [CaveUILabelWidget forText:self->context text:text];
	[lbl setWidgetFontSize:((double)mm3)];
	[lbl setWidgetTextColor:tc];
	[lbl setWidgetFontBold:bold];
	[v addWidget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)lbl) margin:mm3])];
	[self addToWidgetItems:((UIView*)v)];
	return(((UIView*)self));
}

- (UIView*) addActionItem:(NSString*)text handler:(void(^)(void))handler bold:(BOOL)bold backgroundColor:(CaveColor*)backgroundColor textColor:(CaveColor*)textColor {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	CaveColor* bgc = backgroundColor;
	if(bgc == nil) {
		bgc = self->defaultActionItemWidgetBackgroundColor;
	}
	CaveColor* tc = [self determineTextColor:backgroundColor textColor:textColor defaultTextColor:self->defaultActionItemWidgetTextColor lowerBackgroundColor:bgc];
	if(bgc != nil) {
		[v addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
	}
	int mm3 = [self->context getHeightValue:@"3mm"];
	CaveUILabelWidget* lbl = [CaveUILabelWidget forText:self->context text:text];
	[lbl setWidgetFontSize:((double)mm3)];
	[lbl setWidgetTextColor:tc];
	[lbl setWidgetFontBold:bold];
	[v addWidget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)lbl) margin:mm3])];
	if(handler != nil) {
		[CaveUIWidget setWidgetClickHandler:((UIView*)v) handler:handler];
	}
	[self addToWidgetItems:((UIView*)v)];
	return(((UIView*)self));
}

- (void) initializeWidget {
	[super initializeWidget];
	CaveColor* wc = [self determineBackgroundColor];
	[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:wc])];
	CaveUIVerticalBoxWidget* vbox = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	if([CapeVector isEmpty:self->widgetItems] == FALSE) {
		if(self->widgetItems != nil) {
			int n = 0;
			int m = [self->widgetItems count];
			for(n = 0 ; n < m ; n++) {
				UIView* item = ((UIView*)[self->widgetItems objectAtIndex:n]);
				if(item != nil) {
					[vbox addWidget:item weight:0.0];
				}
			}
		}
	}
	CaveUITopMarginLayerWidget* tml = [[CaveUITopMarginLayerWidget alloc] initWithGuiApplicationContext:self->context];
	[tml addWidget:((UIView*)[CaveUILayerWidget forWidgetAndWidth:self->context widget:((UIView*)vbox) width:[self->context getWidthValue:@"50mm"]])];
	[self addWidget:((UIView*)[CaveUIVerticalScrollerWidget forWidget:self->context widget:((UIView*)tml)])];
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveUISidebarWidget*) setWidgetBackgroundColor:(CaveColor*)v {
	self->widgetBackgroundColor = v;
	return(self);
}

- (CaveColor*) getDefaultActionItemWidgetBackgroundColor {
	return(self->defaultActionItemWidgetBackgroundColor);
}

- (CaveUISidebarWidget*) setDefaultActionItemWidgetBackgroundColor:(CaveColor*)v {
	self->defaultActionItemWidgetBackgroundColor = v;
	return(self);
}

- (CaveColor*) getDefaultActionItemWidgetTextColor {
	return(self->defaultActionItemWidgetTextColor);
}

- (CaveUISidebarWidget*) setDefaultActionItemWidgetTextColor:(CaveColor*)v {
	self->defaultActionItemWidgetTextColor = v;
	return(self);
}

- (CaveColor*) getDefaultLabelItemWidgetBackgroundColor {
	return(self->defaultLabelItemWidgetBackgroundColor);
}

- (CaveUISidebarWidget*) setDefaultLabelItemWidgetBackgroundColor:(CaveColor*)v {
	self->defaultLabelItemWidgetBackgroundColor = v;
	return(self);
}

- (CaveColor*) getDefaultLabelItemWidgetTextColor {
	return(self->defaultLabelItemWidgetTextColor);
}

- (CaveUISidebarWidget*) setDefaultLabelItemWidgetTextColor:(CaveColor*)v {
	self->defaultLabelItemWidgetTextColor = v;
	return(self);
}

- (NSMutableArray*) getWidgetItems {
	return(self->widgetItems);
}

- (CaveUISidebarWidget*) setWidgetItems:(NSMutableArray*)v {
	self->widgetItems = v;
	return(self);
}

@end
