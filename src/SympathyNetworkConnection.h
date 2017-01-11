
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

@protocol SympathyIOManagerEntry;
@protocol CapeLoggingContext;
@protocol SympathyConnectedSocket;
@class SympathyNetworkConnectionManager;

@interface SympathyNetworkConnection : NSObject
{
	@protected id<CapeLoggingContext> logContext;
	@protected id<SympathyConnectedSocket> socket;
	@protected long long lastActivity;
}
- (SympathyNetworkConnection*) init;
- (long long) getId;
- (id<SympathyConnectedSocket>) getSocket;
- (SympathyNetworkConnectionManager*) getManager;
- (long long) getLastActivity;
- (NSString*) getRemoteAddress;
- (void) logDebug:(NSString*)text;
- (void) logError:(NSString*)text;
- (void) onActivity;
- (BOOL) initialize;
- (void) cleanup;
- (BOOL) doInitialize:(id<CapeLoggingContext>)logContext socket:(id<SympathyConnectedSocket>)socket manager:(SympathyNetworkConnectionManager*)manager;
- (id<SympathyIOManagerEntry>) getIoEntry;
- (void) setIoEntry:(id<SympathyIOManagerEntry>)entry;
- (int) sendData:(NSMutableData*)data size:(int)size;
- (void) close;
- (void) onReadReady;
- (void) onWriteReady;
- (void) enableIdleMode;
- (void) enableReadMode;
- (void) enableWriteMode;
- (void) enableReadWriteMode;
- (void) onOpened;
- (void) onDataReceived:(NSMutableData*)data size:(int)size;
- (void) onClosed;
- (void) onError:(NSString*)message;
- (int) getStorageIndex;
- (SympathyNetworkConnection*) setStorageIndex:(int)v;
- (int) getDefaultListenMode;
- (SympathyNetworkConnection*) setDefaultListenMode:(int)v;
@end
