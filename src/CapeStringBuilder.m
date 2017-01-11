
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
#import "CapeString.h"
#import "CapeStringBuilder.h"

@implementation CapeStringBuilder

{
	NSMutableString* data;
}

- (CapeStringBuilder*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	[self initialize];
	return(self);
}

- (CapeStringBuilder*) initWithString:(NSString*)initial {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	[self initialize];
	[self appendString:initial];
	return(self);
}

- (CapeStringBuilder*) initWithStringBuilder:(CapeStringBuilder*)initial {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	[self initialize];
	if(initial != nil) {
		[self appendString:[initial toString]];
	}
	return(self);
}

- (void) initialize {
	data = [[NSMutableString alloc] init];
}

- (void) clear {
	[self initialize];
}

- (int) count {
	return([data length]);
}

- (CapeStringBuilder*) appendSignedInteger:(int)c {
	return([self appendString:[CapeString forInteger:c]]);
}

- (CapeStringBuilder*) appendCharacter:(int)c {
	if(c == 0) {
		return(self);
	}
	return([self appendString:[CapeString forCharacter:c]]);
}

- (CapeStringBuilder*) appendDouble:(double)c {
	return([self appendString:[CapeString forDouble:c]]);
}

- (CapeStringBuilder*) appendFloat:(float)c {
	return([self appendString:[CapeString forFloat:c]]);
}

- (CapeStringBuilder*) appendString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(self);
	}
	[data appendString:str];
	return(self);
}

- (CapeStringBuilder*) insertSignedIntegerAndSignedInteger:(int)index c:(int)c {
	return([self insertSignedIntegerAndString:index str:[CapeString forInteger:c]]);
}

- (CapeStringBuilder*) insertSignedIntegerAndCharacter:(int)index c:(int)c {
	if(c == 0) {
		return(self);
	}
	return([self insertSignedIntegerAndString:index str:[CapeString forCharacter:c]]);
}

- (CapeStringBuilder*) insertSignedIntegerAndDouble:(int)index c:(double)c {
	return([self insertSignedIntegerAndString:index str:[CapeString forDouble:c]]);
}

- (CapeStringBuilder*) insertSignedIntegerAndFloat:(int)index c:(float)c {
	return([self insertSignedIntegerAndString:index str:[CapeString forFloat:c]]);
}

- (CapeStringBuilder*) insertSignedIntegerAndString:(int)index str:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(self);
	}
	[data insertString:str atIndex:index];
	return(self);
}

- (NSString*) toString {
	return([NSString stringWithString:data]);
}

@end
