
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
#import "CapeRunnable.h"
#import "CapeLoggingContext.h"
#import "SympathyURL.h"
#import "SympathySMTPMessage.h"
#import "SympathySMTPSenderListener.h"
#import "SympathySMTPSender.h"
#import "SympathySMTPClientResult.h"
#import "SympathySMTPClient.h"
#import "SympathySMTPClientTask.h"

@implementation SympathySMTPClientTask

{
	id<CapeLoggingContext> ctx;
	SympathyURL* server;
	SympathySMTPMessage* msg;
	NSString* serverAddress;
	id<SympathySMTPSenderListener> listener;
	SympathySMTPSender* sender;
}

- (SympathySMTPClientTask*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->sender = nil;
	self->listener = nil;
	self->serverAddress = nil;
	self->msg = nil;
	self->server = nil;
	self->ctx = nil;
	return(self);
}

- (void) run {
	SympathySMTPClientResult* r = nil;
	if(self->msg == nil) {
		r = [SympathySMTPClientResult forError:@"No message was given to SMTPClientTask" msg:self->msg];
	}
	else {
		r = [SympathySMTPClient sendMessage:self->msg server:self->server serverName:self->serverAddress ctx:self->ctx];
	}
	if(r == nil) {
		r = [SympathySMTPClientResult forError:@"Unknown error" msg:self->msg];
	}
	if(self->sender != nil) {
		[self->sender onSendEnd];
	}
	if(self->listener == nil) {
		return;
	}
	[self->listener onSMTPSendComplete:[r getMessage] result:r];
}

- (id<CapeLoggingContext>) getCtx {
	return(self->ctx);
}

- (SympathySMTPClientTask*) setCtx:(id<CapeLoggingContext>)v {
	self->ctx = v;
	return(self);
}

- (SympathyURL*) getServer {
	return(self->server);
}

- (SympathySMTPClientTask*) setServer:(SympathyURL*)v {
	self->server = v;
	return(self);
}

- (SympathySMTPMessage*) getMsg {
	return(self->msg);
}

- (SympathySMTPClientTask*) setMsg:(SympathySMTPMessage*)v {
	self->msg = v;
	return(self);
}

- (NSString*) getServerAddress {
	return(self->serverAddress);
}

- (SympathySMTPClientTask*) setServerAddress:(NSString*)v {
	self->serverAddress = v;
	return(self);
}

- (id<SympathySMTPSenderListener>) getListener {
	return(self->listener);
}

- (SympathySMTPClientTask*) setListener:(id<SympathySMTPSenderListener>)v {
	self->listener = v;
	return(self);
}

- (SympathySMTPSender*) getSender {
	return(self->sender);
}

- (SympathySMTPClientTask*) setSender:(SympathySMTPSender*)v {
	self->sender = v;
	return(self);
}

@end
