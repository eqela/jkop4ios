
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
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeCharacterIterator.h"
#import "CapexURLDecoder.h"

@implementation CapexURLDecoder

- (CapexURLDecoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (int) xcharToInteger:(int)c {
	if(c >= '0' && c <= '9') {
		return(((int)c) - '0');
	}
	else {
		if(c >= 'a' && c <= 'f') {
			return(10 + c - 'a');
		}
		else {
			if(c >= 'A' && c <= 'F') {
				return(10 + c - 'A');
			}
		}
	}
	return(0);
}

+ (NSString*) decode:(NSString*)astr {
	if(({ NSString* _s1 = astr; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* str = [CapeString strip:astr];
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	while(it != nil) {
		int x = [it getNextChar];
		if(x < 1) {
			break;
		}
		if(x == '%') {
			int x1 = [it getNextChar];
			int x2 = [it getNextChar];
			if(x1 > 0 && x2 > 0) {
				[sb appendCharacter:((int)([CapexURLDecoder xcharToInteger:x1] * 16 + [CapexURLDecoder xcharToInteger:x2]))];
			}
			else {
				break;
			}
		}
		else {
			if(x == '+') {
				[sb appendCharacter:' '];
			}
			else {
				[sb appendCharacter:x];
			}
		}
	}
	return([sb toString]);
}

@end
