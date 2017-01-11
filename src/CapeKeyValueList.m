
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
#import "CapeKeyValuePair.h"
#import "CapeIterator.h"
#import "CapeVector.h"
#import "CapeKeyValueList.h"

@implementation CapeKeyValueList

{
	NSMutableArray* values;
}

- (CapeKeyValueList*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->values = nil;
	return(self);
}

- (void) addDynamicAndDynamic:(id)key val:(id)val {
	if(self->values == nil) {
		self->values = [[NSMutableArray alloc] init];
	}
	CapeKeyValuePair* kvp = [[CapeKeyValuePair alloc] init];
	kvp->key = key;
	kvp->value = val;
	[self->values addObject:kvp];
}

- (void) addKeyValuePair:(CapeKeyValuePair*)pair {
	if(self->values == nil) {
		self->values = [[NSMutableArray alloc] init];
	}
	[self->values addObject:pair];
}

- (id<CapeIterator>) iterate {
	id<CapeIterator> v = [CapeVector iterate:self->values];
	return(v);
}

- (NSMutableArray*) asVector {
	return(self->values);
}

- (CapeKeyValueList*) dup {
	CapeKeyValueList* v = [[CapeKeyValueList alloc] init];
	id<CapeIterator> it = [self iterate];
	while(TRUE) {
		CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
		if(kvp == nil) {
			break;
		}
		[v addDynamicAndDynamic:kvp->key val:kvp->value];
	}
	return(v);
}

- (id) getKey:(int)index {
	if(self->values == nil) {
		return(nil);
	}
	CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[CapeVector get:self->values index:index]);
	if(kvp == nil) {
		return(nil);
	}
	return(kvp->key);
}

- (id) getValue:(int)index {
	if(self->values == nil) {
		return(nil);
	}
	CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[CapeVector get:self->values index:index]);
	if(kvp == nil) {
		return(nil);
	}
	return(kvp->value);
}

- (int) count {
	if(self->values == nil) {
		return(0);
	}
	return([CapeVector getSize:self->values]);
}

- (void) clear {
	self->values = nil;
}

@end
