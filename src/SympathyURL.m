
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
#import "CapeKeyValueList.h"
#import "CapeMap.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeIterator.h"
#import "CapexURLEncoder.h"
#import "CapeVector.h"
#import "CapexURLDecoder.h"
#import "SympathyURL.h"

@implementation SympathyURL

{
	NSString* scheme;
	NSString* username;
	NSString* password;
	NSString* host;
	NSString* port;
	NSString* path;
	NSString* fragment;
	CapeKeyValueList* rawQueryParameters;
	NSMutableDictionary* queryParameters;
	NSString* original;
	BOOL percentOnly;
	BOOL encodeUnreservedChars;
}

- (SympathyURL*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->encodeUnreservedChars = TRUE;
	self->percentOnly = FALSE;
	self->original = nil;
	self->queryParameters = nil;
	self->rawQueryParameters = nil;
	self->fragment = nil;
	self->path = nil;
	self->port = nil;
	self->host = nil;
	self->password = nil;
	self->username = nil;
	self->scheme = nil;
	return(self);
}

+ (SympathyURL*) forString:(NSString*)str normalizePath:(BOOL)normalizePath {
	SympathyURL* v = [[SympathyURL alloc] init];
	[v parse:str doNormalizePath:normalizePath];
	return(v);
}

- (SympathyURL*) dup {
	SympathyURL* v = [[SympathyURL alloc] init];
	[v setScheme:self->scheme];
	[v setUsername:self->username];
	[v setPassword:self->password];
	[v setHost:self->host];
	[v setPort:self->port];
	[v setPath:self->path];
	[v setFragment:self->fragment];
	if(self->rawQueryParameters != nil) {
		[v setRawQueryParameters:[self->rawQueryParameters dup]];
	}
	if(self->queryParameters != nil) {
		[v setQueryParameters:[CapeMap dup:self->queryParameters]];
	}
	return(v);
}

- (NSString*) toString {
	return([self toStringDo:TRUE]);
}

- (NSString*) toStringNohost {
	return([self toStringDo:FALSE]);
}

- (NSString*) toStringDo:(BOOL)userhost {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(userhost) {
		if(!(({ NSString* _s1 = self->scheme; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			[sb appendString:self->scheme];
			[sb appendString:@"://"];
		}
		if(!(({ NSString* _s1 = self->username; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			[sb appendString:self->username];
			if(!(({ NSString* _s1 = self->password; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				[sb appendCharacter:':'];
				[sb appendString:self->password];
			}
			[sb appendCharacter:'@'];
		}
		if(!(({ NSString* _s1 = self->host; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			[sb appendString:self->host];
			if(!(({ NSString* _s1 = self->port; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				[sb appendCharacter:':'];
				[sb appendString:self->port];
			}
		}
	}
	if(!(({ NSString* _s1 = self->path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[sb appendString:[CapeString replaceStringAndCharacterAndCharacter:self->path oldChar:' ' newChar:'+']];
	}
	if(self->rawQueryParameters != nil && [self->rawQueryParameters count] > 0) {
		BOOL first = TRUE;
		id<CapeIterator> it = [CapeMap iterateKeys:self->queryParameters];
		while(it != nil) {
			NSString* key = ((NSString*)({ id _v = [it next]; [_v isKindOfClass:[NSString class]] ? _v : nil; }));
			if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				break;
			}
			if(first) {
				[sb appendCharacter:'?'];
				first = FALSE;
			}
			else {
				[sb appendCharacter:'&'];
			}
			[sb appendString:key];
			NSString* val = [CapeMap getMapAndDynamic:self->queryParameters key:((id)key)];
			if(!(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				[sb appendCharacter:'='];
				[sb appendString:[CapexURLEncoder encode:val percentOnly:self->percentOnly encodeUnreservedChars:self->encodeUnreservedChars]];
			}
		}
	}
	if(!(({ NSString* _s1 = self->fragment; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[sb appendCharacter:'#'];
		[sb appendString:self->fragment];
	}
	return([sb toString]);
}

- (NSString*) normalizePath:(NSString*)path {
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapeStringBuilder* v = [[CapeStringBuilder alloc] init];
	NSMutableArray* comps = [CapeString split:path delim:'/' max:0];
	if(comps != nil) {
		int n = 0;
		int m = [comps count];
		for(n = 0 ; n < m ; n++) {
			NSString* comp = ((NSString*)[comps objectAtIndex:n]);
			if(comp != nil) {
				if([CapeString isEmpty:comp]) {
					;
				}
				else {
					if(({ NSString* _s1 = comp; NSString* _s2 = @"."; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						;
					}
					else {
						if(({ NSString* _s1 = comp; NSString* _s2 = @".."; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							NSString* str = [v toString];
							[v clear];
							if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
								int slash = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:str c:'/' start:-1];
								if(slash > 0) {
									[v appendString:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:str start:0 length:slash]];
								}
							}
						}
						else {
							[v appendCharacter:'/'];
							[v appendString:comp];
						}
					}
				}
			}
		}
	}
	if([v count] < 2) {
		return(@"/");
	}
	if([CapeString endsWith:path str2:@"/"]) {
		[v appendCharacter:'/'];
	}
	return([v toString]);
}

- (void) parse:(NSString*)astr doNormalizePath:(BOOL)doNormalizePath {
	[self setOriginal:astr];
	if(({ NSString* _s1 = astr; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	NSMutableArray* fsp = [CapeString split:astr delim:'#' max:2];
	NSString* str = [CapeVector get:fsp index:0];
	self->fragment = [CapeVector get:fsp index:1];
	NSMutableArray* qsplit = [CapeString split:str delim:'?' max:2];
	str = [CapeVector get:qsplit index:0];
	NSString* queryString = [CapeVector get:qsplit index:1];
	if([CapeString isEmpty:queryString] == FALSE) {
		NSMutableArray* qss = [CapeString split:queryString delim:'&' max:0];
		if(qss != nil) {
			int n = 0;
			int m = [qss count];
			for(n = 0 ; n < m ; n++) {
				NSString* qs = ((NSString*)[qss objectAtIndex:n]);
				if(qs != nil) {
					if(self->rawQueryParameters == nil) {
						self->rawQueryParameters = [[CapeKeyValueList alloc] init];
					}
					if(self->queryParameters == nil) {
						self->queryParameters = [[NSMutableDictionary alloc] init];
					}
					if([CapeString indexOfWithStringAndCharacterAndSignedInteger:qs c:'=' start:0] < 0) {
						[CapeMap set:self->queryParameters key:((id)qs) val:nil];
						[self->rawQueryParameters addDynamicAndDynamic:((id)qs) val:nil];
						continue;
					}
					NSMutableArray* qsps = [CapeString split:qs delim:'=' max:2];
					NSString* key = [CapeVector get:qsps index:0];
					NSString* val = [CapeVector get:qsps index:1];
					if([CapeString isEmpty:key] == FALSE) {
						if(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							val = @"";
						}
						NSString* udv = [CapexURLDecoder decode:val];
						[CapeMap set:self->queryParameters key:((id)key) val:((id)udv)];
						[self->rawQueryParameters addDynamicAndDynamic:((id)key) val:((id)udv)];
					}
				}
			}
		}
	}
	int css = [CapeString indexOfWithStringAndStringAndSignedInteger:str s:@"://" start:0];
	if(css >= 0) {
		self->scheme = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:str start:0 length:css];
		if([CapeString indexOfWithStringAndCharacterAndSignedInteger:self->scheme c:':' start:0] >= 0 || [CapeString indexOfWithStringAndCharacterAndSignedInteger:self->scheme c:'/' start:0] >= 0) {
			self->scheme = nil;
		}
		else {
			str = [CapeString subStringWithStringAndSignedInteger:str start:css + 3];
		}
	}
	NSString* pp = nil;
	if([CapeString charAt:str index:0] == '/') {
		pp = [CapexURLDecoder decode:str];
	}
	else {
		if([CapeString indexOfWithStringAndCharacterAndSignedInteger:str c:'/' start:0] >= 0) {
			NSMutableArray* sssplit = [CapeString split:str delim:'/' max:2];
			str = [CapeVector get:sssplit index:0];
			pp = [CapeVector get:sssplit index:1];
			if(({ NSString* _s1 = pp; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				pp = @"";
			}
			if([CapeString charAt:pp index:0] != '/') {
				pp = [CapeString appendStringAndString:@"/" str2:pp];
			}
			pp = [CapexURLDecoder decode:pp];
		}
		if([CapeString indexOfWithStringAndCharacterAndSignedInteger:str c:'@' start:0] >= 0) {
			NSMutableArray* asplit = [CapeString split:str delim:'@' max:2];
			NSString* auth = [CapeVector get:asplit index:0];
			str = [CapeVector get:asplit index:1];
			if([CapeString indexOfWithStringAndCharacterAndSignedInteger:auth c:':' start:0] >= 0) {
				NSMutableArray* acsplit = [CapeString split:auth delim:':' max:2];
				self->username = [CapexURLDecoder decode:[CapeVector get:acsplit index:0]];
				self->password = [CapexURLDecoder decode:[CapeVector get:acsplit index:1]];
			}
			else {
				self->username = auth;
			}
		}
		if([CapeString indexOfWithStringAndCharacterAndSignedInteger:str c:':' start:0] >= 0) {
			NSMutableArray* hcsplit = [CapeString split:str delim:':' max:2];
			str = [CapeVector get:hcsplit index:0];
			self->port = [CapeVector get:hcsplit index:1];
		}
		self->host = str;
	}
	if(doNormalizePath) {
		self->path = [self normalizePath:pp];
	}
	else {
		self->path = pp;
	}
}

- (int) getPortInt {
	if(({ NSString* _s1 = self->port; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return([CapeString toInteger:self->port]);
}

- (NSString*) getQueryParameter:(NSString*)key {
	if(self->queryParameters == nil) {
		return(nil);
	}
	return([CapeMap getMapAndDynamic:self->queryParameters key:((id)key)]);
}

- (NSString*) getScheme {
	return(self->scheme);
}

- (SympathyURL*) setScheme:(NSString*)v {
	self->scheme = v;
	return(self);
}

- (NSString*) getUsername {
	return(self->username);
}

- (SympathyURL*) setUsername:(NSString*)v {
	self->username = v;
	return(self);
}

- (NSString*) getPassword {
	return(self->password);
}

- (SympathyURL*) setPassword:(NSString*)v {
	self->password = v;
	return(self);
}

- (NSString*) getHost {
	return(self->host);
}

- (SympathyURL*) setHost:(NSString*)v {
	self->host = v;
	return(self);
}

- (NSString*) getPort {
	return(self->port);
}

- (SympathyURL*) setPort:(NSString*)v {
	self->port = v;
	return(self);
}

- (NSString*) getPath {
	return(self->path);
}

- (SympathyURL*) setPath:(NSString*)v {
	self->path = v;
	return(self);
}

- (NSString*) getFragment {
	return(self->fragment);
}

- (SympathyURL*) setFragment:(NSString*)v {
	self->fragment = v;
	return(self);
}

- (CapeKeyValueList*) getRawQueryParameters {
	return(self->rawQueryParameters);
}

- (SympathyURL*) setRawQueryParameters:(CapeKeyValueList*)v {
	self->rawQueryParameters = v;
	return(self);
}

- (NSMutableDictionary*) getQueryParameters {
	return(self->queryParameters);
}

- (SympathyURL*) setQueryParameters:(NSMutableDictionary*)v {
	self->queryParameters = v;
	return(self);
}

- (NSString*) getOriginal {
	return(self->original);
}

- (SympathyURL*) setOriginal:(NSString*)v {
	self->original = v;
	return(self);
}

- (BOOL) getPercentOnly {
	return(self->percentOnly);
}

- (SympathyURL*) setPercentOnly:(BOOL)v {
	self->percentOnly = v;
	return(self);
}

- (BOOL) getEncodeUnreservedChars {
	return(self->encodeUnreservedChars);
}

- (SympathyURL*) setEncodeUnreservedChars:(BOOL)v {
	self->encodeUnreservedChars = v;
	return(self);
}

@end
