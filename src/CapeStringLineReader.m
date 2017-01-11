
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
#import "CapeLineReader.h"
#import "CapeCharacterIteratorForString.h"
#import "CapeStringBuilder.h"
#import "CapeCharacterDecoder.h"
#import "CapeStringLineReader.h"

@implementation CapeStringLineReader

{
	CapeCharacterIteratorForString* iterator;
}

- (CapeStringLineReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	return(self);
}

- (CapeStringLineReader*) initWithString:(NSString*)str {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	self->iterator = [[CapeCharacterIteratorForString alloc] initWithString:str];
	return(self);
}

- (NSString*) readLine {
	if(self->iterator == nil) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	while(TRUE) {
		int c = [self->iterator getNextChar];
		if(c < 1) {
			if([sb count] < 1) {
				return(nil);
			}
			break;
		}
		if(c == '\r') {
			continue;
		}
		if(c == '\n') {
			break;
		}
		[sb appendCharacter:c];
	}
	if([sb count] < 1) {
		return(@"");
	}
	return([sb toString]);
}

@end
