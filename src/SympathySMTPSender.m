
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
#import "CapeLoggingContext.h"
#import "CapeDynamicMap.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "SympathyURL.h"
#import "CapexURLEncoder.h"
#import "CapeLog.h"
#import "SympathySMTPMessage.h"
#import "SympathySMTPSenderListener.h"
#import "SympathySMTPClientResult.h"
#import "CapeDynamicVector.h"
#import "SympathySMTPClientTask.h"
#import "CapeThread.h"
#import "CapeRunnable.h"
#import "SympathySMTPSender.h"

@implementation SympathySMTPSender

{
	NSString* thisServerAddress;
	NSString* server;
	NSString* myName;
	NSString* myAddress;
	id<CapeLoggingContext> ctx;
	int maxSenderCount;
	NSString* serverInternal;
	int senderCount;
}

+ (SympathySMTPSender*) forServerAddress:(NSString*)name ctx:(id<CapeLoggingContext>)ctx {
	return([[[[SympathySMTPSender alloc] init] setThisServerAddress:name] setCtx:ctx]);
}

+ (SympathySMTPSender*) forConfiguration:(CapeDynamicMap*)config ctx:(id<CapeLoggingContext>)ctx {
	return([[[[SympathySMTPSender alloc] init] setCtx:ctx] configure:config]);
}

- (SympathySMTPSender*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->senderCount = 0;
	self->serverInternal = nil;
	self->maxSenderCount = 0;
	self->ctx = nil;
	self->myAddress = nil;
	self->myName = nil;
	self->server = nil;
	self->thisServerAddress = nil;
	self->thisServerAddress = @"unknown.server.com";
	return(self);
}

- (NSString*) getDescription {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if([CapeString isEmpty:self->myName] == FALSE) {
		[sb appendCharacter:'\"'];
		[sb appendString:self->myName];
		[sb appendCharacter:'\"'];
	}
	if([CapeString isEmpty:self->myAddress] == FALSE) {
		BOOL hasName = FALSE;
		if([sb count] > 0) {
			hasName = TRUE;
		}
		if(hasName) {
			[sb appendCharacter:' '];
			[sb appendCharacter:'<'];
		}
		[sb appendString:self->myAddress];
		if(hasName) {
			[sb appendCharacter:'>'];
		}
	}
	NSString* s = self->serverInternal;
	if([CapeString isEmpty:s]) {
		s = self->server;
	}
	if([CapeString isEmpty:s] == FALSE) {
		[sb appendCharacter:' '];
		[sb appendCharacter:'('];
		[sb appendString:s];
		[sb appendCharacter:')'];
	}
	if([sb count] < 1) {
		[sb appendString:@"(no configuration; raw passhtrough of messages)"];
	}
	return([sb toString]);
}

- (SympathySMTPSender*) configure:(CapeDynamicMap*)config {
	if(config == nil) {
		return(self);
	}
	NSString* defaultPort = @"25";
	NSString* scheme = [config getString:@"server_type" defval:@"smtp"];
	if([CapeString equals:@"smtp+ssl" str2:scheme]) {
		defaultPort = @"465";
	}
	SympathyURL* url = [[[[[[[SympathyURL alloc] init] setScheme:scheme] setUsername:[CapexURLEncoder encode:[config getString:@"server_username" defval:nil] percentOnly:FALSE encodeUnreservedChars:TRUE]] setPassword:[CapexURLEncoder encode:[config getString:@"server_password" defval:nil] percentOnly:FALSE encodeUnreservedChars:TRUE]] setHost:[config getString:@"server_address" defval:nil]] setPort:[config getString:@"server_port" defval:defaultPort]];
	[self setServer:[url toString]];
	[url setPassword:nil];
	self->serverInternal = [url toString];
	[self setMyName:[config getString:@"sender_name" defval:@"SMTP"]];
	[self setMyAddress:[config getString:@"sender_address" defval:@"my@address.com"]];
	[self setThisServerAddress:[config getString:@"this_server_address" defval:self->thisServerAddress]];
	return(self);
}

- (void) onSendStart {
	self->senderCount++;
	[CapeLog debug:self->ctx message:[[@"SMTP send start: Now " stringByAppendingString:([CapeString forInteger:self->senderCount])] stringByAppendingString:@" sender(s)"]];
}

- (void) onSendEnd {
	self->senderCount--;
	[CapeLog debug:self->ctx message:[[@"SMTP send end: Now " stringByAppendingString:([CapeString forInteger:self->senderCount])] stringByAppendingString:@" sender(s)"]];
}

- (void) send:(SympathySMTPMessage*)msg listener:(id<SympathySMTPSenderListener>)listener {
	if(msg == nil) {
		if(listener != nil) {
			[listener onSMTPSendComplete:msg result:[SympathySMTPClientResult forError:@"No message to send" msg:nil]];
		}
		return;
	}
	CapeDynamicVector* rcpts = [msg getAllRcpts];
	if(rcpts == nil || [rcpts getSize] < 1) {
		if(listener != nil) {
			[listener onSMTPSendComplete:msg result:[SympathySMTPClientResult forSuccess]];
		}
		return;
	}
	if(self->maxSenderCount > 0 && self->senderCount > self->maxSenderCount) {
		[CapeLog warning:self->ctx message:[@"Reached maximum sender count " stringByAppendingString:([CapeString forInteger:self->maxSenderCount])]];
		if(listener != nil) {
			[listener onSMTPSendComplete:msg result:[SympathySMTPClientResult forError:@"Maximum number of SMTP senders has been exceeded." msg:nil]];
		}
		return;
	}
	if([CapeString isEmpty:self->myName] == FALSE) {
		[msg setMyName:self->myName];
	}
	if([CapeString isEmpty:self->myAddress] == FALSE) {
		[msg setMyAddress:self->myAddress];
	}
	SympathySMTPClientTask* sct = [[SympathySMTPClientTask alloc] init];
	if([CapeString isEmpty:self->server] == FALSE) {
		[sct setServer:[SympathyURL forString:self->server normalizePath:FALSE]];
	}
	[sct setCtx:self->ctx];
	[sct setServerAddress:self->thisServerAddress];
	[sct setMsg:msg];
	[sct setListener:listener];
	[sct setSender:self];
	if([CapeThread start:((id<CapeRunnable>)sct)] == FALSE) {
		[CapeLog error:self->ctx message:@"Failed to start SMTP sender background task"];
		if(listener != nil) {
			[listener onSMTPSendComplete:msg result:[SympathySMTPClientResult forError:@"Failed to start SMTP sender background task" msg:nil]];
		}
		return;
	}
	[self onSendStart];
}

- (NSString*) getThisServerAddress {
	return(self->thisServerAddress);
}

- (SympathySMTPSender*) setThisServerAddress:(NSString*)v {
	self->thisServerAddress = v;
	return(self);
}

- (NSString*) getServer {
	return(self->server);
}

- (SympathySMTPSender*) setServer:(NSString*)v {
	self->server = v;
	return(self);
}

- (NSString*) getMyName {
	return(self->myName);
}

- (SympathySMTPSender*) setMyName:(NSString*)v {
	self->myName = v;
	return(self);
}

- (NSString*) getMyAddress {
	return(self->myAddress);
}

- (SympathySMTPSender*) setMyAddress:(NSString*)v {
	self->myAddress = v;
	return(self);
}

- (id<CapeLoggingContext>) getCtx {
	return(self->ctx);
}

- (SympathySMTPSender*) setCtx:(id<CapeLoggingContext>)v {
	self->ctx = v;
	return(self);
}

- (int) getMaxSenderCount {
	return(self->maxSenderCount);
}

- (SympathySMTPSender*) setMaxSenderCount:(int)v {
	self->maxSenderCount = v;
	return(self);
}

@end
