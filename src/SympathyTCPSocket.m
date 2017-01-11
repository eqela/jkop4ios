
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
#import "SympathyConnectedSocket.h"
#import "SympathyTCPSocketImpl.h"
#import "SympathyTCPSocket.h"

@implementation SympathyTCPSocket

- (SympathyTCPSocket*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (SympathyTCPSocket*) create {
	return(((SympathyTCPSocket*)[[SympathyTCPSocketImpl alloc] init]));
}

+ (SympathyTCPSocket*) createAndConnect:(NSString*)address port:(int)port {
	SympathyTCPSocket* v = [SympathyTCPSocket create];
	if(v == nil) {
		return(nil);
	}
	if([v connect:address port:port] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (SympathyTCPSocket*) createAndListen:(int)port {
	SympathyTCPSocket* v = [SympathyTCPSocket create];
	if(v == nil) {
		return(nil);
	}
	if([v listen:port] == FALSE) {
		v = nil;
	}
	return(v);
}

- (NSString*) getRemoteAddress {
}

- (int) getRemotePort {
}

- (NSString*) getLocalAddress {
}

- (int) getLocalPort {
}

- (BOOL) connect:(NSString*)address port:(int)port {
}

- (BOOL) listen:(int)port {
}

- (SympathyTCPSocket*) accept {
}

- (BOOL) setBlocking:(BOOL)blocking {
}

- (void) close {
}

- (int) read:(NSMutableData*)buffer {
}

- (int) readWithTimeout:(NSMutableData*)buffer timeout:(int)timeout {
	return([self read:buffer]);
}

- (int) write:(NSMutableData*)buffer size:(int)size {
}

@end
