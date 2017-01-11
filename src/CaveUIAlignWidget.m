
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
#import "CaveUIAlignWidget.h"

@class CaveUIAlignWidgetMyChildEntry;

@interface CaveUIAlignWidgetMyChildEntry : NSObject
{
	@public UIView* widget;
	@public double alignX;
	@public double alignY;
}
- (CaveUIAlignWidgetMyChildEntry*) init;
@end

@implementation CaveUIAlignWidgetMyChildEntry

- (CaveUIAlignWidgetMyChildEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->alignY = 0.0;
	self->alignX = 0.0;
	self->widget = nil;
	return(self);
}

@end

@implementation CaveUIAlignWidget

{
	NSMutableArray* children;
	int widgetMarginLeft;
	int widgetMarginRight;
	int widgetMarginTop;
	int widgetMarginBottom;
}

- (CaveUIAlignWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	self->children = nil;
	return(self);
}

+ (CaveUIAlignWidget*) forWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget alignX:(double)alignX alignY:(double)alignY margin:(int)margin {
	CaveUIAlignWidget* v = [[CaveUIAlignWidget alloc] initWithGuiApplicationContext:context];
	v->widgetMarginLeft = margin;
	v->widgetMarginRight = margin;
	v->widgetMarginTop = margin;
	v->widgetMarginBottom = margin;
	[v addWidget:widget alignX:alignX alignY:alignY];
	return(v);
}

- (CaveUIAlignWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->widgetMarginBottom = 0;
	self->widgetMarginTop = 0;
	self->widgetMarginRight = 0;
	self->widgetMarginLeft = 0;
	self->children = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->children = [[NSMutableArray alloc] init];
	return(self);
}

- (CaveUIAlignWidget*) setWidgetMargin:(int)margin {
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

- (CaveUIAlignWidget*) setWidgetMarginLeft:(int)value {
	self->widgetMarginLeft = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginRight {
	return(self->widgetMarginRight);
}

- (CaveUIAlignWidget*) setWidgetMarginRight:(int)value {
	self->widgetMarginRight = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginTop {
	return(self->widgetMarginTop);
}

- (CaveUIAlignWidget*) setWidgetMarginTop:(int)value {
	self->widgetMarginTop = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (int) getWidgetMarginBottom {
	return(self->widgetMarginBottom);
}

- (CaveUIAlignWidget*) setWidgetMarginBottom:(int)value {
	self->widgetMarginBottom = value;
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	[self updateChildWidgetLocations];
}

- (void) updateChildWidgetLocations {
	if(self->children != nil) {
		int n = 0;
		int m = [self->children count];
		for(n = 0 ; n < m ; n++) {
			CaveUIAlignWidgetMyChildEntry* child = ((CaveUIAlignWidgetMyChildEntry*)[self->children objectAtIndex:n]);
			if(child != nil) {
				[self handleEntry:child];
			}
		}
	}
}

- (void) computeWidgetLayout:(int)widthConstraint {
	int wc = -1;
	if(widthConstraint >= 0) {
		wc = widthConstraint - self->widgetMarginLeft - self->widgetMarginRight;
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
				[CaveUIWidget layout:child widthConstraint:-1 force:FALSE];
				int cw = [CaveUIWidget getWidth:child];
				if(wc >= 0 && cw > wc) {
					[CaveUIWidget layout:child widthConstraint:wc force:FALSE];
					cw = [CaveUIWidget getWidth:child];
				}
				if(cw > mw) {
					mw = cw;
				}
				int ch = [CaveUIWidget getHeight:child];
				if(ch > mh) {
					mh = ch;
				}
			}
		}
	}
	int mywidth = mw + self->widgetMarginLeft + self->widgetMarginRight;
	if(widthConstraint >= 0) {
		mywidth = widthConstraint;
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:mywidth height:mh + self->widgetMarginTop + self->widgetMarginBottom];
	[self updateChildWidgetLocations];
}

- (void) handleEntry:(CaveUIAlignWidgetMyChildEntry*)entry {
	int w = [CaveUIWidget getWidth:((UIView*)self)] - self->widgetMarginLeft - self->widgetMarginRight;
	int h = [CaveUIWidget getHeight:((UIView*)self)] - self->widgetMarginTop - self->widgetMarginBottom;
	int cw = [CaveUIWidget getWidth:entry->widget];
	int ch = [CaveUIWidget getHeight:entry->widget];
	if(cw > w || ch > h) {
		if(cw > w) {
			cw = w;
		}
		if(ch > h) {
			ch = h;
		}
	}
	int dx = ((int)(self->widgetMarginLeft + (w - cw) * entry->alignX));
	int dy = ((int)(self->widgetMarginTop + (h - ch) * entry->alignY));
	[CaveUIWidget move:entry->widget x:dx y:dy];
}

- (void) onChildWidgetRemoved:(UIView*)widget {
	[super onChildWidgetRemoved:widget];
	if(self->children != nil) {
		int n = 0;
		int m = [self->children count];
		for(n = 0 ; n < m ; n++) {
			CaveUIAlignWidgetMyChildEntry* child = ((CaveUIAlignWidgetMyChildEntry*)[self->children objectAtIndex:n]);
			if(child != nil) {
				if(child->widget == widget) {
					[CapeVector removeValue:self->children value:child];
					break;
				}
			}
		}
	}
}

- (CaveUIAlignWidget*) addWidget:(UIView*)widget alignX:(double)alignX alignY:(double)alignY {
	CaveUIAlignWidgetMyChildEntry* ee = [[CaveUIAlignWidgetMyChildEntry alloc] init];
	ee->widget = widget;
	ee->alignX = alignX;
	ee->alignY = alignY;
	[self->children addObject:ee];
	[CaveUIWidget addChild:((UIView*)self) child:widget];
	if([self hasSize]) {
		[self handleEntry:ee];
	}
	return(self);
}

- (void) setAlignForIndex:(int)index alignX:(double)alignX alignY:(double)alignY {
	CaveUIAlignWidgetMyChildEntry* child = ((CaveUIAlignWidgetMyChildEntry*)[CapeVector get:self->children index:index]);
	if(child == nil) {
		return;
	}
	if(child->alignX != alignX || child->alignY != alignY) {
		child->alignX = alignX;
		child->alignY = alignY;
		[CaveUIWidget onChanged:((UIView*)self)];
	}
}

@end
