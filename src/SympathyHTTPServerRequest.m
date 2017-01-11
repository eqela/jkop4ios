
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
#import "CapeKeyValueList.h"
#import "SympathyURL.h"
#import "SympathyHTTPServerConnection.h"
#import "SympathyHTTPServerBase.h"
#import "SympathyHTTPServerCookie.h"
#import "SympathyDataStream.h"
#import "CapeString.h"
#import "CapeIterator.h"
#import "CapeKeyValuePair.h"
#import "CapeMap.h"
#import "SympathyNetworkConnection.h"
#import "CapeJSONParser.h"
#import "CapeDynamicVector.h"
#import "CapeDynamicMap.h"
#import "CapexQueryString.h"
#import "CapeVector.h"
#import "CapeStringBuilder.h"
#import "SympathyHTTPServerResponse.h"
#import "CapeJSONEncoder.h"
#import "CapeError.h"
#import "SympathyJSONResponse.h"
#import "CapeFile.h"
#import "SympathyHTTPServerRequest.h"

@implementation SympathyHTTPServerRequest

{
	NSString* method;
	NSString* urlString;
	NSString* version;
	CapeKeyValueList* rawHeaders;
	NSMutableDictionary* headers;
	SympathyURL* url;
	NSString* cacheId;
	SympathyHTTPServerConnection* connection;
	SympathyHTTPServerBase* server;
	id data;
	id session;
	NSMutableDictionary* cookies;
	NSMutableData* bodyBuffer;
	NSString* bodyString;
	NSMutableDictionary* postParameters;
	NSMutableArray* resources;
	int currentResource;
	NSString* relativeResourcePath;
	BOOL responseSent;
	NSMutableArray* responseCookies;
}

- (SympathyHTTPServerRequest*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->responseCookies = nil;
	self->responseSent = FALSE;
	self->relativeResourcePath = nil;
	self->currentResource = 0;
	self->resources = nil;
	self->postParameters = nil;
	self->bodyString = nil;
	self->bodyBuffer = nil;
	self->cookies = nil;
	self->session = nil;
	self->data = nil;
	self->server = nil;
	self->connection = nil;
	self->cacheId = nil;
	self->url = nil;
	self->headers = nil;
	self->rawHeaders = nil;
	self->version = nil;
	self->urlString = nil;
	self->method = nil;
	return(self);
}

+ (SympathyHTTPServerRequest*) forDetails:(NSString*)method url:(NSString*)url version:(NSString*)version headers:(CapeKeyValueList*)headers {
	SympathyHTTPServerRequest* v = [[SympathyHTTPServerRequest alloc] init];
	v->method = method;
	v->urlString = url;
	v->version = version;
	[v setHeaders:headers];
	return(v);
}

- (void) setBodyReceiver:(id<SympathyDataStream>)receiver {
	if(receiver == nil) {
		return;
	}
	if(self->bodyBuffer != nil) {
		int sz = [self->bodyBuffer length];
		if([receiver onDataStreamStart:((long long)sz)] == FALSE) {
			return;
		}
		if([receiver onDataStreamContent:self->bodyBuffer size:sz] == FALSE) {
			return;
		}
		[receiver onDataStreamEnd];
		return;
	}
	if(self->connection == nil) {
		return;
	}
	[self->connection setBodyReceiver:receiver];
}

- (NSString*) getCacheId {
	if(({ NSString* _s1 = self->cacheId; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		if(({ NSString* _s1 = self->method; NSString* _s2 = @"GET"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			self->cacheId = [[self->method stringByAppendingString:@" "] stringByAppendingString:self->urlString];
		}
	}
	return(self->cacheId);
}

- (void) clearHeaders {
	self->rawHeaders = nil;
	self->headers = nil;
}

- (void) addHeader:(NSString*)key value:(NSString*)value {
	if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	if(self->rawHeaders == nil) {
		self->rawHeaders = [[CapeKeyValueList alloc] init];
	}
	if(self->headers == nil) {
		self->headers = [[NSMutableDictionary alloc] init];
	}
	[self->rawHeaders addDynamicAndDynamic:((id)key) val:((id)value)];
	({ id _v = value; id _o = self->headers; id _k = [CapeString toLowerCase:key]; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
}

- (void) setHeaders:(CapeKeyValueList*)headers {
	[self clearHeaders];
	if(headers == nil) {
		return;
	}
	id<CapeIterator> it = [headers iterate];
	if(it == nil) {
		return;
	}
	while(TRUE) {
		CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
		if(kvp == nil) {
			break;
		}
		[self addHeader:kvp->key value:kvp->value];
	}
}

- (NSString*) getHeader:(NSString*)name {
	if([CapeString isEmpty:name]) {
		return(nil);
	}
	if(self->headers == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:self->headers key:((id)name)]);
}

- (id<CapeIterator>) iterateHeaders {
	if(self->rawHeaders == nil) {
		return(nil);
	}
	return([self->rawHeaders iterate]);
}

- (SympathyURL*) getURL {
	if(self->url == nil) {
		self->url = [SympathyURL forString:self->urlString normalizePath:TRUE];
	}
	return(self->url);
}

- (NSMutableDictionary*) getQueryParameters {
	SympathyURL* url = [self getURL];
	if(url == nil) {
		return(nil);
	}
	return([url getQueryParameters]);
}

- (id<CapeIterator>) iterateQueryParameters {
	SympathyURL* url = [self getURL];
	if(url == nil) {
		return(nil);
	}
	CapeKeyValueList* list = [url getRawQueryParameters];
	if(list == nil) {
		return(nil);
	}
	return([list iterate]);
}

- (NSString*) getQueryParameter:(NSString*)key {
	SympathyURL* url = [self getURL];
	if(url == nil) {
		return(nil);
	}
	return([url getQueryParameter:key]);
}

- (NSString*) getURLPath {
	SympathyURL* url = [self getURL];
	if(url == nil) {
		return(nil);
	}
	return([url getPath]);
}

- (NSString*) getRemoteIPAddress {
	NSString* rr = [self getRemoteAddress];
	if(({ NSString* _s1 = rr; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int colon = [CapeString indexOfWithStringAndCharacterAndSignedInteger:rr c:':' start:0];
	if(colon < 0) {
		return(rr);
	}
	return([CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:rr start:0 length:colon]);
}

- (NSString*) getRemoteAddress {
	if(self->connection == nil) {
		return(nil);
	}
	return([self->connection getRemoteAddress]);
}

- (BOOL) getConnectionClose {
	NSString* hdr = [self getHeader:@"connection"];
	if(({ NSString* _s1 = hdr; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(({ NSString* _s1 = hdr; NSString* _s2 = @"close"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	return(FALSE);
}

- (NSString*) getETag {
	return([self getHeader:@"if-none-match"]);
}

- (NSMutableDictionary*) getCookieValues {
	if(self->cookies == nil) {
		NSMutableDictionary* v = [[NSMutableDictionary alloc] init];
		NSString* cvals = [self getHeader:@"cookie"];
		if(!(({ NSString* _s1 = cvals; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			NSMutableArray* sp = [CapeString split:cvals delim:';' max:0];
			if(sp != nil) {
				int n = 0;
				int m = [sp count];
				for(n = 0 ; n < m ; n++) {
					NSString* ck = ((NSString*)[sp objectAtIndex:n]);
					if(ck != nil) {
						ck = [CapeString strip:ck];
						if([CapeString isEmpty:ck]) {
							continue;
						}
						int e = [CapeString indexOfWithStringAndCharacterAndSignedInteger:ck c:'=' start:0];
						if(e < 0) {
							[CapeMap set:v key:((id)ck) val:((id)@"")];
						}
						else {
							[CapeMap set:v key:((id)[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:ck start:0 length:e]) val:((id)[CapeString getSubStringWithStringAndSignedInteger:ck start:e + 1])];
						}
					}
				}
			}
		}
		self->cookies = v;
	}
	return(self->cookies);
}

- (NSString*) getCookieValue:(NSString*)name {
	NSMutableDictionary* c = [self getCookieValues];
	if(c == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:c key:((id)name)]);
}

- (NSString*) getBodyString {
	if(({ NSString* _s1 = self->bodyString; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSMutableData* buffer = [self getBodyBuffer];
		if(buffer != nil) {
			self->bodyString = [CapeString forUTF8Buffer:buffer];
		}
		self->bodyBuffer = nil;
	}
	return(self->bodyString);
}

- (id) getBodyJSONObject {
	return([CapeJSONParser parseString:[self getBodyString]]);
}

- (CapeDynamicVector*) getBodyJSONVector {
	return(((CapeDynamicVector*)({ id _v = [self getBodyJSONObject]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; })));
}

- (CapeDynamicMap*) getBodyJSONMap {
	return(((CapeDynamicMap*)({ id _v = [self getBodyJSONObject]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; })));
}

- (NSString*) getBodyJSONMapValue:(NSString*)key {
	CapeDynamicMap* map = [self getBodyJSONMap];
	if(map == nil) {
		return(nil);
	}
	return([map getString:key defval:nil]);
}

- (NSMutableDictionary*) getPostParameters {
	if(self->postParameters == nil) {
		NSString* bs = [self getBodyString];
		if([CapeString isEmpty:bs]) {
			return(nil);
		}
		self->postParameters = [CapexQueryString parse:bs];
	}
	return(self->postParameters);
}

- (NSString*) getPostParameter:(NSString*)key {
	NSMutableDictionary* pps = [self getPostParameters];
	if(pps == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:pps key:((id)key)]);
}

- (NSString*) getRelativeRequestPath:(NSString*)relativeTo {
	NSString* path = [self getURLPath];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	if(!(({ NSString* _s1 = relativeTo; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString startsWith:path str2:relativeTo offset:0]) {
		path = [CapeString getSubStringWithStringAndSignedInteger:path start:[CapeString getLength:relativeTo]];
	}
	else {
		return(nil);
	}
	if([CapeString isEmpty:path]) {
		path = @"/";
	}
	return(path);
}

- (void) initResources {
	NSString* path = [self getURLPath];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	self->resources = [CapeString split:path delim:'/' max:0];
	[CapeVector removeFirst:self->resources];
	int vsz = [CapeVector getSize:self->resources];
	if(vsz > 0) {
		NSString* last = [CapeVector get:self->resources index:vsz - 1];
		if([CapeString isEmpty:last]) {
			[CapeVector removeLast:self->resources];
		}
	}
	self->currentResource = 0;
}

- (BOOL) hasMoreResources {
	if(self->resources == nil) {
		[self initResources];
	}
	if(self->resources == nil) {
		return(FALSE);
	}
	if(self->currentResource < [CapeVector getSize:self->resources]) {
		return(TRUE);
	}
	return(FALSE);
}

- (int) getRemainingResourceCount {
	if(self->resources == nil) {
		[self initResources];
	}
	if(self->resources == nil) {
		return(0);
	}
	return([CapeVector getSize:self->resources] - self->currentResource - 1);
}

- (BOOL) acceptMethodAndResource:(NSString*)methodToAccept resource:(NSString*)resource mustBeLastResource:(BOOL)mustBeLastResource {
	if(({ NSString* _s1 = resource; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(({ NSString* _s1 = methodToAccept; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = self->method; NSString* _s2 = methodToAccept; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSString* cc = [self peekResource];
		if(({ NSString* _s1 = cc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			return(FALSE);
		}
		if(!(({ NSString* _s1 = cc; NSString* _s2 = resource; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			return(FALSE);
		}
		[self popResource];
		if(mustBeLastResource && [self hasMoreResources]) {
			[self unpopResource];
			return(FALSE);
		}
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) acceptResource:(NSString*)resource mustBeLastResource:(BOOL)mustBeLastResource {
	if(({ NSString* _s1 = resource; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	NSString* cc = [self peekResource];
	if(({ NSString* _s1 = cc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(!(({ NSString* _s1 = cc; NSString* _s2 = resource; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(FALSE);
	}
	[self popResource];
	if(mustBeLastResource && [self hasMoreResources]) {
		[self unpopResource];
		return(FALSE);
	}
	return(TRUE);
}

- (NSString*) peekResource {
	if(self->resources == nil) {
		[self initResources];
	}
	if(self->resources == nil) {
		return(nil);
	}
	if(self->currentResource < [CapeVector getSize:self->resources]) {
		return(((NSString*)[self->resources objectAtIndex:self->currentResource]));
	}
	return(nil);
}

- (int) getCurrentResource {
	return(self->currentResource);
}

- (void) setCurrentResource:(int)value {
	self->currentResource = value;
	self->relativeResourcePath = nil;
}

- (NSString*) popResource {
	if(self->resources == nil) {
		[self initResources];
	}
	NSString* v = [self peekResource];
	if(!(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		self->currentResource++;
		self->relativeResourcePath = nil;
	}
	return(v);
}

- (void) unpopResource {
	if(self->currentResource > 0) {
		self->currentResource--;
		self->relativeResourcePath = nil;
	}
}

- (void) resetResources {
	self->resources = nil;
	self->currentResource = 0;
	self->relativeResourcePath = nil;
}

- (NSMutableArray*) getRelativeResources {
	if(self->resources == nil) {
		[self initResources];
	}
	if(self->resources == nil) {
		return(nil);
	}
	if(self->currentResource < 1) {
		return(self->resources);
	}
	NSMutableArray* v = [[NSMutableArray alloc] init];
	int cr = self->currentResource;
	while(cr < [CapeVector getSize:self->resources]) {
		[v addObject:((NSString*)[self->resources objectAtIndex:cr])];
		cr++;
	}
	return(v);
}

- (NSString*) getRelativeResourcePath {
	if(self->resources == nil) {
		return([self getURLPath]);
	}
	if(({ NSString* _s1 = self->relativeResourcePath; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSMutableArray* rrs = [self getRelativeResources];
		if(rrs != nil) {
			CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
			if(rrs != nil) {
				int n = 0;
				int m = [rrs count];
				for(n = 0 ; n < m ; n++) {
					NSString* rr = ((NSString*)[rrs objectAtIndex:n]);
					if(rr != nil) {
						if([CapeString isEmpty:rr] == FALSE) {
							[sb appendCharacter:'/'];
							[sb appendString:rr];
						}
					}
				}
			}
			if([sb count] < 1) {
				[sb appendCharacter:'/'];
			}
			self->relativeResourcePath = [sb toString];
		}
	}
	return(self->relativeResourcePath);
}

- (BOOL) isForResource:(NSString*)res {
	if(({ NSString* _s1 = res; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	NSString* rrp = [self getRelativeResourcePath];
	if(({ NSString* _s1 = rrp; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(({ NSString* _s1 = rrp; NSString* _s2 = res; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isForDirectory {
	NSString* path = [self getURLPath];
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString endsWith:path str2:@"/"]) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isForPrefix:(NSString*)res {
	if(({ NSString* _s1 = res; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	NSString* rr = [self getRelativeResourcePath];
	if(!(({ NSString* _s1 = rr; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString startsWith:rr str2:res offset:0]) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isGET {
	return(({ NSString* _s1 = self->method; NSString* _s2 = @"GET"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }));
}

- (BOOL) isPOST {
	return(({ NSString* _s1 = self->method; NSString* _s2 = @"POST"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }));
}

- (BOOL) isDELETE {
	return(({ NSString* _s1 = self->method; NSString* _s2 = @"DELETE"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }));
}

- (BOOL) isPUT {
	return(({ NSString* _s1 = self->method; NSString* _s2 = @"PUT"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }));
}

- (BOOL) isPATCH {
	return(({ NSString* _s1 = self->method; NSString* _s2 = @"PATCH"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }));
}

- (void) sendJSONObject:(id)o {
	[self sendResponse:[SympathyHTTPServerResponse forJSONString:[CapeJSONEncoder encode:o niceFormatting:TRUE]]];
}

- (void) sendJSONString:(NSString*)json {
	[self sendResponse:[SympathyHTTPServerResponse forJSONString:json]];
}

- (void) sendJSONError:(CapeError*)error {
	[self sendResponse:[SympathyHTTPServerResponse forJSONString:[CapeJSONEncoder encode:((id)[SympathyJSONResponse forError:error]) niceFormatting:TRUE]]];
}

- (void) sendJSONOK:(id)data {
	[self sendResponse:[SympathyHTTPServerResponse forJSONString:[CapeJSONEncoder encode:((id)[SympathyJSONResponse forOk:data]) niceFormatting:TRUE]]];
}

- (void) sendInternalError:(NSString*)text {
	[self sendResponse:[SympathyHTTPServerResponse forHTTPInternalError:text]];
}

- (void) sendNotAllowed {
	[self sendResponse:[SympathyHTTPServerResponse forHTTPNotAllowed:nil]];
}

- (void) sendNotFound {
	[self sendResponse:[SympathyHTTPServerResponse forHTTPNotFound:nil]];
}

- (void) sendInvalidRequest:(NSString*)text {
	[self sendResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:text]];
}

- (void) sendTextString:(NSString*)text {
	[self sendResponse:[SympathyHTTPServerResponse forTextString:text]];
}

- (void) sendHTMLString:(NSString*)html {
	[self sendResponse:[SympathyHTTPServerResponse forHTMLString:html]];
}

- (void) sendXMLString:(NSString*)xml {
	[self sendResponse:[SympathyHTTPServerResponse forXMLString:xml]];
}

- (void) sendFile:(id<CapeFile>)file {
	[self sendResponse:[SympathyHTTPServerResponse forFile:file maxCachedSize:-1]];
}

- (void) sendBuffer:(NSMutableData*)buffer mimeType:(NSString*)mimeType {
	[self sendResponse:[SympathyHTTPServerResponse forBuffer:buffer mimetype:mimeType]];
}

- (void) sendRedirect:(NSString*)url {
	[self sendResponse:[SympathyHTTPServerResponse forHTTPMovedTemporarily:url]];
}

- (void) sendRedirectAsDirectory {
	NSString* path = [self getURLPath];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		path = @"";
	}
	[self sendRedirect:[path stringByAppendingString:@"/"]];
}

- (BOOL) isResponseSent {
	return(self->responseSent);
}

- (void) addResponseCookie:(SympathyHTTPServerCookie*)cookie {
	if(cookie == nil) {
		return;
	}
	if(self->responseCookies == nil) {
		self->responseCookies = [[NSMutableArray alloc] init];
	}
	[self->responseCookies addObject:cookie];
}

- (void) sendResponse:(SympathyHTTPServerResponse*)resp {
	if(self->responseSent) {
		return;
	}
	if(self->server == nil) {
		return;
	}
	if(self->responseCookies != nil) {
		int n = 0;
		int m = [self->responseCookies count];
		for(n = 0 ; n < m ; n++) {
			SympathyHTTPServerCookie* cookie = ((SympathyHTTPServerCookie*)[self->responseCookies objectAtIndex:n]);
			if(cookie != nil) {
				[resp addCookie:cookie];
			}
		}
	}
	self->responseCookies = nil;
	[self->server sendResponse:self->connection req:self resp:resp];
	self->responseSent = TRUE;
}

- (NSString*) getMethod {
	return(self->method);
}

- (SympathyHTTPServerRequest*) setMethod:(NSString*)v {
	self->method = v;
	return(self);
}

- (NSString*) getUrlString {
	return(self->urlString);
}

- (SympathyHTTPServerRequest*) setUrlString:(NSString*)v {
	self->urlString = v;
	return(self);
}

- (NSString*) getVersion {
	return(self->version);
}

- (SympathyHTTPServerRequest*) setVersion:(NSString*)v {
	self->version = v;
	return(self);
}

- (SympathyHTTPServerConnection*) getConnection {
	return(self->connection);
}

- (SympathyHTTPServerRequest*) setConnection:(SympathyHTTPServerConnection*)v {
	self->connection = v;
	return(self);
}

- (SympathyHTTPServerBase*) getServer {
	return(self->server);
}

- (SympathyHTTPServerRequest*) setServer:(SympathyHTTPServerBase*)v {
	self->server = v;
	return(self);
}

- (id) getData {
	return(self->data);
}

- (SympathyHTTPServerRequest*) setData:(id)v {
	self->data = v;
	return(self);
}

- (id) getSession {
	return(self->session);
}

- (SympathyHTTPServerRequest*) setSession:(id)v {
	self->session = v;
	return(self);
}

- (NSMutableData*) getBodyBuffer {
	return(self->bodyBuffer);
}

- (SympathyHTTPServerRequest*) setBodyBuffer:(NSMutableData*)v {
	self->bodyBuffer = v;
	return(self);
}

@end
