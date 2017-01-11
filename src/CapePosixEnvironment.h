
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

@class CapePosixEnvironmentPosixUser;
@class CapePosixEnvironment;

@interface CapePosixEnvironmentPosixUser : NSObject
- (CapePosixEnvironmentPosixUser*) init;
- (NSString*) getPwName;
- (CapePosixEnvironmentPosixUser*) setPwName:(NSString*)v;
- (int) getPwUid;
- (CapePosixEnvironmentPosixUser*) setPwUid:(int)v;
- (int) getPwGid;
- (CapePosixEnvironmentPosixUser*) setPwGid:(int)v;
- (NSString*) getPwGecos;
- (CapePosixEnvironmentPosixUser*) setPwGecos:(NSString*)v;
- (NSString*) getPwDir;
- (CapePosixEnvironmentPosixUser*) setPwDir:(NSString*)v;
- (NSString*) getPwShell;
- (CapePosixEnvironmentPosixUser*) setPwShell:(NSString*)v;
@end

@interface CapePosixEnvironment : NSObject
- (CapePosixEnvironment*) init;
+ (CapePosixEnvironmentPosixUser*) getpwnam:(NSString*)username;
+ (CapePosixEnvironmentPosixUser*) getpwuid:(int)uid;
+ (BOOL) setuid:(int)gid;
+ (BOOL) setgid:(int)gid;
+ (BOOL) seteuid:(int)uid;
+ (BOOL) setegid:(int)gid;
+ (int) getuid;
+ (int) geteuid;
+ (int) getgid;
+ (int) getegid;
@end
