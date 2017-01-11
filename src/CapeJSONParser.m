
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
#import "CapeCharacterIterator.h"
#import "CapeCharacterIteratorForString.h"
#import "CapeStringBuilder.h"
#import "CapeDynamicVector.h"
#import "CapeDynamicMap.h"
#import "CapeJSONParser.h"

@implementation CapeJSONParser

{
	id<CapeCharacterIterator> iterator;
}

- (CapeJSONParser*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	return(self);
}

+ (id) parseBuffer:(NSMutableData*)buffer {
	if(buffer == nil) {
		return(nil);
	}
	return([[[CapeJSONParser alloc] initWithString:[CapeString forUTF8Buffer:buffer]] acceptObject]);
}

+ (id) parseString:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(nil);
	}
	return([[[CapeJSONParser alloc] initWithString:str] acceptObject]);
}

+ (id) parseFile:(id<CapeFile>)file {
	if(file == nil) {
		return(nil);
	}
	return([CapeJSONParser parseString:[file getContentsString:@"UTF-8"]]);
}

- (CapeJSONParser*) initWithString:(NSString*)str {
	if([super init] == nil) {
		return(nil);
	}
	self->iterator = nil;
	self->iterator = ((id<CapeCharacterIterator>)[[CapeCharacterIteratorForString alloc] initWithString:str]);
	[self->iterator moveToNextChar];
	return(self);
}

- (void) skipSpaces {
	while(TRUE) {
		if([self->iterator hasEnded]) {
			break;
		}
		int c = [self->iterator getCurrentChar];
		if(c == ' ' || c == '\t' || c == '\r' || c == '\n') {
			[self->iterator moveToNextChar];
			continue;
		}
		break;
	}
}

- (BOOL) acceptChar:(int)c {
	[self skipSpaces];
	if([self->iterator getCurrentChar] == c) {
		[self->iterator moveToNextChar];
		return(TRUE);
	}
	return(FALSE);
}

- (NSString*) acceptString {
	[self skipSpaces];
	int ss = [self->iterator getCurrentChar];
	if(ss != '\'' && ss != '\"') {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	while(TRUE) {
		int c = [self->iterator getNextChar];
		if(c == ss) {
			[self->iterator moveToNextChar];
			break;
		}
		if(c == '\\') {
			c = [self->iterator getNextChar];
		}
		[sb appendCharacter:c];
	}
	return([sb toString]);
}

- (id) acceptObject {
	if([self acceptChar:'[']) {
		CapeDynamicVector* v = [[CapeDynamicVector alloc] init];
		while(TRUE) {
			if([self acceptChar:']']) {
				break;
			}
			id o = [self acceptObject];
			if(o == nil) {
				return(nil);
			}
			[v appendObject:o];
			[self acceptChar:','];
		}
		return(((id)v));
	}
	if([self acceptChar:'{']) {
		CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
		while(TRUE) {
			if([self acceptChar:'}']) {
				break;
			}
			NSString* key = [self acceptString];
			if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				return(nil);
			}
			if([self acceptChar:':'] == FALSE) {
				return(nil);
			}
			id val = [self acceptObject];
			if(val == nil) {
				return(nil);
			}
			[v setStringAndObject:key value:val];
			[self acceptChar:','];
		}
		return(((id)v));
	}
	NSString* s = [self acceptString];
	if(!(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(((id)s));
	}
	return(nil);
}

@end
