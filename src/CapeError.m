
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
#import "CapeStringObject.h"
#import "CapeString.h"
#import "CapeError.h"

@implementation CapeError

{
	NSString* code;
	NSString* message;
	NSString* detail;
}

- (CapeError*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->detail = nil;
	self->message = nil;
	self->code = nil;
	return(self);
}

+ (CapeError*) forCode:(NSString*)code detail:(NSString*)detail {
	return([[[[CapeError alloc] init] setCode:code] setDetail:detail]);
}

+ (CapeError*) forMessage:(NSString*)message {
	return([[[CapeError alloc] init] setMessage:message]);
}

+ (CapeError*) instance:(NSString*)code message:(NSString*)message detail:(NSString*)detail {
	return([[[[[CapeError alloc] init] setCode:code] setMessage:message] setDetail:detail]);
}

+ (CapeError*) set:(CapeError*)error code:(NSString*)code message:(NSString*)message {
	if(error == nil) {
		return(nil);
	}
	[error setCode:code];
	[error setMessage:message];
	return(error);
}

+ (CapeError*) setErrorCode:(CapeError*)error code:(NSString*)code {
	return([CapeError set:error code:code message:nil]);
}

+ (CapeError*) setErrorMessage:(CapeError*)error message:(NSString*)message {
	return([CapeError set:error code:nil message:message]);
}

+ (BOOL) isError:(id)o {
	if(o == nil) {
		return(FALSE);
	}
	if([o isKindOfClass:[CapeError class]] == FALSE) {
		return(FALSE);
	}
	CapeError* e = ((CapeError*)({ id _v = o; [_v isKindOfClass:[CapeError class]] ? _v : nil; }));
	if([CapeString isEmpty:[e getCode]] && [CapeString isEmpty:[e getMessage]]) {
		return(FALSE);
	}
	return(TRUE);
}

+ (NSString*) asString:(CapeError*)error {
	if(error == nil) {
		return(nil);
	}
	return([error toString]);
}

- (CapeError*) clear {
	self->code = nil;
	self->message = nil;
	self->detail = nil;
	return(self);
}

- (NSString*) toStringWithDefault:(NSString*)defaultError {
	if([CapeString isEmpty:self->message] == FALSE) {
		return(self->message);
	}
	if([CapeString isEmpty:self->code] == FALSE) {
		if([CapeString isEmpty:self->detail] == FALSE) {
			return([[self->code stringByAppendingString:@":"] stringByAppendingString:self->detail]);
		}
		return(self->code);
	}
	if([CapeString isEmpty:self->detail] == FALSE) {
		return([@"Error with detail: " stringByAppendingString:self->detail]);
	}
	return(defaultError);
}

- (NSString*) toString {
	return([self toStringWithDefault:@"Unknown Error"]);
}

- (NSString*) getCode {
	return(self->code);
}

- (CapeError*) setCode:(NSString*)v {
	self->code = v;
	return(self);
}

- (NSString*) getMessage {
	return(self->message);
}

- (CapeError*) setMessage:(NSString*)v {
	self->message = v;
	return(self);
}

- (NSString*) getDetail {
	return(self->detail);
}

- (CapeError*) setDetail:(NSString*)v {
	self->detail = v;
	return(self);
}

@end
