
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
#import "CapeIntegerObject.h"
#import "CapeString.h"
#import "CapeStringObject.h"
#import "CapeDoubleObject.h"
#import "CapeBooleanObject.h"
#import "CapeCharacterObject.h"
#import "CapeInteger.h"

@class CapeIntegerMyIntegerObject;

@interface CapeIntegerMyIntegerObject : NSObject <CapeIntegerObject>
- (CapeIntegerMyIntegerObject*) init;
- (int) toInteger;
- (int) getInteger;
- (CapeIntegerMyIntegerObject*) setInteger:(int)v;
@end

@implementation CapeIntegerMyIntegerObject

{
	int integer;
}

- (CapeIntegerMyIntegerObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->integer = 0;
	return(self);
}

- (int) toInteger {
	return(self->integer);
}

- (int) getInteger {
	return(self->integer);
}

- (CapeIntegerMyIntegerObject*) setInteger:(int)v {
	self->integer = v;
	return(self);
}

@end

@implementation CapeInteger

- (CapeInteger*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeIntegerObject>) asObject:(int)integer {
	CapeIntegerMyIntegerObject* v = [[CapeIntegerMyIntegerObject alloc] init];
	[v setInteger:integer];
	return(((id<CapeIntegerObject>)v));
}

+ (int) asIntegerWithString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return([CapeString toInteger:str]);
}

+ (int) asIntegerWithObject:(id)obj {
	if(obj == nil) {
		return(0);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeIntegerObject)]) {
		return([((id<CapeIntegerObject>)obj) toInteger]);
	}
	if([obj isKindOfClass:[NSString class]]) {
		return([CapeString toInteger:((NSString*)obj)]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeStringObject)]) {
		return([CapeString toInteger:[((id<CapeStringObject>)obj) toString]]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeDoubleObject)]) {
		return(((int)([((id<CapeDoubleObject>)obj) toDouble])));
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeBooleanObject)]) {
		if([((id<CapeBooleanObject>)obj) toBoolean]) {
			return(1);
		}
		return(0);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeCharacterObject)]) {
		return(((int)([((id<CapeCharacterObject>)obj) toCharacter])));
	}
	return(0);
}

@end
