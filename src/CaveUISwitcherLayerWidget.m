
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
#import "CaveUISwitcherLayerWidget.h"

@implementation CaveUISwitcherLayerWidget

{
	int margin;
}

- (CaveUISwitcherLayerWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->margin = 0;
	return(self);
}

+ (CaveUISwitcherLayerWidget*) findTopMostLayerWidget:(UIView*)widget {
	CaveUISwitcherLayerWidget* v = nil;
	UIView* pp = widget;
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUISwitcherLayerWidget class]]) {
			v = ((CaveUISwitcherLayerWidget*)pp);
		}
		pp = [CaveUIWidget getParent:pp];
	}
	return(v);
}

+ (CaveUISwitcherLayerWidget*) forMargin:(id<CaveGuiApplicationContext>)context margin:(int)margin {
	CaveUISwitcherLayerWidget* v = [[CaveUISwitcherLayerWidget alloc] initWithGuiApplicationContext:context];
	v->margin = margin;
	return(v);
}

+ (CaveUISwitcherLayerWidget*) forWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget margin:(int)margin {
	CaveUISwitcherLayerWidget* v = [[CaveUISwitcherLayerWidget alloc] initWithGuiApplicationContext:context];
	v->margin = margin;
	[v addWidget:widget];
	return(v);
}

+ (CaveUISwitcherLayerWidget*) forWidgets:(id<CaveGuiApplicationContext>)context widgets:(NSMutableArray*)widgets margin:(int)margin {
	CaveUISwitcherLayerWidget* v = [[CaveUISwitcherLayerWidget alloc] initWithGuiApplicationContext:context];
	v->margin = margin;
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

- (CaveUISwitcherLayerWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->margin = 0;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (void) onWidgetHeightChanged:(int)height {
	[super onWidgetHeightChanged:height];
	NSMutableArray* children = [CaveUIWidget getChildren:((UIView*)self)];
	if(children != nil) {
		UIView* topmost = ((UIView*)[CapeVector get:children index:[CapeVector getSize:children] - 1]);
		if(topmost != nil) {
			[CaveUIWidget resizeHeight:topmost height:height - self->margin - self->margin];
		}
	}
}

- (void) computeWidgetLayout:(int)widthConstraint {
	NSMutableArray* children = [CaveUIWidget getChildren:((UIView*)self)];
	if(children == nil) {
		return;
	}
	int childCount = [CapeVector getSize:children];
	int wc = -1;
	if(widthConstraint >= 0) {
		wc = widthConstraint - self->margin - self->margin;
		if(wc < 0) {
			wc = 0;
		}
	}
	int mw = 0;
	int mh = 0;
	int n = 0;
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n2 = 0;
		int m = [array count];
		for(n2 = 0 ; n2 < m ; n2++) {
			UIView* child = ((UIView*)[array objectAtIndex:n2]);
			if(child != nil) {
				if(n == childCount - 1) {
					[CaveUIWidget layout:child widthConstraint:wc force:FALSE];
					mw = [CaveUIWidget getWidth:child];
					mh = [CaveUIWidget getHeight:child];
					[CaveUIWidget move:child x:self->margin y:self->margin];
				}
				else {
					int ww = [CaveUIWidget getWidth:child];
					[CaveUIWidget move:child x:-ww y:self->margin];
				}
				n++;
			}
		}
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:mw + self->margin + self->margin height:mh + self->margin + self->margin];
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
