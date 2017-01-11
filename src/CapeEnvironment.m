
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
#import "CapeOS.h"
#import "CapeString.h"
#import "CapeCharacter.h"
#import "CapeMap.h"
#import "CapeFile.h"
#import "CapeFileInvalid.h"
#import "CapeFileInstance.h"
#import "CapeEnvironment.h"

@implementation CapeEnvironment

- (CapeEnvironment*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (int) getPathSeparator {
	if([CapeOS isWindows]) {
		return('\\');
	}
	return('/');
}

+ (BOOL) isAbsolutePath:(NSString*)path {
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	int sep = [CapeEnvironment getPathSeparator];
	int c0 = [CapeString getChar:path index:0];
	if(c0 == sep) {
		return(TRUE);
	}
	if([CapeCharacter isAlpha:c0] && [CapeOS isWindows] && [CapeString getChar:path index:1] == ':' && [CapeString getChar:path index:2] == '\\') {
		return(TRUE);
	}
	return(FALSE);
}

+ (NSMutableDictionary*) getVariables {
	NSLog(@"%@", @"[cape.Environment.getVariables] (Environment.sling:60:1): Not implemented");
	return(nil);
}

+ (NSString*) getVariable:(NSString*)key {
	if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSMutableDictionary* vars = [CapeEnvironment getVariables];
	if(vars == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:vars key:((id)key)]);
}

+ (void) setVariable:(NSString*)key val:(NSString*)val {
	NSLog(@"%@", @"[cape.Environment.setVariable] (Environment.sling:94:1): Not implemented");
}

+ (void) unsetVariable:(NSString*)key {
	NSLog(@"%@", @"[cape.Environment.unsetVariable] (Environment.sling:99:1): Not implemented");
}

+ (void) setCurrentDirectory:(id<CapeFile>)dir {
	NSLog(@"%@", @"[cape.Environment.setCurrentDirectory] (Environment.sling:104:1): Not implemented");
}

+ (id<CapeFile>) getCurrentDirectory {
	NSLog(@"%@", @"[cape.Environment.getCurrentDirectory] (Environment.sling:113:2): Not implemented");
	return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
}

+ (id<CapeFile>) findInPath:(NSString*)command {
	NSString* path = [CapeEnvironment getVariable:@"PATH"];
	if([CapeString isEmpty:path]) {
		return(nil);
	}
	int separator = ':';
	if([CapeOS isWindows]) {
		separator = ';';
	}
	NSMutableArray* array = [CapeString split:path delim:separator max:0];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* dir = ((NSString*)[array objectAtIndex:n]);
			if(dir != nil) {
				id<CapeFile> pp = [[[CapeFileInstance forPath:dir] entry:command] asExecutable];
				if([pp isFile]) {
					return(pp);
				}
			}
		}
	}
	return(nil);
}

+ (id<CapeFile>) findCommand:(NSString*)command {
	if(({ NSString* _s1 = command; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([CapeEnvironment findInPath:command]);
}

+ (id<CapeFile>) getTemporaryDirectory {
	return([CapeFileInstance forPath:@"/tmp"]);
}

+ (id<CapeFile>) getHomeDirectory {
	return([CapeFileInstance forPath:@"~"]);
}

+ (id<CapeFile>) getAppDirectory {
	NSLog(@"%@", @"[cape.Environment.getAppDirectory] (Environment.sling:222:2): Not implemented");
	return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
}

@end
