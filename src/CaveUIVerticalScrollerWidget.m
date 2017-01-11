
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
#import "CaveUIWidgetWithLayout.h"
#import "CaveUIHeightAwareWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUIWidget.h"
#import "CaveUIVerticalScrollerWidget.h"

@implementation CaveUIVerticalScrollerWidget

{
	int layoutHeight;
	BOOL heightChanged;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (CaveUIVerticalScrollerWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->heightChanged = FALSE;
	self->layoutHeight = -1;
	return(self);
}

+ (CaveUIVerticalScrollerWidget*) forWidget:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget {
	CaveUIVerticalScrollerWidget* v = [[CaveUIVerticalScrollerWidget alloc] initWithGuiApplicationContext:context];
	[v addWidget:widget];
	return(v);
}

- (CaveUIVerticalScrollerWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->heightChanged = FALSE;
	self->layoutHeight = -1;
	return(self);
}

- (void) onWidgetHeightChanged:(int)height {
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				if(height > self->layoutHeight) {
					[CaveUIWidget resizeHeight:child height:height];
				}
				else {
					[CaveUIWidget resizeHeight:child height:self->layoutHeight];
				}
			}
		}
	}
	self->heightChanged = TRUE;
}

- (BOOL) layoutWidget:(int)widthConstraint force:(BOOL)force {
	int mw = 0;
	int mh = 0;
	NSMutableArray* array = [CaveUIWidget getChildren:((UIView*)self)];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget move:child x:0 y:0];
				[CaveUIWidget layout:child widthConstraint:widthConstraint force:self->heightChanged];
				int cw = [CaveUIWidget getWidth:child];
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
	self->heightChanged = FALSE;
	self->layoutHeight = mh;
	[CaveUIWidget setLayoutSize:((UIView*)self) width:mw height:mh];
	self.contentSize = CGSizeMake(mw,mh);
	return(TRUE);
}

- (CaveUIVerticalScrollerWidget*) addWidget:(UIView*)widget {
	[CaveUIWidget addChild:((UIView*)self) child:widget];
	return(self);
}

@end
