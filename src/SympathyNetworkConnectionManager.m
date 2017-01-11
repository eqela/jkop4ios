
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
#import "CapeLoggingContext.h"
#import "CapeLog.h"
#import "CapeString.h"
#import "CapeIterator.h"
#import "SympathyIOManager.h"
#import "SympathyConnectedSocket.h"
#import "CapeClosable.h"
#import "SympathyIOManagerEntry.h"
#import "SympathyNetworkConnectionManager.h"

@class SympathyNetworkConnectionManagerConnectionPool;
@class SympathyNetworkConnectionManagerConnectionIterator;

@implementation SympathyNetworkConnectionManagerConnectionPool

- (SympathyNetworkConnectionManagerConnectionPool*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->nConnection = 0;
	self->connections = nil;
	return(self);
}

- (BOOL) initialize:(id<CapeLoggingContext>)logContext maxConnections:(int)maxConnections {
	self->connections = [[NSMutableArray alloc] initWithCapacity:maxConnections];
	return(TRUE);
}

- (int) add:(id<CapeLoggingContext>)logContext conn:(SympathyNetworkConnection*)conn {
	if(self->nConnection >= [self->connections count]) {
		[CapeLog error:logContext message:@"Maximum number of connections exceeded."];
		return(-1);
	}
	[self->connections insertObject:(id)({ id _v = conn; _v == nil ? [NSNull null] : _v; }) atIndex:self->nConnection];
	int v = self->nConnection;
	self->nConnection++;
	[CapeLog debug:logContext message:[[@"Added connection to connection pool: Now " stringByAppendingString:([CapeString forInteger:self->nConnection])] stringByAppendingString:@" connections"]];
	return(v);
}

- (BOOL) remove:(id<CapeLoggingContext>)logContext index:(int)index {
	if(index < 0 || index >= self->nConnection) {
		return(FALSE);
	}
	if(((SympathyNetworkConnection*)[self->connections objectAtIndex:index]) == nil) {
		return(FALSE);
	}
	int last = self->nConnection - 1;
	if(last == index) {
		[self->connections insertObject:(id)({ id _v = nil; _v == nil ? [NSNull null] : _v; }) atIndex:index];
		self->nConnection--;
	}
	else {
		[self->connections insertObject:(id)({ id _v = ((SympathyNetworkConnection*)[self->connections objectAtIndex:last]); _v == nil ? [NSNull null] : _v; }) atIndex:index];
		[self->connections insertObject:(id)({ id _v = nil; _v == nil ? [NSNull null] : _v; }) atIndex:last];
		SympathyNetworkConnection* ci = ((SympathyNetworkConnection*)[self->connections objectAtIndex:index]);
		[ci setStorageIndex:index];
		self->nConnection--;
	}
	[CapeLog debug:logContext message:[[@"Removed connection from connection pool: Now " stringByAppendingString:([CapeString forInteger:self->nConnection])] stringByAppendingString:@" connections"]];
	return(TRUE);
}

@end

@interface SympathyNetworkConnectionManagerConnectionIterator : NSObject <CapeIterator>
- (SympathyNetworkConnectionManagerConnectionIterator*) init;
- (SympathyNetworkConnection*) next;
- (SympathyNetworkConnectionManagerConnectionPool*) getPool;
- (SympathyNetworkConnectionManagerConnectionIterator*) setPool:(SympathyNetworkConnectionManagerConnectionPool*)v;
@end

@implementation SympathyNetworkConnectionManagerConnectionIterator

{
	SympathyNetworkConnectionManagerConnectionPool* pool;
	int current;
}

- (SympathyNetworkConnectionManagerConnectionIterator*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->current = -1;
	self->pool = nil;
	return(self);
}

- (SympathyNetworkConnection*) next {
	if(self->pool == nil) {
		return(nil);
	}
	int nn = self->current + 1;
	if(nn >= self->pool->nConnection) {
		return(nil);
	}
	SympathyNetworkConnection* connection = ((SympathyNetworkConnection*)({ id _v = ((SympathyNetworkConnection*)[self->pool->connections objectAtIndex:nn]); [_v isKindOfClass:[SympathyNetworkConnection class]] ? _v : nil; }));
	if(connection == nil) {
		return(nil);
	}
	self->current = nn;
	return(connection);
}

- (SympathyNetworkConnectionManagerConnectionPool*) getPool {
	return(self->pool);
}

- (SympathyNetworkConnectionManagerConnectionIterator*) setPool:(SympathyNetworkConnectionManagerConnectionPool*)v {
	self->pool = v;
	return(self);
}

@end

@implementation SympathyNetworkConnectionManager

{
	int maxConnections;
	int recvBufferSize;
	NSMutableData* recvBuffer;
}

- (SympathyNetworkConnectionManager*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->recvBuffer = nil;
	self->connections = nil;
	self->recvBufferSize = 32768;
	self->maxConnections = 100000;
	self->ioManager = nil;
	self->logContext = nil;
	return(self);
}

- (SympathyNetworkConnection*) createConnectionObject {
}

- (SympathyNetworkConnectionManager*) setLogContext:(id<CapeLoggingContext>)ctx {
	self->logContext = ctx;
	return(self);
}

- (id<CapeLoggingContext>) getLogContext {
	return(self->logContext);
}

- (SympathyNetworkConnectionManager*) setIoManager:(SympathyIOManager*)io {
	self->ioManager = io;
	return(self);
}

- (SympathyIOManager*) getIoManager {
	return(self->ioManager);
}

- (id<CapeIterator>) iterateConnections {
	return(((id<CapeIterator>)[[[SympathyNetworkConnectionManagerConnectionIterator alloc] init] setPool:self->connections]));
}

- (void) forEachConnection:(void(^)(SympathyNetworkConnection*))function {
	id<CapeIterator> it = [self iterateConnections];
	if(it == nil) {
		return;
	}
	while(TRUE) {
		SympathyNetworkConnection* cc = ((SympathyNetworkConnection*)[it next]);
		if(cc == nil) {
			break;
		}
		function(cc);
	}
}

- (BOOL) isInitialized {
	if(self->connections == nil) {
		return(FALSE);
	}
	return(TRUE);
}

- (BOOL) initializeIOManagerAndLoggingContext:(SympathyIOManager*)ioManager logContext:(id<CapeLoggingContext>)logContext {
	if(ioManager == nil) {
		return(FALSE);
	}
	[self setLogContext:logContext];
	[self setIoManager:ioManager];
	return([self initialize]);
}

- (BOOL) initialize {
	if(self->connections != nil) {
		[CapeLog error:self->logContext message:@"Already initialized"];
		return(FALSE);
	}
	if(self->ioManager == nil) {
		[CapeLog error:self->logContext message:@"No IO manager configured for connection server"];
		return(FALSE);
	}
	self->recvBuffer = [NSMutableData dataWithLength:self->recvBufferSize];
	if(self->recvBuffer == nil) {
		[CapeLog error:self->logContext message:@"Failed to allocate recv buffer"];
		return(FALSE);
	}
	self->connections = [[SympathyNetworkConnectionManagerConnectionPool alloc] init];
	if([self->connections initialize:self->logContext maxConnections:self->maxConnections] == FALSE) {
		[CapeLog error:self->logContext message:@"Failed to initialize connection pool"];
		self->connections = nil;
		self->recvBuffer = nil;
		return(FALSE);
	}
	return(TRUE);
}

- (void) cleanup {
	self->connections = nil;
}

- (void) onNewSocket:(id<SympathyConnectedSocket>)socket {
	if(socket == nil) {
		return;
	}
	SympathyNetworkConnection* connection = [self createConnectionObject];
	if(connection == nil) {
		[CapeLog error:self->logContext message:@"Failed to create TCP server connection object instance for incoming connection"];
		[socket close];
		return;
	}
	if([connection doInitialize:self->logContext socket:socket manager:self] == FALSE) {
		[CapeLog error:self->logContext message:@"Failed to initialize the new connection instance. Closing connection."];
		[socket close];
		return;
	}
	if([self addConnection:connection] == FALSE) {
		[CapeLog error:self->logContext message:@"Failed to add a new connection instance. Closing connection."];
		[connection close];
		return;
	}
	[connection onOpened];
}

- (BOOL) addConnection:(SympathyNetworkConnection*)connection {
	if(connection == nil || self->ioManager == nil) {
		return(FALSE);
	}
	id<SympathyIOManagerEntry> es = [self->ioManager add:((id)[connection getSocket])];
	if(es == nil) {
		return(FALSE);
	}
	[connection setIoEntry:es];
	int idx = [self->connections add:self->logContext conn:connection];
	if(idx < 0) {
		return(FALSE);
	}
	[connection setStorageIndex:idx];
	return(TRUE);
}

- (void) onConnectionClosed:(SympathyNetworkConnection*)connection {
	if(connection == nil) {
		return;
	}
	id<SympathyIOManagerEntry> es = [connection getIoEntry];
	if(es != nil) {
		[es remove];
		[connection setIoEntry:nil];
	}
	int si = [connection getStorageIndex];
	if(si >= 0) {
		[self->connections remove:self->logContext index:si];
		[connection setStorageIndex:-1];
	}
}

- (NSMutableData*) getReceiveBuffer {
	return(self->recvBuffer);
}

- (int) getMaxConnections {
	return(self->maxConnections);
}

- (SympathyNetworkConnectionManager*) setMaxConnections:(int)v {
	self->maxConnections = v;
	return(self);
}

- (int) getRecvBufferSize {
	return(self->recvBufferSize);
}

- (SympathyNetworkConnectionManager*) setRecvBufferSize:(int)v {
	self->recvBufferSize = v;
	return(self);
}

@end
