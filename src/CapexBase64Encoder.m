
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
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapeBuffer.h"
#import "CapexBase64Encoder.h"

@implementation CapexBase64Encoder

- (CapexBase64Encoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) encodeString:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([CapexBase64Encoder encode:[CapeString toUTF8Buffer:str]]);
}

+ (NSString*) encode:(NSMutableData*)buffer {
	if(buffer == nil) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	long long i = ((long long)0);
	int b64i = 0;
	long long size = [CapeBuffer getSize:buffer];
	while(i < size) {
		b64i = ((int)([CapeBuffer getByte:buffer offset:i] >> 2));
		[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
		b64i = ((int)(([CapeBuffer getByte:buffer offset:i] & 3) << 4));
		if(i + 1 < size) {
			b64i += ((int)([CapeBuffer getByte:buffer offset:i + 1] >> 4));
			[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
			b64i = ((int)(([CapeBuffer getByte:buffer offset:i + 1] & 15) << 2));
			if(i + 2 < size) {
				b64i += ((int)([CapeBuffer getByte:buffer offset:i + 2] >> 6));
				[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
				b64i = ((int)([CapeBuffer getByte:buffer offset:i + 2] & 63));
				[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
			}
			else {
				[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
				[sb appendString:@"="];
			}
		}
		else {
			[sb appendCharacter:[CapexBase64Encoder toASCIIChar:b64i]];
			[sb appendString:@"=="];
		}
		i += ((long long)3);
	}
	if(sb != nil) {
		return([sb toString]);
	}
	return(nil);
}

+ (int) toASCIIChar:(int)lookup {
	int c = 0;
	if(lookup < 0 || lookup > 63) {
		return(((int)c));
	}
	if(lookup <= 25) {
		c = lookup + 65;
	}
	else {
		if(lookup <= 51) {
			c = lookup + 71;
		}
		else {
			if(lookup <= 61) {
				c = lookup - 4;
			}
			else {
				if(lookup == 62) {
					c = ((int)'+');
				}
				else {
					if(lookup == 63) {
						c = ((int)'/');
					}
				}
			}
		}
	}
	return(((int)c));
}

@end
