
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
#import "CaveGuiApplicationContextForIOS.h"
#import "CapeLog.h"
#import "CapeLoggingContext.h"
#import "CaveScreenWithContext.h"
#import "CaveGuiApplicationContext.h"
#import "CaveIOSAppDelegate.h"

@implementation CaveIOSAppDelegate

{
	BOOL (^openURLhandler)(UIApplication*,NSURL*,NSDictionary*,NSString*,id);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
	if(self->openURLhandler != nil) {
		return(self->openURLhandler(app, url, options, nil, nil));
	}
	return(NO);
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if(self->openURLhandler != nil) {
		return(self->openURLhandler(app, url, nil, sourceApplication, annotation));
	}
	return(NO);
}

- (CaveIOSAppDelegate*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->openURLhandler = nil;
	self->ctx = nil;
	self->viewController = nil;
	self->window = nil;
	self->ctx = [self createContext];
	return(self);
}

- (CaveGuiApplicationContextForIOS*) createContext {
	return([[CaveGuiApplicationContextForIOS alloc] init]);
}

- (UIViewController*) createMainScreen:(CaveGuiApplicationContextForIOS*)ctx {
	return(nil);
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	[CapeLog debug:((id<CapeLoggingContext>)self->ctx) message:@"applicationDidFinishLaunching"];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController* cc = [self createMainScreen:self->ctx];
	if(cc != nil) {
		if([((NSObject*)cc) conformsToProtocol:@protocol(CaveScreenWithContext)]) {
			[((id<CaveScreenWithContext>)cc) setContext:((id<CaveGuiApplicationContext>)self->ctx)];
		}
		self->viewController = cc;
		window.rootViewController = viewController;
	}
	[window makeKeyAndVisible];
}

- (void) applicationDidBecomeActive:(UIApplication*)application {
	[CapeLog debug:((id<CapeLoggingContext>)self->ctx) message:@"applicationDidBecomeActive"];
}

- (void) applicationWillResignActive:(UIApplication*)application {
	[CapeLog debug:((id<CapeLoggingContext>)self->ctx) message:@"applicationWillResignActive"];
}

- (void) applicationDidEnterBackground:(UIApplication*)application {
	[CapeLog debug:((id<CapeLoggingContext>)self->ctx) message:@"applicationDidEnterBackground"];
}

- (void) applicationWillEnterForeground:(UIApplication*)application {
	[CapeLog debug:((id<CapeLoggingContext>)self->ctx) message:@"applicationWillEnterForeground"];
}

- (BOOL(^)(UIApplication*,NSURL*,NSDictionary*,NSString*,id)) getOpenURLhandler {
	return(self->openURLhandler);
}

- (CaveIOSAppDelegate*) setOpenURLhandler:(BOOL(^)(UIApplication*,NSURL*,NSDictionary*,NSString*,id))v {
	self->openURLhandler = v;
	return(self);
}

@end
