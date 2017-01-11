
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
#import "CapeFile.h"
#import "CapexRichTextWikiMarkupParser.h"
#import "CapeDynamicMap.h"
#import "CapexRichTextParagraph.h"
#import "CapeVector.h"
#import "CapexRichTextStyledParagraph.h"
#import "CapexRichTextReferenceParagraph.h"
#import "CapeString.h"
#import "CapexRichTextSegment.h"
#import "CapexRichTextLinkParagraph.h"
#import "CapexRichTextDocumentReferenceResolver.h"
#import "CapeStringBuilder.h"
#import "CapexRichTextDocument.h"

@implementation CapexRichTextDocument

{
	CapeDynamicMap* metadata;
	NSMutableArray* paragraphs;
}

+ (CapexRichTextDocument*) forWikiMarkupFile:(id<CapeFile>)file {
	return([CapexRichTextWikiMarkupParser parseFile:file]);
}

+ (CapexRichTextDocument*) forWikiMarkupString:(NSString*)str {
	return([CapexRichTextWikiMarkupParser parseString:str]);
}

- (CapexRichTextDocument*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->paragraphs = nil;
	self->metadata = nil;
	self->metadata = [[CapeDynamicMap alloc] init];
	return(self);
}

- (NSString*) getTitle {
	return([self->metadata getString:@"title" defval:nil]);
}

- (CapexRichTextDocument*) setTitle:(NSString*)v {
	[self->metadata setStringAndObject:@"title" value:((id)v)];
	return(self);
}

- (NSString*) getMetadata:(NSString*)k {
	return([self->metadata getString:k defval:nil]);
}

- (CapexRichTextDocument*) setMetadata:(NSString*)k v:(NSString*)v {
	[self->metadata setStringAndObject:k value:((id)v)];
	return(self);
}

- (CapexRichTextDocument*) addParagraph:(CapexRichTextParagraph*)rtp {
	if(rtp == nil) {
		return(self);
	}
	if(self->paragraphs == nil) {
		self->paragraphs = [[NSMutableArray alloc] init];
	}
	[CapeVector append:self->paragraphs object:rtp];
	if(({ NSString* _s1 = [self getTitle]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) && [rtp isKindOfClass:[CapexRichTextStyledParagraph class]] && [((CapexRichTextStyledParagraph*)({ id _v = rtp; [_v isKindOfClass:[CapexRichTextStyledParagraph class]] ? _v : nil; })) getHeading] == 1) {
		[self setTitle:[((CapexRichTextStyledParagraph*)({ id _v = rtp; [_v isKindOfClass:[CapexRichTextStyledParagraph class]] ? _v : nil; })) getTextContent]];
	}
	return(self);
}

- (NSMutableArray*) getAllReferences {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(self->paragraphs != nil) {
		int n = 0;
		int m = [self->paragraphs count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextParagraph* paragraph = ((CapexRichTextParagraph*)[self->paragraphs objectAtIndex:n]);
			if(paragraph != nil) {
				if([paragraph isKindOfClass:[CapexRichTextReferenceParagraph class]]) {
					NSString* ref = [((CapexRichTextReferenceParagraph*)paragraph) getReference];
					if([CapeString isEmpty:ref] == FALSE) {
						[v addObject:ref];
					}
				}
				else {
					if([paragraph isKindOfClass:[CapexRichTextStyledParagraph class]]) {
						NSMutableArray* array = [((CapexRichTextStyledParagraph*)paragraph) getSegments];
						if(array != nil) {
							int n2 = 0;
							int m2 = [array count];
							for(n2 = 0 ; n2 < m2 ; n2++) {
								CapexRichTextSegment* segment = ((CapexRichTextSegment*)[array objectAtIndex:n2]);
								if(segment != nil) {
									NSString* ref = [segment getReference];
									if([CapeString isEmpty:ref] == FALSE) {
										[v addObject:ref];
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return(v);
}

- (NSMutableArray*) getAllLinks {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(self->paragraphs != nil) {
		int n = 0;
		int m = [self->paragraphs count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextParagraph* paragraph = ((CapexRichTextParagraph*)[self->paragraphs objectAtIndex:n]);
			if(paragraph != nil) {
				if([paragraph isKindOfClass:[CapexRichTextLinkParagraph class]]) {
					NSString* link = [((CapexRichTextLinkParagraph*)paragraph) getLink];
					if([CapeString isEmpty:link] == FALSE) {
						[v addObject:link];
					}
				}
				else {
					if([paragraph isKindOfClass:[CapexRichTextStyledParagraph class]]) {
						NSMutableArray* array = [((CapexRichTextStyledParagraph*)paragraph) getSegments];
						if(array != nil) {
							int n2 = 0;
							int m2 = [array count];
							for(n2 = 0 ; n2 < m2 ; n2++) {
								CapexRichTextSegment* segment = ((CapexRichTextSegment*)[array objectAtIndex:n2]);
								if(segment != nil) {
									NSString* link = [segment getLink];
									if([CapeString isEmpty:link] == FALSE) {
										[v addObject:link];
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return(v);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"metadata" value:((id)self->metadata)];
	[v setStringAndObject:@"title" value:((id)[self getTitle])];
	NSMutableArray* pp = [[NSMutableArray alloc] init];
	if(self->paragraphs != nil) {
		int n = 0;
		int m = [self->paragraphs count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextParagraph* par = ((CapexRichTextParagraph*)[self->paragraphs objectAtIndex:n]);
			if(par != nil) {
				CapeDynamicMap* pj = [par toJson];
				if(pj != nil) {
					[CapeVector append:pp object:pj];
				}
			}
		}
	}
	[v setStringAndObject:@"paragraphs" value:((id)pp)];
	return(v);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSMutableArray* array = [self getParagraphs];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextParagraph* paragraph = ((CapexRichTextParagraph*)[array objectAtIndex:n]);
			if(paragraph != nil) {
				NSString* html = [paragraph toHtml:refs];
				if([CapeString isEmpty:html] == FALSE) {
					[sb appendString:html];
					[sb appendCharacter:'\n'];
				}
			}
		}
	}
	return([sb toString]);
}

- (NSMutableArray*) getParagraphs {
	return(self->paragraphs);
}

- (CapexRichTextDocument*) setParagraphs:(NSMutableArray*)v {
	self->paragraphs = v;
	return(self);
}

@end
