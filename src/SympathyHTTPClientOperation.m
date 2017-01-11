
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
#import "SympathyHTTPClientResponse.h"
#import "SympathyHTTPClientListener.h"
#import "CapeBuffer.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeVector.h"
#import "SympathyConnectedSocket.h"
#import "SympathyTCPSocket.h"
#import "SympathySSLSocket.h"
#import "SympathyHTTPClientRequest.h"
#import "CapeClosable.h"
#import "CapePrintWriter.h"
#import "CapePrintWriterWrapper.h"
#import "CapeWriter.h"
#import "CapeSizedReader.h"
#import "CapeReader.h"
#import "SympathyHTTPClientOperation.h"

@class SympathyHTTPClientOperationMyResponseParser;

@interface SympathyHTTPClientOperationMyResponseParser : NSObject
{
	@public SympathyHTTPClientResponse* headers;
	@public BOOL isChunked;
	@public int contentLength;
	@public int dataCounter;
}
- (SympathyHTTPClientOperationMyResponseParser*) init;
- (void) reset;
- (void) onDataReceived:(NSMutableData*)buf size:(long long)size;
- (void) onHeadersReceived:(SympathyHTTPClientResponse*)headers;
- (void) onBodyDataReceived:(NSMutableData*)buffer size:(long long)size;
- (void) onEndOfResponse;
- (SympathyHTTPClientListener*) getListener;
- (SympathyHTTPClientOperationMyResponseParser*) setListener:(SympathyHTTPClientListener*)v;
- (BOOL) getEndOfResponse;
- (SympathyHTTPClientOperationMyResponseParser*) setEndOfResponse:(BOOL)v;
- (BOOL) getAborted;
- (SympathyHTTPClientOperationMyResponseParser*) setAborted:(BOOL)v;
@end

@implementation SympathyHTTPClientOperationMyResponseParser

{
	NSMutableData* receivedData;
	SympathyHTTPClientListener* listener;
	BOOL endOfResponse;
	BOOL aborted;
}

- (SympathyHTTPClientOperationMyResponseParser*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->aborted = FALSE;
	self->endOfResponse = FALSE;
	self->listener = nil;
	self->dataCounter = 0;
	self->contentLength = 0;
	self->isChunked = FALSE;
	self->headers = nil;
	self->receivedData = nil;
	return(self);
}

- (void) reset {
	self->isChunked = FALSE;
	self->headers = nil;
	self->contentLength = 0;
	self->dataCounter = 0;
	self->endOfResponse = FALSE;
	self->aborted = FALSE;
}

- (BOOL) hasEndOfHeaders:(NSMutableData*)buf size:(long long)size {
	int n = 0;
	BOOL v = FALSE;
	while(n <= size - 4) {
		if([CapeBuffer getByte:buf offset:((long long)n)] == '\r' && [CapeBuffer getByte:buf offset:((long long)(n + 1))] == '\n' && [CapeBuffer getByte:buf offset:((long long)(n + 2))] == '\r' && [CapeBuffer getByte:buf offset:((long long)(n + 3))] == '\n') {
			v = TRUE;
			break;
		}
		n++;
	}
	return(v);
}

- (SympathyHTTPClientResponse*) parseResponse:(NSMutableData*)buf {
	int i = 0;
	uint8_t p = ((uint8_t)'0');
	SympathyHTTPClientResponse* v = nil;
	BOOL first = TRUE;
	BOOL isChunked = FALSE;
	while(TRUE) {
		CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
		while((p = [CapeBuffer getByte:buf offset:((long long)i)]) != 0) {
			if(p == '\r') {
				;
			}
			else {
				if(p == '\n') {
					i++;
					break;
				}
				else {
					[sb appendCharacter:((int)p)];
				}
			}
			i++;
		}
		NSString* t = [sb toString];
		if([CapeString isEmpty:t]) {
			break;
		}
		if(first) {
			NSMutableArray* comps = [CapeString split:t delim:' ' max:3];
			v = [[SympathyHTTPClientResponse alloc] init];
			[v setHttpVersion:[CapeVector get:comps index:0]];
			[v setHttpStatus:[CapeVector get:comps index:1]];
			[v setHttpStatusDescription:[CapeVector get:comps index:2]];
		}
		else {
			NSMutableArray* comps = [CapeString split:t delim:':' max:2];
			NSString* key = [CapeVector get:comps index:0];
			if([CapeString isEmpty:key] == FALSE) {
				NSString* val = [CapeString strip:[CapeVector get:comps index:1]];
				[v addHeader:key value:val];
				if(isChunked == FALSE && [CapeString equalsIgnoreCase:key str2:@"transfer-encoding"]) {
					if(({ NSString* _s1 = val; NSString* _s2 = @"chunked"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						isChunked = TRUE;
					}
				}
				else {
					if(self->contentLength < 1 && [CapeString equalsIgnoreCase:key str2:@"content-length"]) {
						self->contentLength = [CapeString toInteger:val];
					}
				}
			}
		}
		first = FALSE;
	}
	long long l = ((long long)([CapeBuffer getSize:buf] - i));
	if(l > 0) {
		self->receivedData = [CapeBuffer getSubBuffer:buf offset:((long long)i) size:l alwaysNewBuffer:FALSE];
	}
	else {
		self->receivedData = nil;
	}
	self->isChunked = isChunked;
	return(v);
}

- (NSMutableData*) getChunk {
	if(self->receivedData == nil) {
		return(nil);
	}
	int i = 0;
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	while(TRUE) {
		uint8_t p = [CapeBuffer getByte:self->receivedData offset:((long long)i)];
		if(p == '\r') {
			;
		}
		else {
			if(p == '\n') {
				i++;
				break;
			}
			else {
				[sb appendCharacter:((int)p)];
			}
		}
		i++;
		if([sb count] >= 16) {
			return(nil);
		}
	}
	int cl = -1;
	NSString* t = [CapeString strip:[sb toString]];
	if([CapeString isEmpty:t] == FALSE) {
		cl = [CapeString toIntegerFromHex:t];
	}
	NSMutableData* v = nil;
	if(cl > 0) {
		if([CapeBuffer getSize:self->receivedData] - i < cl) {
			return(nil);
		}
		v = [NSMutableData dataWithLength:cl];
		[CapeBuffer copyFrom:v src:self->receivedData soffset:((long long)i) doffset:((long long)0) size:((long long)cl)];
		i += cl;
	}
	while(i < [CapeBuffer getSize:self->receivedData] && ([CapeBuffer getByte:self->receivedData offset:((long long)i)] == '\r' || [CapeBuffer getByte:self->receivedData offset:((long long)i)] == '\n')) {
		i++;
	}
	int rem = ((int)([CapeBuffer getSize:self->receivedData] - i));
	if(rem > 0) {
		NSMutableData* tmp = self->receivedData;
		self->receivedData = [NSMutableData dataWithLength:rem];
		[CapeBuffer copyFrom:self->receivedData src:tmp soffset:((long long)i) doffset:((long long)0) size:((long long)rem)];
	}
	else {
		self->receivedData = nil;
	}
	return(v);
}

- (void) onDataReceived:(NSMutableData*)buf size:(long long)size {
	if(size > 0) {
		self->receivedData = [CapeBuffer append:self->receivedData toAppend:buf size:size];
	}
	if(self->headers == nil) {
		if([self hasEndOfHeaders:self->receivedData size:[CapeBuffer getSize:self->receivedData]]) {
			self->headers = [self parseResponse:self->receivedData];
			if(self->headers != nil) {
				[self onHeadersReceived:self->headers];
			}
		}
	}
	if(self->isChunked) {
		while(TRUE) {
			NSMutableData* r = [self getChunk];
			if(r != nil) {
				long long sz = [CapeBuffer getSize:r];
				self->dataCounter += ((int)sz);
				[self onBodyDataReceived:r size:sz];
			}
			else {
				[self reset];
				[self onEndOfResponse];
				break;
			}
			if(self->receivedData == nil) {
				break;
			}
		}
	}
	else {
		if(self->contentLength > 0) {
			long long rsz = [CapeBuffer getSize:self->receivedData];
			if(rsz > 0) {
				if(self->contentLength <= 0 || self->dataCounter + rsz <= self->contentLength) {
					NSMutableData* v = self->receivedData;
					self->receivedData = nil;
					self->dataCounter += ((int)rsz);
					[self onBodyDataReceived:v size:rsz];
				}
				else {
					int vsz = self->contentLength - self->dataCounter;
					NSMutableData* v = [CapeBuffer getSubBuffer:self->receivedData offset:((long long)0) size:((long long)vsz) alwaysNewBuffer:FALSE];
					self->receivedData = [CapeBuffer getSubBuffer:self->receivedData offset:((long long)vsz) size:rsz - vsz alwaysNewBuffer:FALSE];
					self->dataCounter += vsz;
					[self onBodyDataReceived:v size:((long long)vsz)];
				}
			}
			if(self->dataCounter >= self->contentLength) {
				[self reset];
				[self onEndOfResponse];
			}
		}
		else {
			[self reset];
			[self onEndOfResponse];
		}
	}
}

- (void) onHeadersReceived:(SympathyHTTPClientResponse*)headers {
	if(self->listener != nil && [self->listener onResponseReceived:headers] == FALSE) {
		if(self->listener != nil) {
			[self->listener onAborted];
		}
		self->aborted = TRUE;
	}
}

- (void) onBodyDataReceived:(NSMutableData*)buffer size:(long long)size {
	if(self->listener != nil && [self->listener onDataReceived:buffer] == FALSE) {
		if(self->listener != nil) {
			[self->listener onAborted];
		}
		self->aborted = TRUE;
	}
}

- (void) onEndOfResponse {
	if(self->listener != nil) {
		[self->listener onResponseCompleted];
	}
	self->endOfResponse = TRUE;
}

- (SympathyHTTPClientListener*) getListener {
	return(self->listener);
}

- (SympathyHTTPClientOperationMyResponseParser*) setListener:(SympathyHTTPClientListener*)v {
	self->listener = v;
	return(self);
}

- (BOOL) getEndOfResponse {
	return(self->endOfResponse);
}

- (SympathyHTTPClientOperationMyResponseParser*) setEndOfResponse:(BOOL)v {
	self->endOfResponse = v;
	return(self);
}

- (BOOL) getAborted {
	return(self->aborted);
}

- (SympathyHTTPClientOperationMyResponseParser*) setAborted:(BOOL)v {
	self->aborted = v;
	return(self);
}

@end

@implementation SympathyHTTPClientOperation

{
	id<SympathyConnectedSocket> openSocket;
	NSString* openSocketProtocol;
	NSString* openSocketAddress;
	int openSocketPort;
	NSString* defaultUserAgent;
	SympathyHTTPClientOperationMyResponseParser* parser;
	NSMutableData* receiveBuffer;
	BOOL acceptInvalidCertificate;
}

- (SympathyHTTPClientOperation*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->acceptInvalidCertificate = FALSE;
	self->receiveBuffer = nil;
	self->parser = nil;
	self->defaultUserAgent = nil;
	self->openSocketPort = 0;
	self->openSocketAddress = nil;
	self->openSocketProtocol = nil;
	self->openSocket = nil;
	self->receiveBuffer = [NSMutableData dataWithLength:64 * 1024];
	return(self);
}

- (BOOL) openConnectionWithStringAndStringAndSignedIntegerAndHTTPClientListener:(NSString*)protocol address:(NSString*)address aport:(int)aport listener:(SympathyHTTPClientListener*)listener {
	[self closeConnection:listener];
	if([CapeString isEmpty:address]) {
		if(listener != nil) {
			[listener onError:@"No server address"];
		}
		return(FALSE);
	}
	if(!(({ NSString* _s1 = protocol; NSString* _s2 = @"http"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && !(({ NSString* _s1 = protocol; NSString* _s2 = @"https"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(listener != nil) {
			[listener onError:@"Protocol must be http or https"];
		}
		return(FALSE);
	}
	int port = aport;
	if(port < 1) {
		if(({ NSString* _s1 = protocol; NSString* _s2 = @"https"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			port = 443;
		}
		else {
			port = 80;
		}
	}
	if(listener != nil) {
		[listener onStatus:[[[[@"Connecting to server `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"' .."]];
	}
	self->openSocket = ((id<SympathyConnectedSocket>)[SympathyTCPSocket createAndConnect:address port:port]);
	if(listener != nil) {
		[listener onStatus:nil];
	}
	if(self->openSocket == nil) {
		if(listener != nil) {
			[listener onError:[[[[@"Connection failed: `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"'"]];
		}
		return(FALSE);
	}
	if(({ NSString* _s1 = protocol; NSString* _s2 = @"https"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->openSocket = ((id<SympathyConnectedSocket>)[SympathySSLSocket forClient:self->openSocket hostAddress:address ctx:nil acceptInvalidCertificate:self->acceptInvalidCertificate]);
		if(self->openSocket == nil && listener != nil) {
			[listener onError:@"FAILED to create SSL socket for HTTPS"];
			[self closeConnection:listener];
			return(FALSE);
		}
	}
	self->openSocketProtocol = protocol;
	self->openSocketAddress = address;
	self->openSocketPort = port;
	self->parser = [[SympathyHTTPClientOperationMyResponseParser alloc] init];
	return(TRUE);
}

- (BOOL) openConnectionWithHTTPClientRequestAndHTTPClientListener:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener {
	if(request == nil) {
		if(listener != nil) {
			[listener onError:@"No request"];
		}
		return(FALSE);
	}
	return([self openConnectionWithStringAndStringAndSignedIntegerAndHTTPClientListener:[request getProtocol] address:[request getServerAddress] aport:[request getServerPort] listener:listener]);
}

- (void) closeConnection:(SympathyHTTPClientListener*)listener {
	if(self->openSocket == nil) {
		return;
	}
	if(listener != nil) {
		[listener onStatus:@"Closing connection"];
	}
	[self->openSocket close];
	self->openSocket = nil;
	self->openSocketProtocol = nil;
	self->openSocketAddress = nil;
	self->openSocketPort = 0;
	self->parser = nil;
	if(listener != nil) {
		[listener onStatus:nil];
	}
}

- (BOOL) sendRequest:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener {
	if(request == nil) {
		if(listener != nil) {
			[listener onError:@"No request"];
		}
		return(FALSE);
	}
	if(listener != nil && [listener onStartRequest:request] == FALSE) {
		return(FALSE);
	}
	if(self->openSocket != nil) {
		if(!(({ NSString* _s1 = [request getServerAddress]; NSString* _s2 = self->openSocketAddress; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) || !(({ NSString* _s1 = [request getProtocol]; NSString* _s2 = self->openSocketProtocol; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) || [request getServerPort] != self->openSocketPort) {
			[self closeConnection:listener];
		}
	}
	if(self->openSocket == nil) {
		[self openConnectionWithHTTPClientRequestAndHTTPClientListener:request listener:listener];
		if(self->openSocket == nil) {
			return(FALSE);
		}
	}
	if(listener != nil) {
		[listener onStatus:@"Sending request headers .."];
	}
	NSString* rqs = [request toStringWithString:self->defaultUserAgent];
	id<CapePrintWriter> pww = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)self->openSocket)];
	BOOL whr = [pww print:rqs];
	if(listener != nil) {
		[listener onStatus:nil];
	}
	if(whr == FALSE) {
		if(listener != nil) {
			[listener onError:@"Failed to send HTTP request headers"];
		}
		[self closeConnection:listener];
		return(FALSE);
	}
	id<CapeSizedReader> body = [request getBody];
	if(body != nil) {
		if(listener != nil) {
			[listener onStatus:@"Sending request body .."];
		}
		BOOL rv = TRUE;
		NSMutableData* bf = [NSMutableData dataWithLength:4096 * 4];
		while(TRUE) {
			int r = [body read:bf];
			if(r < 1) {
				break;
			}
			if([self->openSocket write:bf size:r] < r) {
				if(listener != nil) {
					[listener onError:@"Failed to send request body"];
				}
				[self closeConnection:listener];
				rv = FALSE;
				break;
			}
		}
		if(listener != nil) {
			[listener onStatus:nil];
		}
		if(rv == FALSE) {
			return(FALSE);
		}
	}
	return(TRUE);
}

- (BOOL) readResponse:(SympathyHTTPClientListener*)listener timeout:(int)timeout {
	if(self->openSocket == nil) {
		if(listener != nil) {
			[listener onError:@"No open socket"];
		}
		return(FALSE);
	}
	if(listener != nil) {
		[listener onStatus:@"Receiving response .."];
	}
	BOOL rv = TRUE;
	[self->parser setListener:listener];
	while(TRUE) {
		int r = 0;
		if([((NSObject*)self->openSocket) isKindOfClass:[SympathySSLSocket class]]) {
			r = [((SympathySSLSocket*)self->openSocket) readWithTimeout:self->receiveBuffer timeout:timeout];
		}
		else {
			r = [((SympathyTCPSocket*)self->openSocket) readWithTimeout:self->receiveBuffer timeout:timeout];
		}
		if(r == 0) {
			rv = FALSE;
			break;
		}
		if(r < 1) {
			[self closeConnection:listener];
			if(listener != nil) {
				[listener onAborted];
			}
			rv = FALSE;
			break;
		}
		[self->parser onDataReceived:self->receiveBuffer size:((long long)r)];
		if([self->parser getAborted]) {
			[self closeConnection:listener];
			rv = FALSE;
			break;
		}
		if([self->parser getEndOfResponse]) {
			[self->parser reset];
			rv = TRUE;
			break;
		}
	}
	if(self->parser != nil) {
		[self->parser setListener:nil];
	}
	if(listener != nil) {
		[listener onStatus:nil];
		if([listener onEndRequest] == FALSE) {
			rv = FALSE;
		}
	}
	return(rv);
}

- (void) executeRequest:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener {
	if([self sendRequest:request listener:listener] == FALSE) {
		return;
	}
	if([self readResponse:listener timeout:30000] == FALSE) {
		return;
	}
	if(({ NSString* _s1 = [request getHeader:@"connection"]; NSString* _s2 = @"close"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[self closeConnection:listener];
	}
}

- (NSString*) getDefaultUserAgent {
	return(self->defaultUserAgent);
}

- (SympathyHTTPClientOperation*) setDefaultUserAgent:(NSString*)v {
	self->defaultUserAgent = v;
	return(self);
}

- (BOOL) getAcceptInvalidCertificate {
	return(self->acceptInvalidCertificate);
}

- (SympathyHTTPClientOperation*) setAcceptInvalidCertificate:(BOOL)v {
	self->acceptInvalidCertificate = v;
	return(self);
}

@end
