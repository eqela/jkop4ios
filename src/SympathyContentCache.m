
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
#import "CapeSystemClock.h"
#import "CapeMap.h"
#import "SympathyContentCache.h"

@class SympathyContentCacheCacheEntry;

@interface SympathyContentCacheCacheEntry : NSObject
- (SympathyContentCacheCacheEntry*) init;
- (id) getData;
- (SympathyContentCacheCacheEntry*) setData:(id)v;
- (int) getTtl;
- (SympathyContentCacheCacheEntry*) setTtl:(int)v;
- (int) getTimestamp;
- (SympathyContentCacheCacheEntry*) setTimestamp:(int)v;
@end

@implementation SympathyContentCacheCacheEntry

{
	id data;
	int ttl;
	int timestamp;
}

- (SympathyContentCacheCacheEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->timestamp = 0;
	self->ttl = 0;
	self->data = nil;
	return(self);
}

- (id) getData {
	return(self->data);
}

- (SympathyContentCacheCacheEntry*) setData:(id)v {
	self->data = v;
	return(self);
}

- (int) getTtl {
	return(self->ttl);
}

- (SympathyContentCacheCacheEntry*) setTtl:(int)v {
	self->ttl = v;
	return(self);
}

- (int) getTimestamp {
	return(self->timestamp);
}

- (SympathyContentCacheCacheEntry*) setTimestamp:(int)v {
	self->timestamp = v;
	return(self);
}

@end

@implementation SympathyContentCache

{
	NSMutableDictionary* cache;
	int cacheTtl;
}

- (SympathyContentCache*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->cacheTtl = 3600;
	self->cache = nil;
	return(self);
}

- (void) onMaintenance {
	if(self->cache == nil) {
		return;
	}
	long long now = [CapeSystemClock asSeconds];
	NSMutableArray* keys = [CapeMap getKeys:self->cache];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				SympathyContentCacheCacheEntry* ce = ((SympathyContentCacheCacheEntry*)({ id _v = [CapeMap getMapAndDynamic:self->cache key:((id)key)]; [_v isKindOfClass:[SympathyContentCacheCacheEntry class]] ? _v : nil; }));
				if(ce == nil) {
					[CapeMap remove:self->cache key:((id)key)];
				}
				else {
					long long diff = now - [ce getTimestamp];
					if(diff >= [ce getTtl]) {
						[CapeMap remove:self->cache key:((id)key)];
					}
				}
			}
		}
	}
}

- (void) clear {
	self->cache = nil;
}

- (void) remove:(NSString*)cacheid {
	[CapeMap remove:self->cache key:((id)cacheid)];
}

- (void) set:(NSString*)cacheid content:(id)content ttl:(int)ttl {
	if(({ NSString* _s1 = cacheid; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	SympathyContentCacheCacheEntry* ee = [[SympathyContentCacheCacheEntry alloc] init];
	[ee setData:content];
	if(ttl >= 0) {
		[ee setTtl:ttl];
	}
	else {
		[ee setTtl:self->cacheTtl];
	}
	if([ee getTtl] < 1) {
		return;
	}
	[ee setTimestamp:((int)[CapeSystemClock asSeconds])];
	if(self->cache == nil) {
		self->cache = [[NSMutableDictionary alloc] init];
	}
	({ id _v = ee; id _o = self->cache; id _k = cacheid; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
}

- (id) get:(NSString*)cacheid {
	if(self->cache == nil) {
		return(nil);
	}
	SympathyContentCacheCacheEntry* ee = ((SympathyContentCacheCacheEntry*)({ id _v = [CapeMap getValue:self->cache key:((id)cacheid)]; [_v isKindOfClass:[SympathyContentCacheCacheEntry class]] ? _v : nil; }));
	if(ee != nil) {
		long long diff = [CapeSystemClock asSeconds] - [ee getTimestamp];
		if(diff >= [ee getTtl]) {
			[CapeMap remove:self->cache key:((id)cacheid)];
			ee = nil;
		}
	}
	if(ee != nil) {
		return([ee getData]);
	}
	return(nil);
}

- (int) getCacheTtl {
	return(self->cacheTtl);
}

- (SympathyContentCache*) setCacheTtl:(int)v {
	self->cacheTtl = v;
	return(self);
}

@end
