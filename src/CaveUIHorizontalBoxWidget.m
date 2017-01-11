
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
#import "CaveUIHorizontalBoxWidget.h"

@class CaveUIHorizontalBoxWidgetMyChildEntry;

@interface CaveUIHorizontalBoxWidgetMyChildEntry : NSObject
{
	@public UIView* widget;
	@public double weight;
}
- (CaveUIHorizontalBoxWidgetMyChildEntry*) init;
@end

@implementation CaveUIHorizontalBoxWidgetMyChildEntry

- (CaveUIHorizontalBoxWidgetMyChildEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->weight = 0.0;
	self->widget = nil;
	return(self);
}

@end

@implementation CaveUIHorizontalBoxWidget

{
	NSMutableArray* children;
	int widgetSpacing;
	int fixedWidgetHeight;
}

- (CaveUIHorizontalBoxWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->fixedWidgetHeight = 0;
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	self->widgetSpacing = 0;
	self->children = nil;
	return(self);
}

+ (CaveUIHorizontalBoxWidget*) forContext:(id<CaveGuiApplicationContext>)context widgetMargin:(int)widgetMargin widgetSpacing:(int)widgetSpacing {
	CaveUIHorizontalBoxWidget* v = [[CaveUIHorizontalBoxWidget alloc] initWithGuiApplicationContext:context];
	v->widgetMarginLeft = widgetMargin;
	v->widgetMarginRight = widgetMargin;
	v->widgetMarginTop = widgetMargin;
	v->widgetMarginBottom = widgetMargin;
	v->widgetSpacing = widgetSpacing;
	return(v);
}

- (CaveUIHorizontalBoxWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->fixedWidgetHeight = 0;
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

- (CaveUIHorizontalBoxWidget*) setWidgetMargin:(int)margin {
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

- (CaveUIHorizontalBoxWidget*) setWidgetMarginLeft:(int)value {
	self->widgetMarginLeft = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginRight {
	return(self->widgetMarginRight);
}

- (CaveUIHorizontalBoxWidget*) setWidgetMarginRight:(int)value {
	self->widgetMarginRight = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginTop {
	return(self->widgetMarginTop);
}

- (CaveUIHorizontalBoxWidget*) setWidgetMarginTop:(int)value {
	self->widgetMarginTop = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginBottom {
	return(self->widgetMarginBottom);
}

- (CaveUIHorizontalBoxWidget*) setWidgetMarginBottom:(int)value {
	self->widgetMarginBottom = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (void) computeWidgetLayout:(int)widthConstraint {
	double totalWeight = 0.0;
	int highest = 0;
	int availableWidth = widthConstraint - self->widgetMarginLeft - self->widgetMarginRight;
	int childCount = 0;
	if(self->children != nil) {
		int n = 0;
		int m = [self->children count];
		for(n = 0 ; n < m ; n++) {
			CaveUIHorizontalBoxWidgetMyChildEntry* child = ((CaveUIHorizontalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n]);
			if(child != nil) {
				childCount++;
				if(child->weight > 0.0) {
					totalWeight += child->weight;
				}
				else {
					[CaveUIWidget layout:child->widget widthConstraint:-1 force:FALSE];
					availableWidth -= [CaveUIWidget getWidth:child->widget];
					int height = [CaveUIWidget getHeight:child->widget];
					if(height > highest) {
						highest = height;
					}
				}
			}
		}
	}
	if(childCount > 1 && self->widgetSpacing > 0) {
		availableWidth -= (childCount - 1) * self->widgetSpacing;
	}
	if(self->children != nil) {
		int n2 = 0;
		int m2 = [self->children count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			CaveUIHorizontalBoxWidgetMyChildEntry* child = ((CaveUIHorizontalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n2]);
			if(child != nil) {
				if(child->weight > 0.0) {
					int ww = ((int)(availableWidth * child->weight / totalWeight));
					[CaveUIWidget layout:child->widget widthConstraint:ww force:FALSE];
					int height = [CaveUIWidget getHeight:child->widget];
					if(height > highest) {
						highest = height;
					}
				}
			}
		}
	}
	int realHighest = highest;
	highest += self->widgetMarginTop + self->widgetMarginBottom;
	if(self->fixedWidgetHeight > 0) {
		highest = self->fixedWidgetHeight;
	}
	if(widthConstraint < 0) {
		int totalWidth = widthConstraint - availableWidth;
		[CaveUIWidget setLayoutSize:((UIView*)self) width:totalWidth height:highest];
	}
	else {
		[CaveUIWidget setLayoutSize:((UIView*)self) width:widthConstraint height:highest];
	}
	if(availableWidth < 0) {
		availableWidth = 0;
	}
	int x = self->widgetMarginLeft;
	if(self->children != nil) {
		int n3 = 0;
		int m3 = [self->children count];
		for(n3 = 0 ; n3 < m3 ; n3++) {
			CaveUIHorizontalBoxWidgetMyChildEntry* child = ((CaveUIHorizontalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n3]);
			if(child != nil) {
				int ww = 0;
				if(child->weight > 0.0) {
					ww = ((int)(availableWidth * child->weight / totalWeight));
					[CaveUIWidget move:child->widget x:x y:self->widgetMarginTop];
					[CaveUIWidget layout:child->widget widthConstraint:ww force:FALSE];
					[CaveUIWidget resizeHeight:child->widget height:realHighest];
				}
				else {
					ww = [CaveUIWidget getWidth:child->widget];
					[CaveUIWidget move:child->widget x:x y:self->widgetMarginTop];
					[CaveUIWidget layout:child->widget widthConstraint:ww force:FALSE];
					[CaveUIWidget resizeHeight:child->widget height:realHighest];
				}
				x += ww;
				x += self->widgetSpacing;
			}
		}
	}
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget resizeHeight:child height:height - self->widgetMarginTop - self->widgetMarginBottom];
			}
		}
	}
}

- (void) onChildWidgetRemoved:(UIView*)widget {
	if(self->children != nil) {
		int n = 0;
		int m = [self->children count];
		for(n = 0 ; n < m ; n++) {
			CaveUIHorizontalBoxWidgetMyChildEntry* child = ((CaveUIHorizontalBoxWidgetMyChildEntry*)[self->children objectAtIndex:n]);
			if(child != nil) {
				if(child->widget == widget) {
					[CapeVector removeValue:self->children value:child];
					break;
				}
			}
		}
	}
	[super onChildWidgetRemoved:widget];
}

- (CaveUIHorizontalBoxWidget*) addWidget:(UIView*)widget weight:(double)weight {
	CaveUIHorizontalBoxWidgetMyChildEntry* ee = [[CaveUIHorizontalBoxWidgetMyChildEntry alloc] init];
	ee->widget = widget;
	ee->weight = weight;
	[self->children addObject:ee];
	[CaveUIWidget addChild:((UIView*)self) child:widget];
	return(self);
}

- (int) getWidgetSpacing {
	return(self->widgetSpacing);
}

- (CaveUIHorizontalBoxWidget*) setWidgetSpacing:(int)v {
	self->widgetSpacing = v;
	return(self);
}

- (int) getFixedWidgetHeight {
	return(self->fixedWidgetHeight);
}

- (CaveUIHorizontalBoxWidget*) setFixedWidgetHeight:(int)v {
	self->fixedWidgetHeight = v;
	return(self);
}

@end
