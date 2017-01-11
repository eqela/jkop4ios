
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
#import "CapeFile.h"
#import "CapeEnvironment.h"
#import "CapeRandom.h"
#import "CapeString.h"
#import "CapeSystemClock.h"
#import "CapeTemporaryFile.h"

@implementation CapeTemporaryFile

- (CapeTemporaryFile*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeFile>) create:(NSString*)extension {
	return([CapeTemporaryFile forDirectory:nil extension:extension]);
}

+ (id<CapeFile>) forDirectory:(id<CapeFile>)dir extension:(NSString*)extension {
	id<CapeFile> tmpdir = dir;
	if(tmpdir == nil) {
		tmpdir = [CapeEnvironment getTemporaryDirectory];
	}
	if(tmpdir == nil || [tmpdir isDirectory] == FALSE) {
		return(nil);
	}
	id<CapeFile> v = nil;
	int n = 0;
	CapeRandom* rnd = [[CapeRandom alloc] init];
	while(n < 100) {
		NSString* _x_id = [[@"_tmp_" stringByAppendingString:([CapeString forInteger:((int)([CapeSystemClock asSeconds]))])] stringByAppendingString:([CapeString forInteger:((int)([rnd nextInt] % 1000000))])];
		if(({ NSString* _s1 = extension; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:extension] < 1) {
			_x_id = [_x_id stringByAppendingString:extension];
		}
		v = [tmpdir entry:_x_id];
		if([v exists] == FALSE) {
			[v touch];
			break;
		}
		n++;
	}
	if(v != nil && [v isFile] == FALSE) {
		v = nil;
	}
	return(v);
}

@end
