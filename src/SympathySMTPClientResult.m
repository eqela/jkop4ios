
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
#import "SympathySMTPMessage.h"
#import "SympathySMTPClientTransactionResult.h"
#import "CapeDynamicVector.h"
#import "SympathySMTPClientResult.h"

@implementation SympathySMTPClientResult

{
	SympathySMTPMessage* message;
	CapeDynamicVector* transactions;
}

- (SympathySMTPClientResult*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->transactions = nil;
	self->message = nil;
	return(self);
}

+ (SympathySMTPClientResult*) forSuccess {
	return([[SympathySMTPClientResult alloc] init]);
}

+ (SympathySMTPClientResult*) forMessage:(SympathySMTPMessage*)msg {
	return([[[SympathySMTPClientResult alloc] init] setMessage:msg]);
}

+ (SympathySMTPClientResult*) forError:(NSString*)error msg:(SympathySMTPMessage*)msg {
	return([[[[SympathySMTPClientResult alloc] init] setMessage:msg] addTransaction:[SympathySMTPClientTransactionResult forError:error]]);
}

- (BOOL) getStatus {
	if(self->transactions == nil) {
		return(FALSE);
	}
	NSMutableArray* array = [self->transactions toVector];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			SympathySMTPClientTransactionResult* rr = ((SympathySMTPClientTransactionResult*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[SympathySMTPClientTransactionResult class]] ? _v : nil; }));
			if(rr != nil) {
				if([rr getStatus] == FALSE) {
					return(FALSE);
				}
			}
		}
	}
	return(TRUE);
}

- (SympathySMTPClientResult*) addTransaction:(SympathySMTPClientTransactionResult*)r {
	if(r == nil) {
		return(self);
	}
	if(self->transactions == nil) {
		self->transactions = [[CapeDynamicVector alloc] init];
	}
	[self->transactions appendObject:((id)r)];
	return(self);
}

- (SympathySMTPMessage*) getMessage {
	return(self->message);
}

- (SympathySMTPClientResult*) setMessage:(SympathySMTPMessage*)v {
	self->message = v;
	return(self);
}

- (CapeDynamicVector*) getTransactions {
	return(self->transactions);
}

- (SympathySMTPClientResult*) setTransactions:(CapeDynamicVector*)v {
	self->transactions = v;
	return(self);
}

@end
