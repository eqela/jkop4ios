
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
#import "CapeVectorObject.h"
#import "CapeObjectWithSize.h"
#import "CapeDynamicMap.h"
#import "CapeIterator.h"
#import "CapeInteger.h"
#import "CapeBoolean.h"
#import "CapeDouble.h"
#import "CapeVector.h"
#import "CapeString.h"
#import "CapeDynamicVector.h"

@implementation CapeDynamicVector

{
	NSMutableArray* vector;
}

+ (CapeDynamicVector*) asDynamicVector:(id)object {
	if(object == nil) {
		return(nil);
	}
	if([object isKindOfClass:[CapeDynamicVector class]]) {
		return(((CapeDynamicVector*)object));
	}
	if([object isKindOfClass:[NSMutableArray class]]) {
		return([CapeDynamicVector forObjectVector:((NSMutableArray*)object)]);
	}
	return(nil);
}

+ (CapeDynamicVector*) forStringVector:(NSMutableArray*)vector {
	CapeDynamicVector* v = [[CapeDynamicVector alloc] init];
	if(vector != nil) {
		int n = 0;
		int m = [vector count];
		for(n = 0 ; n < m ; n++) {
			NSString* item = ((NSString*)[vector objectAtIndex:n]);
			if(item != nil) {
				[v appendObject:((id)item)];
			}
		}
	}
	return(v);
}

+ (CapeDynamicVector*) forObjectVector:(NSMutableArray*)vector {
	CapeDynamicVector* v = [[CapeDynamicVector alloc] init];
	if(vector != nil) {
		int n = 0;
		int m = [vector count];
		for(n = 0 ; n < m ; n++) {
			id item = ((id)[vector objectAtIndex:n]);
			if(item != nil) {
				[v appendObject:item];
			}
		}
	}
	return(v);
}

- (CapeDynamicVector*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->vector = nil;
	self->vector = [[NSMutableArray alloc] init];
	return(self);
}

- (NSMutableArray*) toVector {
	return(self->vector);
}

- (NSMutableArray*) toVectorOfStrings {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(self->vector != nil) {
		int n = 0;
		int m = [self->vector count];
		for(n = 0 ; n < m ; n++) {
			NSString* o = ((NSString*)({ id _v = ((id)[self->vector objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
			if(o != nil) {
				[v addObject:o];
			}
		}
	}
	return(v);
}

- (NSMutableArray*) toVectorOfDynamicMaps {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(self->vector != nil) {
		int n = 0;
		int m = [self->vector count];
		for(n = 0 ; n < m ; n++) {
			CapeDynamicMap* o = ((CapeDynamicMap*)({ id _v = ((id)[self->vector objectAtIndex:n]); [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
			if(o != nil) {
				[v addObject:o];
			}
		}
	}
	return(v);
}

- (id) duplicate {
	CapeDynamicVector* v = [[CapeDynamicVector alloc] init];
	id<CapeIterator> it = [self iterate];
	while(it != nil) {
		id o = [it next];
		if(o == nil) {
			break;
		}
		[v appendObject:o];
	}
	return(((id)v));
}

- (CapeDynamicVector*) appendObject:(id)object {
	[self->vector addObject:object];
	return(self);
}

- (CapeDynamicVector*) appendSignedInteger:(int)value {
	[self->vector addObject:[CapeInteger asObject:value]];
	return(self);
}

- (CapeDynamicVector*) appendBoolean:(BOOL)value {
	[self->vector addObject:[CapeBoolean asObject:value]];
	return(self);
}

- (CapeDynamicVector*) appendDouble:(double)value {
	[self->vector addObject:[CapeDouble asObject:value]];
	return(self);
}

- (CapeDynamicVector*) setSignedIntegerAndObject:(int)index object:(id)object {
	[CapeVector set:self->vector index:index val:object];
	return(self);
}

- (CapeDynamicVector*) setSignedIntegerAndSignedInteger:(int)index value:(int)value {
	[CapeVector set:self->vector index:index val:[CapeInteger asObject:value]];
	return(self);
}

- (CapeDynamicVector*) setSignedIntegerAndBoolean:(int)index value:(BOOL)value {
	[CapeVector set:self->vector index:index val:[CapeBoolean asObject:value]];
	return(self);
}

- (CapeDynamicVector*) setSignedIntegerAndDouble:(int)index value:(double)value {
	[CapeVector set:self->vector index:index val:[CapeDouble asObject:value]];
	return(self);
}

- (id) get:(int)index {
	return([CapeVector getAt:self->vector index:index]);
}

- (NSString*) getString:(int)index defval:(NSString*)defval {
	NSString* v = [CapeString asStringWithObject:[self get:index]];
	if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(defval);
	}
	return(v);
}

- (int) getInteger:(int)index defval:(int)defval {
	id vv = [self get:index];
	if(vv == nil) {
		return(defval);
	}
	return([CapeInteger asIntegerWithObject:vv]);
}

- (BOOL) getBoolean:(int)index defval:(BOOL)defval {
	id vv = [self get:index];
	if(vv == nil) {
		return(defval);
	}
	return([CapeBoolean asBoolean:vv]);
}

- (double) getDouble:(int)index defval:(double)defval {
	id vv = [self get:index];
	if(vv == nil) {
		return(defval);
	}
	return([CapeDouble asDouble:vv]);
}

- (CapeDynamicMap*) getMap:(int)index {
	return(((CapeDynamicMap*)({ id _v = [self get:index]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; })));
}

- (CapeDynamicVector*) getVector:(int)index {
	return(((CapeDynamicVector*)({ id _v = [self get:index]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; })));
}

- (id<CapeIterator>) iterate {
	id<CapeIterator> v = [CapeVector iterate:self->vector];
	return(v);
}

- (void) remove:(int)index {
	[CapeVector remove:self->vector index:index];
}

- (void) clear {
	[CapeVector clear:self->vector];
}

- (int) getSize {
	return([CapeVector getSize:self->vector]);
}

- (void) sort {
	[CapeVector sort:self->vector comparer:^int(id a, id b) {
		return([CapeString compare:[CapeString asStringWithObject:a] str2:[CapeString asStringWithObject:b]]);
	}];
}

- (void) sortFunction:(int(^)(id,id))comparer {
	if(comparer == nil) {
		[self sort];
		return;
	}
	[CapeVector sort:self->vector comparer:comparer];
}

- (void) sortReverse {
	[CapeVector sortReverse:self->vector comparer:^int(id a, id b) {
		return([CapeString compare:[CapeString asStringWithObject:a] str2:[CapeString asStringWithObject:b]]);
	}];
}

- (void) sortReverseWithFunction:(int(^)(id,id))comparer {
	if(comparer == nil) {
		[self sortReverse];
		return;
	}
	[CapeVector sortReverse:self->vector comparer:comparer];
}

@end
