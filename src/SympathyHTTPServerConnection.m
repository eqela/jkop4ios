
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
#import "CapeKeyValueList.h"
#import "CapeStringBuilder.h"
#import "SympathyDataStream.h"
#import "SympathyHTTPServerRequest.h"
#import "CapeReader.h"
#import "SympathyHTTPServerResponse.h"
#import "CapeQueue.h"
#import "SympathyHTTPServerBase.h"
#import "CapeBuffer.h"
#import "CapeString.h"
#import "CapeLog.h"
#import "CapeIterator.h"
#import "CapeVector.h"
#import "CapeStackTrace.h"
#import "CapeStringObject.h"
#import "CapeKeyValuePair.h"
#import "CapexVerboseDateTimeString.h"
#import "CapeBufferReader.h"
#import "SympathyConnectedSocket.h"
#import "CapeWriter.h"
#import "CapeSystemClock.h"
#import "SympathyHTTPServerConnection.h"

@class SympathyHTTPServerConnectionParserState;

@interface SympathyHTTPServerConnectionParserState : NSObject
{
	@public NSString* method;
	@public NSString* uri;
	@public NSString* version;
	@public NSString* key;
	@public CapeKeyValueList* headers;
	@public BOOL headersDone;
	@public BOOL bodyDone;
	@public CapeStringBuilder* hdr;
	@public int contentLength;
	@public BOOL bodyIsChunked;
	@public int dataCounter;
	@public id<SympathyDataStream> bodyStream;
	@public NSMutableData* savedBodyChunk;
	@public NSMutableData* bodyBuffer;
}
- (SympathyHTTPServerConnectionParserState*) init;
@end

@implementation SympathyHTTPServerConnectionParserState

- (SympathyHTTPServerConnectionParserState*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->bodyBuffer = nil;
	self->savedBodyChunk = nil;
	self->bodyStream = nil;
	self->dataCounter = 0;
	self->bodyIsChunked = FALSE;
	self->contentLength = 0;
	self->hdr = nil;
	self->bodyDone = FALSE;
	self->headersDone = FALSE;
	self->headers = nil;
	self->key = nil;
	self->version = nil;
	self->uri = nil;
	self->method = nil;
	return(self);
}

@end

@implementation SympathyHTTPServerConnection

{
	int requests;
	int responses;
	SympathyHTTPServerConnectionParserState* parser;
	SympathyHTTPServerRequest* currentRequest;
	BOOL closeAfterSend;
	int sendWritten;
	NSMutableData* sendBodyBuffer;
	id<CapeReader> sendBody;
	NSMutableData* sendBuffer;
	SympathyHTTPServerResponse* responseToSend;
	CapeQueue* requestQueue;
	BOOL isWaitingForBodyReceiver;
}

- (SympathyHTTPServerConnection*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isWaitingForBodyReceiver = FALSE;
	self->requestQueue = nil;
	self->responseToSend = nil;
	self->sendBuffer = nil;
	self->sendBody = nil;
	self->sendBodyBuffer = nil;
	self->sendWritten = 0;
	self->closeAfterSend = FALSE;
	self->currentRequest = nil;
	self->parser = nil;
	self->responses = 0;
	self->requests = 0;
	self->parser = [[SympathyHTTPServerConnectionParserState alloc] init];
	return(self);
}

- (BOOL) getIsWaitingForBodyReceiver {
	return(self->isWaitingForBodyReceiver);
}

- (SympathyHTTPServerBase*) getHTTPServer {
	return(((SympathyHTTPServerBase*)({ id _v = [self getManager]; [_v isKindOfClass:[SympathyHTTPServerBase class]] ? _v : nil; })));
}

- (int) getWriteBufferSize {
	SympathyHTTPServerBase* server = [self getHTTPServer];
	if(server == nil) {
		return(1024 * 512);
	}
	return([server getWriteBufferSize]);
}

- (int) getSmallBodyLimit {
	SympathyHTTPServerBase* server = [self getHTTPServer];
	if(server == nil) {
		return(1024 * 32);
	}
	return([server getSmallBodyLimit]);
}

- (void) resetParser {
	self->parser->method = nil;
	self->parser->uri = nil;
	self->parser->version = nil;
	self->parser->key = nil;
	self->parser->headers = nil;
	self->parser->headersDone = FALSE;
	if(self->parser->bodyStream != nil) {
		[self->parser->bodyStream onDataStreamAbort];
	}
	self->parser->bodyStream = nil;
	self->parser->bodyDone = FALSE;
	self->parser->hdr = nil;
	self->parser->contentLength = 0;
	self->parser->bodyIsChunked = FALSE;
	self->parser->dataCounter = 0;
}

- (BOOL) initialize {
	if([super initialize] == FALSE) {
		return(FALSE);
	}
	[self updateListeningMode];
	return(TRUE);
}

- (void) updateListeningMode {
	BOOL writeFlag = FALSE;
	BOOL readFlag = TRUE;
	if(self->responseToSend != nil) {
		writeFlag = TRUE;
	}
	if(self->isWaitingForBodyReceiver) {
		readFlag = FALSE;
	}
	if(readFlag && writeFlag) {
		[self enableReadWriteMode];
	}
	else {
		if(readFlag) {
			[self enableReadMode];
		}
		else {
			if(writeFlag) {
				[self enableWriteMode];
			}
			else {
				[self enableIdleMode];
			}
		}
	}
}

- (void) setBodyReceiver:(id<SympathyDataStream>)stream {
	if(self->isWaitingForBodyReceiver == FALSE) {
		if(stream != nil) {
			if([stream onDataStreamStart:((long long)0)]) {
				[stream onDataStreamEnd];
			}
		}
		return;
	}
	self->parser->bodyStream = stream;
	if(stream != nil) {
		self->isWaitingForBodyReceiver = FALSE;
		[self updateListeningMode];
		int ll = self->parser->contentLength;
		if(self->parser->bodyIsChunked) {
			ll = -1;
		}
		if([stream onDataStreamStart:((long long)ll)] == FALSE) {
			self->parser->bodyStream = nil;
			[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
			[self resetParser];
			return;
		}
		NSMutableData* sbc = self->parser->savedBodyChunk;
		self->parser->savedBodyChunk = nil;
		if(sbc != nil) {
			[self onBodyData:sbc offset:0 sz:[sbc length]];
		}
	}
}

- (BOOL) isExpectingBody {
	if(({ NSString* _s1 = self->parser->method; NSString* _s2 = @"POST"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = self->parser->method; NSString* _s2 = @"PUT"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = self->parser->method; NSString* _s2 = @"PATCH"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || self->parser->contentLength > 0 || self->parser->bodyIsChunked) {
		return(TRUE);
	}
	return(FALSE);
}

- (void) onHeadersDone {
	BOOL hasBody = [self isExpectingBody];
	if(hasBody) {
		int sbl = [self getSmallBodyLimit];
		if(sbl > 0 && self->parser->contentLength > 0 && self->parser->contentLength < sbl) {
			self->parser->bodyBuffer = [NSMutableData dataWithLength:self->parser->contentLength];
			return;
		}
		self->isWaitingForBodyReceiver = TRUE;
	}
	SympathyHTTPServerRequest* req = [SympathyHTTPServerRequest forDetails:self->parser->method url:self->parser->uri version:self->parser->version headers:self->parser->headers];
	[self onCompleteRequest:req];
	if(hasBody == FALSE) {
		[self resetParser];
	}
	[self updateListeningMode];
}

- (void) onHeaderData:(NSMutableData*)inputBuffer offset:(int)offset sz:(int)sz {
	if(inputBuffer == nil) {
		return;
	}
	int p = 0;
	while(p < sz) {
		int c = ((int)([CapeBuffer getByte:inputBuffer offset:((long long)(p + offset))]));
		p++;
		if(c == '\r') {
			continue;
		}
		if(({ NSString* _s1 = self->parser->method; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			if(c == '\n') {
				continue;
			}
			if(c == ' ') {
				if(self->parser->hdr != nil) {
					self->parser->method = [self->parser->hdr toString];
					self->parser->hdr = nil;
				}
				continue;
			}
		}
		else {
			if(({ NSString* _s1 = self->parser->uri; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				if(c == ' ') {
					if(self->parser->hdr != nil) {
						self->parser->uri = [self->parser->hdr toString];
						self->parser->hdr = nil;
					}
					continue;
				}
				else {
					if(c == '\n') {
						if(self->parser->hdr != nil) {
							self->parser->uri = [self->parser->hdr toString];
							self->parser->hdr = nil;
						}
						self->parser->version = @"HTTP/0.9";
						self->parser->headersDone = TRUE;
						[self onHeadersDone];
						if(p < sz) {
							[self onData:inputBuffer offset:offset + p asz:sz - p];
						}
						return;
					}
				}
			}
			else {
				if(({ NSString* _s1 = self->parser->version; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					if(c == '\n') {
						if(self->parser->hdr != nil) {
							self->parser->version = [self->parser->hdr toString];
							self->parser->hdr = nil;
						}
						continue;
					}
				}
				else {
					if(({ NSString* _s1 = self->parser->key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						if(c == ':') {
							if(self->parser->hdr != nil) {
								self->parser->key = [self->parser->hdr toString];
								self->parser->hdr = nil;
							}
							continue;
						}
						else {
							if(c == '\n') {
								if(self->parser->hdr != nil) {
									[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
									[self resetParser];
									return;
								}
								self->parser->headersDone = TRUE;
								[self onHeadersDone];
								if(p < sz) {
									[self onData:inputBuffer offset:offset + p asz:sz - p];
								}
								return;
							}
						}
						if(c >= 'A' && c <= 'Z') {
							c = ((int)('a' + c - 'A'));
						}
					}
					else {
						if(c == ' ' && self->parser->hdr == nil) {
							continue;
						}
						else {
							if(c == '\n') {
								NSString* value = nil;
								if(self->parser->hdr != nil) {
									value = [self->parser->hdr toString];
									self->parser->hdr = nil;
								}
								if(self->parser->headers == nil) {
									self->parser->headers = [[CapeKeyValueList alloc] init];
								}
								[self->parser->headers addDynamicAndDynamic:((id)self->parser->key) val:((id)value)];
								if([CapeString equalsIgnoreCase:self->parser->key str2:@"content-length"] && !(({ NSString* _s1 = value; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
									self->parser->contentLength = [CapeString toInteger:value];
								}
								else {
									if([CapeString equalsIgnoreCase:self->parser->key str2:@"transfer-encoding"] && !(({ NSString* _s1 = value; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString contains:value str2:@"chunked"]) {
										self->parser->bodyIsChunked = TRUE;
									}
								}
								self->parser->key = nil;
								continue;
							}
						}
					}
				}
			}
		}
		if(self->parser->hdr == nil) {
			self->parser->hdr = [[CapeStringBuilder alloc] init];
		}
		[self->parser->hdr appendCharacter:c];
		if([self->parser->hdr count] > 32 * 1024) {
			[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
			[self resetParser];
			return;
		}
	}
}

- (void) onBodyData:(NSMutableData*)inputBuffer offset:(int)offset sz:(int)sz {
	if(inputBuffer == nil || sz < 1) {
		return;
	}
	if(self->parser->bodyBuffer == nil && self->parser->bodyStream == nil) {
		[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
		[self resetParser];
		return;
	}
	if(self->parser->contentLength > 0) {
		int p = 0;
		if(self->parser->dataCounter + sz <= self->parser->contentLength) {
			p = sz;
		}
		else {
			p = self->parser->contentLength - self->parser->dataCounter;
		}
		if(self->parser->bodyBuffer != nil) {
			[CapeBuffer copyFrom:self->parser->bodyBuffer src:inputBuffer soffset:((long long)offset) doffset:((long long)self->parser->dataCounter) size:((long long)p)];
		}
		else {
			if([self->parser->bodyStream onDataStreamContent:[CapeBuffer getSubBuffer:inputBuffer offset:((long long)offset) size:((long long)p) alwaysNewBuffer:FALSE] size:p] == FALSE) {
				[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
				self->parser->bodyStream = nil;
				[self resetParser];
				return;
			}
		}
		self->parser->dataCounter += p;
		if(self->parser->dataCounter >= self->parser->contentLength) {
			self->parser->bodyDone = TRUE;
			if(self->parser->bodyBuffer != nil) {
				SympathyHTTPServerRequest* req = [SympathyHTTPServerRequest forDetails:self->parser->method url:self->parser->uri version:self->parser->version headers:self->parser->headers];
				[req setBodyBuffer:self->parser->bodyBuffer];
				self->parser->bodyBuffer = nil;
				[self onCompleteRequest:req];
				[self resetParser];
			}
			else {
				if([self->parser->bodyStream onDataStreamEnd] == FALSE) {
					[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
					self->parser->bodyStream = nil;
					[self resetParser];
					return;
				}
				self->parser->bodyStream = nil;
			}
			if(p < sz) {
				[self onData:inputBuffer offset:offset + p asz:sz - p];
			}
		}
		return;
	}
	else {
		if(self->parser->bodyIsChunked) {
			[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:@"Chunked content body is not supported."]];
			[self resetParser];
			return;
		}
		else {
			[self sendErrorResponse:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
			[self resetParser];
		}
	}
}

- (void) onData:(NSMutableData*)buffer offset:(int)offset asz:(int)asz {
	if(buffer == nil) {
		return;
	}
	int sz = asz;
	if(sz < 0) {
		sz = ((int)([CapeBuffer getSize:buffer] - offset));
	}
	if(self->isWaitingForBodyReceiver) {
		self->parser->savedBodyChunk = [CapeBuffer getSubBuffer:buffer offset:((long long)offset) size:((long long)sz) alwaysNewBuffer:FALSE];
		return;
	}
	if(self->parser->headersDone && self->parser->bodyDone) {
		[self resetParser];
	}
	if(self->parser->headersDone == FALSE) {
		[self onHeaderData:buffer offset:offset sz:sz];
	}
	else {
		if(self->parser->bodyDone == FALSE) {
			[self onBodyData:buffer offset:offset sz:sz];
		}
	}
}

- (void) onOpened {
}

- (void) onClosed {
	[self resetParser];
}

- (void) onError:(NSString*)message {
	[CapeLog error:self->logContext message:message];
}

- (void) onDataReceived:(NSMutableData*)data size:(int)size {
	[self onData:data offset:0 asz:size];
}

- (void) onWriteReady {
	[self sendData];
}

- (void) onCompleteRequest:(SympathyHTTPServerRequest*)req {
	if(req == nil) {
		return;
	}
	self->requests++;
	[req setServer:[self getHTTPServer]];
	[req setConnection:self];
	if(self->currentRequest == nil) {
		self->currentRequest = req;
		[self handleCurrentRequest];
	}
	else {
		if(self->requestQueue == nil) {
			self->requestQueue = [[CapeQueue alloc] init];
		}
		[self->requestQueue push:((id)req)];
	}
}

- (void) handleNextRequest {
	if(self->currentRequest != nil || self->requestQueue == nil) {
		return;
	}
	SympathyHTTPServerRequest* req = ((SympathyHTTPServerRequest*)({ id _v = [self->requestQueue pop]; [_v isKindOfClass:[SympathyHTTPServerRequest class]] ? _v : nil; }));
	if(req == nil) {
		return;
	}
	self->currentRequest = req;
	[self handleCurrentRequest];
}

- (void) sendErrorResponse:(SympathyHTTPServerResponse*)response {
	self->closeAfterSend = TRUE;
	[self sendResponse:nil aresp:response];
}

- (void) handleCurrentRequest {
	SympathyHTTPServerBase* server = [self getHTTPServer];
	if(self->currentRequest == nil || server == nil) {
		return;
	}
	NSString* method = [self->currentRequest getMethod];
	NSString* url = [self->currentRequest getUrlString];
	if([CapeString isEmpty:method] || [CapeString isEmpty:url]) {
		self->closeAfterSend = TRUE;
		[self sendResponse:self->currentRequest aresp:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
		return;
	}
	if(({ NSString* _s1 = [self->currentRequest getVersion]; NSString* _s2 = @"HTTP/0.9"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) && !(({ NSString* _s1 = method; NSString* _s2 = @"GET"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		self->closeAfterSend = TRUE;
		[self sendResponse:self->currentRequest aresp:[SympathyHTTPServerResponse forHTTPInvalidRequest:nil]];
		return;
	}
	[server handleIncomingRequest:self->currentRequest];
}

+ (NSString*) getFullStatus:(NSString*)status {
	NSString* v = nil;
	if(!(({ NSString* _s1 = status; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString indexOfWithStringAndStringAndSignedInteger:status s:@" " start:0] < 1) {
		if([CapeString equals:@"200" str2:status]) {
			v = @"200 OK";
		}
		else {
			if([CapeString equals:@"301" str2:status]) {
				v = @"301 Moved Permanently";
			}
			else {
				if([CapeString equals:@"303" str2:status]) {
					v = @"303 See Other";
				}
				else {
					if([CapeString equals:@"304" str2:status]) {
						v = @"304 Not Modified";
					}
					else {
						if([CapeString equals:@"400" str2:status]) {
							v = @"400 Bad Request";
						}
						else {
							if([CapeString equals:@"401" str2:status]) {
								v = @"401 Unauthorized";
							}
							else {
								if([CapeString equals:@"403" str2:status]) {
									v = @"403 Forbidden";
								}
								else {
									if([CapeString equals:@"404" str2:status]) {
										v = @"404 Not found";
									}
									else {
										if([CapeString equals:@"405" str2:status]) {
											v = @"405 Method not allowed";
										}
										else {
											if([CapeString equals:@"500" str2:status]) {
												v = @"500 Internal server error";
											}
											else {
												if([CapeString equals:@"501" str2:status]) {
													v = @"501 Not implemented";
												}
												else {
													if([CapeString equals:@"503" str2:status]) {
														v = @"503 Service unavailable";
													}
													else {
														v = [status stringByAppendingString:@" Unknown"];
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	else {
		v = status;
	}
	return(v);
}

+ (NSString*) getStatusCode:(NSString*)status {
	if(({ NSString* _s1 = status; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	id<CapeIterator> comps = [CapeVector iterate:[CapeString split:status delim:' ' max:0]];
	if(comps != nil) {
		return(((NSString*)({ id _v = [comps next]; [_v isKindOfClass:[NSString class]] ? _v : nil; })));
	}
	return(nil);
}

- (void) sendResponse:(SympathyHTTPServerRequest*)req aresp:(SympathyHTTPServerResponse*)aresp {
	if(self->socket == nil) {
		return;
	}
	if(req != nil) {
		if(self->currentRequest == nil) {
			[CapeLog error:self->logContext message:@"Sending a response, but no current request!"];
			[CapeLog error:self->logContext message:[[[CapeStackTrace alloc] init] toString]];
			[self close];
			return;
		}
		if(self->currentRequest != req) {
			[CapeLog error:self->logContext message:@"Sending a response for an incorrect request"];
			[self close];
			return;
		}
	}
	if(self->isWaitingForBodyReceiver) {
		self->closeAfterSend = TRUE;
	}
	self->responses++;
	SympathyHTTPServerResponse* resp = aresp;
	if(resp == nil) {
		resp = [SympathyHTTPServerResponse forTextString:@""];
	}
	NSString* inm = nil;
	if(req != nil) {
		inm = [req getETag];
	}
	if(!(({ NSString* _s1 = inm; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([CapeString equals:inm str2:[resp getETag]]) {
			resp = [[SympathyHTTPServerResponse alloc] init];
			[resp setStatus:@"304"];
			[resp setETag:[aresp getETag]];
		}
	}
	NSString* status = [resp getStatus];
	id<CapeReader> bod = [resp getBody];
	NSString* ver = nil;
	NSString* met = nil;
	if(req != nil) {
		ver = [req getVersion];
		met = [req getMethod];
	}
	CapeKeyValueList* headers = [resp getHeaders];
	SympathyHTTPServerBase* server = [self getHTTPServer];
	if([CapeString equals:@"HTTP/0.9" str2:ver]) {
		self->closeAfterSend = TRUE;
	}
	else {
		if(({ NSString* _s1 = status; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:status] < 1) {
			status = @"200";
			[resp setStatus:status];
		}
		if(req != nil && [req getConnectionClose]) {
			self->closeAfterSend = TRUE;
		}
		NSString* fs = [SympathyHTTPServerConnection getFullStatus:status];
		{
			CapeStringBuilder* reply = [[CapeStringBuilder alloc] init];
			if(({ NSString* _s1 = ver; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:ver] < 1) {
				[reply appendString:@"HTTP/1.1"];
			}
			else {
				[reply appendString:ver];
			}
			[reply appendCharacter:' '];
			[reply appendString:fs];
			[reply appendCharacter:'\r'];
			[reply appendCharacter:'\n'];
			if([CapeString startsWith:fs str2:@"400 " offset:0]) {
				self->closeAfterSend = TRUE;
			}
			if(headers != nil) {
				id<CapeIterator> it = [headers iterate];
				while(it != nil) {
					CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
					if(kvp == nil) {
						break;
					}
					[reply appendString:kvp->key];
					[reply appendCharacter:':'];
					[reply appendCharacter:' '];
					[reply appendString:kvp->value];
					[reply appendCharacter:'\r'];
					[reply appendCharacter:'\n'];
				}
			}
			if(self->closeAfterSend) {
				[reply appendString:@"Connection: close\r\n"];
			}
			if(server != nil) {
				[reply appendString:@"Server: "];
				[reply appendString:[server getServerName]];
			}
			[reply appendCharacter:'\r'];
			[reply appendCharacter:'\n'];
			[reply appendString:@"Date: "];
			[reply appendString:[CapexVerboseDateTimeString forNow]];
			[reply appendCharacter:'\r'];
			[reply appendCharacter:'\n'];
			[reply appendCharacter:'\r'];
			[reply appendCharacter:'\n'];
			self->sendBuffer = [CapeString toUTF8Buffer:[reply toString]];
		}
	}
	self->sendWritten = 0;
	if(bod != nil) {
		if([CapeString equals:@"HEAD" str2:met] == FALSE) {
			self->sendBody = bod;
		}
	}
	self->responseToSend = resp;
	[self updateListeningMode];
}

- (void) sendData {
	if(self->socket == nil) {
		return;
	}
	NSString* remoteAddress = [self getRemoteAddress];
	if([CapeBuffer getSize:self->sendBuffer] == 0) {
		if(self->sendBody != nil) {
			if([((NSObject*)self->sendBody) isKindOfClass:[CapeBufferReader class]]) {
				self->sendBuffer = [((CapeBufferReader*)self->sendBody) getBuffer];
				self->sendBody = nil;
			}
			else {
				if(self->sendBodyBuffer == nil) {
					self->sendBodyBuffer = [NSMutableData dataWithLength:[self getWriteBufferSize]];
				}
				int n = [self->sendBody read:self->sendBodyBuffer];
				if(n < 1) {
					self->sendBody = nil;
				}
				else {
					if(n == [self->sendBodyBuffer length]) {
						self->sendBuffer = self->sendBodyBuffer;
					}
					else {
						self->sendBuffer = [CapeBuffer getSubBuffer:self->sendBodyBuffer offset:((long long)0) size:((long long)n) alwaysNewBuffer:FALSE];
					}
				}
			}
		}
	}
	if([CapeBuffer getSize:self->sendBuffer] > 0) {
		id<SympathyConnectedSocket> socket = self->socket;
		int r = [socket write:self->sendBuffer size:[CapeBuffer getSize:self->sendBuffer]];
		if(r < 0) {
			self->sendBuffer = nil;
			self->sendBody = nil;
			[self close];
			return;
		}
		else {
			if(r == 0) {
				;
			}
			else {
				self->sendWritten += r;
				long long osz = [CapeBuffer getSize:self->sendBuffer];
				if(r < osz) {
					self->sendBuffer = [CapeBuffer getSubBuffer:self->sendBuffer offset:((long long)r) size:osz - r alwaysNewBuffer:FALSE];
				}
				else {
					self->sendBuffer = nil;
				}
			}
		}
	}
	if([CapeBuffer getSize:self->sendBuffer] == 0 && self->sendBody == nil) {
		SympathyHTTPServerBase* server = [self getHTTPServer];
		if(server != nil) {
			[server onRequestComplete:self->currentRequest resp:self->responseToSend bytesSent:self->sendWritten remoteAddress:remoteAddress];
		}
		self->currentRequest = nil;
		self->responseToSend = nil;
		if(self->closeAfterSend) {
			[self close];
		}
		else {
			[self updateListeningMode];
			[self handleNextRequest];
		}
	}
	self->lastActivity = [CapeSystemClock asSeconds];
}

- (int) getRequests {
	return(self->requests);
}

- (SympathyHTTPServerConnection*) setRequests:(int)v {
	self->requests = v;
	return(self);
}

- (int) getResponses {
	return(self->responses);
}

- (SympathyHTTPServerConnection*) setResponses:(int)v {
	self->responses = v;
	return(self);
}

@end
