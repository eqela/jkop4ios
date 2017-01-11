
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
#import "CapeLoggingContext.h"
#import "CaveIOSScreen.h"

@implementation CaveIOSScreen

{
	BOOL isLightStatusBar;
}

- (CaveIOSScreen*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isLightStatusBar = FALSE;
	self->ctx = nil;
	return(self);
}

- (void) setContext:(id<CapeLoggingContext>)ctx {
	self->ctx = ctx;
}

- (void) jkInitialize {
}

- (void) jkLayout {
}

- (void) jkStart {
}

- (void) jkStop {
}

- (void) jkCleanup {
}

- (int) jkGetWidth {
	return(self.view.frame.size.width);
}

- (int) jkGetHeight {
	return(self.view.frame.size.height);
}

- (id) createColor:(double)r g:(double)g b:(double)b a:(double)a {
	return([UIColor colorWithRed:r green:g blue:b alpha:a]);
}

- (id) getBackgroundColor {
	return([UIColor whiteColor]);
}

- (void) viewDidLoad {
	[super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle*) preferredStatusBarStyle {
	if(self->isLightStatusBar) {
		return(UIStatusBarStyleLightContent);
	}
	return(UIStatusBarStyleDefault);
}

- (void) loadView {
	UIView* view = [[UIView alloc] init];
	view.backgroundColor = (UIColor*)[self getBackgroundColor];
	self.view = view;
	[self jkInitialize];
}

- (void) viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self jkLayout];
}

- (void) viewDidAppear:(BOOL)animated {
	[self jkStart];
}

- (void) viewWillDisappear:(BOOL)animated {
	[self jkStop];
	if([self isBeingDismissed]) {
		[self jkCleanup];
	}
}

- (void) didMoveToParentViewController:(UIViewController*)parent {
	if(parent == nil) {
		[self jkCleanup];
	}
}

- (BOOL) getIsLightStatusBar {
	return(self->isLightStatusBar);
}

- (CaveIOSScreen*) setIsLightStatusBar:(BOOL)v {
	self->isLightStatusBar = v;
	return(self);
}

@end
