
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
#import "CapeError.h"
#import "CapeDynamicMap.h"
#import "CapeString.h"
#import "SympathyJSONResponse.h"

@implementation SympathyJSONResponse

- (SympathyJSONResponse*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapeDynamicMap*) forError:(CapeError*)error {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"status" value:((id)@"error")];
	if(error != nil) {
		NSString* code = [error getCode];
		NSString* message = [error getMessage];
		NSString* detail = [error getDetail];
		if([CapeString isEmpty:code] == FALSE) {
			[v setStringAndObject:@"code" value:((id)code)];
		}
		if([CapeString isEmpty:message] == FALSE) {
			[v setStringAndObject:@"message" value:((id)message)];
		}
		if([CapeString isEmpty:detail] == FALSE) {
			[v setStringAndObject:@"detail" value:((id)detail)];
		}
	}
	return(v);
}

+ (CapeDynamicMap*) forErrorCode:(NSString*)code {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"status" value:((id)@"error")];
	[v setStringAndObject:@"code" value:((id)code)];
	return(v);
}

+ (CapeDynamicMap*) forErrorMessage:(NSString*)message code:(NSString*)code {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"status" value:((id)@"error")];
	if([CapeString isEmpty:message] == FALSE) {
		[v setStringAndObject:@"message" value:((id)message)];
	}
	if([CapeString isEmpty:code] == FALSE) {
		[v setStringAndObject:@"code" value:((id)code)];
	}
	return(v);
}

+ (CapeDynamicMap*) forOk:(id)data {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"status" value:((id)@"ok")];
	if(data != nil) {
		[v setStringAndObject:@"data" value:data];
	}
	return(v);
}

+ (CapeDynamicMap*) forDetails:(NSString*)status code:(NSString*)code message:(NSString*)message {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	if([CapeString isEmpty:status] == FALSE) {
		[v setStringAndObject:@"status" value:((id)status)];
	}
	if([CapeString isEmpty:code] == FALSE) {
		[v setStringAndObject:@"code" value:((id)code)];
	}
	if([CapeString isEmpty:message] == FALSE) {
		[v setStringAndObject:@"message" value:((id)message)];
	}
	return(v);
}

+ (CapeDynamicMap*) forMissingData:(NSString*)type {
	if([CapeString isEmpty:type] == FALSE) {
		return([SympathyJSONResponse forErrorMessage:[@"Missing data: " stringByAppendingString:type] code:@"missing_data"]);
	}
	return([SympathyJSONResponse forErrorMessage:@"Missing data" code:@"missing_data"]);
}

+ (CapeDynamicMap*) forInvalidData:(NSString*)type {
	if([CapeString isEmpty:type] == FALSE) {
		return([SympathyJSONResponse forErrorMessage:[@"Invalid data: " stringByAppendingString:type] code:@"invalid_data"]);
	}
	return([SympathyJSONResponse forErrorMessage:@"Invalid data" code:@"invalid_data"]);
}

+ (CapeDynamicMap*) forAlreadyExists {
	return([SympathyJSONResponse forErrorMessage:@"Already exists" code:@"already_exists"]);
}

+ (CapeDynamicMap*) forInvalidRequest:(NSString*)type {
	if([CapeString isEmpty:type] == FALSE) {
		return([SympathyJSONResponse forErrorMessage:[@"Invalid request: " stringByAppendingString:type] code:@"invalid_request"]);
	}
	return([SympathyJSONResponse forErrorMessage:@"Invalid request" code:@"invalid_request"]);
}

+ (CapeDynamicMap*) forNotAllowed {
	return([SympathyJSONResponse forErrorMessage:@"Not allowed" code:@"not_allowed"]);
}

+ (CapeDynamicMap*) forFailedToCreate {
	return([SympathyJSONResponse forErrorMessage:@"Failed to create" code:@"failed_to_create"]);
}

+ (CapeDynamicMap*) forNotFound {
	return([SympathyJSONResponse forErrorMessage:@"Not found" code:@"not_found"]);
}

+ (CapeDynamicMap*) forAuthenticationFailed {
	return([SympathyJSONResponse forErrorMessage:@"Authentication failed" code:@"authentication_failed"]);
}

+ (CapeDynamicMap*) forIncorrectUsernamePassword {
	return([SympathyJSONResponse forErrorMessage:@"Incorrect username and/or password" code:@"authentication_failed"]);
}

+ (CapeDynamicMap*) forInternalError:(NSString*)details {
	if([CapeString isEmpty:details] == FALSE) {
		return([SympathyJSONResponse forErrorMessage:[@"Internal error: " stringByAppendingString:details] code:@"internal_error"]);
	}
	return([SympathyJSONResponse forErrorMessage:@"Internal error" code:@"internal_error"]);
}

@end
