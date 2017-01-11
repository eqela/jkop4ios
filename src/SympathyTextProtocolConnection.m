
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
#import "SympathyNetworkConnection.h"
#import "CapeBuffer.h"
#import "CapeString.h"
#import "SympathyTextProtocolConnection.h"

@implementation SympathyTextProtocolConnection

{
	NSString* encoding;
}

- (SympathyTextProtocolConnection*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->encoding = nil;
	return(self);
}

- (void) onDataReceived:(NSMutableData*)data size:(int)size {
	if(size < 1) {
		return;
	}
	NSMutableData* sb = [CapeBuffer getSubBuffer:data offset:((long long)0) size:((long long)size) alwaysNewBuffer:FALSE];
	if(sb == nil) {
		return;
	}
	NSString* str = nil;
	if(({ NSString* _s1 = self->encoding; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		str = [CapeString forUTF8Buffer:sb];
	}
	else {
		str = [CapeString forBuffer:data encoding:self->encoding];
	}
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	[self onTextReceived:str];
}

- (void) sendText:(NSString*)text {
	if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	[self sendData:[CapeString toUTF8Buffer:text] size:-1];
}

- (void) onTextReceived:(NSString*)data {
}

- (NSString*) getEncoding {
	return(self->encoding);
}

- (SympathyTextProtocolConnection*) setEncoding:(NSString*)v {
	self->encoding = v;
	return(self);
}

@end
