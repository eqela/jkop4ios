
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
#import "CapeMap.h"
#import "CapexURLDecoder.h"
#import "CapexQueryString.h"

@implementation CapexQueryString

- (CapexQueryString*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSMutableDictionary*) parse:(NSString*)queryString {
	NSMutableDictionary* v = [[NSMutableDictionary alloc] init];
	NSMutableArray* array = [CapeString split:queryString delim:'&' max:0];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* qs = ((NSString*)[array objectAtIndex:n]);
			if(qs != nil) {
				if([CapeString isEmpty:qs]) {
					continue;
				}
				if([CapeString indexOfWithStringAndCharacterAndSignedInteger:qs c:'=' start:0] < 0) {
					[CapeMap set:v key:((id)qs) val:nil];
					continue;
				}
				NSMutableArray* qsps = [CapeString split:qs delim:'=' max:2];
				NSString* key = ((NSString*)[qsps objectAtIndex:0]);
				NSString* val = ((NSString*)[qsps objectAtIndex:1]);
				if(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					val = @"";
				}
				if([CapeString isEmpty:key] == FALSE) {
					[CapeMap set:v key:((id)key) val:((id)[CapexURLDecoder decode:val])];
				}
			}
		}
	}
	return(v);
}

@end
