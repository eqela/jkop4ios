
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
#import <unistd.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <string.h>
#import <errno.h>
#import <arpa/inet.h>
#import "SympathyUDPSocket.h"
#import "CapeFileDescriptor.h"
#import "CapeString.h"
#import "SympathyUDPSocketImpl.h"

@implementation SympathyUDPSocketImpl

{
	int fileDescriptor;
}

-(void)dealloc {
	[self close];
}

- (SympathyUDPSocketImpl*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->fileDescriptor = -1;
	fileDescriptor = socket(PF_INET, SOCK_DGRAM, 0);
	return(self);
}

- (int) getFileDescriptor {
	return(self->fileDescriptor);
}

- (void) close {
	if(self->fileDescriptor >= 0) {
		close(fileDescriptor);
		self->fileDescriptor = -1;
	}
}

- (int) send:(NSMutableData*)message address:(NSString*)address port:(int)port {
	if(({ NSString* _s1 = address; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(-1);
	}
	if(message == nil || self->fileDescriptor < 0) {
		return(0);
	}
	int v = 0;
	struct sockaddr_in server_addr;
	memset(&server_addr, 0, sizeof(struct sockaddr_in));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr([address UTF8String]);
	server_addr.sin_port = htons(port);
	v = sendto(fileDescriptor, [message bytes], [message length], 0, (struct sockaddr*)(&server_addr), sizeof(struct sockaddr_in));
	return(v);
}

- (int) sendBroadcast:(NSMutableData*)message address:(NSString*)address port:(int)port {
	int v = 0;
	int flag = 1;
	setsockopt(fileDescriptor, SOL_SOCKET, SO_BROADCAST, (void*)&flag, sizeof(int));
	v = [self send:message address:address port:port];
	flag = 0;
	setsockopt(fileDescriptor, SOL_SOCKET, SO_BROADCAST, (void*)&flag, sizeof(int));
	return(v);
}

- (BOOL) waitForData:(int)timeout {
	BOOL v = FALSE;
	if(self->fileDescriptor < 0) {
		return(FALSE);
	}
	fd_set fdset;
	FD_ZERO(&fdset);
	FD_SET(fileDescriptor, &fdset);
	int r = -1;
	if(timeout < 0) {
		r = select(fileDescriptor+1, &fdset, (void*)0, (void*)0, (void*)0);
	}
	else {
		struct timeval tv;
		tv.tv_sec = timeout / 1000000;
		tv.tv_usec = timeout % 1000000;
		r = select(fileDescriptor+1, &fdset, (void*)0, (void*)0, &tv);
	}
	if(r > 0) {
		if(FD_ISSET(fileDescriptor, &fdset) != 0) {
			v = YES;
		}
	}
	if(r < 0) {
		NSString* err = nil;
		if(errno != EINTR) {
			const char* ep = strerror(errno);
			if(ep != NULL) {
				err = [[NSString alloc] initWithUTF8String:ep];
			}
		}
		if(!(({ NSString* _s1 = err; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			NSLog(@"%@", [[[@"select() returned error status " stringByAppendingString:([CapeString forInteger:r])] stringByAppendingString:@": "] stringByAppendingString:err]);
		}
	}
	return(v);
}

- (int) receive:(NSMutableData*)buffer timeout:(int)timeout {
	if(buffer == nil || self->fileDescriptor < 0) {
		return(0);
	}
	int v = 0;
	if([self waitForData:timeout]) {
		socklen_t l = (socklen_t)sizeof(struct sockaddr_in);
		struct sockaddr_in client_addr;
		v = recvfrom(fileDescriptor, [buffer mutableBytes], [buffer length], 0, (struct sockaddr*)(&client_addr), &l);
	}
	return(v);
}

- (BOOL) bind:(int)port {
	if(self->fileDescriptor < 0) {
		return(FALSE);
	}
	int v = 0;
	struct sockaddr_in server_addr;
	memset(&server_addr, 0, sizeof(struct sockaddr_in));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	server_addr.sin_port = htons(port);
	v = bind(fileDescriptor, (struct sockaddr*)(&server_addr), sizeof(struct sockaddr_in));
	if(v != 0) {
		[self close];
		return(FALSE);
	}
	return(TRUE);
}

- (NSString*) getLocalAddress {
	int r = 0;
	socklen_t s = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	r = getsockname(fileDescriptor, (struct sockaddr*)(&new_addr), &s);
	if(r < 0) {
		return(nil);
	}
	NSString* v = nil;
	char* adds = (char*)inet_ntoa(new_addr.sin_addr);
	if(adds != NULL) {
		v = [[NSString alloc] initWithUTF8String:adds];
	}
	return(v);
}

- (int) getLocalPort {
	int r = 0;
	socklen_t s = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	r = getsockname(fileDescriptor, (struct sockaddr*)(&new_addr), &s);
	if(r < 0) {
		return(0);
	}
	r = ntohs(new_addr.sin_port);
	return(r);
}

@end
