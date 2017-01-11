
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
#import "CapeBuffer.h"
#import "CapeString.h"
#import "CapexMD5Encoder.h"

@implementation CapexMD5Encoder

- (CapexMD5Encoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) encodeBuffer:(NSMutableData*)buffer {
	if(buffer == nil || [CapeBuffer getSize:buffer] < 1) {
		return(nil);
	}
	NSLog(@"%@", @"[capex.MD5Encoder.encode] (MD5Encoder.sling:104:2): Not implemented.");
	return(nil);
}

+ (NSString*) encodeString:(NSString*)_x_string {
	return([CapexMD5Encoder encodeBuffer:[CapeString toUTF8Buffer:_x_string]]);
}

+ (NSString*) encodeObject:(id)obj {
	NSMutableData* bb = [CapeBuffer asBuffer:obj];
	if(bb != nil) {
		return([CapexMD5Encoder encodeBuffer:bb]);
	}
	NSString* ss = [CapeString asStringWithObject:obj];
	if(!(({ NSString* _s1 = ss; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([CapexMD5Encoder encodeObject:ss]);
	}
	return(nil);
}

@end
