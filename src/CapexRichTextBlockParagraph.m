
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
#import "CapexRichTextParagraph.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeDynamicMap.h"
#import "CapexRichTextDocumentReferenceResolver.h"
#import "CapexHTMLString.h"
#import "CapexRichTextStyledParagraph.h"
#import "CapexRichTextBlockParagraph.h"

@implementation CapexRichTextBlockParagraph

{
	NSString* _x_id;
	NSString* text;
}

- (CapexRichTextBlockParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->text = nil;
	self->_x_id = nil;
	return(self);
}

- (NSString*) toMarkup {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* delim = nil;
	if([CapeString isEmpty:self->_x_id]) {
		delim = @"-- ";
	}
	else {
		delim = [[@"-- " stringByAppendingString:self->_x_id] stringByAppendingString:@" --"];
	}
	[sb appendString:delim];
	[sb appendCharacter:'\n'];
	if(!(({ NSString* _s1 = self->text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[sb appendString:self->text];
		if([CapeString endsWith:self->text str2:@"\n"] == FALSE) {
			[sb appendCharacter:'\n'];
		}
	}
	[sb appendString:delim];
	return([sb toString]);
}

- (NSString*) toText {
	return(self->text);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* map = [[CapeDynamicMap alloc] init];
	[map setStringAndObject:@"type" value:((id)@"block")];
	[map setStringAndObject:@"id" value:((id)self->_x_id)];
	[map setStringAndObject:@"text" value:((id)self->text)];
	return(map);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	NSString* ids = @"";
	if([CapeString isEmpty:self->_x_id] == FALSE) {
		ids = [@" " stringByAppendingString:([CapexHTMLString sanitize:self->_x_id])];
	}
	CapexRichTextStyledParagraph* content = [CapexRichTextStyledParagraph forString:self->text];
	return([[[[@"<div class=\"block" stringByAppendingString:ids] stringByAppendingString:@"\">"] stringByAppendingString:([content toHtml:refs])] stringByAppendingString:@"</div>"]);
}

- (NSString*) getId {
	return(self->_x_id);
}

- (CapexRichTextBlockParagraph*) setId:(NSString*)v {
	self->_x_id = v;
	return(self);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexRichTextBlockParagraph*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

@end
