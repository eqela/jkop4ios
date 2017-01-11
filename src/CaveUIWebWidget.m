
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
#import "CaveUIWebWidget.h"

@implementation CaveUIWebWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetUrl;
	NSString* widgetHtmlString;
	BOOL (^customUrlHandler)(NSString*);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return(![self overrideWidgetUrlLoading:[[request URL] absoluteString]]);
}

- (CaveUIWebWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->customUrlHandler = nil;
	self->widgetHtmlString = nil;
	self->widgetUrl = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUIWebWidget*) forUrl:(id<CaveGuiApplicationContext>)context url:(NSString*)url {
	CaveUIWebWidget* v = [[CaveUIWebWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetUrl:url];
	return(v);
}

+ (CaveUIWebWidget*) forHtmlString:(id<CaveGuiApplicationContext>)context html:(NSString*)html {
	CaveUIWebWidget* v = [[CaveUIWebWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetHtmlString:html];
	return(v);
}

- (CaveUIWebWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->customUrlHandler = nil;
	self->widgetHtmlString = nil;
	self->widgetUrl = nil;
	self->widgetContext = nil;
	[self setDelegate:self];
	self->widgetContext = context;
	return(self);
}

- (BOOL) overrideWidgetUrlLoading:(NSString*)url {
	if(self->customUrlHandler != nil) {
		return(self->customUrlHandler(url));
	}
	return(FALSE);
}

- (CaveUIWebWidget*) setWidgetHtmlString:(NSString*)html {
	self->widgetHtmlString = html;
	self->widgetUrl = nil;
	[self updateWidgetContent];
	return(self);
}

- (NSString*) getWidgetHtmlString {
	return(self->widgetHtmlString);
}

- (CaveUIWebWidget*) setWidgetUrl:(NSString*)url {
	self->widgetUrl = url;
	self->widgetHtmlString = nil;
	[self updateWidgetContent];
	return(self);
}

- (NSString*) getWidgetUrl {
	return(self->widgetUrl);
}

- (void) updateWidgetContent {
	NSString* url = self->widgetUrl;
	if(!(({ NSString* _s1 = url; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	}
	else {
		NSString* htmlString = self->widgetHtmlString;
		[self loadHTMLString:htmlString baseURL:nil];
	}
}

- (BOOL(^)(NSString*)) getCustomUrlHandler {
	return(self->customUrlHandler);
}

- (CaveUIWebWidget*) setCustomUrlHandler:(BOOL(^)(NSString*))v {
	self->customUrlHandler = v;
	return(self);
}

@end
