
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
#import "CaveImage.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUIWidget.h"
#import "CaveUIWidgetAnimation.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveColor.h"
#import "CaveUIImageWidget.h"
#import "CapeString.h"
#import "CaveUILabelWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUILoadingWidget.h"

NSString* CaveUILoadingWidgetDisplayText = nil;
CaveImage* CaveUILoadingWidgetDisplayImage = nil;

@implementation CaveUILoadingWidget

{
	UIView* loading;
	CaveUIWidgetAnimation* animation;
}

- (CaveUILoadingWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->animation = nil;
	self->loading = nil;
	return(self);
}

+ (void) initializeWithText:(NSString*)text {
	CaveUILoadingWidgetDisplayText = text;
	CaveUILoadingWidgetDisplayImage = nil;
}

+ (void) initializeWithImage:(CaveImage*)image {
	CaveUILoadingWidgetDisplayText = nil;
	CaveUILoadingWidgetDisplayImage = image;
}

+ (CaveUILoadingWidget*) openPopup:(id<CaveGuiApplicationContext>)context widget:(UIView*)widget {
	CaveUILoadingWidget* v = [[CaveUILoadingWidget alloc] initWithGuiApplicationContext:context];
	if([v showPopup:widget] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (CaveUILoadingWidget*) closePopup:(CaveUILoadingWidget*)widget {
	if(widget != nil) {
		[widget stop];
		[CaveUIWidget removeFromParent:((UIView*)widget)];
	}
	return(nil);
}

- (CaveUILoadingWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->animation = nil;
	self->loading = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	return(self);
}

- (void) initializeWidget {
	[super initializeWidget];
	[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor forRGBADouble:((double)0) g:((double)0) b:((double)0) a:0.8]])];
	if(CaveUILoadingWidgetDisplayImage != nil) {
		CaveUIImageWidget* img = [CaveUIImageWidget forImage:self->context image:CaveUILoadingWidgetDisplayImage];
		[img setWidgetImageHeight:[self->context getHeightValue:@"20mm"]];
		self->loading = ((UIView*)img);
	}
	else {
		NSString* text = CaveUILoadingWidgetDisplayText;
		if([CapeString isEmpty:text]) {
			text = @"Loading ..";
		}
		CaveUILabelWidget* lt = [CaveUILabelWidget forText:self->context text:text];
		[lt setWidgetTextColor:[CaveColor white]];
		[lt setWidgetFontSize:((double)20)];
		self->loading = ((UIView*)lt);
	}
	[self addWidget:((UIView*)[CaveUIAlignWidget forWidget:self->context widget:self->loading alignX:0.5 alignY:0.5 margin:0])];
	[self start];
}

- (void) start {
	self->animation = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)1000)];
	[self->animation addFadeOutIn:self->loading];
	[self->animation setShouldLoop:TRUE];
	[self->animation start];
}

- (void) stop {
	if(self->animation != nil) {
		[self->animation setShouldStop:TRUE];
		self->animation = nil;
	}
}

- (BOOL) showPopup:(UIView*)target {
	CaveUILayerWidget* topmost = [CaveUILayerWidget findTopMostLayerWidget:target];
	if(topmost == nil) {
		return(FALSE);
	}
	[topmost addWidget:((UIView*)self)];
	return(TRUE);
}

@end
