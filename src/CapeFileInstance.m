
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
#import "CapeString.h"
#import "CapeFile.h"
#import "CapeFileInvalid.h"
#import "CapeFileForObjC.h"
#import "CapeEnvironment.h"
#import "CapeFileInstance.h"

@implementation CapeFileInstance

- (CapeFileInstance*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeFile>) forPath:(NSString*)path {
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:path] < 1) {
		return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
	}
	return([CapeFileForObjC forPath:path]);
}

+ (id<CapeFile>) forRelativePath:(NSString*)path relativeTo:(id<CapeFile>)relativeTo alwaysSupportWindowsPathnames:(BOOL)alwaysSupportWindowsPathnames {
	if(relativeTo == nil) {
		return([CapeFileInstance forPath:path]);
	}
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
	}
	if([CapeEnvironment isAbsolutePath:path]) {
		return([CapeFileInstance forPath:path]);
	}
	int sep = [CapeEnvironment getPathSeparator];
	if(sep != '/') {
		if([CapeString indexOfWithStringAndCharacterAndSignedInteger:path c:sep start:0] < 0 && [CapeString indexOfWithStringAndCharacterAndSignedInteger:path c:'/' start:0] >= 0) {
			sep = '/';
		}
	}
	else {
		if(alwaysSupportWindowsPathnames) {
			if([CapeString indexOfWithStringAndCharacterAndSignedInteger:path c:sep start:0] < 0 && [CapeString indexOfWithStringAndCharacterAndSignedInteger:path c:'\\' start:0] >= 0) {
				sep = '\\';
			}
		}
	}
	id<CapeFile> f = relativeTo;
	NSMutableArray* comps = [CapeString split:path delim:sep max:0];
	if(comps != nil) {
		int n = 0;
		int m = [comps count];
		for(n = 0 ; n < m ; n++) {
			NSString* comp = ((NSString*)[comps objectAtIndex:n]);
			if(comp != nil) {
				if([CapeString isEmpty:comp]) {
					continue;
				}
				f = [f entry:comp];
			}
		}
	}
	return(f);
}

@end
