
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
#import "SympathyHTTPServerRequestHandlerListener.h"
#import "CapeFile.h"
#import "CapeLoggingContext.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerResponse.h"
#import "CapeString.h"
#import "CapeDateTime.h"
#import "CapePrintWriter.h"
#import "CapePrintWriterWrapper.h"
#import "CapeWriter.h"
#import "CapeLog.h"
#import "SympathyHTTPServerRequestLogger.h"

@implementation SympathyHTTPServerRequestLogger

{
	id<CapeFile> logdir;
	id<CapeLoggingContext> logContext;
}

- (SympathyHTTPServerRequestLogger*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->logContext = nil;
	self->logdir = nil;
	return(self);
}

- (void) onRequestHandled:(SympathyHTTPServerRequest*)request resp:(SympathyHTTPServerResponse*)resp written:(int)written aremoteAddress:(NSString*)aremoteAddress {
	NSString* remoteAddress = aremoteAddress;
	if([CapeString isEmpty:remoteAddress]) {
		remoteAddress = @"-";
	}
	NSString* username = nil;
	if([CapeString isEmpty:username]) {
		username = @"-";
	}
	NSString* sessionid = nil;
	if([CapeString isEmpty:sessionid]) {
		sessionid = @"-";
	}
	CapeDateTime* dt = [CapeDateTime forNow];
	NSString* logTime = nil;
	if(dt != nil) {
		logTime = [[[[[[[[[[[([CapeString forInteger:[dt getDayOfMonth]]) stringByAppendingString:@"/"] stringByAppendingString:([CapeString forInteger:[dt getMonth]])] stringByAppendingString:@"/"] stringByAppendingString:([CapeString forInteger:[dt getYear]])] stringByAppendingString:@"/"] stringByAppendingString:([CapeString forInteger:[dt getHours]])] stringByAppendingString:@"/"] stringByAppendingString:([CapeString forInteger:[dt getMinutes]])] stringByAppendingString:@"/"] stringByAppendingString:([CapeString forInteger:[dt getSeconds]])] stringByAppendingString:@" UTC"];
	}
	else {
		logTime = @"[DATE/TIME]";
	}
	NSString* rf = [request getHeader:@"referer"];
	if([CapeString isEmpty:rf]) {
		rf = @"-";
	}
	NSString* logLine = [[[[[[[[[[[[[[[[[[[[[remoteAddress stringByAppendingString:@" "] stringByAppendingString:username] stringByAppendingString:@" "] stringByAppendingString:sessionid] stringByAppendingString:@" ["] stringByAppendingString:logTime] stringByAppendingString:@"] \""] stringByAppendingString:([request getMethod])] stringByAppendingString:@" "] stringByAppendingString:([request getURLPath])] stringByAppendingString:@" "] stringByAppendingString:([request getVersion])] stringByAppendingString:@"\" "] stringByAppendingString:([resp getStatus])] stringByAppendingString:@" "] stringByAppendingString:([CapeString forInteger:written])] stringByAppendingString:@" \""] stringByAppendingString:rf] stringByAppendingString:@"\" \""] stringByAppendingString:([request getHeader:@"user-agent"])] stringByAppendingString:@"\""];
	if(self->logdir != nil) {
		NSString* logidname = nil;
		if(dt != nil) {
			logidname = [[[[@"accesslog_" stringByAppendingString:([CapeString forInteger:[dt getYear]])] stringByAppendingString:([CapeString forInteger:[dt getMonth]])] stringByAppendingString:([CapeString forInteger:[dt getDayOfMonth]])] stringByAppendingString:@".log"];
		}
		else {
			logidname = @"accesslog.log";
		}
		id<CapePrintWriter> os = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)[[self->logdir entry:logidname] append])];
		if(os == nil && [self->logdir isDirectory] == FALSE) {
			[self->logdir createDirectoryRecursive];
			os = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)[[self->logdir entry:logidname] append])];
		}
		if(os != nil) {
			[os println:logLine];
		}
		[CapeLog debug:self->logContext message:logLine];
	}
	else {
		if(self->logContext != nil) {
			[CapeLog info:self->logContext message:logLine];
		}
		else {
			NSLog(@"%@", logLine);
		}
	}
}

- (id<CapeFile>) getLogdir {
	return(self->logdir);
}

- (SympathyHTTPServerRequestLogger*) setLogdir:(id<CapeFile>)v {
	self->logdir = v;
	return(self);
}

- (id<CapeLoggingContext>) getLogContext {
	return(self->logContext);
}

- (SympathyHTTPServerRequestLogger*) setLogContext:(id<CapeLoggingContext>)v {
	self->logContext = v;
	return(self);
}

@end
