
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
#import "CapeFile.h"
#import "CapeString.h"
#import "CapePrintWriter.h"
#import "CapeDateTime.h"
#import "CapePrintWriterWrapper.h"
#import "CapeWriter.h"
#import "CapeFlushableWriter.h"
#import "CapeClosable.h"
#import "SympathyDirectoryLogContext.h"

@implementation SympathyDirectoryLogContext

{
	BOOL enableDebugMessages;
	id<CapeFile> logDir;
	NSString* logIdPrefix;
	id<CapePrintWriter> os;
	NSString* currentLogIdName;
	BOOL alsoPrintOnConsole;
}

-(void)dealloc {
	if(self->os != nil) {
		if([((NSObject*)self->os) conformsToProtocol:@protocol(CapeClosable)]) {
			[((id<CapeClosable>)self->os) close];
		}
		self->os = nil;
	}
}

- (SympathyDirectoryLogContext*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->alsoPrintOnConsole = FALSE;
	self->currentLogIdName = nil;
	self->os = nil;
	self->logIdPrefix = @"messages";
	self->logDir = nil;
	self->enableDebugMessages = TRUE;
	return(self);
}

+ (SympathyDirectoryLogContext*) create:(id<CapeFile>)logDir logIdPrefix:(NSString*)logIdPrefix dbg:(BOOL)dbg {
	SympathyDirectoryLogContext* v = [[SympathyDirectoryLogContext alloc] init];
	[v setLogDir:logDir];
	[v setEnableDebugMessages:dbg];
	if([CapeString isEmpty:logIdPrefix] == FALSE) {
		[v setLogIdPrefix:logIdPrefix];
	}
	return(v);
}

- (void) logError:(NSString*)text {
	[self message:@"ERROR" text:text];
}

- (void) logWarning:(NSString*)text {
	[self message:@"WARNING" text:text];
}

- (void) logInfo:(NSString*)text {
	[self message:@"INFO" text:text];
}

- (void) logDebug:(NSString*)text {
	[self message:@"DEBUG" text:text];
}

- (void) message:(NSString*)type text:(NSString*)text {
	if(self->enableDebugMessages == FALSE && [CapeString equalsIgnoreCase:@"debug" str2:type]) {
		return;
	}
	CapeDateTime* dt = [CapeDateTime forNow];
	NSString* logTime = nil;
	if(dt != nil) {
		logTime = [[[[[[[[[[[([CapeString forInteger:[dt getYear]]) stringByAppendingString:@"-"] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getMonth] length:2 paddingString:nil])] stringByAppendingString:@"-"] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getDayOfMonth] length:2 paddingString:nil])] stringByAppendingString:@" "] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getHours] length:2 paddingString:nil])] stringByAppendingString:@":"] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getMinutes] length:2 paddingString:nil])] stringByAppendingString:@":"] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getSeconds] length:2 paddingString:nil])] stringByAppendingString:@" UTC"];
	}
	else {
		logTime = @"DATE/TIME";
	}
	NSString* logLine = [[[[[@"[" stringByAppendingString:([CapeString padToLength:type length:7 align:-1 paddingCharacter:' '])] stringByAppendingString:@"] ["] stringByAppendingString:logTime] stringByAppendingString:@"]: "] stringByAppendingString:text];
	if(self->logDir != nil) {
		NSString* logIdName = nil;
		if(dt != nil) {
			logIdName = [[[[[self->logIdPrefix stringByAppendingString:@"_"] stringByAppendingString:([CapeString forInteger:[dt getYear]])] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getMonth] length:2 paddingString:nil])] stringByAppendingString:([CapeString forIntegerWithPadding:[dt getDayOfMonth] length:2 paddingString:nil])] stringByAppendingString:@".log"];
		}
		else {
			logIdName = [self->logIdPrefix stringByAppendingString:@".log"];
		}
		if(self->os == nil || !(({ NSString* _s1 = self->currentLogIdName; NSString* _s2 = logIdName; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			self->currentLogIdName = logIdName;
			self->os = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)[[self->logDir entry:self->currentLogIdName] append])];
			if(self->os == nil && [self->logDir isDirectory] == FALSE) {
				[self->logDir createDirectoryRecursive];
				self->os = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)[[self->logDir entry:self->currentLogIdName] append])];
			}
		}
		if(self->os != nil) {
			if([self->os println:logLine] == FALSE) {
				return;
			}
			if([((NSObject*)self->os) conformsToProtocol:@protocol(CapeFlushableWriter)]) {
				[((id<CapeFlushableWriter>)self->os) flush];
			}
		}
	}
	if(self->alsoPrintOnConsole) {
		NSLog(@"%@", logLine);
	}
}

- (BOOL) getEnableDebugMessages {
	return(self->enableDebugMessages);
}

- (SympathyDirectoryLogContext*) setEnableDebugMessages:(BOOL)v {
	self->enableDebugMessages = v;
	return(self);
}

- (id<CapeFile>) getLogDir {
	return(self->logDir);
}

- (SympathyDirectoryLogContext*) setLogDir:(id<CapeFile>)v {
	self->logDir = v;
	return(self);
}

- (NSString*) getLogIdPrefix {
	return(self->logIdPrefix);
}

- (SympathyDirectoryLogContext*) setLogIdPrefix:(NSString*)v {
	self->logIdPrefix = v;
	return(self);
}

- (BOOL) getAlsoPrintOnConsole {
	return(self->alsoPrintOnConsole);
}

- (SympathyDirectoryLogContext*) setAlsoPrintOnConsole:(BOOL)v {
	self->alsoPrintOnConsole = v;
	return(self);
}

@end
