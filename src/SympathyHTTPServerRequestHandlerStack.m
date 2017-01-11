
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
#import "SympathyHTTPServerRequestHandlerContainer.h"
#import "SympathyHTTPServerRequestHandler.h"
#import "SympathyHTTPServerRequest.h"
#import "CapeVector.h"
#import "SympathyHTTPServerResponse.h"
#import "CapeIterator.h"
#import "SympathyHTTPServerComponent.h"
#import "SympathyHTTPServerRequestHandlerAdapter.h"
#import "SympathyHTTPServerRequestHandlerStack.h"

@class SympathyHTTPServerRequestHandlerStackFunctionRequestHandler;
@class SympathyHTTPServerRequestHandlerStackRequestProcessor;

@interface SympathyHTTPServerRequestHandlerStackFunctionRequestHandler : NSObject <SympathyHTTPServerRequestHandler>
- (SympathyHTTPServerRequestHandlerStackFunctionRequestHandler*) init;
- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next;
- (void(^)(SympathyHTTPServerRequest*,void(^)(void))) getHandler;
- (SympathyHTTPServerRequestHandlerStackFunctionRequestHandler*) setHandler:(void(^)(SympathyHTTPServerRequest*,void(^)(void)))v;
@end

@implementation SympathyHTTPServerRequestHandlerStackFunctionRequestHandler

{
	void (^handler)(SympathyHTTPServerRequest*,void(^)(void));
}

- (SympathyHTTPServerRequestHandlerStackFunctionRequestHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->handler = nil;
	return(self);
}

- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	self->handler(req, next);
}

- (void(^)(SympathyHTTPServerRequest*,void(^)(void))) getHandler {
	return(self->handler);
}

- (SympathyHTTPServerRequestHandlerStackFunctionRequestHandler*) setHandler:(void(^)(SympathyHTTPServerRequest*,void(^)(void)))v {
	self->handler = v;
	return(self);
}

@end

@interface SympathyHTTPServerRequestHandlerStackRequestProcessor : NSObject
- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) init;
- (void) start;
- (void) next;
- (void) defaultLast;
- (NSMutableArray*) getRequestHandlers;
- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setRequestHandlers:(NSMutableArray*)v;
- (SympathyHTTPServerRequest*) getRequest;
- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setRequest:(SympathyHTTPServerRequest*)v;
- (void(^)(void)) getLast;
- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setLast:(void(^)(void))v;
@end

@implementation SympathyHTTPServerRequestHandlerStackRequestProcessor

{
	NSMutableArray* requestHandlers;
	SympathyHTTPServerRequest* request;
	void (^last)(void);
	int current;
}

- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->current = 0;
	self->last = nil;
	self->request = nil;
	self->requestHandlers = nil;
	return(self);
}

- (void) start {
	self->current = -1;
	[self next];
}

- (void) next {
	self->current++;
	id<SympathyHTTPServerRequestHandler> handler = ((id<SympathyHTTPServerRequestHandler>)[CapeVector get:self->requestHandlers index:self->current]);
	if(handler == nil) {
		if(self->last == nil) {
			[self defaultLast];
		}
		else {
			self->last();
		}
		return;
	}
	[handler handleRequest:self->request next:^void() {
		[self next];
	}];
	[self->request resetResources];
}

- (void) defaultLast {
	[self->request sendResponse:[SympathyHTTPServerResponse forHTTPNotFound:nil]];
}

- (NSMutableArray*) getRequestHandlers {
	return(self->requestHandlers);
}

- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setRequestHandlers:(NSMutableArray*)v {
	self->requestHandlers = v;
	return(self);
}

- (SympathyHTTPServerRequest*) getRequest {
	return(self->request);
}

- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setRequest:(SympathyHTTPServerRequest*)v {
	self->request = v;
	return(self);
}

- (void(^)(void)) getLast {
	return(self->last);
}

- (SympathyHTTPServerRequestHandlerStackRequestProcessor*) setLast:(void(^)(void))v {
	self->last = v;
	return(self);
}

@end

@implementation SympathyHTTPServerRequestHandlerStack

- (SympathyHTTPServerRequestHandlerStack*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->requestHandlers = nil;
	return(self);
}

- (id<CapeIterator>) iterateRequestHandlers {
	if(self->requestHandlers == nil) {
		return(nil);
	}
	return(((id<CapeIterator>)[CapeVector iterate:self->requestHandlers]));
}

- (void) pushRequestHandlerWithFunction:(void(^)(SympathyHTTPServerRequest*,void(^)(void)))handler {
	if(handler == nil) {
		return;
	}
	[self pushRequestHandlerWithHTTPServerRequestHandler:((id<SympathyHTTPServerRequestHandler>)[[[SympathyHTTPServerRequestHandlerStackFunctionRequestHandler alloc] init] setHandler:handler])];
}

- (void) pushRequestHandlerWithHTTPServerRequestHandler:(id<SympathyHTTPServerRequestHandler>)handler {
	if(handler == nil) {
		return;
	}
	if(self->requestHandlers == nil) {
		self->requestHandlers = [[NSMutableArray alloc] init];
	}
	[self->requestHandlers addObject:handler];
	if([((NSObject*)handler) conformsToProtocol:@protocol(SympathyHTTPServerComponent)] && [self isInitialized]) {
		[((id<SympathyHTTPServerComponent>)handler) initialize:[self getServer]];
	}
}

- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	SympathyHTTPServerRequestHandlerStackRequestProcessor* rp = [[SympathyHTTPServerRequestHandlerStackRequestProcessor alloc] init];
	[rp setRequestHandlers:self->requestHandlers];
	[rp setRequest:req];
	[rp setLast:next];
	[rp start];
}

@end
