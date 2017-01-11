
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
#import "CapeString.h"
#import "CapeDynamicMap.h"
#import "CapexRichTextSegment.h"

@implementation CapexRichTextSegment

{
	NSString* text;
	BOOL bold;
	BOOL italic;
	BOOL underline;
	NSString* color;
	NSString* link;
	NSString* reference;
	BOOL isInline;
	BOOL linkPopup;
}

- (CapexRichTextSegment*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->linkPopup = FALSE;
	self->isInline = FALSE;
	self->reference = nil;
	self->link = nil;
	self->color = nil;
	self->underline = FALSE;
	self->italic = FALSE;
	self->bold = FALSE;
	self->text = nil;
	return(self);
}

- (void) addMarkupModifiers:(CapeStringBuilder*)sb {
	if(self->bold) {
		[sb appendString:@"**"];
	}
	if(self->italic) {
		[sb appendString:@"''"];
	}
	if(self->underline) {
		[sb appendString:@"__"];
	}
}

- (NSString*) toMarkup {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[self addMarkupModifiers:sb];
	if([CapeString isEmpty:self->link] == FALSE) {
		[sb appendCharacter:'['];
		if(self->isInline) {
			[sb appendCharacter:'>'];
		}
		[sb appendString:self->link];
		if([CapeString isEmpty:self->text] == FALSE) {
			[sb appendCharacter:'|'];
			[sb appendString:self->text];
		}
		[sb appendCharacter:']'];
	}
	else {
		if([CapeString isEmpty:self->reference] == FALSE) {
			[sb appendCharacter:'{'];
			if(self->isInline) {
				[sb appendCharacter:'>'];
			}
			[sb appendString:self->reference];
			if([CapeString isEmpty:self->text] == FALSE) {
				[sb appendCharacter:'|'];
				[sb appendString:self->text];
			}
			[sb appendCharacter:'}'];
		}
		else {
			[sb appendString:self->text];
		}
	}
	[self addMarkupModifiers:sb];
	return([sb toString]);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"text" value:((id)self->text)];
	if(self->isInline) {
		[v setStringAndBoolean:@"inline" value:self->isInline];
	}
	if(self->bold) {
		[v setStringAndBoolean:@"bold" value:self->bold];
	}
	if(self->italic) {
		[v setStringAndBoolean:@"italic" value:self->italic];
	}
	if(self->underline) {
		[v setStringAndBoolean:@"underline" value:self->underline];
	}
	if([CapeString isEmpty:self->color] == FALSE) {
		[v setStringAndObject:@"color" value:((id)self->color)];
	}
	if([CapeString isEmpty:self->link] == FALSE) {
		[v setStringAndObject:@"link" value:((id)self->link)];
	}
	if([CapeString isEmpty:self->reference] == FALSE) {
		[v setStringAndObject:@"reference" value:((id)self->reference)];
	}
	return(v);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexRichTextSegment*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

- (BOOL) getBold {
	return(self->bold);
}

- (CapexRichTextSegment*) setBold:(BOOL)v {
	self->bold = v;
	return(self);
}

- (BOOL) getItalic {
	return(self->italic);
}

- (CapexRichTextSegment*) setItalic:(BOOL)v {
	self->italic = v;
	return(self);
}

- (BOOL) getUnderline {
	return(self->underline);
}

- (CapexRichTextSegment*) setUnderline:(BOOL)v {
	self->underline = v;
	return(self);
}

- (NSString*) getColor {
	return(self->color);
}

- (CapexRichTextSegment*) setColor:(NSString*)v {
	self->color = v;
	return(self);
}

- (NSString*) getLink {
	return(self->link);
}

- (CapexRichTextSegment*) setLink:(NSString*)v {
	self->link = v;
	return(self);
}

- (NSString*) getReference {
	return(self->reference);
}

- (CapexRichTextSegment*) setReference:(NSString*)v {
	self->reference = v;
	return(self);
}

- (BOOL) getIsInline {
	return(self->isInline);
}

- (CapexRichTextSegment*) setIsInline:(BOOL)v {
	self->isInline = v;
	return(self);
}

- (BOOL) getLinkPopup {
	return(self->linkPopup);
}

- (CapexRichTextSegment*) setLinkPopup:(BOOL)v {
	self->linkPopup = v;
	return(self);
}

@end
