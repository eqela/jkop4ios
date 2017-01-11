
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
#import "CapexRichTextReferenceParagraph.h"

@implementation CapexRichTextReferenceParagraph

{
	NSString* reference;
	NSString* text;
}

- (CapexRichTextReferenceParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->text = nil;
	self->reference = nil;
	return(self);
}

- (NSString*) toMarkup {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"@reference "];
	[sb appendString:self->reference];
	if([CapeString isEmpty:self->text] == FALSE) {
		[sb appendCharacter:' '];
		[sb appendCharacter:'\"'];
		[sb appendString:self->text];
		[sb appendCharacter:'\"'];
	}
	return([sb toString]);
}

- (NSString*) toText {
	NSString* v = self->text;
	if([CapeString isEmpty:self->text]) {
		v = self->reference;
	}
	return(v);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"type" value:((id)@"reference")];
	[v setStringAndObject:@"reference" value:((id)self->reference)];
	[v setStringAndObject:@"text" value:((id)self->text)];
	return(v);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	NSString* reftitle = nil;
	NSString* href = nil;
	if([CapeString isEmpty:self->text] == FALSE) {
		reftitle = self->text;
	}
	if([CapeString isEmpty:reftitle]) {
		if(refs != nil) {
			reftitle = [refs getReferenceTitle:self->reference];
		}
		else {
			reftitle = self->reference;
		}
	}
	if(refs != nil) {
		href = [refs getReferenceHref:self->reference];
	}
	else {
		href = self->reference;
	}
	if([CapeString isEmpty:href]) {
		return(@"");
	}
	if([CapeString isEmpty:reftitle]) {
		reftitle = href;
	}
	return([[[[@"<p class=\"reference\"><a href=\"" stringByAppendingString:([CapexHTMLString sanitize:href])] stringByAppendingString:@"\">"] stringByAppendingString:([CapexHTMLString sanitize:reftitle])] stringByAppendingString:@"</a></p>\n"]);
}

- (NSString*) getReference {
	return(self->reference);
}

- (CapexRichTextReferenceParagraph*) setReference:(NSString*)v {
	self->reference = v;
	return(self);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexRichTextReferenceParagraph*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

@end
