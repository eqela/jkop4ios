
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
#import "CapeStringObject.h"
#import "CapeSizedReader.h"
#import "CapeString.h"
#import "CapeBufferReader.h"
#import "CapeKeyValueList.h"
#import "CapeKeyValueListForStrings.h"
#import "SympathyURL.h"
#import "CapeMap.h"
#import "CapeStringBuilder.h"
#import "CapeIterator.h"
#import "CapeKeyValuePair.h"
#import "CapexURLEncoder.h"
#import "SympathyHTTPClientRequest.h"

@implementation SympathyHTTPClientRequest

{
	NSString* method;
	NSString* protocol;
	NSString* username;
	NSString* password;
	NSString* serverAddress;
	int serverPort;
	NSString* requestPath;
	id<CapeSizedReader> body;
	CapeKeyValueList* queryParams;
	CapeKeyValueListForStrings* rawHeaders;
	NSMutableDictionary* headers;
}

+ (SympathyHTTPClientRequest*) forGET:(NSString*)url {
	SympathyHTTPClientRequest* v = [[SympathyHTTPClientRequest alloc] init];
	[v setMethod:@"GET"];
	[v setUrl:url];
	return(v);
}

+ (SympathyHTTPClientRequest*) forPOSTWithStringAndStringAndSizedReader:(NSString*)url mimeType:(NSString*)mimeType data:(id<CapeSizedReader>)data {
	SympathyHTTPClientRequest* v = [[SympathyHTTPClientRequest alloc] init];
	[v setMethod:@"POST"];
	[v setUrl:url];
	if([CapeString isEmpty:mimeType] == FALSE) {
		[v addHeader:@"Content-Type" value:mimeType];
	}
	if(data != nil) {
		[v setBody:data];
	}
	return(v);
}

+ (SympathyHTTPClientRequest*) forPOSTWithStringAndStringAndBuffer:(NSString*)url mimeType:(NSString*)mimeType data:(NSMutableData*)data {
	SympathyHTTPClientRequest* v = [[SympathyHTTPClientRequest alloc] init];
	[v setMethod:@"POST"];
	[v setUrl:url];
	if([CapeString isEmpty:mimeType] == FALSE) {
		[v addHeader:@"Content-Type" value:mimeType];
	}
	if(data != nil) {
		[v setBody:((id<CapeSizedReader>)[CapeBufferReader forBuffer:data])];
	}
	return(v);
}

- (SympathyHTTPClientRequest*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->headers = nil;
	self->rawHeaders = nil;
	self->queryParams = nil;
	self->body = nil;
	self->requestPath = nil;
	self->serverPort = 0;
	self->serverAddress = nil;
	self->password = nil;
	self->username = nil;
	self->protocol = nil;
	self->method = nil;
	self->protocol = @"http";
	self->serverPort = 80;
	self->requestPath = @"/";
	self->method = @"GET";
	return(self);
}

- (void) setUrl:(NSString*)url {
	SympathyURL* uu = [SympathyURL forString:url normalizePath:FALSE];
	[self setProtocol:[uu getScheme]];
	[self setUsername:[uu getUsername]];
	[self setPassword:[uu getPassword]];
	[self setServerAddress:[uu getHost]];
	int pp = [CapeString toInteger:[uu getPort]];
	if(pp < 1) {
		if(({ NSString* _s1 = self->protocol; NSString* _s2 = @"https"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			pp = 443;
		}
		else {
			if(({ NSString* _s1 = self->protocol; NSString* _s2 = @"http"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				pp = 80;
			}
		}
	}
	[self setServerPort:pp];
	[self setRequestPath:[uu getPath]];
	self->queryParams = [uu getRawQueryParameters];
}

- (void) addHeader:(NSString*)key value:(NSString*)value {
	if(self->rawHeaders == nil) {
		self->rawHeaders = [[CapeKeyValueListForStrings alloc] init];
	}
	if(self->headers == nil) {
		self->headers = [[NSMutableDictionary alloc] init];
	}
	[self->rawHeaders addDynamicAndDynamic:((id)key) val:((id)value)];
	({ id _v = value; id _o = self->headers; id _k = [CapeString toLowerCase:key]; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
}

- (NSString*) getHeader:(NSString*)key {
	if(self->headers == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:self->headers key:((id)key)]);
}

- (void) setUserAgent:(NSString*)agent {
	[self addHeader:@"User-Agent" value:agent];
}

- (NSString*) toStringWithString:(NSString*)defaultUserAgent {
	CapeStringBuilder* rq = [[CapeStringBuilder alloc] init];
	id<CapeSizedReader> body = [self getBody];
	NSString* path = [self getRequestPath];
	if([CapeString isEmpty:path]) {
		path = @"/";
	}
	[rq appendString:[self getMethod]];
	[rq appendCharacter:' '];
	[rq appendString:path];
	BOOL first = TRUE;
	if(self->queryParams != nil) {
		id<CapeIterator> it = [self->queryParams iterate];
		while(it != nil) {
			CapeKeyValuePair* kv = ((CapeKeyValuePair*)[it next]);
			if(kv == nil) {
				break;
			}
			if(first) {
				[rq appendCharacter:'?'];
				first = FALSE;
			}
			else {
				[rq appendCharacter:'&'];
			}
			[rq appendString:kv->key];
			NSString* val = kv->value;
			if(!(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				[rq appendCharacter:'='];
				[rq appendString:[CapexURLEncoder encode:val percentOnly:FALSE encodeUnreservedChars:FALSE]];
			}
		}
	}
	[rq appendCharacter:' '];
	[rq appendString:@"HTTP/1.1\r\n"];
	BOOL hasUserAgent = FALSE;
	BOOL hasHost = FALSE;
	BOOL hasContentLength = FALSE;
	if(self->rawHeaders != nil) {
		id<CapeIterator> it = [((CapeKeyValueList*)self->rawHeaders) iterate];
		while(TRUE) {
			CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
			if(kvp == nil) {
				break;
			}
			NSString* key = kvp->key;
			if([CapeString equalsIgnoreCase:key str2:@"user-agent"]) {
				hasUserAgent = TRUE;
			}
			else {
				if([CapeString equalsIgnoreCase:key str2:@"host"]) {
					hasHost = TRUE;
				}
				else {
					if([CapeString equalsIgnoreCase:key str2:@"content-length"]) {
						hasContentLength = TRUE;
					}
				}
			}
			[rq appendString:key];
			[rq appendString:@": "];
			[rq appendString:kvp->value];
			[rq appendString:@"\r\n"];
		}
	}
	if(hasUserAgent == FALSE && !(({ NSString* _s1 = defaultUserAgent; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[rq appendString:@"User-Agent: "];
		[rq appendString:defaultUserAgent];
		[rq appendString:@"\r\n"];
	}
	if(hasHost == FALSE) {
		[rq appendString:[[@"Host: " stringByAppendingString:([self getServerAddress])] stringByAppendingString:@"\r\n"]];
	}
	if(body != nil && hasContentLength == FALSE) {
		int bs = [body getSize];
		NSString* bss = [CapeString forInteger:bs];
		[rq appendString:[[@"Content-Length: " stringByAppendingString:bss] stringByAppendingString:@"\r\n"]];
	}
	[rq appendString:@"\r\n"];
	return([rq toString]);
}

- (NSString*) toString {
	return([self toStringWithString:nil]);
}

- (NSString*) getMethod {
	return(self->method);
}

- (SympathyHTTPClientRequest*) setMethod:(NSString*)v {
	self->method = v;
	return(self);
}

- (NSString*) getProtocol {
	return(self->protocol);
}

- (SympathyHTTPClientRequest*) setProtocol:(NSString*)v {
	self->protocol = v;
	return(self);
}

- (NSString*) getUsername {
	return(self->username);
}

- (SympathyHTTPClientRequest*) setUsername:(NSString*)v {
	self->username = v;
	return(self);
}

- (NSString*) getPassword {
	return(self->password);
}

- (SympathyHTTPClientRequest*) setPassword:(NSString*)v {
	self->password = v;
	return(self);
}

- (NSString*) getServerAddress {
	return(self->serverAddress);
}

- (SympathyHTTPClientRequest*) setServerAddress:(NSString*)v {
	self->serverAddress = v;
	return(self);
}

- (int) getServerPort {
	return(self->serverPort);
}

- (SympathyHTTPClientRequest*) setServerPort:(int)v {
	self->serverPort = v;
	return(self);
}

- (NSString*) getRequestPath {
	return(self->requestPath);
}

- (SympathyHTTPClientRequest*) setRequestPath:(NSString*)v {
	self->requestPath = v;
	return(self);
}

- (id<CapeSizedReader>) getBody {
	return(self->body);
}

- (SympathyHTTPClientRequest*) setBody:(id<CapeSizedReader>)v {
	self->body = v;
	return(self);
}

- (CapeKeyValueListForStrings*) getRawHeaders {
	return(self->rawHeaders);
}

- (SympathyHTTPClientRequest*) setRawHeaders:(CapeKeyValueListForStrings*)v {
	self->rawHeaders = v;
	return(self);
}

- (NSMutableDictionary*) getHeaders {
	return(self->headers);
}

- (SympathyHTTPClientRequest*) setHeaders:(NSMutableDictionary*)v {
	self->headers = v;
	return(self);
}

@end
