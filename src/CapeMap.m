
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
#import "CapeMapObject.h"
#import "CapeVector.h"
#import "CapeIterator.h"
#import "CapeMap.h"

@class CapeMapMyMapObject;

@interface CapeMapMyMapObject : NSObject <CapeMapObject>
- (CapeMapMyMapObject*) init;
- (NSMutableDictionary*) toMap;
- (NSMutableDictionary*) getMap;
- (CapeMapMyMapObject*) setMap:(NSMutableDictionary*)v;
@end

@implementation CapeMapMyMapObject

{
	NSMutableDictionary* map;
}

- (CapeMapMyMapObject*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->map = nil;
	return(self);
}

- (NSMutableDictionary*) toMap {
	return(self->map);
}

- (NSMutableDictionary*) getMap {
	return(self->map);
}

- (CapeMapMyMapObject*) setMap:(NSMutableDictionary*)v {
	self->map = v;
	return(self);
}

@end

@implementation CapeMap

- (CapeMap*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (id<CapeMapObject>) asObject:(NSMutableDictionary*)map {
	if(map == nil) {
		return(nil);
	}
	CapeMapMyMapObject* v = [[CapeMapMyMapObject alloc] init];
	[v setMap:map];
	return(((id<CapeMapObject>)v));
}

+ (id) getMapAndDynamicAndDynamic:(NSMutableDictionary*)map key:(id)key ddf:(id)ddf {
	if(map == nil || key == nil) {
		return(ddf);
	}
	if([CapeMap containsKey:map key:key] == FALSE) {
		return(ddf);
	}
	return([CapeMap getValue:map key:key]);
}

+ (id) getMapAndDynamic:(NSMutableDictionary*)map key:(id)key {
	return([CapeMap getValue:map key:key]);
}

+ (id) getValue:(NSMutableDictionary*)map key:(id)key {
	if(map == nil || key == nil) {
		return(nil);
	}
	return(((id)[map objectForKey:key]));
}

+ (BOOL) set:(NSMutableDictionary*)data key:(id)key val:(id)val {
	if(data == nil || key == nil) {
		return(FALSE);
	}
	({ id _v = val; id _o = data; id _k = key; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	return(TRUE);
}

+ (BOOL) setValue:(NSMutableDictionary*)data key:(id)key val:(id)val {
	return([CapeMap set:data key:key val:val]);
}

+ (void) remove:(NSMutableDictionary*)data key:(id)key {
	if(data == nil || key == nil) {
		return;
	}
	NSLog(@"%@", @"[cape.Map.remove] (Map.sling:145:2): Not implemented");
}

+ (int) count:(NSMutableDictionary*)data {
	if(data == nil) {
		return(0);
	}
	NSLog(@"%@", @"[cape.Map.count] (Map.sling:164:2): Not implemented");
	return(0);
}

+ (BOOL) containsKey:(NSMutableDictionary*)data key:(id)key {
	if(data == nil || key == nil) {
		return(FALSE);
	}
	return([data objectForKey:key] == nil ? NO : YES);
}

+ (BOOL) containsValue:(NSMutableDictionary*)data val:(id)val {
	if(data == nil || val == nil) {
		return(FALSE);
	}
	NSLog(@"%@", @"[cape.Map.containsValue] (Map.sling:208:2): Not implemented");
	return(FALSE);
}

+ (void) clear:(NSMutableDictionary*)data {
	if(data == nil) {
		return;
	}
	NSLog(@"%@", @"[cape.Map.clear] (Map.sling:234:2): Not implemented");
}

+ (NSMutableDictionary*) dup:(NSMutableDictionary*)data {
	if(data == nil) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.Map.dup] (Map.sling:253:2): Not implemented");
	return(nil);
}

+ (NSMutableArray*) getKeys:(NSMutableDictionary*)data {
	if(data == nil) {
		return(nil);
	}
	return([[data allKeys] mutableCopy]);
}

+ (NSMutableArray*) getValues:(NSMutableDictionary*)data {
	if(data == nil) {
		return(nil);
	}
	return([[data allValues] mutableCopy]);
}

+ (id<CapeIterator>) iterateKeys:(NSMutableDictionary*)data {
	return([CapeVector iterate:[CapeMap getKeys:data]]);
}

+ (id<CapeIterator>) iterateValues:(NSMutableDictionary*)data {
	return([CapeVector iterate:[CapeMap getValues:data]]);
}

@end
