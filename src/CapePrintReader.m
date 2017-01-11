
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
#import "CapeReader.h"
#import "CapeLineReader.h"
#import "CapeClosable.h"
#import "CapeCharacterIteratorForReader.h"
#import "CapeStringBuilder.h"
#import "CapeCharacterDecoder.h"
#import "CapePrintReader.h"

@implementation CapePrintReader

{
	id<CapeReader> reader;
	CapeCharacterIteratorForReader* iterator;
}

- (CapePrintReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	self->reader = nil;
	return(self);
}

- (CapePrintReader*) initWithReader:(id<CapeReader>)reader {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	self->reader = nil;
	[self setReader:reader];
	return(self);
}

- (void) setReader:(id<CapeReader>)reader {
	self->reader = reader;
	if(reader == nil) {
		self->iterator = nil;
	}
	else {
		self->iterator = [[CapeCharacterIteratorForReader alloc] initWithReader:reader];
	}
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

- (int) read:(NSMutableData*)buffer {
	if(self->reader == nil) {
		return(-1);
	}
	return([self->reader read:buffer]);
}

- (void) close {
	id<CapeClosable> rc = ((id<CapeClosable>)({ id _v = self->reader; [((NSObject*)_v) conformsToProtocol:@protocol(CapeClosable)] ? _v : nil; }));
	if(rc != nil) {
		[rc close];
	}
}

@end
