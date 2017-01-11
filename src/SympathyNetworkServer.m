
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
#import "SympathyNetworkConnectionManager.h"
#import "SympathyTCPSocket.h"
#import "SympathyIOManagerEntry.h"
#import "CapeLog.h"
#import "CapeString.h"
#import "SympathyIOManager.h"
#import "SympathyConnectedSocket.h"
#import "SympathyNetworkServer.h"

@implementation SympathyNetworkServer

{
	int port;
	SympathyTCPSocket* socket;
	id<SympathyIOManagerEntry> esocket;
}

- (SympathyNetworkServer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->esocket = nil;
	self->socket = nil;
	self->port = 0;
	return(self);
}

- (BOOL) initialize {
	if([super initialize] == FALSE) {
		return(FALSE);
	}
	self->socket = [SympathyTCPSocket createAndListen:self->port];
	if(self->socket == nil) {
		[CapeLog error:self->logContext message:[@"Failed to listen on TCP port " stringByAppendingString:([CapeString forInteger:self->port])]];
		[self cleanup];
		return(FALSE);
	}
	self->esocket = [self->ioManager addWithReadListener:((id)self->socket) rrl:^void() {
		[self onIncomingConnection];
	}];
	if(self->esocket == nil) {
		[CapeLog error:self->logContext message:@"Failed to register with event loop"];
		[self cleanup];
		return(FALSE);
	}
	[CapeLog info:self->logContext message:[@"TCP server initialized, listening on port " stringByAppendingString:([CapeString forInteger:self->port])]];
	return(TRUE);
}

- (void) cleanup {
	if(self->esocket != nil) {
		[self->esocket remove];
		self->esocket = nil;
	}
	if(self->socket != nil) {
		[self->socket close];
		self->socket = nil;
	}
	[super cleanup];
}

- (void) onIncomingConnection {
	SympathyTCPSocket* nn = [self->socket accept];
	if(nn == nil) {
		[CapeLog error:self->logContext message:@"Failed to accept an incoming client."];
		return;
	}
	[self onNewSocket:((id<SympathyConnectedSocket>)nn)];
}

- (int) getPort {
	return(self->port);
}

- (SympathyNetworkServer*) setPort:(int)v {
	self->port = v;
	return(self);
}

@end
