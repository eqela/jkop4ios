
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
#import "CapeKeyValueListForStrings.h"
#import "CapeKeyValueList.h"
#import "CapeString.h"
#import "CapeMap.h"
#import "SympathyHTTPClientResponse.h"

@implementation SympathyHTTPClientResponse

{
	NSString* httpVersion;
	NSString* httpStatus;
	NSString* httpStatusDescription;
	CapeKeyValueListForStrings* rawHeaders;
	NSMutableDictionary* headers;
}

- (SympathyHTTPClientResponse*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->headers = nil;
	self->rawHeaders = nil;
	self->httpStatusDescription = nil;
	self->httpStatus = nil;
	self->httpVersion = nil;
	return(self);
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

- (NSString*) toString {
	return([CapeString asStringWithObject:((id)self->rawHeaders)]);
}

- (NSString*) getHttpVersion {
	return(self->httpVersion);
}

- (SympathyHTTPClientResponse*) setHttpVersion:(NSString*)v {
	self->httpVersion = v;
	return(self);
}

- (NSString*) getHttpStatus {
	return(self->httpStatus);
}

- (SympathyHTTPClientResponse*) setHttpStatus:(NSString*)v {
	self->httpStatus = v;
	return(self);
}

- (NSString*) getHttpStatusDescription {
	return(self->httpStatusDescription);
}

- (SympathyHTTPClientResponse*) setHttpStatusDescription:(NSString*)v {
	self->httpStatusDescription = v;
	return(self);
}

- (CapeKeyValueListForStrings*) getRawHeaders {
	return(self->rawHeaders);
}

- (SympathyHTTPClientResponse*) setRawHeaders:(CapeKeyValueListForStrings*)v {
	self->rawHeaders = v;
	return(self);
}

- (NSMutableDictionary*) getHeaders {
	return(self->headers);
}

- (SympathyHTTPClientResponse*) setHeaders:(NSMutableDictionary*)v {
	self->headers = v;
	return(self);
}

@end
