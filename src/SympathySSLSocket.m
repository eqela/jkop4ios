
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
#import "CapeLoggingContext.h"
#import "CapeFile.h"
#import "SympathySSLSocket.h"

@implementation SympathySSLSocket

- (SympathySSLSocket*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (SympathySSLSocket*) createInstance:(id<SympathyConnectedSocket>)cSocket serverAddress:(NSString*)serverAddress ctx:(id<CapeLoggingContext>)ctx certFile:(id<CapeFile>)certFile keyFile:(id<CapeFile>)keyFile isServer:(BOOL)isServer acceptInvalidCertificate:(BOOL)acceptInvalidCertificate {
	if(cSocket == nil) {
		return(nil);
	}
	SympathySSLSocket* v = nil;
	return(v);
}

+ (SympathySSLSocket*) forClient:(id<SympathyConnectedSocket>)cSocket hostAddress:(NSString*)hostAddress ctx:(id<CapeLoggingContext>)ctx acceptInvalidCertificate:(BOOL)acceptInvalidCertificate {
	return([SympathySSLSocket createInstance:cSocket serverAddress:hostAddress ctx:ctx certFile:nil keyFile:nil isServer:FALSE acceptInvalidCertificate:acceptInvalidCertificate]);
}

+ (SympathySSLSocket*) forServer:(id<SympathyConnectedSocket>)cSocket certFile:(id<CapeFile>)certFile keyFile:(id<CapeFile>)keyFile ctx:(id<CapeLoggingContext>)ctx {
	return([SympathySSLSocket createInstance:cSocket serverAddress:nil ctx:ctx certFile:certFile keyFile:keyFile isServer:TRUE acceptInvalidCertificate:FALSE]);
}

- (void) setAcceptInvalidCertificate:(BOOL)accept {
}

- (void) close {
}

- (int) read:(NSMutableData*)buffer {
}

- (int) readWithTimeout:(NSMutableData*)buffer timeout:(int)timeout {
}

- (int) write:(NSMutableData*)buffer size:(int)size {
}

- (id<SympathyConnectedSocket>) getSocket {
}

@end
