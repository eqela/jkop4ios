
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
#import "CaveGuiApplicationContext.h"
#import "CaveUIWidget.h"
#import "CapeVector.h"
#import "CaveUIVerticalBoxWidget.h"

@class CaveUIVerticalBoxWidgetMyChildEntry;

@interface CaveUIVerticalBoxWidgetMyChildEntry : NSObject
{
	@public UIView* widget;
	@public double weight;
}
- (CaveUIVerticalBoxWidgetMyChildEntry*) init;
@end

@implementation CaveUIVerticalBoxWidgetMyChildEntry

- (CaveUIVerticalBoxWidgetMyChildEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->weight = 0.0;
	self->widget = nil;
	return(self);
}

@end

@implementation CaveUIVerticalBoxWidget

{
	NSMutableArray* children;
	int widgetSpacing;
	int widgetWidthRequest;
	int widgetMaximumWidthRequest;
}

- (CaveUIVerticalBoxWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetMaximumWidthRequest = 0;
	self->widgetWidthRequest = 0;
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	self->widgetSpacing = 0;
	self->children = nil;
	return(self);
}

+ (CaveUIVerticalBoxWidget*) forContext:(id<CaveGuiApplicationContext>)context widgetMargin:(int)widgetMargin widgetSpacing:(int)widgetSpacing {
	CaveUIVerticalBoxWidget* v = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:context];
	v->widgetMarginLeft = widgetMargin;
	v->widgetMarginRight = widgetMargin;
	v->widgetMarginTop = widgetMargin;
	v->widgetMarginBottom = widgetMargin;
	v->widgetSpacing = widgetSpacing;
	return(v);
}

- (CaveUIVerticalBoxWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->widgetMaximumWidthRequest = 0;
	self->widgetWidthRequest = 0;
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	self->widgetSpacing = 0;
	self->children = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->children = [[NSMutableArray alloc] init];
	return(self);
}

- (CaveUIVerticalBoxWidget*) setWidgetMargin:(int)margin {
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

- (CaveUIVerticalBoxWidget*) setWidgetMarginLeft:(int)value {
	self->widgetMarginLeft = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginRight {
	return(self->widgetMarginRight);
}

- (CaveUIVerticalBoxWidget*) setWidgetMarginRight:(int)value {
	self->widgetMarginRight = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginTop {
	return(self->widgetMarginTop);
}

- (CaveUIVerticalBoxWidget*) setWidgetMarginTop:(int)value {
	self->widgetMarginTop = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginBottom {
	return(self->widgetMarginBottom);
}

- (CaveUIVerticalBoxWidget*) setWidgetMarginBottom:(int)value {
	self->widgetMarginBottom = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUIVerticalBoxWidget*) setWidgetWidthRequest:(int)request {
	self->widgetWidthRequest = request;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetWidthRequest {
	return(self->widgetWidthRequest);
}

- (CaveUIVerticalBoxWidget*) setWidgetMaximumWidthRequest:(int)width {
	self->widgetMaximumWidthRequest = width;
	if([CaveUIWidget getWidth:((UIView*)self)] > width) {
		[CaveUIWidget onChanged:((UIView*)self)];
	}
	return(self);
}

- (int) getWidgetMaximumWidthRequest {
	return(self->widgetMaximumWidthRequest);
}

- (void) computeWidgetLayout:(int)widthConstraint {
	int wc = -1;
	if(widthConstraint < 0 && self->widgetWidthRequest > 0) {
		wc = self->widgetWidthRequest - self->widgetMarginLeft - self->widgetMarginRight;
	}
	if(wc < 0 && widthConstraint >= 0) {
		wc = widthConstraint - self->widgetMarginLeft - self->widgetMarginRight;
		if(wc < 0) {
			wc = 0;
		}
	}
	int widest = 0;
	int childCount = 0;
	int y = self->widgetMarginTop;
	if(wc < 0) {
		if(self->children != nil) {
			int n = 0;
			int m = [self->children count];
			for(n = 0 ; n < m ; n++) {
				CaveUIVerticalBoxWidgetMyChildEntry* child = ((CaveUIVerticalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n]);
				if(child != nil) {
					[CaveUIWidget layout:child->widget widthConstraint:-1 force:FALSE];
					int ww = [CaveUIWidget getWidth:child->widget];
					if(ww > wc) {
						wc = ww;
					}
				}
			}
		}
	}
	if(self->children != nil) {
		int n2 = 0;
		int m2 = [self->children count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			CaveUIVerticalBoxWidgetMyChildEntry* child = ((CaveUIVerticalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n2]);
			if(child != nil) {
				if(childCount > 0) {
					y += self->widgetSpacing;
				}
				childCount++;
				[CaveUIWidget layout:child->widget widthConstraint:wc force:FALSE];
				[CaveUIWidget move:child->widget x:self->widgetMarginLeft y:y];
				int ww = [CaveUIWidget getWidth:child->widget];
				if(wc < 0 && self->widgetMaximumWidthRequest > 0 && ww + self->widgetMarginLeft + self->widgetMarginRight > self->widgetMaximumWidthRequest) {
					[CaveUIWidget layout:child->widget widthConstraint:self->widgetMaximumWidthRequest - self->widgetMarginLeft - self->widgetMarginRight force:FALSE];
					ww = [CaveUIWidget getWidth:child->widget];
				}
				if(ww > widest) {
					widest = ww;
				}
				y += [CaveUIWidget getHeight:child->widget];
			}
		}
	}
	y += self->widgetMarginBottom;
	int mywidth = widest + self->widgetMarginLeft + self->widgetMarginRight;
	if(widthConstraint >= 0) {
		mywidth = widthConstraint;
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:mywidth height:y];
	[self onWidgetHeightChanged:y];
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	double totalWeight = 0.0;
	int availableHeight = height - self->widgetMarginTop - self->widgetMarginBottom;
	int childCount = 0;
	if(self->children != nil) {
		int n = 0;
		int m = [self->children count];
		for(n = 0 ; n < m ; n++) {
			CaveUIVerticalBoxWidgetMyChildEntry* child = ((CaveUIVerticalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n]);
			if(child != nil) {
				childCount++;
				if(child->weight > 0.0) {
					totalWeight += child->weight;
				}
				else {
					availableHeight -= [CaveUIWidget getHeight:child->widget];
				}
			}
		}
	}
	if(childCount > 1 && self->widgetSpacing > 0) {
		availableHeight -= (childCount - 1) * self->widgetSpacing;
	}
	if(availableHeight < 0) {
		availableHeight = 0;
	}
	int y = self->widgetMarginTop;
	if(self->children != nil) {
		int n2 = 0;
		int m2 = [self->children count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			CaveUIVerticalBoxWidgetMyChildEntry* child = ((CaveUIVerticalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n2]);
			if(child != nil) {
				[CaveUIWidget move:child->widget x:self->widgetMarginLeft y:y];
				if(child->weight > 0.0) {
					int hh = ((int)(availableHeight * child->weight / totalWeight));
					[CaveUIWidget resizeHeight:child->widget height:hh];
				}
				int hh = [CaveUIWidget getHeight:child->widget];
				y += hh;
				y += self->widgetSpacing;
			}
		}
	}
}

- (void) onChildWidgetRemoved:(UIView*)widget {
	if(widget != nil) {
		if(self->children != nil) {
			int n = 0;
			int m = [self->children count];
			for(n = 0 ; n < m ; n++) {
				CaveUIVerticalBoxWidgetMyChildEntry* child = ((CaveUIVerticalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n]);
				if(child != nil) {
					if(child->widget == widget) {
						[CapeVector removeValue:self->children value:child];
						break;
					}
				}
			}
		}
	}
	[super onChildWidgetRemoved:widget];
}

- (CaveUIVerticalBoxWidget*) addWidget:(UIView*)widget weight:(double)weight {
	if(widget != nil) {
		CaveUIVerticalBoxWidgetMyChildEntry* ee = [[CaveUIVerticalBoxWidgetMyChildEntry alloc] init];
		ee->widget = widget;
		ee->weight = weight;
		[self->children addObject:ee];
		[CaveUIWidget addChild:((UIView*)self) child:widget];
	}
	return(self);
}

- (int) getWidgetSpacing {
	return(self->widgetSpacing);
}

- (CaveUIVerticalBoxWidget*) setWidgetSpacing:(int)v {
	self->widgetSpacing = v;
	return(self);
}

@end
