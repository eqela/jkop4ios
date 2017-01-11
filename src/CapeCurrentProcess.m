
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
#import <mach-o/dyld.h>
#import "CapeFileInstance.h"
#import "CapeFile.h"
#import "CapeCurrentProcess.h"

@implementation CapeCurrentProcess

- (CapeCurrentProcess*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (void) terminate:(int)value {
	NSLog(@"%@", @"[cape.CurrentProcess.terminate] (CurrentProcess.sling:44:2): Not implemented");
}

+ (id<CapeFile>) getExecutableFile {
	int r = -1;
	char buffer[PATH_MAX];
	uint32_t bs = PATH_MAX;
	r = _NSGetExecutablePath(buffer, &bs);
	if(r != 0) {
		return(nil);
	}
	NSString* filepath = nil;
	char rp[PATH_MAX];
	char* rpx = realpath(buffer, rp);
	if(rpx == NULL) {
		rpx = buffer;
	}
	filepath = [[NSString alloc] initWithUTF8String:rpx];
	if(({ NSString* _s1 = filepath; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([CapeFileInstance forPath:filepath]);
}

@end
