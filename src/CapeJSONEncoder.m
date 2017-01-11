
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
#import "CapeStringBuilder.h"
#import "CapeDynamicVector.h"
#import "CapeIterator.h"
#import "CapeMap.h"
#import "CapeDynamicMap.h"
#import "CapeKeyValueListForStrings.h"
#import "CapeKeyValuePair.h"
#import "CapeKeyValueList.h"
#import "CapeCharacterIteratorForString.h"
#import "CapeCharacterDecoder.h"
#import "CapeStringObject.h"
#import "CapeArrayObject.h"
#import "CapeVectorObject.h"
#import "CapeIntegerObject.h"
#import "CapeBooleanObject.h"
#import "CapeDoubleObject.h"
#import "CapeCharacterObject.h"
#import "CapeString.h"
#import "CapeJSONEncoder.h"

@implementation CapeJSONEncoder

{
	BOOL isNewLine;
}

- (CapeJSONEncoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isNewLine = TRUE;
	return(self);
}

- (void) print:(NSString*)line indent:(int)indent startline:(BOOL)startline endline:(BOOL)endline sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	if(startline && self->isNewLine == FALSE) {
		if(niceFormatting) {
			[sb appendCharacter:'\n'];
		}
		else {
			[sb appendCharacter:' '];
		}
		self->isNewLine = TRUE;
	}
	if(self->isNewLine && niceFormatting) {
		for(int n = 0 ; n < indent ; n++) {
			[sb appendCharacter:'\t'];
		}
	}
	[sb appendString:line];
	if(endline) {
		if(niceFormatting) {
			[sb appendCharacter:'\n'];
		}
		else {
			[sb appendCharacter:' '];
		}
		self->isNewLine = TRUE;
	}
	else {
		self->isNewLine = FALSE;
	}
}

- (void) encodeArray:(NSMutableArray*)cc indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"[" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	if(cc != nil) {
		int n = 0;
		int m = [cc count];
		for(n = 0 ; n < m ; n++) {
			id o = ((id)[cc objectAtIndex:n]);
			if(o != nil) {
				if(first == FALSE) {
					[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
				}
				[self encodeObject:o indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				first = FALSE;
			}
		}
	}
	[self print:@"]" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeDynamicVector:(CapeDynamicVector*)cc indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"[" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	id<CapeIterator> it = [cc iterate];
	while(it != nil) {
		id o = [it next];
		if(o == nil) {
			break;
		}
		if(first == FALSE) {
			[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
		}
		[self encodeObject:o indent:indent + 1 sb:sb niceFormatting:niceFormatting];
		first = FALSE;
	}
	[self print:@"]" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeVector:(NSMutableArray*)cc indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"[" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	if(cc != nil) {
		int n = 0;
		int m = [cc count];
		for(n = 0 ; n < m ; n++) {
			id o = ((id)[cc objectAtIndex:n]);
			if(o != nil) {
				if(first == FALSE) {
					[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
				}
				[self encodeObject:o indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				first = FALSE;
			}
		}
	}
	[self print:@"]" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeMap:(NSMutableDictionary*)map indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"{" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	NSMutableArray* keys = [CapeMap getKeys:map];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				if(first == FALSE) {
					[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
				}
				[self encodeString:key indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				[sb appendString:@" : "];
				[self encodeObject:((id)[map objectForKey:key]) indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				first = FALSE;
			}
		}
	}
	[self print:@"}" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeDynamicMap:(CapeDynamicMap*)map indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"{" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	NSMutableArray* keys = [map getKeys];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				if(first == FALSE) {
					[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
				}
				[self encodeString:key indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				[sb appendString:@" : "];
				[self encodeObject:[map get:key] indent:indent + 1 sb:sb niceFormatting:niceFormatting];
				first = FALSE;
			}
		}
	}
	[self print:@"}" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeKeyValueList:(CapeKeyValueListForStrings*)list indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	[self print:@"{" indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
	BOOL first = TRUE;
	id<CapeIterator> it = [list iterate];
	while(it != nil) {
		CapeKeyValuePair* pair = ((CapeKeyValuePair*)[it next]);
		if(pair == nil) {
			break;
		}
		if(first == FALSE) {
			[self print:@"," indent:indent startline:FALSE endline:TRUE sb:sb niceFormatting:niceFormatting];
		}
		[self encodeString:pair->key indent:indent + 1 sb:sb niceFormatting:niceFormatting];
		[sb appendString:@" : "];
		[self encodeString:pair->value indent:indent + 1 sb:sb niceFormatting:niceFormatting];
		first = FALSE;
	}
	[self print:@"}" indent:indent startline:TRUE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeString:(NSString*)s indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	CapeStringBuilder* mysb = [[CapeStringBuilder alloc] init];
	[mysb appendCharacter:'\"'];
	CapeCharacterIteratorForString* it = [[CapeCharacterIteratorForString alloc] initWithString:s];
	while(TRUE) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		if(c == '\"') {
			[mysb appendCharacter:'\\'];
		}
		else {
			if(c == '\\') {
				[mysb appendCharacter:'\\'];
			}
		}
		[mysb appendCharacter:c];
	}
	[mysb appendCharacter:'\"'];
	[self print:[mysb toString] indent:indent startline:FALSE endline:FALSE sb:sb niceFormatting:niceFormatting];
}

- (void) encodeObject:(id)o indent:(int)indent sb:(CapeStringBuilder*)sb niceFormatting:(BOOL)niceFormatting {
	if(o == nil) {
		[self encodeString:@"" indent:indent sb:sb niceFormatting:niceFormatting];
	}
	else {
		if([o isKindOfClass:[NSMutableArray class]]) {
			[self encodeArray:((NSMutableArray*)o) indent:indent sb:sb niceFormatting:niceFormatting];
		}
		else {
			if([o isKindOfClass:[NSMutableArray class]]) {
				[self encodeVector:((NSMutableArray*)o) indent:indent sb:sb niceFormatting:niceFormatting];
			}
			else {
				if([o isKindOfClass:[CapeDynamicMap class]]) {
					[self encodeDynamicMap:((CapeDynamicMap*)o) indent:indent sb:sb niceFormatting:niceFormatting];
				}
				else {
					if([o isKindOfClass:[NSString class]]) {
						[self encodeString:((NSString*)o) indent:indent sb:sb niceFormatting:niceFormatting];
					}
					else {
						if([((NSObject*)o) conformsToProtocol:@protocol(CapeStringObject)]) {
							[self encodeString:[((id<CapeStringObject>)o) toString] indent:indent sb:sb niceFormatting:niceFormatting];
						}
						else {
							if([((NSObject*)o) conformsToProtocol:@protocol(CapeArrayObject)]) {
								NSMutableArray* aa = [((id<CapeArrayObject>)o) toArray];
								[self encodeArray:aa indent:indent sb:sb niceFormatting:niceFormatting];
							}
							else {
								if([((NSObject*)o) conformsToProtocol:@protocol(CapeVectorObject)]) {
									NSMutableArray* vv = [((id<CapeVectorObject>)o) toVector];
									[self encodeVector:vv indent:indent sb:sb niceFormatting:niceFormatting];
								}
								else {
									if([o isKindOfClass:[CapeDynamicVector class]]) {
										NSMutableArray* vv = [((id<CapeVectorObject>)o) toVector];
										[self encodeDynamicVector:[CapeDynamicVector forObjectVector:vv] indent:indent sb:sb niceFormatting:niceFormatting];
									}
									else {
										if([o isKindOfClass:[CapeKeyValueListForStrings class]]) {
											[self encodeKeyValueList:((CapeKeyValueListForStrings*)o) indent:indent sb:sb niceFormatting:niceFormatting];
										}
										else {
											if([((NSObject*)o) conformsToProtocol:@protocol(CapeIntegerObject)] || [((NSObject*)o) conformsToProtocol:@protocol(CapeBooleanObject)] || [((NSObject*)o) conformsToProtocol:@protocol(CapeDoubleObject)] || [((NSObject*)o) conformsToProtocol:@protocol(CapeCharacterObject)]) {
												[self encodeString:[CapeString asStringWithObject:o] indent:indent sb:sb niceFormatting:niceFormatting];
											}
											else {
												[self encodeString:@"" indent:indent sb:sb niceFormatting:niceFormatting];
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

+ (NSString*) encode:(id)o niceFormatting:(BOOL)niceFormatting {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[[[CapeJSONEncoder alloc] init] encodeObject:o indent:0 sb:sb niceFormatting:niceFormatting];
	return([sb toString]);
}

@end
