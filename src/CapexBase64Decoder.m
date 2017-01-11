
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
#import "CapeCharacterIterator.h"
#import "CapeString.h"
#import "CapexBase64Decoder.h"

@implementation CapexBase64Decoder

- (CapexBase64Decoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSMutableData*) appendByte:(NSMutableData*)buffer byte:(uint8_t)byte {
	NSMutableData* nbyte = [CapeBuffer allocate:((long long)1)];
	[CapeBuffer setByte:nbyte offset:((long long)0) value:byte];
	return([CapeBuffer append:buffer toAppend:nbyte size:[CapeBuffer getSize:nbyte]]);
}

+ (int) fromLookupChar:(int)ascii {
	int c = 0;
	if(ascii == 43) {
		c = 62;
	}
	else {
		if(ascii == 47) {
			c = 63;
		}
		else {
			if(ascii >= 48 && ascii <= 57) {
				c = ((int)(ascii + 4));
			}
			else {
				if(ascii >= 65 && ascii <= 90) {
					c = ((int)(ascii - 65));
				}
				else {
					if(ascii >= 97 && ascii <= 122) {
						c = ((int)(ascii - 71));
					}
				}
			}
		}
	}
	return(c);
}

+ (NSMutableData*) decode:(NSString*)text {
	if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSMutableData* data = [NSMutableData dataWithLength:0];
	id<CapeCharacterIterator> iter = [CapeString iterate:text];
	BOOL done = FALSE;
	if(iter != nil) {
		int ch = ((int)0);
		while((ch = [iter getNextChar]) > 0) {
			int c1 = 0;
			int c2 = 0;
			int c3 = 0;
			int c4 = 0;
			uint8_t byte1 = ((uint8_t)0);
			uint8_t byte2 = ((uint8_t)0);
			uint8_t byte3 = ((uint8_t)0);
			c1 = [CapexBase64Decoder fromLookupChar:ch];
			c2 = [CapexBase64Decoder fromLookupChar:ch = [iter getNextChar]];
			byte1 = ((uint8_t)((c1 << 2) + (c2 >> 4)));
			data = [CapexBase64Decoder appendByte:data byte:byte1];
			ch = [iter getNextChar];
			if(ch == '=') {
				done = TRUE;
			}
			else {
				c3 = [CapexBase64Decoder fromLookupChar:ch];
			}
			byte2 = ((uint8_t)(((c2 & 15) << 4) + (c3 >> 2)));
			data = [CapexBase64Decoder appendByte:data byte:byte2];
			if(!done) {
				ch = [iter getNextChar];
				if(ch == '=') {
					done = TRUE;
				}
				else {
					c4 = [CapexBase64Decoder fromLookupChar:ch];
				}
				byte3 = ((uint8_t)(((c3 & 3) << 6) + c4));
				data = [CapexBase64Decoder appendByte:data byte:byte3];
			}
			if(done) {
				break;
			}
		}
	}
	return(data);
}

@end
