
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
#import "CapeDynamicMap.h"
#import "CapeStack.h"
#import "CapeDynamicVector.h"
#import "CapeCharacterIterator.h"
#import "CapeStringBuilder.h"
#import "CapeFile.h"
#import "CapeFileReader.h"
#import "CapeCharacterIteratorForReader.h"
#import "CapeReader.h"
#import "CapeCharacterIteratorForString.h"
#import "CapeString.h"
#import "CapeCharacterDecoder.h"
#import "CapexXMLParser.h"

@class CapexXMLParserStartElement;
@class CapexXMLParserEndElement;
@class CapexXMLParserCharacterData;
@class CapexXMLParserComment;

@implementation CapexXMLParserStartElement

{
	NSString* name;
	CapeDynamicMap* params;
}

- (CapexXMLParserStartElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->params = nil;
	self->name = nil;
	return(self);
}

- (NSString*) getParam:(NSString*)pname {
	if(self->params == nil) {
		return(nil);
	}
	return([self->params getString:pname defval:nil]);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexXMLParserStartElement*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (CapeDynamicMap*) getParams {
	return(self->params);
}

- (CapexXMLParserStartElement*) setParams:(CapeDynamicMap*)v {
	self->params = v;
	return(self);
}

@end

@implementation CapexXMLParserEndElement

{
	NSString* name;
}

- (CapexXMLParserEndElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->name = nil;
	return(self);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexXMLParserEndElement*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

@end

@implementation CapexXMLParserCharacterData

{
	NSString* data;
}

- (CapexXMLParserCharacterData*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	return(self);
}

- (NSString*) getData {
	return(self->data);
}

- (CapexXMLParserCharacterData*) setData:(NSString*)v {
	self->data = v;
	return(self);
}

@end

@implementation CapexXMLParserComment

{
	NSString* text;
}

- (CapexXMLParserComment*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->text = nil;
	return(self);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexXMLParserComment*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

@end

@implementation CapexXMLParser

{
	id<CapeCharacterIterator> it;
	id nextQueue;
	NSString* cdataStart;
	NSString* commentStart;
	CapeStringBuilder* tag;
	CapeStringBuilder* def;
	CapeStringBuilder* cdata;
	CapeStringBuilder* comment;
	BOOL ignoreWhiteSpace;
}

- (CapexXMLParser*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->ignoreWhiteSpace = FALSE;
	self->comment = nil;
	self->cdata = nil;
	self->def = nil;
	self->tag = nil;
	self->commentStart = @"!--";
	self->cdataStart = @"![CDATA[";
	self->nextQueue = nil;
	self->it = nil;
	return(self);
}

+ (CapeDynamicMap*) parseAsTreeObject:(NSString*)xml ignoreWhiteSpace:(BOOL)ignoreWhiteSpace {
	CapeDynamicMap* root = nil;
	CapeStack* stack = [[CapeStack alloc] init];
	CapexXMLParser* pp = [CapexXMLParser forString:xml];
	[pp setIgnoreWhiteSpace:ignoreWhiteSpace];
	while(TRUE) {
		id o = [pp next];
		if(o == nil) {
			break;
		}
		if([o isKindOfClass:[CapexXMLParserStartElement class]]) {
			CapeDynamicMap* nn = [[CapeDynamicMap alloc] init];
			[nn setStringAndObject:@"name" value:((id)[((CapexXMLParserStartElement*)o) getName])];
			[nn setStringAndObject:@"attributes" value:((id)[((CapexXMLParserStartElement*)o) getParams])];
			if(root == nil) {
				root = nn;
				[stack push:((id)nn)];
			}
			else {
				CapeDynamicMap* current = ((CapeDynamicMap*)[stack peek]);
				if(current == nil) {
					current = root;
				}
				CapeDynamicVector* children = [current getDynamicVector:@"children"];
				if(children == nil) {
					children = [[CapeDynamicVector alloc] init];
					[current setStringAndObject:@"children" value:((id)children)];
				}
				[children appendObject:((id)nn)];
				[stack push:((id)nn)];
			}
		}
		else {
			if([o isKindOfClass:[CapexXMLParserEndElement class]]) {
				[stack pop];
			}
			else {
				if([o isKindOfClass:[CapexXMLParserCharacterData class]]) {
					CapeDynamicMap* current = ((CapeDynamicMap*)[stack peek]);
					if(current != nil) {
						CapeDynamicVector* children = [current getDynamicVector:@"children"];
						if(children == nil) {
							children = [[CapeDynamicVector alloc] init];
							[current setStringAndObject:@"children" value:((id)children)];
						}
						[children appendObject:((id)[((CapexXMLParserCharacterData*)o) getData])];
					}
				}
			}
		}
	}
	return(root);
}

+ (CapexXMLParser*) forFile:(id<CapeFile>)file {
	if(file == nil) {
		return(nil);
	}
	id<CapeFileReader> reader = [file read];
	if(reader == nil) {
		return(nil);
	}
	CapexXMLParser* v = [[CapexXMLParser alloc] init];
	v->it = ((id<CapeCharacterIterator>)[[CapeCharacterIteratorForReader alloc] initWithReader:((id<CapeReader>)reader)]);
	return(v);
}

+ (CapexXMLParser*) forString:(NSString*)_x_string {
	if(({ NSString* _s1 = _x_string; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapexXMLParser* v = [[CapexXMLParser alloc] init];
	v->it = ((id<CapeCharacterIterator>)[[CapeCharacterIteratorForString alloc] initWithString:_x_string]);
	return(v);
}

+ (CapexXMLParser*) forIterator:(id<CapeCharacterIterator>)it {
	if(it == nil) {
		return(nil);
	}
	CapexXMLParser* v = [[CapexXMLParser alloc] init];
	v->it = it;
	return(v);
}

- (id) onTagString:(NSString*)tagstring {
	if([CapeString charAt:tagstring index:0] == '/') {
		return(((id)[[[CapexXMLParserEndElement alloc] init] setName:[CapeString subStringWithStringAndSignedInteger:tagstring start:1]]));
	}
	CapeStringBuilder* element = [[CapeStringBuilder alloc] init];
	CapeDynamicMap* params = [[CapeDynamicMap alloc] init];
	CapeCharacterIteratorForString* it = [[CapeCharacterIteratorForString alloc] initWithString:tagstring];
	int c = ' ';
	while((c = [it getNextChar]) > 0) {
		if(c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '/') {
			if([element count] > 0) {
				break;
			}
		}
		else {
			[element appendCharacter:c];
		}
	}
	while(c > 0 && c != '/') {
		CapeStringBuilder* pname = [[CapeStringBuilder alloc] init];
		CapeStringBuilder* pval = [[CapeStringBuilder alloc] init];
		while(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
			c = [it getNextChar];
		}
		while(c > 0 && c != ' ' && c != '\t' && c != '\n' && c != '\r' && c != '=') {
			[pname appendCharacter:c];
			c = [it getNextChar];
		}
		while(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
			c = [it getNextChar];
		}
		if(c != '=') {
			;
		}
		else {
			c = [it getNextChar];
			while(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
				c = [it getNextChar];
			}
			if(c != '\"') {
				;
				while(c > 0 && c != ' ' && c != '\t' && c != '\n' && c != '\r') {
					[pval appendCharacter:c];
					c = [it getNextChar];
				}
				while(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
					c = [it getNextChar];
				}
			}
			else {
				c = [it getNextChar];
				while(c > 0 && c != '\"') {
					[pval appendCharacter:c];
					c = [it getNextChar];
				}
				if(c != '\"') {
					;
				}
				else {
					c = [it getNextChar];
				}
				while(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
					c = [it getNextChar];
				}
			}
		}
		NSString* pnamestr = [pname toString];
		NSString* pvalstr = [pval toString];
		[params setStringAndObject:pnamestr value:((id)pvalstr)];
	}
	NSString* els = [element toString];
	if(c == '/') {
		self->nextQueue = ((id)[[[CapexXMLParserEndElement alloc] init] setName:els]);
	}
	return(((id)[[[[CapexXMLParserStartElement alloc] init] setName:els] setParams:params]));
}

- (BOOL) isOnlyWhiteSpace:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	NSMutableArray* array = [CapeString toCharArray:str];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			int c = (int)({ NSNumber* _v = (NSNumber*)[array objectAtIndex:n]; _v == nil ? 0 : _v.intValue; });
			if(c == ' ' || c == '\t' || c == '\n' || c == '\r') {
				;
			}
			else {
				return(FALSE);
			}
		}
	}
	return(TRUE);
}

- (id) next {
	if(self->nextQueue != nil) {
		id v = self->nextQueue;
		self->nextQueue = nil;
		return(v);
	}
	while([self->it hasEnded] == FALSE) {
		int nxb = [self->it getNextChar];
		if(nxb < 1) {
			continue;
		}
		if(self->tag != nil) {
			if(nxb == '>') {
				NSString* ts = [self->tag toString];
				self->tag = nil;
				return([self onTagString:ts]);
			}
			[self->tag appendCharacter:nxb];
			if(nxb == '[' && [self->tag count] == [CapeString getLength:self->cdataStart] && [CapeString equals:self->cdataStart str2:[self->tag toString]]) {
				self->tag = nil;
				self->cdata = [[CapeStringBuilder alloc] init];
			}
			else {
				if(nxb == '-' && [self->tag count] == [CapeString getLength:self->commentStart] && [CapeString equals:self->commentStart str2:[self->tag toString]]) {
					self->tag = nil;
					self->comment = [[CapeStringBuilder alloc] init];
				}
			}
		}
		else {
			if(self->cdata != nil) {
				int c0 = nxb;
				int c1 = ' ';
				int c2 = ' ';
				if(c0 == ']') {
					c1 = [self->it getNextChar];
					if(c1 == ']') {
						c2 = [self->it getNextChar];
						if(c2 == '>') {
							NSString* dd = [self->cdata toString];
							self->cdata = nil;
							return(((id)[[[CapexXMLParserCharacterData alloc] init] setData:dd]));
						}
						else {
							[self->it moveToPreviousChar];
							[self->it moveToPreviousChar];
							[self->cdata appendCharacter:c0];
						}
					}
					else {
						[self->it moveToPreviousChar];
						[self->cdata appendCharacter:c0];
					}
				}
				else {
					[self->cdata appendCharacter:c0];
				}
			}
			else {
				if(self->comment != nil) {
					int c0 = nxb;
					int c1 = ' ';
					int c2 = ' ';
					if(c0 == '-') {
						c1 = [self->it getNextChar];
						if(c1 == '-') {
							c2 = [self->it getNextChar];
							if(c2 == '>') {
								NSString* ct = [self->comment toString];
								self->comment = nil;
								return(((id)[[[CapexXMLParserComment alloc] init] setText:ct]));
							}
							else {
								[self->it moveToPreviousChar];
								[self->it moveToPreviousChar];
								[self->comment appendCharacter:c0];
							}
						}
						else {
							[self->it moveToPreviousChar];
							[self->comment appendCharacter:c0];
						}
					}
					else {
						[self->comment appendCharacter:c0];
					}
				}
				else {
					if(nxb == '<') {
						if(self->def != nil) {
							NSString* cd = [self->def toString];
							self->def = nil;
							if(self->ignoreWhiteSpace && !(({ NSString* _s1 = cd; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
								if([self isOnlyWhiteSpace:cd]) {
									cd = nil;
								}
							}
							if(!(({ NSString* _s1 = cd; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
								[self->it moveToPreviousChar];
								return(((id)[[[CapexXMLParserCharacterData alloc] init] setData:cd]));
							}
						}
						self->tag = [[CapeStringBuilder alloc] init];
					}
					else {
						if(self->def == nil) {
							self->def = [[CapeStringBuilder alloc] init];
						}
						[self->def appendCharacter:nxb];
					}
				}
			}
		}
	}
	return(nil);
}

- (BOOL) getIgnoreWhiteSpace {
	return(self->ignoreWhiteSpace);
}

- (CapexXMLParser*) setIgnoreWhiteSpace:(BOOL)v {
	self->ignoreWhiteSpace = v;
	return(self);
}

@end
