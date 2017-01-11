
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
#import "CapexJSONAPIClient.h"
#import "CaveGuiApplicationContext.h"
#import "CaveUILoadingWidget.h"
#import "CapeError.h"
#import "CaveUIJSONAPIClientWithGui.h"

@implementation CaveUIJSONAPIClientWithGui

{
	id<CaveGuiApplicationContext> context;
	UIView* parentWidget;
	CaveUILoadingWidget* loadingWidget;
	int requestCounter;
}

- (CaveUIJSONAPIClientWithGui*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->requestCounter = 0;
	self->loadingWidget = nil;
	self->parentWidget = nil;
	self->context = nil;
	return(self);
}

- (void) onStartSendRequest {
	[super onStartSendRequest];
	if(self->loadingWidget == nil) {
		self->loadingWidget = [CaveUILoadingWidget openPopup:self->context widget:self->parentWidget];
	}
	self->requestCounter++;
}

- (void) onEndSendRequest {
	[super onEndSendRequest];
	self->requestCounter--;
	if(self->requestCounter < 1) {
		self->loadingWidget = [CaveUILoadingWidget closePopup:self->loadingWidget];
	}
}

- (void) onDefaultErrorHandler:(CapeError*)error {
	if(error == nil || self->context == nil) {
		return;
	}
	[self->context showErrorDialogWithString:[error toString]];
}

- (id<CaveGuiApplicationContext>) getContext {
	return(self->context);
}

- (CaveUIJSONAPIClientWithGui*) setContext:(id<CaveGuiApplicationContext>)v {
	self->context = v;
	return(self);
}

- (UIView*) getParentWidget {
	return(self->parentWidget);
}

- (CaveUIJSONAPIClientWithGui*) setParentWidget:(UIView*)v {
	self->parentWidget = v;
	return(self);
}

@end
