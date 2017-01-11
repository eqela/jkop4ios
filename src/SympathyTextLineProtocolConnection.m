
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
#import "SympathyTextProtocolConnection.h"
#import "CapeString.h"
#import "SympathyTextLineProtocolConnection.h"

@implementation SympathyTextLineProtocolConnection

{
	BOOL useCRLF;
}

- (SympathyTextLineProtocolConnection*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->useCRLF = FALSE;
	return(self);
}

- (void) sendLine:(NSString*)text {
	if(self->useCRLF) {
		[self sendText:[text stringByAppendingString:@"\r\n"]];
	}
	else {
		[self sendText:[text stringByAppendingString:@"\n"]];
	}
}

- (void) onTextReceived:(NSString*)data {
	if(({ NSString* _s1 = data; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	NSString* str = data;
	if([CapeString endsWith:str str2:@"\r\n"]) {
		str = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:str start:0 length:[CapeString getLength:str] - 2];
	}
	else {
		if([CapeString endsWith:str str2:@"\n"]) {
			str = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:str start:0 length:[CapeString getLength:str] - 1];
		}
	}
	int nn = [CapeString indexOfWithStringAndCharacterAndSignedInteger:str c:'\n' start:0];
	if(nn < 0) {
		[self onLineReceived:str];
		return;
	}
	NSMutableArray* array = [CapeString split:str delim:'\n' max:0];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* line = ((NSString*)[array objectAtIndex:n]);
			if(line != nil) {
				if([CapeString endsWith:line str2:@"\r"]) {
					line = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:line start:0 length:[CapeString getLength:line] - 1];
				}
				[self onLineReceived:line];
			}
		}
	}
}

- (void) onLineReceived:(NSString*)data {
}

- (BOOL) getUseCRLF {
	return(self->useCRLF);
}

- (SympathyTextLineProtocolConnection*) setUseCRLF:(BOOL)v {
	self->useCRLF = v;
	return(self);
}

@end
