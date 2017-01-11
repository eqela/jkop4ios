
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
#import "CapeFile.h"
#import "CapexMimeTypeRegistry.h"
#import "CapeFileInfo.h"
#import "CapexVerboseDateTimeString.h"
#import "CapeDateTime.h"
#import "CapexMD5Encoder.h"
#import "CapeString.h"
#import "CapeJSONEncoder.h"
#import "CapeKeyValueList.h"
#import "CapeReader.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerCookie.h"
#import "CapeBufferReader.h"
#import "CapeBuffer.h"
#import "CapeSizedReader.h"
#import "SympathyHTTPServerResponse.h"

@implementation SympathyHTTPServerResponse

{
	CapeKeyValueList* headers;
	NSString* message;
	int cacheTtl;
	NSString* status;
	BOOL statusIsOk;
	id<CapeReader> body;
	NSString* eTag;
}

- (SympathyHTTPServerResponse*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->eTag = nil;
	self->body = nil;
	self->statusIsOk = FALSE;
	self->status = nil;
	self->cacheTtl = 0;
	self->message = nil;
	self->headers = nil;
	return(self);
}

+ (SympathyHTTPServerResponse*) forFile:(id<CapeFile>)file maxCachedSize:(int)maxCachedSize {
	if(file == nil || [file isFile] == FALSE) {
		return([SympathyHTTPServerResponse forHTTPNotFound:nil]);
	}
	BOOL bodyset = FALSE;
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:[CapexMimeTypeRegistry typeForFile:file]];
	CapeFileInfo* st = [file stat];
	if(st != nil) {
		int lm = [st getModifyTime];
		if(lm > 0) {
			NSString* dts = [CapexVerboseDateTimeString forDateTime:[CapeDateTime forTimeSeconds:((long long)lm)]];
			[resp addHeader:@"Last-Modified" value:dts];
			[resp setETag:[CapexMD5Encoder encodeString:dts]];
		}
		int mcs = maxCachedSize;
		if(mcs < 0) {
			mcs = 32 * 1024;
		}
		if([st getSize] < mcs) {
			[resp setBodyWithBuffer:[file getContentsBuffer]];
			bodyset = TRUE;
		}
	}
	if(bodyset == FALSE) {
		[resp setBodyWithFile:file];
	}
	return(resp);
}

+ (SympathyHTTPServerResponse*) forBuffer:(NSMutableData*)data mimetype:(NSString*)mimetype {
	NSString* mt = mimetype;
	if([CapeString isEmpty:mt]) {
		mt = @"application/binary";
	}
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:mt];
	[resp setBodyWithBuffer:data];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forString:(NSString*)text mimetype:(NSString*)mimetype {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	if([CapeString isEmpty:mimetype] == FALSE) {
		[resp addHeader:@"Content-Type" value:mimetype];
	}
	[resp setBodyWithString:text];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forTextString:(NSString*)text {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:@"text/plain; charset=\"UTF-8\""];
	[resp setBodyWithString:text];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTMLString:(NSString*)html {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:@"text/html; charset=\"UTF-8\""];
	[resp setBodyWithString:html];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forXMLString:(NSString*)xml {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:@"text/xml; charset=\"UTF-8\""];
	[resp setBodyWithString:xml];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forJSONObject:(id)o {
	return([SympathyHTTPServerResponse forJSONString:[CapeJSONEncoder encode:o niceFormatting:TRUE]]);
}

+ (SympathyHTTPServerResponse*) forJSONString:(NSString*)json {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"200"];
	[resp addHeader:@"Content-Type" value:@"application/json; charset=\"UTF-8\""];
	[resp setBodyWithString:json];
	return(resp);
}

+ (NSString*) stringWithMessage:(NSString*)str message:(NSString*)message {
	if([CapeString isEmpty:message]) {
		return(str);
	}
	return([[str stringByAppendingString:@": "] stringByAppendingString:message]);
}

+ (SympathyHTTPServerResponse*) forHTTPInvalidRequest:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Invalid request" message:message]];
	[resp setStatus:@"400"];
	[resp addHeader:@"Connection" value:@"close"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPInternalError:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Internal server error" message:message]];
	[resp setStatus:@"500"];
	[resp addHeader:@"Connection" value:@"close"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPNotImplemented:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Not implemented" message:message]];
	[resp setStatus:@"501"];
	[resp addHeader:@"Connection" value:@"close"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPNotAllowed:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Not allowed" message:message]];
	[resp setStatus:@"405"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPNotFound:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Not found" message:message]];
	[resp setStatus:@"404"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPForbidden:(NSString*)message {
	SympathyHTTPServerResponse* resp = [SympathyHTTPServerResponse forTextString:[SympathyHTTPServerResponse stringWithMessage:@"Forbidden" message:message]];
	[resp setStatus:@"403"];
	[resp setMessage:message];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forRedirect:(NSString*)url {
	return([SympathyHTTPServerResponse forHTTPMovedTemporarily:url]);
}

+ (SympathyHTTPServerResponse*) forHTTPMovedPermanently:(NSString*)url {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"301"];
	[resp addHeader:@"Location" value:url];
	[resp setBodyWithString:url];
	return(resp);
}

+ (SympathyHTTPServerResponse*) forHTTPMovedTemporarily:(NSString*)url {
	SympathyHTTPServerResponse* resp = [[SympathyHTTPServerResponse alloc] init];
	[resp setStatus:@"303"];
	[resp addHeader:@"Location" value:url];
	[resp setBodyWithString:url];
	return(resp);
}

- (SympathyHTTPServerResponse*) setETag:(NSString*)eTag {
	self->eTag = eTag;
	[self addHeader:@"ETag" value:eTag];
	return(self);
}

- (NSString*) getETag {
	return(self->eTag);
}

- (SympathyHTTPServerResponse*) setStatus:(NSString*)status {
	self->status = status;
	if(({ NSString* _s1 = status; NSString* _s2 = @"200"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->statusIsOk = TRUE;
	}
	return(self);
}

- (NSString*) getStatus {
	return(self->status);
}

- (int) getCacheTtl {
	if(self->statusIsOk) {
		return(self->cacheTtl);
	}
	return(0);
}

- (SympathyHTTPServerResponse*) enableCaching:(int)ttl {
	self->cacheTtl = ttl;
	return(self);
}

- (SympathyHTTPServerResponse*) disableCaching {
	self->cacheTtl = 0;
	return(self);
}

- (SympathyHTTPServerResponse*) enableCORS:(SympathyHTTPServerRequest*)req {
	[self addHeader:@"Access-Control-Allow-Origin" value:@"*"];
	if(req != nil) {
		[self addHeader:@"Access-Control-Allow-Methods" value:[req getHeader:@"access-control-request-method"]];
		[self addHeader:@"Access-Control-Allow-Headers" value:[req getHeader:@"access-control-request-headers"]];
	}
	[self addHeader:@"Access-Control-Max-Age" value:@"1728000"];
	return(self);
}

- (SympathyHTTPServerResponse*) addHeader:(NSString*)key value:(NSString*)value {
	if(self->headers == nil) {
		self->headers = [[CapeKeyValueList alloc] init];
	}
	[self->headers addDynamicAndDynamic:((id)key) val:((id)value)];
	return(self);
}

- (void) addCookie:(SympathyHTTPServerCookie*)cookie {
	if(cookie == nil) {
		return;
	}
	[self addHeader:@"Set-Cookie" value:[cookie toString]];
}

- (SympathyHTTPServerResponse*) setBodyWithBuffer:(NSMutableData*)buf {
	if(buf == nil) {
		self->body = nil;
		[self addHeader:@"Content-Length" value:@"0"];
	}
	else {
		self->body = ((id<CapeReader>)[CapeBufferReader forBuffer:buf]);
		[self addHeader:@"Content-Length" value:[CapeString forInteger:[buf length]]];
	}
	return(self);
}

- (SympathyHTTPServerResponse*) setBodyWithString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->body = nil;
		[self addHeader:@"Content-Length" value:@"0"];
	}
	else {
		NSMutableData* buf = [CapeString toUTF8Buffer:str];
		self->body = ((id<CapeReader>)[CapeBufferReader forBuffer:buf]);
		[self addHeader:@"Content-Length" value:[CapeString forInteger:((int)[CapeBuffer getSize:buf])]];
	}
	return(self);
}

- (SympathyHTTPServerResponse*) setBodyWithFile:(id<CapeFile>)file {
	if(file == nil || [file isFile] == FALSE) {
		self->body = nil;
		[self addHeader:@"Content-Length" value:@"0"];
	}
	else {
		self->body = ((id<CapeReader>)[file read]);
		[self addHeader:@"Content-Length" value:[CapeString forInteger:[file getSize]]];
	}
	return(self);
}

- (SympathyHTTPServerResponse*) setBodyWithSizedReader:(id<CapeSizedReader>)reader {
	if(reader == nil) {
		self->body = nil;
		[self addHeader:@"Content-Length" value:@"0"];
	}
	else {
		self->body = ((id<CapeReader>)reader);
		[self addHeader:@"Content-Length" value:[CapeString forInteger:[reader getSize]]];
	}
	return(self);
}

- (id<CapeReader>) getBody {
	return(self->body);
}

- (CapeKeyValueList*) getHeaders {
	return(self->headers);
}

- (SympathyHTTPServerResponse*) setHeaders:(CapeKeyValueList*)v {
	self->headers = v;
	return(self);
}

- (NSString*) getMessage {
	return(self->message);
}

- (SympathyHTTPServerResponse*) setMessage:(NSString*)v {
	self->message = v;
	return(self);
}

@end
