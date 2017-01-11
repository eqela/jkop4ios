
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
#import "SympathyHTTPClient.h"

@class SympathyHTTPClientOperationMyResponseParser;
@class SympathyHTTPClientResponse;
@class SympathyHTTPClientListener;
@protocol SympathyConnectedSocket;
@class SympathyHTTPClientRequest;

@interface SympathyHTTPClientOperation : SympathyHTTPClient
- (SympathyHTTPClientOperation*) init;
- (BOOL) openConnectionWithStringAndStringAndSignedIntegerAndHTTPClientListener:(NSString*)protocol address:(NSString*)address aport:(int)aport listener:(SympathyHTTPClientListener*)listener;
- (BOOL) openConnectionWithHTTPClientRequestAndHTTPClientListener:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener;
- (void) closeConnection:(SympathyHTTPClientListener*)listener;
- (BOOL) sendRequest:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener;
- (BOOL) readResponse:(SympathyHTTPClientListener*)listener timeout:(int)timeout;
- (void) executeRequest:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener;
- (NSString*) getDefaultUserAgent;
- (SympathyHTTPClientOperation*) setDefaultUserAgent:(NSString*)v;
- (BOOL) getAcceptInvalidCertificate;
- (SympathyHTTPClientOperation*) setAcceptInvalidCertificate:(BOOL)v;
@end
