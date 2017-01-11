
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
#import "CapeBufferWriter.h"
#import "CapexBlockCipherWriter.h"
#import "CapeWriter.h"
#import "CapeBuffer.h"
#import "CapeBufferReader.h"
#import "CapeSizedReader.h"
#import "CapexBlockCipherReader.h"
#import "CapeReader.h"
#import "CapexBlockCipher.h"

@implementation CapexBlockCipher

- (CapexBlockCipher*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSMutableData*) encryptString:(NSString*)data cipher:(CapexBlockCipher*)cipher {
	if(({ NSString* _s1 = data; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([CapexBlockCipher encryptBuffer:[CapeString toUTF8Buffer:data] cipher:cipher]);
}

+ (NSString*) decryptString:(NSMutableData*)data cipher:(CapexBlockCipher*)cipher {
	NSMutableData* db = [CapexBlockCipher decryptBuffer:data cipher:cipher];
	if(db == nil) {
		return(nil);
	}
	return([CapeString forUTF8Buffer:db]);
}

+ (NSMutableData*) encryptBuffer:(NSMutableData*)data cipher:(CapexBlockCipher*)cipher {
	if(cipher == nil || data == nil) {
		return(nil);
	}
	CapeBufferWriter* bw = [[CapeBufferWriter alloc] init];
	if(bw == nil) {
		return(nil);
	}
	CapexBlockCipherWriter* ww = [CapexBlockCipherWriter create:((id<CapeWriter>)bw) cipher:cipher];
	if(ww == nil) {
		return(nil);
	}
	int r = [ww write:data asize:-1];
	[ww close];
	if(r < [CapeBuffer getSize:data]) {
		return(nil);
	}
	return([bw getBuffer]);
}

+ (NSMutableData*) decryptBuffer:(NSMutableData*)data cipher:(CapexBlockCipher*)cipher {
	if(cipher == nil || data == nil) {
		return(nil);
	}
	CapeBufferReader* br = [CapeBufferReader forBuffer:data];
	if(br == nil) {
		return(nil);
	}
	id<CapeSizedReader> rr = [CapexBlockCipherReader create:((id<CapeSizedReader>)br) cipher:cipher];
	if(rr == nil) {
		return(nil);
	}
	NSMutableData* db = [CapeBuffer allocate:[CapeBuffer getSize:data]];
	if(db == nil) {
		return(nil);
	}
	int ll = [rr read:db];
	if(ll < 0) {
		return(nil);
	}
	if(ll < [CapeBuffer getSize:db]) {
		[CapeBuffer allocate:((long long)ll)];
	}
	return(db);
}

- (int) getBlockSize {
}

- (void) encryptBlock:(NSMutableData*)src dest:(NSMutableData*)dest {
}

- (void) decryptBlock:(NSMutableData*)src dest:(NSMutableData*)dest {
}

@end
