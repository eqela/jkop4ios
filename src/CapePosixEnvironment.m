
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
#import "CapePosixEnvironment.h"

@class CapePosixEnvironmentPosixUser;

@implementation CapePosixEnvironmentPosixUser

{
	NSString* pwName;
	int pwUid;
	int pwGid;
	NSString* pwGecos;
	NSString* pwDir;
	NSString* pwShell;
}

- (CapePosixEnvironmentPosixUser*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->pwShell = nil;
	self->pwDir = nil;
	self->pwGecos = nil;
	self->pwGid = 0;
	self->pwUid = 0;
	self->pwName = nil;
	return(self);
}

- (NSString*) getPwName {
	return(self->pwName);
}

- (CapePosixEnvironmentPosixUser*) setPwName:(NSString*)v {
	self->pwName = v;
	return(self);
}

- (int) getPwUid {
	return(self->pwUid);
}

- (CapePosixEnvironmentPosixUser*) setPwUid:(int)v {
	self->pwUid = v;
	return(self);
}

- (int) getPwGid {
	return(self->pwGid);
}

- (CapePosixEnvironmentPosixUser*) setPwGid:(int)v {
	self->pwGid = v;
	return(self);
}

- (NSString*) getPwGecos {
	return(self->pwGecos);
}

- (CapePosixEnvironmentPosixUser*) setPwGecos:(NSString*)v {
	self->pwGecos = v;
	return(self);
}

- (NSString*) getPwDir {
	return(self->pwDir);
}

- (CapePosixEnvironmentPosixUser*) setPwDir:(NSString*)v {
	self->pwDir = v;
	return(self);
}

- (NSString*) getPwShell {
	return(self->pwShell);
}

- (CapePosixEnvironmentPosixUser*) setPwShell:(NSString*)v {
	self->pwShell = v;
	return(self);
}

@end

@implementation CapePosixEnvironment

- (CapePosixEnvironment*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapePosixEnvironmentPosixUser*) getpwnam:(NSString*)username {
	return(nil);
}

+ (CapePosixEnvironmentPosixUser*) getpwuid:(int)uid {
	return(nil);
}

+ (BOOL) setuid:(int)gid {
	return(FALSE);
}

+ (BOOL) setgid:(int)gid {
	return(FALSE);
}

+ (BOOL) seteuid:(int)uid {
	return(FALSE);
}

+ (BOOL) setegid:(int)gid {
	return(FALSE);
}

+ (int) getuid {
	return(-1);
}

+ (int) geteuid {
	return(-1);
}

+ (int) getgid {
	return(-1);
}

+ (int) getegid {
	return(-1);
}

@end
