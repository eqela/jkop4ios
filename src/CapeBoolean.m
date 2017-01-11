
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
#import "CapeBooleanObject.h"
#import "CapeIntegerObject.h"
#import "CapeString.h"
#import "CapeStringObject.h"
#import "CapeDoubleObject.h"
#import "CapeCharacterObject.h"
#import "CapeObjectWithSize.h"
#import "CapeBoolean.h"

@class CapeBooleanMyBooleanObject;

@interface CapeBooleanMyBooleanObject : NSObject <CapeBooleanObject>
- (CapeBooleanMyBooleanObject*) init;
- (BOOL) toBoolean;
- (BOOL) getValue;
- (CapeBooleanMyBooleanObject*) setValue:(BOOL)v;
@end

@implementation CapeBooleanMyBooleanObject

{
	BOOL value;
}

- (CapeBooleanMyBooleanObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->value = FALSE;
	return(self);
}

- (BOOL) toBoolean {
	return(self->value);
}

- (BOOL) getValue {
	return(self->value);
}

- (CapeBooleanMyBooleanObject*) setValue:(BOOL)v {
	self->value = v;
	return(self);
}

@end

@implementation CapeBoolean

- (CapeBoolean*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeBooleanObject>) asObject:(BOOL)value {
	CapeBooleanMyBooleanObject* v = [[CapeBooleanMyBooleanObject alloc] init];
	[v setValue:value];
	return(((id<CapeBooleanObject>)v));
}

+ (BOOL) asBoolean:(id)obj {
	if(obj == nil) {
		return(FALSE);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeBooleanObject)]) {
		return([((id<CapeBooleanObject>)obj) toBoolean]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeIntegerObject)]) {
		if([((id<CapeIntegerObject>)obj) toInteger] == 0) {
			return(FALSE);
		}
		return(TRUE);
	}
	if([obj isKindOfClass:[NSString class]]) {
		NSString* str = [CapeString toLowerCase:((NSString*)obj)];
		if(({ NSString* _s1 = str; NSString* _s2 = @"yes"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str; NSString* _s2 = @"true"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			return(TRUE);
		}
		return(FALSE);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeStringObject)]) {
		NSString* str = [((id<CapeStringObject>)obj) toString];
		if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			str = [CapeString toLowerCase:str];
			if(({ NSString* _s1 = str; NSString* _s2 = @"yes"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str; NSString* _s2 = @"true"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				return(TRUE);
			}
		}
		return(FALSE);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeDoubleObject)]) {
		if([((id<CapeDoubleObject>)obj) toDouble] == 0.0) {
			return(FALSE);
		}
		return(TRUE);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeCharacterObject)]) {
		if(((int)([((id<CapeCharacterObject>)obj) toCharacter])) == 0) {
			return(FALSE);
		}
		return(TRUE);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeObjectWithSize)]) {
		int sz = [((id<CapeObjectWithSize>)obj) getSize];
		if(sz == 0) {
			return(FALSE);
		}
		return(TRUE);
	}
	return(FALSE);
}

@end
