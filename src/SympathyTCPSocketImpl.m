
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
#import <errno.h>
#import <string.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <fcntl.h>
#import "SympathyTCPSocket.h"
#import "CapeFileDescriptor.h"
#import "CapeString.h"
#import "SympathyTCPSocketImpl.h"

@implementation SympathyTCPSocketImpl

{
	int fileDescriptor;
	BOOL blocking;
}

-(void)dealloc {
	[self close];
}

- (SympathyTCPSocketImpl*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->blocking = TRUE;
	self->fileDescriptor = -1;
	return(self);
}

- (NSString*) getRemoteAddress {
	int r = 0;
	socklen_t s = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	r = getpeername(fileDescriptor, (struct sockaddr*)(&new_addr), &s);
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

- (int) getRemotePort {
	int r = 0;
	socklen_t s = (socklen_t)sizeof(struct sockaddr_in);
	struct sockaddr_in new_addr;
	r = getpeername(fileDescriptor, (struct sockaddr*)(&new_addr), &s);
	if(r < 0) {
		return(0);
	}
	r = ntohs(new_addr.sin_port);
	return(r);
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

- (void) close {
	if(self->fileDescriptor < 0) {
		return;
	}
	int r = 0;
	r = close(fileDescriptor);
	if(r < 0) {
		NSString* err = nil;
		const char* ee = strerror(errno);
		if(ee != NULL) {
			err = [[NSString alloc] initWithUTF8String:ee];
		}
		if(!(({ NSString* _s1 = err; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			NSLog(@"%@", [@"Failed to close a TCP socket: " stringByAppendingString:err]);
		}
	}
	else {
		self->fileDescriptor = -1;
	}
}

- (BOOL) setBlocking:(BOOL)blocking {
	if(self->fileDescriptor < 0) {
		return(FALSE);
	}
	if(blocking == FALSE) {
		int f = fcntl(fileDescriptor, F_GETFL, 0);
		fcntl(fileDescriptor, F_SETFL, f | O_NONBLOCK);
	}
	else {
		int f = fcntl(fileDescriptor, F_GETFL, 0);
		fcntl(fileDescriptor, F_SETFL, f & ~O_NONBLOCK);
	}
	self->blocking = blocking;
	return(TRUE);
}

- (BOOL) connect:(NSString*)address port:(int)port {
	if(({ NSString* _s1 = address; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || port < 1 || self->fileDescriptor >= 0) {
		return(FALSE);
	}
	int fd = 0;
	fd = socket(AF_INET, SOCK_STREAM, 0);
	if(fd < 0) {
		NSLog(@"%@", @"Failed to create a new TCP (stream) socket");
		return(FALSE);
	}
	NSString* err = nil;
	int sai_size = sizeof(struct sockaddr_in);
	struct sockaddr_in svr_addr;
	memset(&svr_addr, 0, sai_size);
	svr_addr.sin_family = AF_INET;
	svr_addr.sin_addr.s_addr = inet_addr([address UTF8String]);
	svr_addr.sin_port = htons(port);
	if(connect(fd, (struct sockaddr*)(&svr_addr), sai_size) != 0) {
		char* ee = strerror(errno);
		if(ee == NULL) {
			ee = (char*)"Unknown error";
		}
		err = [[NSString alloc] initWithUTF8String:ee];
	}
	if(!(({ NSString* _s1 = err; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		close(fd);
		NSLog(@"%@", [[[[[@"Failed to connect to `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"': "] stringByAppendingString:err]);
		return(FALSE);
	}
	self->fileDescriptor = fd;
	return(TRUE);
}

- (BOOL) listen:(int)port {
	if(self->fileDescriptor >= 0 || port < 1) {
		return(FALSE);
	}
	int fd = 0;
	int reuseaddr = 1;
	fd = socket(AF_INET, SOCK_STREAM, 0);
	setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (const char*)&reuseaddr, sizeof(int));
	if(fd < 0) {
		NSLog(@"%@", @"Failed to create a new TCP (stream) socket");
		return(FALSE);
	}
	BOOL v = FALSE;
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(struct sockaddr_in));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	if(bind(fd, (struct sockaddr*)(&addr), sizeof(struct sockaddr_in)) >= 0) {
		if(listen(fd, 256) >= 0) {
			v = YES;
		}
	}
	if(v == FALSE) {
		close(fd);
		return(FALSE);
	}
	self->fileDescriptor = fd;
	return(TRUE);
}

- (SympathyTCPSocket*) accept {
	if(self->fileDescriptor < 0) {
		return(nil);
	}
	int newfd = 0;
	newfd = accept(fileDescriptor, NULL, NULL);
	if(newfd < 0) {
		return(nil);
	}
	SympathyTCPSocketImpl* v = [[SympathyTCPSocketImpl alloc] init];
	[v setFileDescriptor:newfd];
	return(((SympathyTCPSocket*)v));
}

- (int) read:(NSMutableData*)buffer {
	if(buffer == nil) {
		return(0);
	}
	if(self->fileDescriptor < 0) {
		return(-1);
	}
	int v = 0;
	v = read(fileDescriptor, [buffer mutableBytes], [buffer length]);
	if(v == 0) {
		v = -1;
	}
	else {
		if(v < 0 && self->blocking == FALSE) {
			if(errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK) {
				v = 0;
			}
		}
	}
	return(v);
}

- (int) write:(NSMutableData*)buffer size:(int)size {
	if(buffer == nil) {
		return(0);
	}
	if(self->fileDescriptor < 0) {
		return(-1);
	}
	int v = 0;
	int sz = size;
	if(sz < 0) {
		sz = [buffer length];
	}
	v = write(fileDescriptor, [buffer bytes], sz);
	if(v < 0 && self->blocking == FALSE) {
		if(errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK) {
			v = 0;
		}
	}
	return(v);
}

- (int) getFileDescriptor {
	return(self->fileDescriptor);
}

- (SympathyTCPSocketImpl*) setFileDescriptor:(int)v {
	self->fileDescriptor = v;
	return(self);
}

@end
