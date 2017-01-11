
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
#import "SympathyNetworkServer.h"

@class SympathyContentCache;
@protocol SympathyIOManagerTimer;
@class SympathyNetworkConnection;
@class SympathyHTTPServerRequest;
@class SympathyHTTPServerResponse;
@class SympathyHTTPServerConnection;

@interface SympathyHTTPServerBase : SympathyNetworkServer
- (SympathyHTTPServerBase*) init;
- (SympathyNetworkConnection*) createConnectionObject;
- (void) onRefresh;
- (BOOL) onTimeoutTimer;
- (BOOL) onMaintenanceTimer;
- (void) onMaintenance;
- (id<SympathyIOManagerTimer>) startTimer:(long long)delay handler:(BOOL(^)(void))handler;
- (BOOL) initialize;
- (void) cleanup;
- (SympathyHTTPServerResponse*) createOptionsResponse:(SympathyHTTPServerRequest*)req;
- (void) onRequest:(SympathyHTTPServerRequest*)req;
- (void) handleIncomingRequest:(SympathyHTTPServerRequest*)req;
- (void) sendResponse:(SympathyHTTPServerConnection*)connection req:(SympathyHTTPServerRequest*)req resp:(SympathyHTTPServerResponse*)resp;
- (void) onRequestComplete:(SympathyHTTPServerRequest*)request resp:(SympathyHTTPServerResponse*)resp bytesSent:(int)bytesSent remoteAddress:(NSString*)remoteAddress;
- (int) getWriteBufferSize;
- (SympathyHTTPServerBase*) setWriteBufferSize:(int)v;
- (int) getSmallBodyLimit;
- (SympathyHTTPServerBase*) setSmallBodyLimit:(int)v;
- (int) getTimeoutDelay;
- (SympathyHTTPServerBase*) setTimeoutDelay:(int)v;
- (int) getMaintenanceTimerDelay;
- (SympathyHTTPServerBase*) setMaintenanceTimerDelay:(int)v;
- (NSString*) getServerName;
- (SympathyHTTPServerBase*) setServerName:(NSString*)v;
- (BOOL) getEnableCaching;
- (SympathyHTTPServerBase*) setEnableCaching:(BOOL)v;
- (BOOL) getAllowCORS;
- (SympathyHTTPServerBase*) setAllowCORS:(BOOL)v;
@end
