
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
#import "CapeStringObject.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "SympathyHTTPServerCookie.h"

@implementation SympathyHTTPServerCookie

{
	NSString* key;
	NSString* value;
	int maxAge;
	NSString* path;
	NSString* domain;
}

- (SympathyHTTPServerCookie*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->domain = nil;
	self->path = nil;
	self->maxAge = -1;
	self->value = nil;
	self->key = nil;
	return(self);
}

- (SympathyHTTPServerCookie*) initWithStringAndString:(NSString*)key value:(NSString*)value {
	if([super init] == nil) {
		return(nil);
	}
	self->domain = nil;
	self->path = nil;
	self->maxAge = -1;
	self->value = nil;
	self->key = nil;
	self->key = key;
	self->value = value;
	return(self);
}

- (NSString*) toString {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:self->key];
	[sb appendCharacter:'='];
	[sb appendString:self->value];
	if(self->maxAge >= 0) {
		[sb appendString:@"; Max-Age="];
		[sb appendString:[CapeString forInteger:self->maxAge]];
	}
	if([CapeString isEmpty:self->path] == FALSE) {
		[sb appendString:@"; Path="];
		[sb appendString:self->path];
	}
	if([CapeString isEmpty:self->domain] == FALSE) {
		[sb appendString:@"; Domain="];
		[sb appendString:self->domain];
	}
	return([sb toString]);
}

- (NSString*) getKey {
	return(self->key);
}

- (SympathyHTTPServerCookie*) setKey:(NSString*)v {
	self->key = v;
	return(self);
}

- (NSString*) getValue {
	return(self->value);
}

- (SympathyHTTPServerCookie*) setValue:(NSString*)v {
	self->value = v;
	return(self);
}

- (int) getMaxAge {
	return(self->maxAge);
}

- (SympathyHTTPServerCookie*) setMaxAge:(int)v {
	self->maxAge = v;
	return(self);
}

- (NSString*) getPath {
	return(self->path);
}

- (SympathyHTTPServerCookie*) setPath:(NSString*)v {
	self->path = v;
	return(self);
}

- (NSString*) getDomain {
	return(self->domain);
}

- (SympathyHTTPServerCookie*) setDomain:(NSString*)v {
	self->domain = v;
	return(self);
}

@end
