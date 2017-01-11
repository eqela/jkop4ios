
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
#import "SympathyHTTPServerRequestHandlerAdapter.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerRequestHandler.h"
#import "SympathyHTTPServerBase.h"
#import "CapeIterator.h"
#import "CapeMap.h"
#import "SympathyHTTPServerComponent.h"
#import "SympathyHTTPServerRequestHandlerMap.h"

@implementation SympathyHTTPServerRequestHandlerMap

{
	NSMutableDictionary* getHandlerFunctions;
	NSMutableDictionary* postHandlerFunctions;
	NSMutableDictionary* putHandlerFunctions;
	NSMutableDictionary* deleteHandlerFunctions;
	NSMutableDictionary* patchHandlerFunctions;
	NSMutableDictionary* childObjects;
}

- (SympathyHTTPServerRequestHandlerMap*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->childObjects = nil;
	self->patchHandlerFunctions = nil;
	self->deleteHandlerFunctions = nil;
	self->putHandlerFunctions = nil;
	self->postHandlerFunctions = nil;
	self->getHandlerFunctions = nil;
	return(self);
}

- (void) initialize:(SympathyHTTPServerBase*)server {
	[super initialize:server];
	id<CapeIterator> it = [CapeMap iterateValues:self->childObjects];
	while(TRUE) {
		id<SympathyHTTPServerRequestHandler> child = ((id<SympathyHTTPServerRequestHandler>)[it next]);
		if(child == nil) {
			break;
		}
		if([((NSObject*)child) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
			[((id<SympathyHTTPServerComponent>)child) initialize:server];
		}
	}
}

- (void) onMaintenance {
	[super onMaintenance];
	id<CapeIterator> it = [CapeMap iterateValues:self->childObjects];
	while(TRUE) {
		id<SympathyHTTPServerRequestHandler> child = ((id<SympathyHTTPServerRequestHandler>)[it next]);
		if(child == nil) {
			break;
		}
		if([((NSObject*)child) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
			[((id<SympathyHTTPServerComponent>)child) onMaintenance];
		}
	}
}

- (void) onRefresh {
	[super onRefresh];
	id<CapeIterator> it = [CapeMap iterateValues:self->childObjects];
	while(TRUE) {
		id<SympathyHTTPServerRequestHandler> child = ((id<SympathyHTTPServerRequestHandler>)[it next]);
		if(child == nil) {
			break;
		}
		if([((NSObject*)child) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
			[((id<SympathyHTTPServerComponent>)child) onRefresh];
		}
	}
}

- (void) cleanup {
	[super cleanup];
	id<CapeIterator> it = [CapeMap iterateValues:self->childObjects];
	while(TRUE) {
		id<SympathyHTTPServerRequestHandler> child = ((id<SympathyHTTPServerRequestHandler>)[it next]);
		if(child == nil) {
			break;
		}
		if([((NSObject*)child) conformsToProtocol:@protocol(SympathyHTTPServerComponent)]) {
			[((id<SympathyHTTPServerComponent>)child) cleanup];
		}
	}
}

- (BOOL) onHTTPMethod:(SympathyHTTPServerRequest*)req functions:(NSMutableDictionary*)functions {
	NSString* rsc = [req peekResource];
	if(({ NSString* _s1 = rsc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		rsc = @"";
	}
	void (^handler)(SympathyHTTPServerRequest*) = nil;
	int rsccount = [req getRemainingResourceCount];
	if(rsccount < 1) {
		handler = [CapeMap getMapAndDynamic:functions key:((id)rsc)];
	}
	else {
		if(rsccount == 1) {
			handler = [CapeMap getMapAndDynamic:functions key:((id)[rsc stringByAppendingString:@"/*"])];
			if(handler == nil) {
				handler = [CapeMap getMapAndDynamic:functions key:((id)[rsc stringByAppendingString:@"/**"])];
			}
		}
		else {
			handler = [CapeMap getMapAndDynamic:functions key:((id)[rsc stringByAppendingString:@"/**"])];
		}
	}
	if(handler != nil) {
		[req popResource];
		handler(req);
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) onGET:(SympathyHTTPServerRequest*)req {
	return([self onHTTPMethod:req functions:self->getHandlerFunctions]);
}

- (BOOL) onPOST:(SympathyHTTPServerRequest*)req {
	return([self onHTTPMethod:req functions:self->postHandlerFunctions]);
}

- (BOOL) onPUT:(SympathyHTTPServerRequest*)req {
	return([self onHTTPMethod:req functions:self->putHandlerFunctions]);
}

- (BOOL) onDELETE:(SympathyHTTPServerRequest*)req {
	return([self onHTTPMethod:req functions:self->deleteHandlerFunctions]);
}

- (BOOL) onPATCH:(SympathyHTTPServerRequest*)req {
	return([self onHTTPMethod:req functions:self->patchHandlerFunctions]);
}

- (BOOL) tryHandleRequest:(SympathyHTTPServerRequest*)req {
	BOOL v = FALSE;
	if(req == nil) {
		;
	}
	else {
		if([req isGET]) {
			v = [self onGET:req];
		}
		else {
			if([req isPOST]) {
				v = [self onPOST:req];
			}
			else {
				if([req isPUT]) {
					v = [self onPUT:req];
				}
				else {
					if([req isDELETE]) {
						v = [self onDELETE:req];
					}
					else {
						if([req isPATCH]) {
							v = [self onPATCH:req];
						}
					}
				}
			}
		}
	}
	return(v);
}

- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if([self tryHandleRequest:req]) {
		return;
	}
	NSString* rsc = [req peekResource];
	if(({ NSString* _s1 = rsc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		rsc = @"";
	}
	id<SympathyHTTPServerRequestHandler> sub = ((id<SympathyHTTPServerRequestHandler>)[CapeMap getMapAndDynamic:self->childObjects key:((id)rsc)]);
	if(sub == nil) {
		sub = ((id<SympathyHTTPServerRequestHandler>)[CapeMap getMapAndDynamic:self->childObjects key:((id)[rsc stringByAppendingString:@"/**"])]);
	}
	if(sub != nil) {
		[req popResource];
		[sub handleRequest:req next:next];
		return;
	}
	next();
	return;
}

- (SympathyHTTPServerRequestHandlerMap*) child:(NSString*)path handler:(id<SympathyHTTPServerRequestHandler>)handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->childObjects == nil) {
			self->childObjects = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->childObjects; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
		if(handler != nil && [((NSObject*)handler) conformsToProtocol:@protocol(SympathyHTTPServerComponent)] && [self isInitialized]) {
			[((id<SympathyHTTPServerComponent>)handler) initialize:[self getServer]];
		}
	}
	return(self);
}

- (SympathyHTTPServerRequestHandlerMap*) get:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->getHandlerFunctions == nil) {
			self->getHandlerFunctions = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->getHandlerFunctions; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

- (SympathyHTTPServerRequestHandlerMap*) post:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->postHandlerFunctions == nil) {
			self->postHandlerFunctions = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->postHandlerFunctions; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

- (SympathyHTTPServerRequestHandlerMap*) put:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->putHandlerFunctions == nil) {
			self->putHandlerFunctions = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->putHandlerFunctions; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

- (SympathyHTTPServerRequestHandlerMap*) _x_delete:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->deleteHandlerFunctions == nil) {
			self->deleteHandlerFunctions = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->deleteHandlerFunctions; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

- (SympathyHTTPServerRequestHandlerMap*) patch:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler {
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->patchHandlerFunctions == nil) {
			self->patchHandlerFunctions = [[NSMutableDictionary alloc] init];
		}
		({ id _v = handler; id _o = self->patchHandlerFunctions; id _k = path; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

@end
