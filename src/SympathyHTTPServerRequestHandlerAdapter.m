
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
#import "SympathyHTTPServerRequestHandler.h"
#import "SympathyHTTPServerComponent.h"
#import "SympathyHTTPServerBase.h"
#import "CapeLoggingContext.h"
#import "SympathyNetworkConnectionManager.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerRequestHandlerAdapter.h"

@implementation SympathyHTTPServerRequestHandlerAdapter

{
	SympathyHTTPServerBase* server;
}

- (SympathyHTTPServerRequestHandlerAdapter*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->logContext = nil;
	self->server = nil;
	return(self);
}

- (SympathyHTTPServerBase*) getServer {
	return(self->server);
}

- (BOOL) isInitialized {
	if(self->server == nil) {
		return(FALSE);
	}
	return(TRUE);
}

- (void) initialize:(SympathyHTTPServerBase*)server {
	self->server = server;
	if(server != nil) {
		self->logContext = [server getLogContext];
	}
	else {
		self->logContext = nil;
	}
}

- (void) onMaintenance {
}

- (void) onRefresh {
}

- (void) cleanup {
	self->server = nil;
}

- (BOOL) onGETWithHTTPServerRequest:(SympathyHTTPServerRequest*)req {
	return(FALSE);
}

- (void) onGETWithHTTPServerRequestAndFunction:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self onGETWithHTTPServerRequest:req] == FALSE) {
		next();
	}
}

- (BOOL) onPOSTWithHTTPServerRequest:(SympathyHTTPServerRequest*)req {
	return(FALSE);
}

- (void) onPOSTWithHTTPServerRequestAndFunction:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self onPOSTWithHTTPServerRequest:req] == FALSE) {
		next();
	}
}

- (BOOL) onPUTWithHTTPServerRequest:(SympathyHTTPServerRequest*)req {
	return(FALSE);
}

- (void) onPUTWithHTTPServerRequestAndFunction:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self onPUTWithHTTPServerRequest:req] == FALSE) {
		next();
	}
}

- (BOOL) onDELETEWithHTTPServerRequest:(SympathyHTTPServerRequest*)req {
	return(FALSE);
}

- (void) onDELETEWithHTTPServerRequestAndFunction:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self onDELETEWithHTTPServerRequest:req] == FALSE) {
		next();
	}
}

- (BOOL) onPATCHWithHTTPServerRequest:(SympathyHTTPServerRequest*)req {
	return(FALSE);
}

- (void) onPATCHWithHTTPServerRequestAndFunction:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self onPATCHWithHTTPServerRequest:req] == FALSE) {
		next();
	}
}

- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if(req == nil) {
		next();
	}
	else {
		if([req isGET]) {
			[self onGETWithHTTPServerRequestAndFunction:req next:next];
		}
		else {
			if([req isPOST]) {
				[self onPOSTWithHTTPServerRequestAndFunction:req next:next];
			}
			else {
				if([req isPUT]) {
					[self onPUTWithHTTPServerRequestAndFunction:req next:next];
				}
				else {
					if([req isDELETE]) {
						[self onDELETEWithHTTPServerRequestAndFunction:req next:next];
					}
					else {
						if([req isPATCH]) {
							[self onPATCHWithHTTPServerRequestAndFunction:req next:next];
						}
						else {
							next();
						}
					}
				}
			}
		}
	}
}

@end
