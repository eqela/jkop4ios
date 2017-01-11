
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
#import "CapeString.h"
#import "CapeDynamicMap.h"
#import "CapeJSONEncoder.h"
#import "CapeKeyValueList.h"
#import "CapeError.h"
#import "CapexWebClient.h"
#import "CapexNativeWebClient.h"
#import "CapeJSONParser.h"
#import "CapexJSONAPIClient.h"

@implementation CapexJSONAPIClient

{
	NSString* apiUrl;
}

- (CapexJSONAPIClient*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->apiUrl = nil;
	return(self);
}

- (NSString*) getFullURL:(NSString*)api {
	NSString* url = self->apiUrl;
	if([CapeString isEmpty:url]) {
		url = @"/";
	}
	if(({ NSString* _s1 = url; NSString* _s2 = @"/"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		if([CapeString startsWith:api str2:@"/" offset:0]) {
			return(api);
		}
		return([url stringByAppendingString:api]);
	}
	if([CapeString endsWith:url str2:@"/"]) {
		if([CapeString startsWith:api str2:@"/" offset:0]) {
			return([url stringByAppendingString:([CapeString getSubStringWithStringAndSignedInteger:api start:1])]);
		}
		return([url stringByAppendingString:api]);
	}
	if([CapeString startsWith:api str2:@"/" offset:0]) {
		return([url stringByAppendingString:api]);
	}
	return([[url stringByAppendingString:@"/"] stringByAppendingString:api]);
}

- (NSMutableData*) toUTF8Buffer:(CapeDynamicMap*)data {
	if(data == nil) {
		return(nil);
	}
	return([CapeString toUTF8Buffer:[CapeJSONEncoder encode:((id)data) niceFormatting:TRUE]]);
}

- (void) customizeRequestHeaders:(CapeKeyValueList*)headers {
}

- (void) onStartSendRequest {
}

- (void) onEndSendRequest {
}

- (void) onDefaultErrorHandler:(CapeError*)error {
}

- (BOOL) handleAsError:(CapeDynamicMap*)response callback:(void(^)(CapeError*))callback {
	CapeError* error = [self toError:response];
	if(error != nil) {
		[self onErrorWithErrorAndFunction:error callback:callback];
	}
	return(FALSE);
}

- (CapeError*) toError:(CapeDynamicMap*)response {
	if(response == nil) {
		return([CapeError forCode:@"noServerResponse" detail:nil]);
	}
	if(({ NSString* _s1 = [response getString:@"status" defval:nil]; NSString* _s2 = @"error"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		CapeError* v = [[CapeError alloc] init];
		[v setCode:[response getString:@"code" defval:nil]];
		[v setMessage:[response getString:@"message" defval:nil]];
		[v setDetail:[response getString:@"detail" defval:nil]];
		return(v);
	}
	return(nil);
}

- (void) onErrorWithErrorAndFunction:(CapeError*)error callback:(void(^)(CapeError*))callback {
	if(callback != nil) {
		callback(error);
	}
	else {
		[self onDefaultErrorHandler:error];
	}
}

- (void) onErrorWithError:(CapeError*)error {
	[self onErrorWithErrorAndFunction:error callback:nil];
}

- (void) sendRequest:(NSString*)method url:(NSString*)url headers:(CapeKeyValueList*)headers data:(NSMutableData*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	if(callback == nil) {
		return;
	}
	CapeKeyValueList* hrs = headers;
	if(headers == nil) {
		hrs = [[CapeKeyValueList alloc] init];
		[hrs addDynamicAndDynamic:((id)@"Content-Type") val:((id)@"application/json")];
	}
	id<CapexWebClient> webClient = [CapexNativeWebClient instance];
	if(webClient == nil) {
		[self onErrorWithErrorAndFunction:[CapeError forCode:@"noWebClient" detail:nil] callback:errorCallback];
		return;
	}
	void (^ll)(CapeDynamicMap*) = callback;
	[self customizeRequestHeaders:hrs];
	[self onStartSendRequest];
	void (^ecb)(CapeError*) = errorCallback;
	[webClient query:method url:url headers:hrs body:data callback:^void(NSString* status, CapeKeyValueList* responseHeaders, NSMutableData* data) {
		[self onEndSendRequest];
		if(data == nil) {
			[self onErrorWithErrorAndFunction:[CapeError forCode:@"failedToConnect" detail:nil] callback:ecb];
			return;
		}
		CapeDynamicMap* jsonResponseBody = ((CapeDynamicMap*)({ id _v = [CapeJSONParser parseString:[CapeString forUTF8Buffer:data]]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
		if(jsonResponseBody == nil) {
			[self onErrorWithErrorAndFunction:[CapeError forCode:@"invalidServerResponse" detail:nil] callback:ecb];
			return;
		}
		ll(jsonResponseBody);
	}];
}

- (void) doGet:(NSString*)url callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	[self sendRequest:@"GET" url:[self getFullURL:url] headers:nil data:nil callback:callback errorCallback:errorCallback];
}

- (void) doPost:(NSString*)url data:(CapeDynamicMap*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	[self sendRequest:@"POST" url:[self getFullURL:url] headers:nil data:[self toUTF8Buffer:data] callback:callback errorCallback:errorCallback];
}

- (void) doPut:(NSString*)url data:(CapeDynamicMap*)data callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	[self sendRequest:@"PUT" url:[self getFullURL:url] headers:nil data:[self toUTF8Buffer:data] callback:callback errorCallback:errorCallback];
}

- (void) doDelete:(NSString*)url callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	[self sendRequest:@"DELETE" url:[self getFullURL:url] headers:nil data:nil callback:callback errorCallback:errorCallback];
}

- (void) uploadFile:(NSString*)url data:(NSMutableData*)data mimeType:(NSString*)mimeType callback:(void(^)(CapeDynamicMap*))callback errorCallback:(void(^)(CapeError*))errorCallback {
	NSString* mt = mimeType;
	if([CapeString isEmpty:mt]) {
		mt = @"application/octet-stream";
	}
	CapeKeyValueList* hdrs = [[CapeKeyValueList alloc] init];
	[hdrs addDynamicAndDynamic:((id)@"content-type") val:((id)mt)];
	[self sendRequest:@"POST" url:[self getFullURL:url] headers:hdrs data:data callback:callback errorCallback:errorCallback];
}

- (NSString*) getApiUrl {
	return(self->apiUrl);
}

- (CapexJSONAPIClient*) setApiUrl:(NSString*)v {
	self->apiUrl = v;
	return(self);
}

@end
