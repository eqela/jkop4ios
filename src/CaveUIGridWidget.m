
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
#import "CapeMath.h"
#import "CaveUIGridWidget.h"

@implementation CaveUIGridWidget

{
	int widgetCellSize;
	int minimumCols;
	int maximumCols;
	int widgetSpacing;
	int widgetMargin;
}

- (CaveUIGridWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetMargin = 0;
	self->widgetSpacing = 0;
	self->maximumCols = 0;
	self->minimumCols = 2;
	self->widgetCellSize = -1;
	return(self);
}

+ (CaveUIGridWidget*) forContext:(id<CaveGuiApplicationContext>)context {
	CaveUIGridWidget* v = [[CaveUIGridWidget alloc] initWithGuiApplicationContext:context];
	return(v);
}

- (CaveUIGridWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->widgetMargin = 0;
	self->widgetSpacing = 0;
	self->maximumCols = 0;
	self->minimumCols = 2;
	self->widgetCellSize = -1;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (void) computeWidgetLayout:(int)widthConstraint {
	int rows = 0;
	int cols = 0;
	NSMutableArray* children = [CaveUIWidget getChildren:((UIView*)self)];
	if(children == nil) {
		return;
	}
	int childCount = [CapeVector getSize:children];
	if(childCount < 1) {
		return;
	}
	int wcs = self->widgetCellSize;
	if(wcs < 1) {
		wcs = [self->context getWidthValue:@"25mm"];
	}
	BOOL adjustWcs = FALSE;
	int mywidth = widthConstraint - self->widgetMargin - self->widgetMargin;
	if(widthConstraint < 0) {
		cols = childCount;
	}
	else {
		cols = ((int)([CapeMath floor:((double)((mywidth + self->widgetSpacing) / (wcs + self->widgetSpacing)))]));
		if(self->minimumCols > 0 && cols < self->minimumCols) {
			cols = self->minimumCols;
			adjustWcs = TRUE;
		}
		else {
			if(childCount >= cols) {
				adjustWcs = TRUE;
			}
		}
	}
	if(adjustWcs) {
		wcs = (mywidth + self->widgetSpacing) / cols - self->widgetSpacing;
	}
	if(self->maximumCols > 0 && cols > self->maximumCols) {
		cols = self->maximumCols;
	}
	rows = ((int)([CapeMath floor:((double)(childCount / cols))]));
	if(childCount % cols > 0) {
		rows++;
	}
	[CaveUIWidget setLayoutSize:((UIView*)self) width:self->widgetMargin + cols * wcs + (cols - 1) * self->widgetSpacing + self->widgetMargin height:self->widgetMargin + rows * wcs + (rows - 1) * self->widgetSpacing + self->widgetMargin];
	int cx = 0;
	int x = self->widgetMargin;
	int y = self->widgetMargin;
	if(children != nil) {
		int n = 0;
		int m = [children count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[children objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget move:child x:x y:y];
				[CaveUIWidget layout:child widthConstraint:wcs force:FALSE];
				[CaveUIWidget resizeHeight:child height:wcs];
				x += wcs;
				x += self->widgetSpacing;
				cx++;
				if(cx >= cols) {
					cx = 0;
					y += wcs;
					y += self->widgetSpacing;
					x = self->widgetMargin;
				}
			}
		}
	}
}

- (int) getWidgetCellSize {
	return(self->widgetCellSize);
}

- (CaveUIGridWidget*) setWidgetCellSize:(int)v {
	self->widgetCellSize = v;
	return(self);
}

- (int) getMinimumCols {
	return(self->minimumCols);
}

- (CaveUIGridWidget*) setMinimumCols:(int)v {
	self->minimumCols = v;
	return(self);
}

- (int) getMaximumCols {
	return(self->maximumCols);
}

- (CaveUIGridWidget*) setMaximumCols:(int)v {
	self->maximumCols = v;
	return(self);
}

- (int) getWidgetSpacing {
	return(self->widgetSpacing);
}

- (CaveUIGridWidget*) setWidgetSpacing:(int)v {
	self->widgetSpacing = v;
	return(self);
}

- (int) getWidgetMargin {
	return(self->widgetMargin);
}

- (CaveUIGridWidget*) setWidgetMargin:(int)v {
	self->widgetMargin = v;
	return(self);
}

@end
