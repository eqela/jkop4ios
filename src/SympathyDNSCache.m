
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
#import "CapeDynamicMap.h"
#import "CapeMutex.h"
#import "SympathyDNSResolver.h"
#import "SympathyDNSCache.h"

@class SympathyDNSCacheDNSCacheEntry;
@class SympathyDNSCacheDNSCacheImpl;

@interface SympathyDNSCacheDNSCacheEntry : NSObject
- (SympathyDNSCacheDNSCacheEntry*) init;
+ (SympathyDNSCacheDNSCacheEntry*) create:(NSString*)ip;
- (NSString*) getIp;
- (SympathyDNSCacheDNSCacheEntry*) setIp:(NSString*)v;
- (int) getTimestamp;
- (SympathyDNSCacheDNSCacheEntry*) setTimestamp:(int)v;
@end

@implementation SympathyDNSCacheDNSCacheEntry

{
	NSString* ip;
	int timestamp;
}

- (SympathyDNSCacheDNSCacheEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->timestamp = 0;
	self->ip = nil;
	return(self);
}

+ (SympathyDNSCacheDNSCacheEntry*) create:(NSString*)ip {
	SympathyDNSCacheDNSCacheEntry* v = [[SympathyDNSCacheDNSCacheEntry alloc] init];
	[v setIp:ip];
	[v setTimestamp:((int)[CapeSystemClock asSeconds])];
	return(v);
}

- (NSString*) getIp {
	return(self->ip);
}

- (SympathyDNSCacheDNSCacheEntry*) setIp:(NSString*)v {
	self->ip = v;
	return(self);
}

- (int) getTimestamp {
	return(self->timestamp);
}

- (SympathyDNSCacheDNSCacheEntry*) setTimestamp:(int)v {
	self->timestamp = v;
	return(self);
}

@end

@interface SympathyDNSCacheDNSCacheImpl : NSObject
- (SympathyDNSCacheDNSCacheImpl*) init;
- (NSString*) resolve:(NSString*)hostname;
@end

@implementation SympathyDNSCacheDNSCacheImpl

{
	CapeDynamicMap* entries;
	CapeMutex* mutex;
}

- (SympathyDNSCacheDNSCacheImpl*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->mutex = nil;
	self->entries = nil;
	self->entries = [[CapeDynamicMap alloc] init];
	self->mutex = [CapeMutex create];
	return(self);
}

- (void) add:(NSString*)hostname ip:(NSString*)ip {
	if(self->mutex != nil) {
		[self->mutex lockMutex];
	}
	[self->entries setStringAndObject:hostname value:((id)[SympathyDNSCacheDNSCacheEntry create:ip])];
	if(self->mutex != nil) {
		[self->mutex unlockMutex];
	}
}

- (NSString*) getCachedEntry:(NSString*)hostname {
	SympathyDNSCacheDNSCacheEntry* v = nil;
	if(self->mutex != nil) {
		[self->mutex lockMutex];
	}
	v = ((SympathyDNSCacheDNSCacheEntry*)({ id _v = [self->entries get:hostname]; [_v isKindOfClass:[SympathyDNSCacheDNSCacheEntry class]] ? _v : nil; }));
	if(self->mutex != nil) {
		[self->mutex unlockMutex];
	}
	if(v != nil) {
		if([CapeSystemClock asSeconds] - [v getTimestamp] > 60 * 60) {
			if(self->mutex != nil) {
				[self->mutex lockMutex];
			}
			[self->entries remove:hostname];
			if(self->mutex != nil) {
				[self->mutex unlockMutex];
			}
			v = nil;
		}
	}
	if(v != nil) {
		return([v getIp]);
	}
	return(nil);
}

- (NSString*) resolve:(NSString*)hostname {
	NSString* v = [self getCachedEntry:hostname];
	if(!(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(v);
	}
	SympathyDNSResolver* dr = [SympathyDNSResolver create];
	if(dr == nil) {
		return(nil);
	}
	v = [dr getIPAddress:hostname ctx:nil];
	if(!(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[self add:hostname ip:v];
	}
	return(v);
}

@end

SympathyDNSCacheDNSCacheImpl* SympathyDNSCacheCC = nil;

@implementation SympathyDNSCache

- (SympathyDNSCache*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) resolve:(NSString*)hostname {
	if(SympathyDNSCacheCC == nil) {
		SympathyDNSCacheCC = [[SympathyDNSCacheDNSCacheImpl alloc] init];
	}
	return([SympathyDNSCacheCC resolve:hostname]);
}

@end
