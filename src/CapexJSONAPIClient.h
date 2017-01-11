
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

@class CapeDynamicMap;
@class CapeKeyValueList;
@class CapeError;

@interface CapexJSONAPIClient : NSObject
- (CapexJSONAPIClient*) init;
- (NSString*) getFullURL:(NSString*)api;
- (void) customizeRequestHeaders:(CapeKeyValueList*)headers;
- (void) onStartSendRequest;
- (void) onEndSendRequest;
- (void) onDefaultErrorHandler:(CapeError*)error;
- (BOOL) handleAsError:(CapeDynamicMap*)response callback:(void(^)(CapeError*))callback;
- (CapeError*) toError:(CapeDynamicMap*)response;
- (void) onErrorWithErrorAndFunction:(CapeError*)error callback:(void(^)(CapeError*))callback;
- (void) onErrorWithError:(CapeError*)error;
- (void) sendRequest:(NSString*)method url:(NSString*)url headers:(CapeKeyValueList*)headers data:(NSMutableData*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (void) doGet:(NSString*)url callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (void) doPost:(NSString*)url data:(CapeDynamicMap*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (void) doPut:(NSString*)url data:(CapeDynamicMap*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (void) doDelete:(NSString*)url callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (void) uploadFile:(NSString*)url data:(NSMutableData*)data mimeType:(NSString*)mimeType callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback;
- (NSString*) getApiUrl;
- (CapexJSONAPIClient*) setApiUrl:(NSString*)v;
@end
