
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
#import "CapeStringBuilder.h"
#import "CapeMap.h"
#import "CapeVector.h"
#import "CapeString.h"
#import "CapexXMLMaker.h"

@class CapexXMLMakerCData;
@class CapexXMLMakerStartElement;
@class CapexXMLMakerEndElement;
@class CapexXMLMakerElement;
@class CapexXMLMakerCustomXML;

@implementation CapexXMLMakerCData

{
	NSString* text;
	BOOL simple;
	BOOL singleLine;
}

- (CapexXMLMakerCData*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->singleLine = FALSE;
	self->simple = FALSE;
	self->text = nil;
	return(self);
}

- (CapexXMLMakerCData*) initWithString:(NSString*)t {
	if([super init] == nil) {
		return(nil);
	}
	self->singleLine = FALSE;
	self->simple = FALSE;
	self->text = nil;
	self->text = t;
	return(self);
}

- (NSString*) toString {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(self->simple) {
		[sb appendString:self->text];
	}
	else {
		[sb appendString:@"<![CDATA["];
		[sb appendString:self->text];
		[sb appendString:@"]]>"];
	}
	return([sb toString]);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexXMLMakerCData*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

- (BOOL) getSimple {
	return(self->simple);
}

- (CapexXMLMakerCData*) setSimple:(BOOL)v {
	self->simple = v;
	return(self);
}

- (BOOL) getSingleLine {
	return(self->singleLine);
}

- (CapexXMLMakerCData*) setSingleLine:(BOOL)v {
	self->singleLine = v;
	return(self);
}

@end

@implementation CapexXMLMakerStartElement

{
	NSString* name;
	NSMutableDictionary* attributes;
	BOOL single;
	BOOL singleLine;
}

- (CapexXMLMakerStartElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->singleLine = FALSE;
	self->single = FALSE;
	self->attributes = nil;
	self->name = nil;
	return(self);
}

- (CapexXMLMakerStartElement*) initWithString:(NSString*)n {
	if([super init] == nil) {
		return(nil);
	}
	self->singleLine = FALSE;
	self->single = FALSE;
	self->attributes = nil;
	self->name = nil;
	self->name = n;
	self->attributes = [[NSMutableDictionary alloc] init];
	return(self);
}

- (CapexXMLMakerStartElement*) attribute:(NSString*)key value:(NSString*)value {
	[CapeMap setValue:self->attributes key:((id)key) val:((id)value)];
	return(self);
}

- (NSString*) toString {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendCharacter:'<'];
	[sb appendString:self->name];
	NSMutableArray* keys = [CapeMap getKeys:self->attributes];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				[sb appendCharacter:' '];
				[sb appendString:key];
				[sb appendCharacter:'='];
				[sb appendCharacter:'\"'];
				NSString* val = [CapeMap getValue:self->attributes key:((id)key)];
				[sb appendString:val];
				[sb appendCharacter:'\"'];
			}
		}
	}
	if(self->single) {
		[sb appendCharacter:' '];
		[sb appendCharacter:'/'];
	}
	[sb appendCharacter:'>'];
	return([sb toString]);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexXMLMakerStartElement*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (NSMutableDictionary*) getAttributes {
	return(self->attributes);
}

- (CapexXMLMakerStartElement*) setAttributes:(NSMutableDictionary*)v {
	self->attributes = v;
	return(self);
}

- (BOOL) getSingle {
	return(self->single);
}

- (CapexXMLMakerStartElement*) setSingle:(BOOL)v {
	self->single = v;
	return(self);
}

- (BOOL) getSingleLine {
	return(self->singleLine);
}

- (CapexXMLMakerStartElement*) setSingleLine:(BOOL)v {
	self->singleLine = v;
	return(self);
}

@end

@implementation CapexXMLMakerEndElement

{
	NSString* name;
}

- (CapexXMLMakerEndElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->name = nil;
	return(self);
}

- (CapexXMLMakerEndElement*) initWithString:(NSString*)n {
	if([super init] == nil) {
		return(nil);
	}
	self->name = nil;
	self->name = n;
	return(self);
}

- (NSString*) toString {
	return([[@"</" stringByAppendingString:([self getName])] stringByAppendingString:@">"]);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexXMLMakerEndElement*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

@end

@implementation CapexXMLMakerElement

- (CapexXMLMakerElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

- (CapexXMLMakerElement*) initWithString:(NSString*)name {
	if([super initWithString:name] == nil) {
		return(nil);
	}
	[self setSingle:TRUE];
	return(self);
}

@end

@implementation CapexXMLMakerCustomXML

{
	NSString* _x_string;
}

- (CapexXMLMakerCustomXML*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->_x_string = nil;
	return(self);
}

- (CapexXMLMakerCustomXML*) initWithString:(NSString*)s {
	if([super init] == nil) {
		return(nil);
	}
	self->_x_string = nil;
	self->_x_string = s;
	return(self);
}

- (NSString*) getString {
	return(self->_x_string);
}

- (CapexXMLMakerCustomXML*) setString:(NSString*)v {
	self->_x_string = v;
	return(self);
}

@end

@implementation CapexXMLMaker

{
	NSMutableArray* elements;
	NSString* customHeader;
	BOOL singleLine;
	NSString* header;
}

- (CapexXMLMaker*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->header = nil;
	self->singleLine = FALSE;
	self->customHeader = nil;
	self->elements = nil;
	self->elements = [[NSMutableArray alloc] init];
	self->header = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
	return(self);
}

- (CapexXMLMaker*) startStringAndBoolean:(NSString*)element singleLine:(BOOL)singleLine {
	[self add:((id)[[[CapexXMLMakerStartElement alloc] initWithString:element] setSingleLine:singleLine])];
	return(self);
}

- (CapexXMLMaker*) startStringAndStringAndStringAndBoolean:(NSString*)element k1:(NSString*)k1 v1:(NSString*)v1 singleLine:(BOOL)singleLine {
	CapexXMLMakerStartElement* v = [[CapexXMLMakerStartElement alloc] initWithString:element];
	[v setSingleLine:singleLine];
	if(!(({ NSString* _s1 = k1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[v attribute:k1 value:v1];
	}
	[self add:((id)v)];
	return(self);
}

- (CapexXMLMaker*) startStringAndMapAndBoolean:(NSString*)element attrs:(NSMutableDictionary*)attrs singleLine:(BOOL)singleLine {
	CapexXMLMakerStartElement* v = [[CapexXMLMakerStartElement alloc] initWithString:element];
	[v setSingleLine:singleLine];
	if(attrs != nil) {
		NSMutableArray* keys = [CapeMap getKeys:attrs];
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					NSString* val = ((NSString*)[attrs objectForKey:key]);
					[v attribute:key value:val];
				}
			}
		}
	}
	[self add:((id)v)];
	return(self);
}

- (CapexXMLMaker*) element:(NSString*)element attrs:(NSMutableDictionary*)attrs {
	CapexXMLMakerElement* v = [[CapexXMLMakerElement alloc] initWithString:element];
	if(attrs != nil) {
		NSMutableArray* keys = [CapeMap getKeys:attrs];
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					NSString* val = ((NSString*)[attrs objectForKey:key]);
					[v attribute:key value:val];
				}
			}
		}
	}
	[self add:((id)v)];
	return(self);
}

- (CapexXMLMaker*) end:(NSString*)element {
	[self add:((id)[[CapexXMLMakerEndElement alloc] initWithString:element])];
	return(self);
}

- (CapexXMLMaker*) text:(NSString*)element {
	[self add:((id)element)];
	return(self);
}

- (CapexXMLMaker*) cdata:(NSString*)element {
	[self add:((id)[[CapexXMLMakerCData alloc] initWithString:element])];
	return(self);
}

- (CapexXMLMaker*) textElement:(NSString*)element text:(NSString*)text {
	[self add:((id)[[[CapexXMLMakerStartElement alloc] initWithString:element] setSingleLine:TRUE])];
	[self add:((id)text)];
	[self add:((id)[[CapexXMLMakerEndElement alloc] initWithString:element])];
	return(self);
}

- (CapexXMLMaker*) add:(id)o {
	if(o != nil) {
		[CapeVector append:self->elements object:o];
	}
	return(self);
}

- (void) append:(CapeStringBuilder*)sb level:(int)level str:(NSString*)str noIndent:(BOOL)noIndent noNewLine:(BOOL)noNewLine {
	int n = 0;
	if(self->singleLine == FALSE && noIndent == FALSE) {
		for(n = 0 ; n < level ; n++) {
			[sb appendCharacter:' '];
			[sb appendCharacter:' '];
		}
	}
	[sb appendString:str];
	if(self->singleLine == FALSE && noNewLine == FALSE) {
		[sb appendCharacter:'\n'];
	}
}

- (NSString*) escapeString:(NSString*)str {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		NSMutableArray* array = [CapeString toCharArray:str];
		if(array != nil) {
			int n = 0;
			int m = [array count];
			for(n = 0 ; n < m ; n++) {
				int c = (int)({ NSNumber* _v = (NSNumber*)[array objectAtIndex:n]; _v == nil ? 0 : _v.intValue; });
				if(c == '\"') {
					[sb appendString:@"&quot;"];
				}
				else {
					if(c == '\'') {
						[sb appendString:@"&apos;"];
					}
					else {
						if(c == '<') {
							[sb appendString:@"&lt;"];
						}
						else {
							if(c == '>') {
								[sb appendString:@"&gt;"];
							}
							else {
								if(c == '&') {
									[sb appendString:@"&amp;"];
								}
								else {
									[sb appendCharacter:c];
								}
							}
						}
					}
				}
			}
		}
	}
	return([sb toString]);
}

- (NSString*) toString {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	int level = 0;
	if(!(({ NSString* _s1 = self->header; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[self append:sb level:level str:self->header noIndent:FALSE noNewLine:FALSE];
	}
	if(!(({ NSString* _s1 = self->customHeader; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[sb appendString:self->customHeader];
	}
	BOOL singleLine = FALSE;
	if(self->elements != nil) {
		int n = 0;
		int m = [self->elements count];
		for(n = 0 ; n < m ; n++) {
			id o = ((id)[self->elements objectAtIndex:n]);
			if(o != nil) {
				if([o isKindOfClass:[CapexXMLMakerElement class]]) {
					[self append:sb level:level str:[((CapexXMLMakerElement*)o) toString] noIndent:singleLine noNewLine:singleLine];
				}
				else {
					if([o isKindOfClass:[CapexXMLMakerStartElement class]]) {
						singleLine = [((CapexXMLMakerStartElement*)o) getSingleLine];
						[self append:sb level:level str:[((CapexXMLMakerStartElement*)o) toString] noIndent:FALSE noNewLine:singleLine];
						level++;
					}
					else {
						if([o isKindOfClass:[CapexXMLMakerEndElement class]]) {
							level--;
							[self append:sb level:level str:[((CapexXMLMakerEndElement*)o) toString] noIndent:singleLine noNewLine:FALSE];
							singleLine = FALSE;
						}
						else {
							if([o isKindOfClass:[CapexXMLMakerCustomXML class]]) {
								[self append:sb level:level str:[((CapexXMLMakerCustomXML*)o) getString] noIndent:singleLine noNewLine:singleLine];
							}
							else {
								if([o isKindOfClass:[NSString class]]) {
									[self append:sb level:level str:[self escapeString:((NSString*)o)] noIndent:singleLine noNewLine:singleLine];
								}
								else {
									if([o isKindOfClass:[CapexXMLMakerCData class]]) {
										[self append:sb level:level str:[((CapexXMLMakerCData*)o) toString] noIndent:singleLine noNewLine:[((CapexXMLMakerCData*)o) getSingleLine]];
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return([sb toString]);
}

- (NSMutableArray*) getElements {
	return(self->elements);
}

- (CapexXMLMaker*) setElements:(NSMutableArray*)v {
	self->elements = v;
	return(self);
}

- (NSString*) getCustomHeader {
	return(self->customHeader);
}

- (CapexXMLMaker*) setCustomHeader:(NSString*)v {
	self->customHeader = v;
	return(self);
}

- (BOOL) getSingleLine {
	return(self->singleLine);
}

- (CapexXMLMaker*) setSingleLine:(BOOL)v {
	self->singleLine = v;
	return(self);
}

- (NSString*) getHeader {
	return(self->header);
}

- (CapexXMLMaker*) setHeader:(NSString*)v {
	self->header = v;
	return(self);
}

@end
