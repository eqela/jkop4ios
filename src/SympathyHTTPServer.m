
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
#import "SympathyHTTPServerBase.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerResponse.h"
#import "SympathyHTTPServerRequestHandlerListener.h"
#import "SympathyHTTPServerRequestHandlerStack.h"
#import "SympathyHTTPServerRequestHandlerContainer.h"
#import "SympathyHTTPServerComponent.h"
#import "SympathyHTTPServerRequestHandler.h"
#import "SympathyNetworkConnectionManager.h"
#import "SympathyHTTPServer.h"

@implementation SympathyHTTPServer

{
	SympathyHTTPServerResponse* (^createOptionsResponseHandler)(SympathyHTTPServerRequest*);
	NSMutableArray* requestHandlerListenerFunctions;
	NSMutableArray* requestHandlerListenerObjects;
	SympathyHTTPServerRequestHandlerStack* handlerStack;
}

- (SympathyHTTPServer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->handlerStack = nil;
	self->requestHandlerListenerObjects = nil;
	self->requestHandlerListenerFunctions = nil;
	self->createOptionsResponseHandler = nil;
	self->handlerStack = [[SympathyHTTPServerRequestHandlerStack alloc] init];
	return(self);
}

- (BOOL) initialize {
	if([super initialize] == FALSE) {
		return(FALSE);
	}
	[self->handlerStack initialize:((SympathyHTTPServerBase*)self)];
	if(self->requestHandlerListenerObjects != nil) {
		int n = 0;
		int m = [self->requestHandlerListenerObjects count];
		for(n = 0 ; n < m ; n++) {
			id<SympathyHTTPServerRequestHandlerListener> listener = ((id<SympathyHTTPServerRequestHandlerListener>)[self->requestHandlerListenerObjects objectAtIndex:n]);
			if(listener != nil) {
				if([((NSObject*)listener) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
					[((id<SympathyHTTPServerComponent>)listener) initialize:((SympathyHTTPServerBase*)self)];
				}
			}
		}
	}
	return(TRUE);
}

- (void) onRefresh {
	[super onRefresh];
	[self->handlerStack onRefresh];
	if(self->requestHandlerListenerObjects != nil) {
		int n = 0;
		int m = [self->requestHandlerListenerObjects count];
		for(n = 0 ; n < m ; n++) {
			id<SympathyHTTPServerRequestHandlerListener> listener = ((id<SympathyHTTPServerRequestHandlerListener>)[self->requestHandlerListenerObjects objectAtIndex:n]);
			if(listener != nil) {
				if([((NSObject*)listener) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
					[((id<SympathyHTTPServerComponent>)listener) onRefresh];
				}
			}
		}
	}
}

- (void) onMaintenance {
	[super onMaintenance];
	[self->handlerStack onMaintenance];
	if(self->requestHandlerListenerObjects != nil) {
		int n = 0;
		int m = [self->requestHandlerListenerObjects count];
		for(n = 0 ; n < m ; n++) {
			id<SympathyHTTPServerRequestHandlerListener> listener = ((id<SympathyHTTPServerRequestHandlerListener>)[self->requestHandlerListenerObjects objectAtIndex:n]);
			if(listener != nil) {
				if([((NSObject*)listener) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
					[((id<SympathyHTTPServerComponent>)listener) onMaintenance];
				}
			}
		}
	}
}

- (void) cleanup {
	[super cleanup];
	[self->handlerStack cleanup];
	if(self->requestHandlerListenerObjects != nil) {
		int n = 0;
		int m = [self->requestHandlerListenerObjects count];
		for(n = 0 ; n < m ; n++) {
			id<SympathyHTTPServerRequestHandlerListener> listener = ((id<SympathyHTTPServerRequestHandlerListener>)[self->requestHandlerListenerObjects objectAtIndex:n]);
			if(listener != nil) {
				if([((NSObject*)listener) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
					[((id<SympathyHTTPServerComponent>)listener) cleanup];
				}
			}
		}
	}
}

- (void) pushRequestHandlerWithFunction:(void(^)(SympathyHTTPServerRequest*,void(^)(void)))handler {
	[self->handlerStack pushRequestHandlerWithFunction:handler];
}

- (void) pushRequestHandlerWithHTTPServerRequestHandler:(id<SympathyHTTPServerRequestHandler>)handler {
	[self->handlerStack pushRequestHandlerWithHTTPServerRequestHandler:handler];
}

- (void) addRequestHandlerListenerWithFunction:(void(^)(SympathyHTTPServerRequest*,SympathyHTTPServerResponse*,int,NSString*))handler {
	if(self->requestHandlerListenerFunctions == nil) {
		self->requestHandlerListenerFunctions = [[NSMutableArray alloc] init];
	}
	[self->requestHandlerListenerFunctions addObject:handler];
}

- (void) addRequestHandlerListenerWithHTTPServerRequestHandlerListener:(id<SympathyHTTPServerRequestHandlerListener>)handler {
	if(self->requestHandlerListenerObjects == nil) {
		self->requestHandlerListenerObjects = [[NSMutableArray alloc] init];
	}
	[self->requestHandlerListenerObjects addObject:handler];
	if([((NSObject*)handler) conformsToProtocol:@protocol(SympathyHTTPServerComponent)] && [self isInitialized]) {
		[((id<SympathyHTTPServerComponent>)handler) initialize:((SympathyHTTPServerBase*)self)];
	}
}

- (SympathyHTTPServerResponse*) createOptionsResponse:(SympathyHTTPServerRequest*)req {
	if(self->createOptionsResponseHandler != nil) {
		return(self->createOptionsResponseHandler(req));
	}
	return([super createOptionsResponse:req]);
}

- (void) onRequest:(SympathyHTTPServerRequest*)req {
	SympathyHTTPServerRequest* rq = req;
	[self->handlerStack handleRequest:((SympathyHTTPServerRequest*)({ id _v = req; [_v isKindOfClass:[SympathyHTTPServerRequest class]] ? _v : nil; })) next:^void() {
		[rq sendResponse:[SympathyHTTPServerResponse forHTTPNotFound:nil]];
	}];
}

- (void) onRequestComplete:(SympathyHTTPServerRequest*)request resp:(SympathyHTTPServerResponse*)resp bytesSent:(int)bytesSent remoteAddress:(NSString*)remoteAddress {
	[super onRequestComplete:request resp:resp bytesSent:bytesSent remoteAddress:remoteAddress];
	if(self->requestHandlerListenerFunctions != nil) {
		int n = 0;
		int m = [self->requestHandlerListenerFunctions count];
		for(n = 0 ; n < m ; n++) {
			void (^handler)(SympathyHTTPServerRequest*,SympathyHTTPServerResponse*,int,NSString*) = ((void(^)(SympathyHTTPServerRequest*,SympathyHTTPServerResponse*,int,NSString*))[self->requestHandlerListenerFunctions objectAtIndex:n]);
			if(handler != nil) {
				handler(request, resp, bytesSent, remoteAddress);
			}
		}
	}
	if(self->requestHandlerListenerObjects != nil) {
		int n2 = 0;
		int m2 = [self->requestHandlerListenerObjects count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			id<SympathyHTTPServerRequestHandlerListener> handler = ((id<SympathyHTTPServerRequestHandlerListener>)[self->requestHandlerListenerObjects objectAtIndex:n2]);
			if(handler != nil) {
				[handler onRequestHandled:request resp:resp bytesSent:bytesSent remoteAddress:remoteAddress];
			}
		}
	}
}

- (SympathyHTTPServerResponse*(^)(SympathyHTTPServerRequest*)) getCreateOptionsResponseHandler {
	return(self->createOptionsResponseHandler);
}

- (SympathyHTTPServer*) setCreateOptionsResponseHandler:(SympathyHTTPServerResponse*(^)(SympathyHTTPServerRequest*))v {
	self->createOptionsResponseHandler = v;
	return(self);
}

@end
