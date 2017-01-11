
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
#import "CaveGuiApplicationContext.h"
#import "CaveUIWidget.h"
#import "CapeMath.h"
#import "CaveUIWidgetAnimation.h"

@implementation CaveUIWidgetAnimation

{
	id<CaveGuiApplicationContext> context;
	long long duration;
	NSMutableArray* callbacks;
	void (^endListener)(void);
	BOOL shouldStop;
	BOOL shouldLoop;
	CADisplayLink* displayLink;
	double startTime;
}

- (CaveUIWidgetAnimation*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->startTime = ((double)0);
	self->displayLink = nil;
	self->shouldLoop = FALSE;
	self->shouldStop = FALSE;
	self->endListener = nil;
	self->callbacks = nil;
	self->duration = ((long long)0);
	self->context = nil;
	return(self);
}

+ (CaveUIWidgetAnimation*) forDuration:(id<CaveGuiApplicationContext>)context duration:(long long)duration {
	CaveUIWidgetAnimation* v = [[CaveUIWidgetAnimation alloc] initWithGuiApplicationContext:context];
	[v setDuration:duration];
	return(v);
}

- (CaveUIWidgetAnimation*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->startTime = ((double)0);
	self->displayLink = nil;
	self->shouldLoop = FALSE;
	self->shouldStop = FALSE;
	self->endListener = nil;
	self->callbacks = nil;
	self->duration = ((long long)0);
	self->context = nil;
	self->context = context;
	self->callbacks = [[NSMutableArray alloc] init];
	return(self);
}

- (CaveUIWidgetAnimation*) addCallback:(void(^)(double))callback {
	if(callback != nil) {
		[self->callbacks addObject:callback];
	}
	return(self);
}

- (CaveUIWidgetAnimation*) addCrossFade:(UIView*)from to:(UIView*)to removeFrom:(BOOL)removeFrom {
	UIView* ff = from;
	UIView* tt = to;
	BOOL rf = removeFrom;
	[self addCallback:^void(double completion) {
		[CaveUIWidget setAlpha:ff alpha:1.0 - completion];
		[CaveUIWidget setAlpha:tt alpha:completion];
		if(rf && completion >= 1.0) {
			[CaveUIWidget removeFromParent:ff];
		}
	}];
	return(self);
}

- (CaveUIWidgetAnimation*) addFadeIn:(UIView*)from {
	UIView* ff = from;
	[self addCallback:^void(double completion) {
		[CaveUIWidget setAlpha:ff alpha:completion];
	}];
	return(self);
}

- (CaveUIWidgetAnimation*) addFadeOut:(UIView*)from removeAfter:(BOOL)removeAfter {
	UIView* ff = from;
	BOOL ra = removeAfter;
	[self addCallback:^void(double completion) {
		[CaveUIWidget setAlpha:ff alpha:1.0 - completion];
		if(ra && completion >= 1.0) {
			[CaveUIWidget removeFromParent:ff];
		}
	}];
	return(self);
}

- (CaveUIWidgetAnimation*) addFadeOutIn:(UIView*)from {
	UIView* ff = from;
	[self addCallback:^void(double completion) {
		double r = [CapeMath remainder:completion y:1.0];
		if(r < 0.5) {
			[CaveUIWidget setAlpha:ff alpha:1.0 - r * 2];
		}
		else {
			[CaveUIWidget setAlpha:ff alpha:(r - 0.5) * 2];
		}
	}];
	return(self);
}

- (void) tick:(double)completion {
	if(self->callbacks != nil) {
		int n = 0;
		int m = [self->callbacks count];
		for(n = 0 ; n < m ; n++) {
			void (^callback)(double) = ((void(^)(double))[self->callbacks objectAtIndex:n]);
			if(callback != nil) {
				callback(completion);
			}
		}
	}
}

- (BOOL) onProgress:(long long)elapsedTime {
	double completion = ((double)elapsedTime) / ((double)self->duration);
	[self tick:completion];
	if(self->shouldLoop == FALSE && completion >= 1.0 || self->shouldStop) {
		[self onAnimationEnded];
		return(FALSE);
	}
	return(TRUE);
}

- (void) onAnimationEnded {
	if(self->endListener != nil) {
		self->endListener();
	}
}

- (void) onAnimationFrame {
	if(self->startTime <= 0.0) {
		startTime = [displayLink timestamp];
	}
	double currentTime = [displayLink timestamp];
	double diff = currentTime - self->startTime;
	int diffms = ((int)([CapeMath rint:diff * 1000]));
	if([self onProgress:((long long)diffms)] == FALSE) {
		[displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self->displayLink = nil;
	}
}

- (void) start {
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onAnimationFrame)];
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (long long) getDuration {
	return(self->duration);
}

- (CaveUIWidgetAnimation*) setDuration:(long long)v {
	self->duration = v;
	return(self);
}

- (void(^)(void)) getEndListener {
	return(self->endListener);
}

- (CaveUIWidgetAnimation*) setEndListener:(void(^)(void))v {
	self->endListener = v;
	return(self);
}

- (BOOL) getShouldStop {
	return(self->shouldStop);
}

- (CaveUIWidgetAnimation*) setShouldStop:(BOOL)v {
	self->shouldStop = v;
	return(self);
}

- (BOOL) getShouldLoop {
	return(self->shouldLoop);
}

- (CaveUIWidgetAnimation*) setShouldLoop:(BOOL)v {
	self->shouldLoop = v;
	return(self);
}

@end
