
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
#import "SympathyIOManagerEntry.h"
#import "CapeLoggingContext.h"
#import "SympathyConnectedSocket.h"
#import "SympathyNetworkConnectionManager.h"
#import "SympathyTCPSocket.h"
#import "CapeString.h"
#import "CapeLog.h"
#import "CapeSystemClock.h"
#import "CapeWriter.h"
#import "CapeClosable.h"
#import "CapeReader.h"
#import "SympathyNetworkConnection.h"

int SympathyNetworkConnectionIdcounter = 0;

@implementation SympathyNetworkConnection

{
	int storageIndex;
	id<SympathyIOManagerEntry> ioEntry;
	long long _x_id;
	NSString* remoteAddress;
	int currentListenMode;
	SympathyNetworkConnectionManager* manager;
	int defaultListenMode;
}

- (SympathyNetworkConnection*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->defaultListenMode = 1;
	self->manager = nil;
	self->currentListenMode = -1;
	self->remoteAddress = nil;
	self->lastActivity = ((long long)0);
	self->socket = nil;
	self->logContext = nil;
	self->_x_id = ((long long)0);
	self->ioEntry = nil;
	self->storageIndex = 0;
	self->_x_id = ((long long)SympathyNetworkConnectionIdcounter++);
	return(self);
}

- (long long) getId {
	return(self->_x_id);
}

- (id<SympathyConnectedSocket>) getSocket {
	return(self->socket);
}

- (SympathyNetworkConnectionManager*) getManager {
	return(self->manager);
}

- (long long) getLastActivity {
	return(self->lastActivity);
}

- (NSString*) getRemoteAddress {
	if(({ NSString* _s1 = self->remoteAddress; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		SympathyTCPSocket* ts = ((SympathyTCPSocket*)({ id _v = self->socket; [_v isKindOfClass:[SympathyTCPSocket class]] ? _v : nil; }));
		if(ts != nil) {
			self->remoteAddress = [[([ts getRemoteAddress]) stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:[ts getRemotePort]])];
		}
	}
	return(self->remoteAddress);
}

- (void) logDebug:(NSString*)text {
	[CapeLog debug:self->logContext message:[[[@"[Connection:" stringByAppendingString:([CapeString forInteger:((int)[self getId])])] stringByAppendingString:@"] "] stringByAppendingString:text]];
}

- (void) logError:(NSString*)text {
	[CapeLog error:self->logContext message:[[[@"[Connection:" stringByAppendingString:([CapeString forInteger:((int)[self getId])])] stringByAppendingString:@"] "] stringByAppendingString:text]];
}

- (void) onActivity {
	self->lastActivity = [CapeSystemClock asSeconds];
}

- (BOOL) initialize {
	return(TRUE);
}

- (void) cleanup {
}

- (BOOL) doInitialize:(id<CapeLoggingContext>)logContext socket:(id<SympathyConnectedSocket>)socket manager:(SympathyNetworkConnectionManager*)manager {
	self->logContext = logContext;
	self->socket = socket;
	self->manager = manager;
	if([self initialize] == FALSE) {
		return(FALSE);
	}
	[self onActivity];
	return(TRUE);
}

- (id<SympathyIOManagerEntry>) getIoEntry {
	return(self->ioEntry);
}

- (void) setIoEntry:(id<SympathyIOManagerEntry>)entry {
	self->ioEntry = entry;
	self->currentListenMode = -1;
	if(entry != nil) {
		[self setListenMode:[self getDefaultListenMode]];
	}
}

- (int) sendData:(NSMutableData*)data size:(int)size {
	if(self->socket == nil) {
		return(0);
	}
	int v = [self->socket write:data size:size];
	[self onActivity];
	return(v);
}

- (void) close {
	if(self->socket == nil) {
		return;
	}
	id<SympathyConnectedSocket> ss = self->socket;
	self->socket = nil;
	if(self->ioEntry != nil) {
		[self->ioEntry remove];
		self->ioEntry = nil;
	}
	[ss close];
	if(self->manager != nil) {
		[self->manager onConnectionClosed:self];
	}
	[self cleanup];
	[self onClosed];
	self->socket = nil;
	self->manager = nil;
}

- (void) onReadReady {
	if(self->socket == nil) {
		return;
	}
	NSMutableData* recvBuffer = nil;
	if(self->manager != nil) {
		recvBuffer = [self->manager getReceiveBuffer];
	}
	if(recvBuffer == nil) {
		recvBuffer = [NSMutableData dataWithLength:1024];
	}
	int n = [self->socket read:recvBuffer];
	if(n < 0) {
		[self close];
	}
	else {
		[self onDataReceived:recvBuffer size:n];
	}
	[self onActivity];
}

- (void) onWriteReady {
}

- (void) enableIdleMode {
	[self setListenMode:0];
}

- (void) enableReadMode {
	[self setListenMode:1];
}

- (void) enableWriteMode {
	[self setListenMode:2];
}

- (void) enableReadWriteMode {
	[self setListenMode:3];
}

- (void) setListenMode:(int)n {
	if(self->ioEntry == nil) {
		self->defaultListenMode = n;
		return;
	}
	if(n == self->currentListenMode) {
		return;
	}
	self->currentListenMode = n;
	if(n == 0) {
		[self->ioEntry setListeners:nil wrl:nil];
	}
	else {
		if(n == 1) {
			[self->ioEntry setListeners:^void() {
				[self onReadReady];
			} wrl:nil];
		}
		else {
			if(n == 2) {
				[self->ioEntry setListeners:nil wrl:^void() {
					[self onWriteReady];
				}];
			}
			else {
				if(n == 3) {
					[self->ioEntry setListeners:^void() {
						[self onReadReady];
					} wrl:^void() {
						[self onWriteReady];
					}];
				}
			}
		}
	}
}

- (void) onOpened {
}

- (void) onDataReceived:(NSMutableData*)data size:(int)size {
}

- (void) onClosed {
}

- (void) onError:(NSString*)message {
}

- (int) getStorageIndex {
	return(self->storageIndex);
}

- (SympathyNetworkConnection*) setStorageIndex:(int)v {
	self->storageIndex = v;
	return(self);
}

- (int) getDefaultListenMode {
	return(self->defaultListenMode);
}

- (SympathyNetworkConnection*) setDefaultListenMode:(int)v {
	self->defaultListenMode = v;
	return(self);
}

@end
