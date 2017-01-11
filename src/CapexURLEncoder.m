
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
#import "CapeCharacterIterator.h"
#import "CapeString.h"
#import "CapexURLEncoder.h"

@implementation CapexURLEncoder

- (CapexURLEncoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) encode:(NSString*)str percentOnly:(BOOL)percentOnly encodeUnreservedChars:(BOOL)encodeUnreservedChars {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	while(it != nil) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		if(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9') {
			[sb appendCharacter:c];
		}
		else {
			if((c == '-' || c == '.' || c == '_' || c == '~') && encodeUnreservedChars == FALSE) {
				[sb appendCharacter:c];
			}
			else {
				if(c == ' ' && percentOnly == FALSE) {
					[sb appendCharacter:'+'];
				}
				else {
					[sb appendCharacter:'%'];
					[sb appendString:[CapeString forIntegerHex:((int)c)]];
				}
			}
		}
	}
	return([sb toString]);
}

@end
