
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
#import "CapeCharacterIterator.h"
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapexWordWrap.h"

@implementation CapexWordWrap

- (CapexWordWrap*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSMutableArray*) wrapToLines:(NSString*)text charactersPerLine:(int)charactersPerLine {
	if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSMutableArray* v = [[NSMutableArray alloc] init];
	id<CapeCharacterIterator> it = [CapeString iterate:text];
	CapeStringBuilder* lineBuilder = nil;
	CapeStringBuilder* wordBuilder = nil;
	while(it != nil) {
		int c = [it getNextChar];
		if(c == ' ' || c == '\t' || c == '\n' || c < 1) {
			if(wordBuilder != nil) {
				NSString* word = [wordBuilder toString];
				wordBuilder = nil;
				if(lineBuilder == nil) {
					lineBuilder = [[CapeStringBuilder alloc] init];
				}
				int cc = [lineBuilder count];
				if(cc > 0) {
					cc++;
				}
				cc += [CapeString getLength:word];
				if(cc > charactersPerLine) {
					[v addObject:[lineBuilder toString]];
					lineBuilder = [[CapeStringBuilder alloc] init];
				}
				if([lineBuilder count] > 0) {
					[lineBuilder appendCharacter:' '];
				}
				[lineBuilder appendString:word];
			}
			if(c < 1) {
				break;
			}
			continue;
		}
		if(wordBuilder == nil) {
			wordBuilder = [[CapeStringBuilder alloc] init];
		}
		[wordBuilder appendCharacter:c];
	}
	if(lineBuilder != nil) {
		[v addObject:[lineBuilder toString]];
	}
	return(v);
}

@end
