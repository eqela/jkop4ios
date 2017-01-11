
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
#import "CaveUILayerWidget.h"
#import "CaveColor.h"
#import "CaveUIImageWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CapeVector.h"
#import "CaveUIWidgetAnimation.h"
#import "CaveUIWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUISplashScreenWidget.h"

@class CaveUISplashScreenWidgetSlide;

@interface CaveUISplashScreenWidgetSlide : NSObject
{
	@public NSString* resource;
	@public int delay;
}
- (CaveUISplashScreenWidgetSlide*) init;
@end

@implementation CaveUISplashScreenWidgetSlide

- (CaveUISplashScreenWidgetSlide*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->delay = 0;
	self->resource = nil;
	return(self);
}

@end

@implementation CaveUISplashScreenWidget

{
	CaveColor* backgroundColor;
	NSMutableArray* slides;
	void (^doneHandler)(void);
	int currentSlide;
	CaveUIImageWidget* currentImageWidget;
	NSString* imageWidgetWidth;
}

- (CaveUISplashScreenWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->imageWidgetWidth = @"80mm";
	self->currentImageWidget = nil;
	self->currentSlide = -1;
	self->doneHandler = nil;
	self->slides = nil;
	self->backgroundColor = nil;
	return(self);
}

- (CaveUISplashScreenWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)ctx {
	self->imageWidgetWidth = @"80mm";
	self->currentImageWidget = nil;
	self->currentSlide = -1;
	self->doneHandler = nil;
	self->slides = nil;
	self->backgroundColor = nil;
	if([super initWithGuiApplicationContext:ctx] == nil) {
		return(nil);
	}
	self->slides = [[NSMutableArray alloc] init];
	return(self);
}

- (void) addSlide:(NSString*)resource delay:(int)delay {
	CaveUISplashScreenWidgetSlide* slide = [[CaveUISplashScreenWidgetSlide alloc] init];
	slide->resource = resource;
	slide->delay = delay;
	[self->slides addObject:slide];
}

- (void) initializeWidget {
	[super initializeWidget];
	if(self->backgroundColor != nil) {
		[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->backgroundColor])];
	}
	[self nextImage];
}

- (void) nextImage {
	self->currentSlide++;
	CaveUISplashScreenWidgetSlide* slide = ((CaveUISplashScreenWidgetSlide*)[CapeVector get:self->slides index:self->currentSlide]);
	if(slide == nil) {
		CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)1000)];
		[anim addFadeOut:((UIView*)self->currentImageWidget) removeAfter:TRUE];
		[anim setEndListener:^void() {
			[self onEnded];
		}];
		[anim start];
		return;
	}
	CaveUIImageWidget* imageWidget = [CaveUIImageWidget forImageResource:self->context resName:slide->resource];
	[CaveUIWidget setAlpha:((UIView*)imageWidget) alpha:((double)0)];
	[imageWidget setWidgetImageWidth:[self->context getWidthValue:self->imageWidgetWidth]];
	CaveUIAlignWidget* align = [CaveUIAlignWidget forWidget:self->context widget:((UIView*)imageWidget) alignX:0.5 alignY:0.5 margin:[self->context getWidthValue:@"5mm"]];
	[self addWidget:((UIView*)align)];
	CaveUIWidgetAnimation* anim = [CaveUIWidgetAnimation forDuration:self->context duration:((long long)1000)];
	[anim addCrossFade:((UIView*)self->currentImageWidget) to:((UIView*)imageWidget) removeFrom:TRUE];
	[anim start];
	self->currentImageWidget = imageWidget;
	[self->context startTimer:((long long)slide->delay) callback:^void() {
		[self nextImage];
	}];
}

- (void) onEnded {
	if(self->doneHandler != nil) {
		self->doneHandler();
	}
}

- (CaveColor*) getBackgroundColor {
	return(self->backgroundColor);
}

- (CaveUISplashScreenWidget*) setBackgroundColor:(CaveColor*)v {
	self->backgroundColor = v;
	return(self);
}

- (void(^)(void)) getDoneHandler {
	return(self->doneHandler);
}

- (CaveUISplashScreenWidget*) setDoneHandler:(void(^)(void))v {
	self->doneHandler = v;
	return(self);
}

- (NSString*) getImageWidgetWidth {
	return(self->imageWidgetWidth);
}

- (CaveUISplashScreenWidget*) setImageWidgetWidth:(NSString*)v {
	self->imageWidgetWidth = v;
	return(self);
}

@end
