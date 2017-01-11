
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
#import "CaveUICustomContainerWidget.h"
#import "CaveUIWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CapeVector.h"
#import "CaveUILayerWidget.h"

@implementation CaveUILayerWidget

{
	int widgetWidthRequest;
	int widgetHeightRequest;
	int widgetMinimumHeightRequest;
	int widgetMaximumWidthRequest;
}

- (CaveUILayerWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetMaximumWidthRequest = 0;
	self->widgetMinimumHeightRequest = 0;
	self->widgetHeightRequest = 0;
	self->widgetWidthRequest = 0;
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	return(self);
}

+ (CaveUILayerWidget*) findTopMostLayerWidget:(UIView*)widget {
	CaveUILayerWidget* v = nil;
	UIView* pp = widget;
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUILayerWidget class]]) {
			v = ((CaveUILayerWidget*)pp);
		}
		pp = [CaveUIWidget getParent:pp];
	}
	return(v);
}

+ (CaveUILayerWidget*) forContext:(id<CaveGuiApplicationContext>)context {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	return(v);
}

+ (CaveUILayerWidget*) forMargin:(id<CaveGuiApplicationContext>)context margin:(int)margin {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetMargin:margin];
	return(v);
}

+ (CaveUILayerWidget*) forWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget margin:(int)margin {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetMargin:margin];
	[v addWidget:widget];
	return(v);
}

+ (CaveUILayerWidget*) forWidgetAndWidth:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget width:(int)width {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	[v addWidget:widget];
	[v setWidgetWidthRequest:width];
	return(v);
}

+ (CaveUILayerWidget*) forWidgets:(id<CaveGuiApplicationContext>)context widgets:(NSMutableArray*)widgets margin:(int)margin {
	CaveUILayerWidget* v = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetMargin:margin];
	if(widgets != nil) {
		int n = 0;
		int m = [widgets count];
		for(n = 0 ; n < m ; n++) {
			UIView* widget = ((UIView*)[widgets objectAtIndex:n]);
			if(widget != nil) {
				[v addWidget:widget];
			}
		}
	}
	return(v);
}

- (CaveUILayerWidget*) setWidgetMaximumWidthRequest:(int)width {
	self->widgetMaximumWidthRequest = width;
	if([CaveUIWidget getWidth:((UIView*)self)] > width) {
		[CaveUIWidget onChanged:((UIView*)self)];
	}
	return(self);
}

- (int) getWidgetMaximumWidthRequest {
	return(self->widgetMaximumWidthRequest);
}

- (CaveUILayerWidget*) setWidgetWidthRequest:(int)request {
	self->widgetWidthRequest = request;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetWidthRequest {
	return(self->widgetWidthRequest);
}

- (CaveUILayerWidget*) setWidgetHeightRequest:(int)request {
	self->widgetHeightRequest = request;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetHeightRequest {
	return(self->widgetHeightRequest);
}

- (CaveUILayerWidget*) setWidgetMinimumHeightRequest:(int)request {
	self->widgetMinimumHeightRequest = request;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMinimumHeightRequest {
	return(self->widgetMinimumHeightRequest);
}

- (CaveUILayerWidget*) setWidgetMargin:(int)margin {
	self->widgetMarginLeft = margin;
	self->widgetMarginRight = margin;
	self->widgetMarginTop = margin;
	self->widgetMarginBottom = margin;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginLeft {
	return(self->widgetMarginLeft);
}

- (CaveUILayerWidget*) setWidgetMarginLeft:(int)value {
	self->widgetMarginLeft = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginRight {
	return(self->widgetMarginRight);
}

- (CaveUILayerWidget*) setWidgetMarginRight:(int)value {
	self->widgetMarginRight = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginTop {
	return(self->widgetMarginTop);
}

- (CaveUILayerWidget*) setWidgetMarginTop:(int)value {
	self->widgetMarginTop = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginBottom {
	return(self->widgetMarginBottom);
}

- (CaveUILayerWidget*) setWidgetMarginBottom:(int)value {
	self->widgetMarginBottom = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUILayerWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->widgetMaximumWidthRequest = 0;
	self->widgetMinimumHeightRequest = 0;
	self->widgetHeightRequest = 0;
	self->widgetWidthRequest = 0;
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	int mh = height - self->widgetMarginTop - self->widgetMarginBottom;
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget resizeHeight:child height:mh];
			}
		}
	}
}

- (void) computeWidgetLayout:(int)widthConstraint {
	int wc = widthConstraint;
	if(wc < 0 && self->widgetWidthRequest > 0) {
		wc = self->widgetWidthRequest;
	}
	if(wc >= 0) {
		wc = wc - self->widgetMarginLeft - self->widgetMarginRight;
		if(wc < 0) {
			wc = 0;
		}
	}
	int mw = 0;
	int mh = 0;
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget layout:child widthConstraint:wc force:FALSE];
				[CaveUIWidget move:child x:self->widgetMarginLeft y:self->widgetMarginTop];
				int cw = [CaveUIWidget getWidth:child];
				if(wc < 0 && self->widgetMaximumWidthRequest > 0 && cw + self->widgetMarginLeft + self->widgetMarginRight > self->widgetMaximumWidthRequest) {
					[CaveUIWidget layout:child widthConstraint:self->widgetMaximumWidthRequest - self->widgetMarginLeft - self->widgetMarginRight force:FALSE];
					cw = [CaveUIWidget getWidth:child];
				}
				int ch = [CaveUIWidget getHeight:child];
				if(cw > mw) {
					mw = cw;
				}
				if(ch > mh) {
					mh = ch;
				}
			}
		}
	}
	int fw = widthConstraint;
	if(fw < 0) {
		fw = mw + self->widgetMarginLeft + self->widgetMarginRight;
	}
	int fh = mh + self->widgetMarginTop + self->widgetMarginBottom;
	if(self->widgetHeightRequest > 0) {
		fh = self->widgetHeightRequest;
	}
	if(self->widgetMinimumHeightRequest > 0 && fh < self->widgetMinimumHeightRequest) {
		fh = self->widgetMinimumHeightRequest;
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:fw height:fh];
	mw = [CaveUIWidget getWidth:((UIView*)self)] - self->widgetMarginLeft - self->widgetMarginRight;
	mh = [CaveUIWidget getHeight:((UIView*)self)] - self->widgetMarginTop - self->widgetMarginBottom;
	NSMutableArray* array2 = [CaveUIWidget getChildren:((UIView*)self)];
	if(array2 != nil) {
		int n2 = 0;
		int m2 = [array2 count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			UIView* child = ((UIView*)[array2 objectAtIndex:n2]);
			if(child != nil) {
				if(wc < 0) {
					[CaveUIWidget layout:child widthConstraint:mw force:FALSE];
				}
				[CaveUIWidget resizeHeight:child height:mh];
			}
		}
	}
}

- (void) removeAllChildren {
	[CaveUIWidget removeChildrenOf:((UIView*)self)];
}

- (UIView*) getChildWidget:(int)index {
	NSMutableArray* children = [CaveUIWidget getChildren:((UIView*)self)];
	if(children == nil) {
		return(nil);
	}
	return(((UIView*)[CapeVector get:children index:index]));
}

@end
