
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
#import "SympathyNetworkConnection.h"

@class SympathyHTTPServerConnectionParserState;
@class CapeKeyValueList;
@class CapeStringBuilder;
@protocol SympathyDataStream;
@class SympathyHTTPServerRequest;
@protocol CapeReader;
@class SympathyHTTPServerResponse;
@class CapeQueue;
@class SympathyHTTPServerBase;

@interface SympathyHTTPServerConnection : SympathyNetworkConnection
- (SympathyHTTPServerConnection*) init;
- (BOOL) getIsWaitingForBodyReceiver;
- (SympathyHTTPServerBase*) getHTTPServer;
- (int) getWriteBufferSize;
- (int) getSmallBodyLimit;
- (void) resetParser;
- (BOOL) initialize;
- (void) updateListeningMode;
- (void) setBodyReceiver:(id<SympathyDataStream>)stream;
- (BOOL) isExpectingBody;
- (void) onData:(NSMutableData*)buffer offset:(int)offset asz:(int)asz;
- (void) onOpened;
- (void) onClosed;
- (void) onError:(NSString*)message;
- (void) onDataReceived:(NSMutableData*)data size:(int)size;
- (void) onWriteReady;
- (void) onCompleteRequest:(SympathyHTTPServerRequest*)req;
- (void) sendErrorResponse:(SympathyHTTPServerResponse*)response;
+ (NSString*) getFullStatus:(NSString*)status;
+ (NSString*) getStatusCode:(NSString*)status;
- (void) sendResponse:(SympathyHTTPServerRequest*)req aresp:(SympathyHTTPServerResponse*)aresp;
- (int) getRequests;
- (SympathyHTTPServerConnection*) setRequests:(int)v;
- (int) getResponses;
- (SympathyHTTPServerConnection*) setResponses:(int)v;
@end
