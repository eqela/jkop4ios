
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
#import "CapeDuplicateable.h"
#import "CapeIterateable.h"
#import "CapeIterator.h"
#import "CapeMap.h"
#import "CapeBuffer.h"
#import "CapeInteger.h"
#import "CapeBoolean.h"
#import "CapeDouble.h"
#import "CapeString.h"
#import "CapeDynamicVector.h"
#import "CapeVectorObject.h"
#import "CapeDynamicMap.h"

@implementation CapeDynamicMap

{
	NSMutableDictionary* map;
}

+ (CapeDynamicMap*) asDynamicMap:(id)object {
	if(object == nil) {
		return(nil);
	}
	if([object isKindOfClass:[CapeDynamicMap class]]) {
		return(((CapeDynamicMap*)object));
	}
	if([object isKindOfClass:[NSMutableDictionary class]]) {
		return([CapeDynamicMap forObjectMap:((NSMutableDictionary*)object)]);
	}
	return(nil);
}

+ (CapeDynamicMap*) forObjectMap:(NSMutableDictionary*)map {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	if(map != nil) {
		id<CapeIterator> it = [CapeMap iterateKeys:map];
		while(it != nil) {
			id key = [it next];
			if(key == nil) {
				break;
			}
			if([key isKindOfClass:[NSString class]] == FALSE) {
				continue;
			}
			[v setStringAndObject:((NSString*)key) value:[CapeMap getValue:map key:((id)((NSString*)key))]];
		}
	}
	return(v);
}

+ (CapeDynamicMap*) forStringMap:(NSMutableDictionary*)map {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	if(map != nil) {
		id<CapeIterator> it = [CapeMap iterateKeys:map];
		while(it != nil) {
			NSString* key = [it next];
			if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				break;
			}
			[v setStringAndObject:key value:[CapeMap getValue:map key:((id)key)]];
		}
	}
	return(v);
}

- (CapeDynamicMap*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->map = nil;
	self->map = [[NSMutableDictionary alloc] init];
	return(self);
}

- (id) duplicate {
	return(((id)[self duplicateMap]));
}

- (CapeDynamicMap*) duplicateMap {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	id<CapeIterator> it = [self iterateKeys];
	while(it != nil) {
		NSString* key = [it next];
		if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		[v setStringAndObject:key value:[self get:key]];
	}
	return(v);
}

- (CapeDynamicMap*) mergeFrom:(CapeDynamicMap*)other {
	if(other == nil) {
		return(self);
	}
	id<CapeIterator> it = [other iterateKeys];
	while(it != nil) {
		NSString* key = [it next];
		if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		[self setStringAndObject:key value:[other get:key]];
	}
	return(self);
}

- (CapeDynamicMap*) setStringAndObject:(NSString*)key value:(id)value {
	if(!(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		({ id _v = value; id _o = self->map; id _k = key; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(self);
}

- (CapeDynamicMap*) setStringAndBuffer:(NSString*)key value:(NSMutableData*)value {
	return([self setStringAndObject:key value:((id)[CapeBuffer asObject:value])]);
}

- (CapeDynamicMap*) setStringAndSignedInteger:(NSString*)key value:(int)value {
	return([self setStringAndObject:key value:((id)[CapeInteger asObject:value])]);
}

- (CapeDynamicMap*) setStringAndBoolean:(NSString*)key value:(BOOL)value {
	return([self setStringAndObject:key value:((id)[CapeBoolean asObject:value])]);
}

- (CapeDynamicMap*) setStringAndDouble:(NSString*)key value:(double)value {
	return([self setStringAndObject:key value:((id)[CapeDouble asObject:value])]);
}

- (id) get:(NSString*)key {
	return([CapeMap getMapAndDynamicAndDynamic:self->map key:((id)key) ddf:nil]);
}

- (NSString*) getString:(NSString*)key defval:(NSString*)defval {
	NSString* v = [CapeString asStringWithObject:[self get:key]];
	if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(defval);
	}
	return(v);
}

- (int) getInteger:(NSString*)key defval:(int)defval {
	id vv = [self get:key];
	if(vv == nil) {
		return(defval);
	}
	return([CapeInteger asIntegerWithObject:vv]);
}

- (BOOL) getBoolean:(NSString*)key defval:(BOOL)defval {
	id vv = [self get:key];
	if(vv == nil) {
		return(defval);
	}
	return([CapeBoolean asBoolean:vv]);
}

- (double) getDouble:(NSString*)key defval:(double)defval {
	id vv = [self get:key];
	if(vv == nil) {
		return(defval);
	}
	return([CapeDouble asDouble:vv]);
}

- (NSMutableData*) getBuffer:(NSString*)key {
	id vv = [self get:key];
	if(vv == nil) {
		return(nil);
	}
	return([CapeBuffer asBuffer:vv]);
}

- (CapeDynamicVector*) getDynamicVector:(NSString*)key {
	CapeDynamicVector* vv = ((CapeDynamicVector*)({ id _v = [self get:key]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; }));
	if(vv != nil) {
		return(vv);
	}
	NSMutableArray* v = [self getVector:key];
	if(v != nil) {
		return([CapeDynamicVector forObjectVector:v]);
	}
	return(nil);
}

- (NSMutableArray*) getVector:(NSString*)key {
	id val = [self get:key];
	if(val == nil) {
		return(nil);
	}
	if([val isKindOfClass:[NSMutableArray class]]) {
		return(((NSMutableArray*)val));
	}
	if([((NSObject*)val) conformsToProtocol:@protocol(CapeVectorObject)]) {
		id<CapeVectorObject> vo = ((id<CapeVectorObject>)val);
		NSMutableArray* vv = [vo toVector];
		return(vv);
	}
	return(nil);
}

- (CapeDynamicMap*) getDynamicMap:(NSString*)key {
	return(((CapeDynamicMap*)({ id _v = [self get:key]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; })));
}

- (NSMutableArray*) getKeys {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	id<CapeIterator> it = [self iterateKeys];
	while(TRUE) {
		NSString* kk = [it next];
		if(({ NSString* _s1 = kk; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		[v addObject:kk];
	}
	return(v);
}

- (id<CapeIterator>) iterate {
	id<CapeIterator> v = [CapeMap iterateKeys:self->map];
	return(v);
}

- (id<CapeIterator>) iterateKeys {
	id<CapeIterator> v = [CapeMap iterateKeys:self->map];
	return(v);
}

- (id<CapeIterator>) iterateValues {
	id<CapeIterator> v = [CapeMap iterateValues:self->map];
	return(v);
}

- (void) remove:(NSString*)key {
	[CapeMap remove:self->map key:((id)key)];
}

- (void) clear {
	[CapeMap clear:self->map];
}

- (int) getCount {
	return([CapeMap count:self->map]);
}

- (BOOL) containsKey:(NSString*)key {
	return([CapeMap containsKey:self->map key:((id)key)]);
}

@end
