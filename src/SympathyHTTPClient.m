
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
#import "SympathyHTTPClientOperation.h"
#import "SympathyHTTPClientRequest.h"
#import "SympathyHTTPClientListener.h"
#import "SympathyHTTPClientResponse.h"
#import "CapeBuffer.h"
#import "CapeString.h"
#import "SympathyHTTPClient.h"

@class SympathyHTTPClientMyListener;

@interface SympathyHTTPClientMyListener : SympathyHTTPClientListener
- (SympathyHTTPClientMyListener*) init;
- (BOOL) onResponseReceived:(SympathyHTTPClientResponse*)response;
- (BOOL) onDataReceived:(NSMutableData*)buffer;
- (void) onAborted;
- (void) onError:(NSString*)message;
- (void) onResponseCompleted;
- (SympathyHTTPClientResponse*) getResponse;
- (SympathyHTTPClientMyListener*) setResponse:(SympathyHTTPClientResponse*)v;
- (NSMutableData*) getBuffer;
- (SympathyHTTPClientMyListener*) setBuffer:(NSMutableData*)v;
@end

@implementation SympathyHTTPClientMyListener

{
	SympathyHTTPClientResponse* response;
	NSMutableData* buffer;
}

- (SympathyHTTPClientMyListener*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->buffer = nil;
	self->response = nil;
	return(self);
}

- (BOOL) onResponseReceived:(SympathyHTTPClientResponse*)response {
	self->response = response;
	return(TRUE);
}

- (BOOL) onDataReceived:(NSMutableData*)buffer {
	self->buffer = [CapeBuffer append:self->buffer toAppend:buffer size:((long long)-1)];
	return(TRUE);
}

- (void) onAborted {
}

- (void) onError:(NSString*)message {
}

- (void) onResponseCompleted {
}

- (SympathyHTTPClientResponse*) getResponse {
	return(self->response);
}

- (SympathyHTTPClientMyListener*) setResponse:(SympathyHTTPClientResponse*)v {
	self->response = v;
	return(self);
}

- (NSMutableData*) getBuffer {
	return(self->buffer);
}

- (SympathyHTTPClientMyListener*) setBuffer:(NSMutableData*)v {
	self->buffer = v;
	return(self);
}

@end

@implementation SympathyHTTPClient

- (SympathyHTTPClient*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (SympathyHTTPClient*) createDefault {
	return(((SympathyHTTPClient*)[[SympathyHTTPClientOperation alloc] init]));
}

+ (void) executeHTTPClientAndHTTPClientRequestAndHTTPClientListener:(SympathyHTTPClient*)client request:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener {
	if(client == nil) {
		return;
	}
	[client executeRequest:request listener:listener];
}

+ (void) executeHTTPClientAndHTTPClientRequestAndFunction:(SympathyHTTPClient*)client request:(SympathyHTTPClientRequest*)request listener:(void(^)(SympathyHTTPClientResponse*))listener {
	SympathyHTTPClientMyListener* ll = [[SympathyHTTPClientMyListener alloc] init];
	[SympathyHTTPClient executeHTTPClientAndHTTPClientRequestAndHTTPClientListener:client request:request listener:((SympathyHTTPClientListener*)ll)];
	if(listener != nil) {
		listener([ll getResponse]);
	}
}

+ (void) executeForBuffer:(SympathyHTTPClient*)client request:(SympathyHTTPClientRequest*)request listener:(void(^)(SympathyHTTPClientResponse*,NSMutableData*))listener {
	SympathyHTTPClientMyListener* ll = [[SympathyHTTPClientMyListener alloc] init];
	[SympathyHTTPClient executeHTTPClientAndHTTPClientRequestAndHTTPClientListener:client request:request listener:((SympathyHTTPClientListener*)ll)];
	if(listener != nil) {
		listener([ll getResponse], [ll getBuffer]);
	}
}

+ (void) executeForString:(SympathyHTTPClient*)client request:(SympathyHTTPClientRequest*)request listener:(void(^)(SympathyHTTPClientResponse*,NSString*))listener {
	SympathyHTTPClientMyListener* ll = [[SympathyHTTPClientMyListener alloc] init];
	[SympathyHTTPClient executeHTTPClientAndHTTPClientRequestAndHTTPClientListener:client request:request listener:((SympathyHTTPClientListener*)ll)];
	if(listener != nil) {
		listener([ll getResponse], [CapeString forUTF8Buffer:[ll getBuffer]]);
	}
}

- (void) executeRequest:(SympathyHTTPClientRequest*)request listener:(SympathyHTTPClientListener*)listener {
}

@end
