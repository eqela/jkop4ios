
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
#import "SympathyHTTPServerRequestHandler.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerResponse.h"
#import "SympathyHTTPServerStaticContentHandler.h"

@implementation SympathyHTTPServerStaticContentHandler

{
	NSString* content;
	NSString* mimeType;
	NSString* redirectUrl;
}

- (SympathyHTTPServerStaticContentHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->redirectUrl = nil;
	self->mimeType = nil;
	self->content = nil;
	return(self);
}

+ (SympathyHTTPServerStaticContentHandler*) forContent:(NSString*)content mimeType:(NSString*)mimeType {
	SympathyHTTPServerStaticContentHandler* v = [[SympathyHTTPServerStaticContentHandler alloc] init];
	[v setContent:content];
	[v setMimeType:mimeType];
	return(v);
}

+ (SympathyHTTPServerStaticContentHandler*) forHTMLContent:(NSString*)content {
	SympathyHTTPServerStaticContentHandler* v = [[SympathyHTTPServerStaticContentHandler alloc] init];
	[v setContent:content];
	[v setMimeType:@"text/html"];
	return(v);
}

+ (SympathyHTTPServerStaticContentHandler*) forJSONContent:(NSString*)content {
	SympathyHTTPServerStaticContentHandler* v = [[SympathyHTTPServerStaticContentHandler alloc] init];
	[v setContent:content];
	[v setMimeType:@"application/json"];
	return(v);
}

+ (SympathyHTTPServerStaticContentHandler*) forRedirect:(NSString*)url {
	SympathyHTTPServerStaticContentHandler* v = [[SympathyHTTPServerStaticContentHandler alloc] init];
	[v setRedirectUrl:url];
	return(v);
}

- (void) handleRequest:(SympathyHTTPServerRequest*)req next:(void(^)(void))next {
	if(!(({ NSString* _s1 = self->redirectUrl; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[req sendResponse:[SympathyHTTPServerResponse forRedirect:self->redirectUrl]];
	}
	else {
		[req sendResponse:[SympathyHTTPServerResponse forString:self->content mimetype:self->mimeType]];
	}
}

- (NSString*) getContent {
	return(self->content);
}

- (SympathyHTTPServerStaticContentHandler*) setContent:(NSString*)v {
	self->content = v;
	return(self);
}

- (NSString*) getMimeType {
	return(self->mimeType);
}

- (SympathyHTTPServerStaticContentHandler*) setMimeType:(NSString*)v {
	self->mimeType = v;
	return(self);
}

- (NSString*) getRedirectUrl {
	return(self->redirectUrl);
}

- (SympathyHTTPServerStaticContentHandler*) setRedirectUrl:(NSString*)v {
	self->redirectUrl = v;
	return(self);
}

@end
