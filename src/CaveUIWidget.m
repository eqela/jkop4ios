
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
#import "CaveUIScreenForWidget.h"
#import "CaveUIScreenAwareWidget.h"
#import "CaveUIWidgetWithLayout.h"
#import "CaveUIResizeAwareWidget.h"
#import "CaveUIHeightAwareWidget.h"
#import "CaveUIWidget.h"

@class CaveUIWidgetWidgetClickForwarder;

@interface CaveUIWidgetWidgetClickForwarder : NSObject
- (CaveUIWidgetWidgetClickForwarder*) init;
- (void) execute;
- (void(^)(void)) getHandler;
- (CaveUIWidgetWidgetClickForwarder*) setHandler:(void(^)(void))v;
- (UIView*) getWidget;
- (CaveUIWidgetWidgetClickForwarder*) setWidget:(UIView*)v;
@end

@implementation CaveUIWidgetWidgetClickForwarder

{
	void (^handler)(void);
	UIView* widget;
}

- (CaveUIWidgetWidgetClickForwarder*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widget = nil;
	self->handler = nil;
	return(self);
}

- (void) execute {
	[[widget.window.subviews objectAtIndex:0] endEditing:YES];
	self->handler();
}

- (void(^)(void)) getHandler {
	return(self->handler);
}

- (CaveUIWidgetWidgetClickForwarder*) setHandler:(void(^)(void))v {
	self->handler = v;
	return(self);
}

- (UIView*) getWidget {
	return(self->widget);
}

- (CaveUIWidgetWidgetClickForwarder*) setWidget:(UIView*)v {
	self->widget = v;
	return(self);
}

@end

@implementation CaveUIWidget

- (CaveUIWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (void) onWidgetAddedToParent:(UIView*)widget {
	if(widget == nil) {
		return;
	}
	if([widget isKindOfClass:[CaveUICustomContainerWidget class]]) {
		[((CaveUICustomContainerWidget*)widget) onWidgetAddedToParent];
	}
}

+ (void) onWidgetRemovedFromParent:(UIView*)widget {
	if(widget == nil) {
		return;
	}
	if([widget isKindOfClass:[CaveUICustomContainerWidget class]]) {
		[((CaveUICustomContainerWidget*)widget) onWidgetRemovedFromParent];
	}
}

+ (void) notifyOnAddedToScreen:(UIView*)widget screen:(CaveUIScreenForWidget*)screen {
	NSMutableArray* array = [CaveUIWidget getChildren:widget];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget notifyOnAddedToScreen:child screen:screen];
			}
		}
	}
	if([((NSObject*)widget) conformsToProtocol:@protocol(CaveUIScreenAwareWidget)]) {
		[((id<CaveUIScreenAwareWidget>)widget) onWidgetAddedToScreen:screen];
	}
}

+ (void) notifyOnRemovedFromScreen:(UIView*)widget screen:(CaveUIScreenForWidget*)screen {
	if([((NSObject*)widget) conformsToProtocol:@protocol(CaveUIScreenAwareWidget)]) {
		[((id<CaveUIScreenAwareWidget>)widget) onWidgetRemovedFromScreen:screen];
	}
	NSMutableArray* array = [CaveUIWidget getChildren:widget];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget notifyOnRemovedFromScreen:child screen:screen];
			}
		}
	}
}

+ (void) addChild:(UIView*)parent child:(UIView*)child {
	if(parent == nil || child == nil) {
		return;
	}
	CaveUICustomContainerWidget* ccw = ((CaveUICustomContainerWidget*)({ id _v = child; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
	if(ccw != nil) {
		[ccw tryInitializeWidget];
	}
	[parent addSubview:child];
	CaveUICustomContainerWidget* pp = ((CaveUICustomContainerWidget*)({ id _v = parent; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
	if(pp != nil) {
		[pp onChildWidgetAdded:child];
	}
	[CaveUIWidget onWidgetAddedToParent:child];
	CaveUIScreenForWidget* screen = [CaveUIScreenForWidget findScreenForWidget:child];
	if(screen != nil) {
		[CaveUIWidget notifyOnAddedToScreen:child screen:screen];
	}
}

+ (UIView*) removeFromParent:(UIView*)child {
	if(child == nil) {
		return(nil);
	}
	UIView* parentWidget = [CaveUIWidget getParent:child];
	if(parentWidget == nil) {
		return(nil);
	}
	CaveUICustomContainerWidget* pp = ((CaveUICustomContainerWidget*)({ id _v = parentWidget; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
	[child removeFromSuperview];
	if(pp != nil) {
		[pp onChildWidgetRemoved:child];
	}
	CaveUIScreenForWidget* screen = [CaveUIScreenForWidget findScreenForWidget:parentWidget];
	if(screen != nil) {
		[CaveUIWidget notifyOnRemovedFromScreen:child screen:screen];
	}
	[CaveUIWidget onWidgetRemovedFromParent:child];
	return(nil);
}

+ (BOOL) hasParent:(UIView*)widget {
	if([CaveUIWidget getParent:widget] == nil) {
		return(FALSE);
	}
	return(TRUE);
}

+ (UIView*) getParent:(UIView*)widget {
	if(widget == nil) {
		return(nil);
	}
	if([widget isKindOfClass:[CaveUICustomContainerWidget class]] && [((CaveUICustomContainerWidget*)widget) getScreenForWidget] != nil) {
		return(nil);
	}
	return([widget superview]);
}

+ (NSMutableArray*) getChildren:(UIView*)widget {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	for(UIView* subview in widget.subviews) {
		[v addObject:subview];
	}
	return(v);
}

+ (int) getX:(UIView*)widget {
	if(widget == nil) {
		return(0);
	}
	int v = 0;
	v = widget.frame.origin.x;
	return(v);
}

+ (int) getY:(UIView*)widget {
	if(widget == nil) {
		return(0);
	}
	int v = 0;
	v = widget.frame.origin.y;
	return(v);
}

+ (int) getWidth:(UIView*)widget {
	if(widget == nil) {
		return(0);
	}
	int v = 0;
	v = widget.frame.size.width;
	return(v);
}

+ (int) getHeight:(UIView*)widget {
	if(widget == nil) {
		return(0);
	}
	int v = 0;
	v = widget.frame.size.height;
	return(v);
}

+ (void) move:(UIView*)widget x:(int)x y:(int)y {
	widget.frame = CGRectMake(x, y, widget.frame.size.width, widget.frame.size.height);
}

+ (BOOL) isRootWidget:(UIView*)widget {
	CaveUICustomContainerWidget* cw = ((CaveUICustomContainerWidget*)({ id _v = widget; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
	if(cw == nil) {
		return(FALSE);
	}
	UIView* pp = [CaveUIWidget getParent:((UIView*)cw)];
	if(pp == nil) {
		return(TRUE);
	}
	if([((NSObject*)pp) conformsToProtocol:@protocol(CaveUIWidgetWithLayout)]) {
		return(FALSE);
	}
	return(TRUE);
}

+ (UIViewController*) findScreen:(UIView*)widget {
	UIView* pp = widget;
	while(pp != nil) {
		if([pp isKindOfClass:[CaveUICustomContainerWidget class]]) {
			UIViewController* screen = [((CaveUICustomContainerWidget*)pp) getScreenForWidget];
			if(screen != nil) {
				return(screen);
			}
		}
		pp = [CaveUIWidget getParent:pp];
	}
	return(nil);
}

+ (CaveUICustomContainerWidget*) findRootWidget:(UIView*)widget {
	UIView* v = widget;
	while(TRUE) {
		if(v == nil) {
			break;
		}
		if([CaveUIWidget isRootWidget:v]) {
			return(((CaveUICustomContainerWidget*)({ id _v = v; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; })));
		}
		v = [CaveUIWidget getParent:v];
	}
	return(nil);
}

+ (BOOL) setLayoutSize:(UIView*)widget width:(int)width height:(int)height {
	if([CaveUIWidget isRootWidget:widget]) {
		CaveUICustomContainerWidget* ccw = ((CaveUICustomContainerWidget*)({ id _v = widget; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
		if(ccw != nil && [ccw getAllowResize] == FALSE) {
			return(FALSE);
		}
	}
	if([CaveUIWidget getWidth:widget] == width && [CaveUIWidget getHeight:widget] == height) {
		return(FALSE);
	}
	widget.frame = CGRectMake(widget.frame.origin.x, widget.frame.origin.y, width, height);
	if([((NSObject*)widget) conformsToProtocol:@protocol(CaveUIResizeAwareWidget)]) {
		[((id<CaveUIResizeAwareWidget>)widget) onWidgetResized];
	}
	return(TRUE);
}

+ (BOOL) resizeHeight:(UIView*)widget height:(int)height {
	if([CaveUIWidget setLayoutSize:widget width:[CaveUIWidget getWidth:widget] height:height] == FALSE) {
		return(FALSE);
	}
	if([((NSObject*)widget) conformsToProtocol:@protocol(CaveUIHeightAwareWidget)]) {
		[((id<CaveUIHeightAwareWidget>)widget) onWidgetHeightChanged:height];
	}
	return(TRUE);
}

+ (void) layout:(UIView*)widget widthConstraint:(int)widthConstraint force:(BOOL)force {
	if(widget == nil) {
		return;
	}
	BOOL done = FALSE;
	if([((NSObject*)widget) conformsToProtocol:@protocol(CaveUIWidgetWithLayout)]) {
		done = [((id<CaveUIWidgetWithLayout>)widget) layoutWidget:widthConstraint force:force];
	}
	if(done == FALSE) {
		int srw = 0;
		int srh = 0;
		int cw = widthConstraint;
		int ch = 0;
		if(cw < 0) {
			cw = 0;
		}
		CGSize nsz = [widget sizeThatFits:CGSizeMake(cw, ch)];
		srw = nsz.width;
		if(nsz.width - srw > 0) {
			srw ++;
		}
		srh = nsz.height;
		if(nsz.height - srh > 0) {
			srh ++;
		}
		if(widthConstraint >= 0 && srw != widthConstraint) {
			srw = widthConstraint;
		}
		[CaveUIWidget setLayoutSize:widget width:srw height:srh];
	}
}

+ (void) setWidgetClickHandler:(UIView*)widget handler:(void(^)(void))handler {
	if([widget isKindOfClass:[CaveUICustomContainerWidget class]]) {
		if(handler == nil) {
			[((CaveUICustomContainerWidget*)widget) togglePointerEventHandling:FALSE];
		}
		else {
			[((CaveUICustomContainerWidget*)widget) togglePointerEventHandling:TRUE];
		}
	}
	CaveUIWidgetWidgetClickForwarder* forwarder = [[CaveUIWidgetWidgetClickForwarder alloc] init];
	[forwarder setWidget:widget];
	[forwarder setHandler:handler];
	objc_setAssociatedObject(widget, "_gestureHandler", forwarder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[widget setUserInteractionEnabled:YES];
	[widget addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:forwarder action:@selector(execute)]];
}

+ (void) removeChildrenOf:(UIView*)widget {
	NSMutableArray* children = [CaveUIWidget getChildren:widget];
	if(children != nil) {
		int n = 0;
		int m = [children count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[children objectAtIndex:n]);
			if(child != nil) {
				[CaveUIWidget removeFromParent:child];
			}
		}
	}
}

+ (void) onChanged:(UIView*)widget {
	if(widget == nil) {
		return;
	}
	CaveUICustomContainerWidget* ccw = ((CaveUICustomContainerWidget*)({ id _v = widget; [_v isKindOfClass:[CaveUICustomContainerWidget class]] ? _v : nil; }));
	if(ccw != nil && [ccw getWidgetChanged]) {
		return;
	}
	if([CaveUIWidget isRootWidget:widget]) {
		[((CaveUICustomContainerWidget*)widget) scheduleLayout];
	}
	else {
		UIView* pp = ((UIView*)({ id _v = [CaveUIWidget getParent:widget]; [_v isKindOfClass:[UIView class]] ? _v : nil; }));
		if(pp != nil) {
			[CaveUIWidget onChanged:pp];
		}
		else {
			CaveUICustomContainerWidget* root = [CaveUIWidget findRootWidget:widget];
			if(root != nil) {
				[root scheduleLayout];
			}
		}
	}
	if(ccw != nil) {
		[ccw setWidgetChanged:TRUE];
	}
}

+ (void) setAlpha:(UIView*)widget alpha:(double)alpha {
	if(widget == nil) {
		return;
	}
	[widget setAlpha:(CGFloat)alpha];
}

@end
