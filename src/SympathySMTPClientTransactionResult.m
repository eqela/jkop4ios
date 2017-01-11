
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
#import "CapeDynamicVector.h"
#import "SympathySMTPClientTransactionResult.h"

@implementation SympathySMTPClientTransactionResult

{
	BOOL status;
	NSString* errorMessage;
	NSString* domain;
	NSString* server;
	CapeDynamicVector* recipients;
}

- (SympathySMTPClientTransactionResult*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->recipients = nil;
	self->server = nil;
	self->domain = nil;
	self->errorMessage = nil;
	self->status = FALSE;
	return(self);
}

+ (SympathySMTPClientTransactionResult*) forError:(NSString*)error {
	return([[[[SympathySMTPClientTransactionResult alloc] init] setStatus:FALSE] setErrorMessage:error]);
}

+ (SympathySMTPClientTransactionResult*) forNetworkError {
	return([SympathySMTPClientTransactionResult forError:@"Network communications error"]);
}

+ (SympathySMTPClientTransactionResult*) forSuccess {
	return([[[SympathySMTPClientTransactionResult alloc] init] setStatus:TRUE]);
}

- (BOOL) getStatus {
	return(self->status);
}

- (SympathySMTPClientTransactionResult*) setStatus:(BOOL)v {
	self->status = v;
	return(self);
}

- (NSString*) getErrorMessage {
	return(self->errorMessage);
}

- (SympathySMTPClientTransactionResult*) setErrorMessage:(NSString*)v {
	self->errorMessage = v;
	return(self);
}

- (NSString*) getDomain {
	return(self->domain);
}

- (SympathySMTPClientTransactionResult*) setDomain:(NSString*)v {
	self->domain = v;
	return(self);
}

- (NSString*) getServer {
	return(self->server);
}

- (SympathySMTPClientTransactionResult*) setServer:(NSString*)v {
	self->server = v;
	return(self);
}

- (CapeDynamicVector*) getRecipients {
	return(self->recipients);
}

- (SympathySMTPClientTransactionResult*) setRecipients:(CapeDynamicVector*)v {
	self->recipients = v;
	return(self);
}

@end
