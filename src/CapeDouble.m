
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
#import "CapeDoubleObject.h"
#import "CapeIntegerObject.h"
#import "CapeString.h"
#import "CapeStringObject.h"
#import "CapeBooleanObject.h"
#import "CapeCharacterObject.h"
#import "CapeDouble.h"

@class CapeDoubleMyDoubleObject;

@interface CapeDoubleMyDoubleObject : NSObject <CapeDoubleObject>
- (CapeDoubleMyDoubleObject*) init;
- (double) toDouble;
- (double) getValue;
- (CapeDoubleMyDoubleObject*) setValue:(double)v;
@end

@implementation CapeDoubleMyDoubleObject

{
	double value;
}

- (CapeDoubleMyDoubleObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->value = 0.0;
	return(self);
}

- (double) toDouble {
	return(self->value);
}

- (double) getValue {
	return(self->value);
}

- (CapeDoubleMyDoubleObject*) setValue:(double)v {
	self->value = v;
	return(self);
}

@end

@implementation CapeDouble

- (CapeDouble*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeDoubleObject>) asObject:(double)value {
	CapeDoubleMyDoubleObject* v = [[CapeDoubleMyDoubleObject alloc] init];
	[v setValue:value];
	return(((id<CapeDoubleObject>)v));
}

+ (double) asDouble:(id)obj {
	if(obj == nil) {
		return(0.0);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeDoubleObject)]) {
		return([((id<CapeDoubleObject>)obj) toDouble]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeIntegerObject)]) {
		return(((double)([((id<CapeIntegerObject>)obj) toInteger])));
	}
	if([obj isKindOfClass:[NSString class]]) {
		return([CapeString toDouble:((NSString*)obj)]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeStringObject)]) {
		return([CapeString toDouble:[((id<CapeStringObject>)obj) toString]]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeBooleanObject)]) {
		if([((id<CapeBooleanObject>)obj) toBoolean]) {
			return(1.0);
		}
		return(0.0);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeCharacterObject)]) {
		return(((double)([((id<CapeCharacterObject>)obj) toCharacter])));
	}
	return(0.0);
}

@end
