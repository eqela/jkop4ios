
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
#import "CapeVectorObject.h"
#import "CapeIterator.h"
#import "CapeVector.h"

@class CapeVectorVectorIterator;

@interface CapeVectorVectorIterator : NSObject <CapeIterator>
{
	@public NSMutableArray* vector;
}
- (CapeVectorVectorIterator*) init;
- (CapeVectorVectorIterator*) initWithVectorAndSignedInteger:(NSMutableArray*)vector increment:(int)increment;
- (id) next;
@end

@implementation CapeVectorVectorIterator

{
	int index;
	int increment;
}

- (CapeVectorVectorIterator*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->increment = 1;
	self->index = 0;
	self->vector = nil;
	return(self);
}

- (CapeVectorVectorIterator*) initWithVectorAndSignedInteger:(NSMutableArray*)vector increment:(int)increment {
	if([super init] == nil) {
		return(nil);
	}
	self->increment = 1;
	self->index = 0;
	self->vector = nil;
	self->vector = vector;
	self->increment = increment;
	if(increment < 0 && vector != nil) {
		self->index = [CapeVector getSize:vector] - 1;
	}
	return(self);
}

- (id) next {
	if(self->vector == nil) {
		return(nil);
	}
	if(self->index < 0 || self->index >= [CapeVector getSize:self->vector]) {
		return(nil);
	}
	id v = ((id)[self->vector objectAtIndex:self->index]);
	self->index += self->increment;
	return(v);
}

@end

@implementation CapeVector

- (CapeVector*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSMutableArray*) asVector:(id)obj {
	id<CapeVectorObject> vo = ((id<CapeVectorObject>)({ id _v = obj; [((NSObject*)_v) conformsToProtocol:@protocol(CapeVectorObject)] ? _v : nil; }));
	if(vo == nil) {
		return(nil);
	}
	return([vo toVector]);
}

+ (NSMutableArray*) forIterator:(id<CapeIterator>)iterator {
	if(iterator == nil) {
		return(nil);
	}
	NSMutableArray* v = [[NSMutableArray alloc] init];
	while(TRUE) {
		id o = [iterator next];
		if(o == nil) {
			break;
		}
		[v addObject:o];
	}
	return(v);
}

+ (NSMutableArray*) forArray:(NSMutableArray*)array {
	if(array == nil) {
		return(nil);
	}
	NSMutableArray* v = [[NSMutableArray alloc] init];
	for(int n = 0 ; n < [array count] ; n++) {
		[v addObject:((id)[array objectAtIndex:n])];
	}
	return(v);
}

+ (void) append:(NSMutableArray*)vector object:(id)object {
	[vector addObject:object];
}

+ (int) getSize:(NSMutableArray*)vector {
	if(vector == nil) {
		return(0);
	}
	return([vector count]);
}

+ (id) getAt:(NSMutableArray*)vector index:(int)index {
	return([CapeVector get:vector index:index]);
}

+ (id) get:(NSMutableArray*)vector index:(int)index {
	if(index < 0 || index >= [CapeVector getSize:vector]) {
		return(nil);
	}
	return([vector objectAtIndex:index]);
}

+ (void) set:(NSMutableArray*)vector index:(int)index val:(id)val {
	if(index < 0 || index >= [CapeVector getSize:vector]) {
		return;
	}
	[vector replaceObjectAtIndex:index withObject:val];
}

+ (id) remove:(NSMutableArray*)vector index:(int)index {
	if(index < 0 || index >= [CapeVector getSize:vector]) {
		return(nil);
	}
	id t = ((id)[vector objectAtIndex:index]);
	[vector removeObjectAtIndex:index];
	return(t);
}

+ (id) popFirst:(NSMutableArray*)vector {
	if(vector == nil || [CapeVector getSize:vector] < 1) {
		return(nil);
	}
	id v = [CapeVector get:vector index:0];
	[CapeVector removeFirst:vector];
	return(v);
}

+ (void) removeFirst:(NSMutableArray*)vector {
	if(vector == nil || [CapeVector getSize:vector] < 1) {
		return;
	}
	[CapeVector remove:vector index:0];
}

+ (id) popLast:(NSMutableArray*)vector {
	if(vector == nil || [CapeVector getSize:vector] < 1) {
		return(nil);
	}
	id v = [CapeVector get:vector index:[CapeVector getSize:vector] - 1];
	[CapeVector removeLast:vector];
	return(v);
}

+ (void) removeLast:(NSMutableArray*)vector {
	if(vector == nil) {
		return;
	}
	int sz = [CapeVector getSize:vector];
	if(sz < 1) {
		return;
	}
	[CapeVector remove:vector index:sz - 1];
}

+ (int) removeValue:(NSMutableArray*)vector value:(id)value {
	int n = 0;
	for(n = 0 ; n < [vector count] ; n++) {
		if(((id)[vector objectAtIndex:n]) == value) {
			[CapeVector remove:vector index:n];
			return(n);
		}
	}
	return(-1);
}

+ (void) clear:(NSMutableArray*)vector {
	NSLog(@"%@", @"[cape.Vector.clear] (Vector.sling:298:2): Not implemented");
}

+ (BOOL) isEmpty:(NSMutableArray*)vector {
	return(vector == nil || [vector count] < 1);
}

+ (void) removeRange:(NSMutableArray*)vector index:(int)index count:(int)count {
	NSLog(@"%@", @"[cape.Vector.removeRange] (Vector.sling:340:2): not implemented!");
}

+ (id<CapeIterator>) iterate:(NSMutableArray*)vector {
	return(((id<CapeIterator>)[[CapeVectorVectorIterator alloc] initWithVectorAndSignedInteger:vector increment:1]));
}

+ (id<CapeIterator>) iterateReverse:(NSMutableArray*)vector {
	return(((id<CapeIterator>)[[CapeVectorVectorIterator alloc] initWithVectorAndSignedInteger:vector increment:-1]));
}

+ (void) sort:(NSMutableArray*)vector comparer:(int(^)(id,id))comparer {
	if(vector == nil) {
		return;
	}
	NSLog(@"%@", @"[cape.Vector.sort] (Vector.sling:394:2): Not implemented");
}

+ (void) sortReverse:(NSMutableArray*)vector comparer:(int(^)(id,id))comparer {
	int (^cc)(id,id) = comparer;
	[CapeVector sort:vector comparer:^int(id a, id b) {
		return(-cc(a, b));
	}];
}

@end
