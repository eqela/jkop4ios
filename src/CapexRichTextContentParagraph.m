
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
#import "CapeDynamicMap.h"
#import "CapexRichTextDocumentReferenceResolver.h"
#import "CapexRichTextContentParagraph.h"

@implementation CapexRichTextContentParagraph

{
	NSString* contentId;
}

- (CapexRichTextContentParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->contentId = nil;
	return(self);
}

- (NSString*) toMarkup {
	return([[@"@content " stringByAppendingString:self->contentId] stringByAppendingString:@"\n"]);
}

- (NSString*) toText {
	return([[@"[content:" stringByAppendingString:self->contentId] stringByAppendingString:@"]\n"]);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* map = [[CapeDynamicMap alloc] init];
	[map setStringAndObject:@"type" value:((id)@"content")];
	[map setStringAndObject:@"id" value:((id)self->contentId)];
	return(map);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	NSString* cc = nil;
	if(refs != nil && !(({ NSString* _s1 = self->contentId; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		cc = [refs getContentString:self->contentId];
	}
	if(({ NSString* _s1 = cc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		cc = @"";
	}
	return(cc);
}

- (NSString*) getContentId {
	return(self->contentId);
}

- (CapexRichTextContentParagraph*) setContentId:(NSString*)v {
	self->contentId = v;
	return(self);
}

@end
