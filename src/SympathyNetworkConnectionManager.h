
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

@class SympathyNetworkConnectionManagerConnectionPool;
@class SympathyNetworkConnection;
@protocol CapeLoggingContext;
@protocol CapeIterator;
@class SympathyNetworkConnectionManagerConnectionIterator;
@class SympathyIOManager;
@protocol SympathyConnectedSocket;
@class SympathyNetworkConnectionManager;

@interface SympathyNetworkConnectionManagerConnectionPool : NSObject
{
	@public NSMutableArray* connections;
	@public int nConnection;
}
- (SympathyNetworkConnectionManagerConnectionPool*) init;
- (BOOL) initialize:(id<CapeLoggingContext>)logContext maxConnections:(int)maxConnections;
- (int) add:(id<CapeLoggingContext>)logContext conn:(SympathyNetworkConnection*)conn;
- (BOOL) remove:(id<CapeLoggingContext>)logContext index:(int)index;
@end

@interface SympathyNetworkConnectionManager : NSObject
{
	@protected id<CapeLoggingContext> logContext;
	@protected SympathyIOManager* ioManager;
	@protected SympathyNetworkConnectionManagerConnectionPool* connections;
}
- (SympathyNetworkConnectionManager*) init;
- (SympathyNetworkConnection*) createConnectionObject;
- (SympathyNetworkConnectionManager*) setLogContext:(id<CapeLoggingContext>)ctx;
- (id<CapeLoggingContext>) getLogContext;
- (SympathyNetworkConnectionManager*) setIoManager:(SympathyIOManager*)io;
- (SympathyIOManager*) getIoManager;
- (id<CapeIterator>) iterateConnections;
- (void) forEachConnection:(void(^)(SympathyNetworkConnection*))function;
- (BOOL) isInitialized;
- (BOOL) initializeIOManagerAndLoggingContext:(SympathyIOManager*)ioManager logContext:(id<CapeLoggingContext>)logContext;
- (BOOL) initialize;
- (void) cleanup;
- (void) onNewSocket:(id<SympathyConnectedSocket>)socket;
- (BOOL) addConnection:(SympathyNetworkConnection*)connection;
- (void) onConnectionClosed:(SympathyNetworkConnection*)connection;
- (NSMutableData*) getReceiveBuffer;
- (int) getMaxConnections;
- (SympathyNetworkConnectionManager*) setMaxConnections:(int)v;
- (int) getRecvBufferSize;
- (SympathyNetworkConnectionManager*) setRecvBufferSize:(int)v;
@end
