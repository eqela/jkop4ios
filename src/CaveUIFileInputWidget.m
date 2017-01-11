
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
#import "CaveUIFileInputWidget.h"

@implementation CaveUIFileInputWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetType;
	void (^widgetListener)(void);
}

- (CaveUIFileInputWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetListener = nil;
	self->widgetType = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIFileInputWidget*) forType:(id<CaveGuiApplicationContext>)context type:(NSString*)type {
	CaveUIFileInputWidget* v = [[CaveUIFileInputWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetType:type];
	return(v);
}

- (CaveUIFileInputWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetListener = nil;
	self->widgetType = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	return(self);
}

- (void) setWidgetType:(NSString*)type {
	self->widgetType = type;
	NSLog(@"%@", @"[cave.ui.FileInputWidget.setWidgetType] (FileInputWidget.sling:80:2): Not implemented");
}

- (NSString*) getWidgetType {
	return(self->widgetType);
}

- (void) setWidgetListener:(NSString*)event listener:(void(^)(void))listener {
	self->widgetListener = listener;
	NSLog(@"%@", @"[cave.ui.FileInputWidget.setWidgetListener] (FileInputWidget.sling:96:2): Not implemented");
}

- (NSString*) getWidgetFileName {
	NSLog(@"%@", @"[cave.ui.FileInputWidget.getWidgetFileName] (FileInputWidget.sling:109:2): Not implemented");
	return(nil);
}

- (NSString*) getWidgetFileMimeType {
	NSLog(@"%@", @"[cave.ui.FileInputWidget.getWidgetFileMimeType] (FileInputWidget.sling:116:1): Not implemented");
	return(nil);
}

- (NSMutableData*) getWidgetFileContents {
	NSLog(@"%@", @"[cave.ui.FileInputWidget.getWidgetFileContents] (FileInputWidget.sling:122:1): Not implemented");
	return(nil);
}

@end
