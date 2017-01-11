
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

@class SympathyHTTPServerRequest;
@protocol SympathyHTTPServerRequestHandler;
@class SympathyHTTPServerBase;

@interface SympathyHTTPServerRequestHandlerMap : SympathyHTTPServerRequestHandlerAdapter
- (SympathyHTTPServerRequestHandlerMap*) init;
- (void) initialize:(SympathyHTTPServerBase*)server;
- (void) onMaintenance;
- (void) onRefresh;
- (void) cleanup;
- (BOOL) onHTTPMethod:(SympathyHTTPServerRequest*)req functions:(NSMutableDictionary*)functions;
- (BOOL) onGET:(SympathyHTTPServerRequest*)req;
- (BOOL) onPOST:(SympathyHTTPServerRequest*)req;
- (BOOL) onPUT:(SympathyHTTPServerRequest*)req;
- (BOOL) onDELETE:(SympathyHTTPServerRequest*)req;
- (BOOL) onPATCH:(SympathyHTTPServerRequest*)req;
- (BOOL) tryHandleRequest:(SympathyHTTPServerRequest*)req;
- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next;
- (SympathyHTTPServerRequestHandlerMap*) child:(NSString*)path handler:(id<SympathyHTTPServerRequestHandler>)handler;
- (SympathyHTTPServerRequestHandlerMap*) get:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler;
- (SympathyHTTPServerRequestHandlerMap*) post:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler;
- (SympathyHTTPServerRequestHandlerMap*) put:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler;
- (SympathyHTTPServerRequestHandlerMap*) _x_delete:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler;
- (SympathyHTTPServerRequestHandlerMap*) patch:(NSString*)path handler:(void(^)(SympathyHTTPServerRequest*))handler;
@end
