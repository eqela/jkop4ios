
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
#import "CapeCharacterObject.h"
#import "CapeCharacter.h"

@class CapeCharacterMyCharacterObject;

@interface CapeCharacterMyCharacterObject : NSObject <CapeCharacterObject>
- (CapeCharacterMyCharacterObject*) init;
- (int) toCharacter;
- (int) getCharacter;
- (CapeCharacterMyCharacterObject*) setCharacter:(int)v;
@end

@implementation CapeCharacterMyCharacterObject

{
	int character;
}

- (CapeCharacterMyCharacterObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->character = ' ';
	return(self);
}

- (int) toCharacter {
	return(self->character);
}

- (int) getCharacter {
	return(self->character);
}

- (CapeCharacterMyCharacterObject*) setCharacter:(int)v {
	self->character = v;
	return(self);
}

@end

@implementation CapeCharacter

- (CapeCharacter*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeCharacterObject>) asObject:(int)character {
	CapeCharacterMyCharacterObject* v = [[CapeCharacterMyCharacterObject alloc] init];
	[v setCharacter:character];
	return(((id<CapeCharacterObject>)v));
}

+ (int) toUppercase:(int)c {
	if(c >= 'a' && c <= 'z') {
		return(((int)(c - 'a' + 'A')));
	}
	return(c);
}

+ (int) toLowercase:(int)c {
	if(c >= 'A' && c <= 'Z') {
		return(((int)(c - 'A' + 'a')));
	}
	return(c);
}

+ (BOOL) isDigit:(int)c {
	return(c >= '0' && c <= '9');
}

+ (BOOL) isLowercaseAlpha:(int)c {
	return(c >= 'a' && c <= 'z');
}

+ (BOOL) isUppercaseAlpha:(int)c {
	return(c >= 'A' && c <= 'Z');
}

+ (BOOL) isHexDigit:(int)c {
	return(c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F' || c >= '0' && c <= '9');
}

+ (BOOL) isAlnum:(int)c {
	return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9');
}

+ (BOOL) isAlpha:(int)c {
	return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z');
}

+ (BOOL) isAlphaNumeric:(int)c {
	return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9');
}

+ (BOOL) isLowercaseAlphaNumeric:(int)c {
	return(c >= 'a' && c <= 'z' || c >= '0' && c <= '9');
}

+ (BOOL) isUppercaseAlphaNumeric:(int)c {
	return(c >= 'A' && c <= 'Z' || c >= '0' && c <= '9');
}

@end
