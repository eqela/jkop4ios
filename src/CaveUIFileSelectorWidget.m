
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
#import "CapeError.h"
#import "CaveUIFileSelectorWidget.h"

@implementation CaveUIFileSelectorWidget

{
	id<CaveGuiApplicationContext> context;
}

- (CaveUIFileSelectorWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->context = nil;
	return(self);
}

- (CaveUIFileSelectorWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->context = nil;
	self->context = context;
	return(self);
}

- (void) openFileDialog:(UIView*)widget type:(NSString*)type callback:(void(^)(NSMutableData*,NSString*,CapeError*))callback {
	void (^cb)(NSMutableData*,NSString*,CapeError*) = callback;
	NSLog(@"%@", @"[cave.ui.FileSelectorWidget.openFileDialog] (FileSelectorWidget.sling:129:2): Not implemented");
	if(cb != nil) {
		cb(nil, nil, [CapeError forCode:@"not_supported" detail:nil]);
	}
}

@end
