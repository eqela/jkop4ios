
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
#import "CapexRichTextLinkParagraph.h"

@implementation CapexRichTextLinkParagraph

{
	NSString* link;
	NSString* text;
	BOOL popup;
}

- (CapexRichTextLinkParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->popup = FALSE;
	self->text = nil;
	self->link = nil;
	return(self);
}

- (NSString*) toMarkup {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"@link "];
	[sb appendString:self->link];
	[sb appendCharacter:' '];
	[sb appendCharacter:'\"'];
	if([CapeString isEmpty:self->text] == FALSE) {
		[sb appendString:self->text];
	}
	[sb appendCharacter:'\"'];
	if(self->popup) {
		[sb appendString:@" popup"];
	}
	return([sb toString]);
}

- (NSString*) toText {
	NSString* v = self->text;
	if([CapeString isEmpty:v]) {
		v = self->link;
	}
	return(v);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"type" value:((id)@"link")];
	[v setStringAndObject:@"link" value:((id)self->link)];
	[v setStringAndObject:@"text" value:((id)self->text)];
	return(v);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	NSString* href = [CapexHTMLString sanitize:self->link];
	NSString* tt = self->text;
	if([CapeString isEmpty:tt]) {
		tt = href;
	}
	if([CapeString isEmpty:tt]) {
		tt = @"(empty link)";
	}
	NSString* targetblank = @"";
	if(self->popup) {
		targetblank = @" target=\"_blank\"";
	}
	return([[[[[[@"<p class=\"link\"><a href=\"" stringByAppendingString:href] stringByAppendingString:@"\""] stringByAppendingString:targetblank] stringByAppendingString:@">"] stringByAppendingString:tt] stringByAppendingString:@"</a></p>\n"]);
}

- (NSString*) getLink {
	return(self->link);
}

- (CapexRichTextLinkParagraph*) setLink:(NSString*)v {
	self->link = v;
	return(self);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexRichTextLinkParagraph*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

- (BOOL) getPopup {
	return(self->popup);
}

- (CapexRichTextLinkParagraph*) setPopup:(BOOL)v {
	self->popup = v;
	return(self);
}

@end
