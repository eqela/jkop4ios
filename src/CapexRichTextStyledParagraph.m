
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
#import "CapexRichTextSegment.h"
#import "CapeStringBuilder.h"
#import "CapeDynamicMap.h"
#import "CapeVector.h"
#import "CapeString.h"
#import "CapexRichTextDocumentReferenceResolver.h"
#import "CapexHTMLString.h"
#import "CapeCharacterIterator.h"
#import "CapexRichTextStyledParagraph.h"

@implementation CapexRichTextStyledParagraph

{
	int heading;
	NSMutableArray* segments;
}

- (CapexRichTextStyledParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->segments = nil;
	self->heading = 0;
	return(self);
}

+ (CapexRichTextStyledParagraph*) forString:(NSString*)text {
	CapexRichTextStyledParagraph* rtsp = [[CapexRichTextStyledParagraph alloc] init];
	return([rtsp parse:text]);
}

- (BOOL) isHeading {
	if(self->heading > 0) {
		return(TRUE);
	}
	return(FALSE);
}

- (NSString*) getTextContent {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(self->segments != nil) {
		int n = 0;
		int m = [self->segments count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextSegment* segment = ((CapexRichTextSegment*)[self->segments objectAtIndex:n]);
			if(segment != nil) {
				[sb appendString:[segment getText]];
			}
		}
	}
	return([sb toString]);
}

- (CapeDynamicMap*) toJson {
	NSMutableArray* segs = [[NSMutableArray alloc] init];
	if(self->segments != nil) {
		int n = 0;
		int m = [self->segments count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextSegment* segment = ((CapexRichTextSegment*)[self->segments objectAtIndex:n]);
			if(segment != nil) {
				CapeDynamicMap* segj = [segment toJson];
				if(segj != nil) {
					[CapeVector append:segs object:segj];
				}
			}
		}
	}
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"type" value:((id)@"styled")];
	[v setStringAndSignedInteger:@"heading" value:self->heading];
	[v setStringAndObject:@"segments" value:((id)segs)];
	return(v);
}

- (NSString*) toText {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(self->segments != nil) {
		int n = 0;
		int m = [self->segments count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextSegment* sg = ((CapexRichTextSegment*)[self->segments objectAtIndex:n]);
			if(sg != nil) {
				[sb appendString:[sg getText]];
				NSString* link = [sg getLink];
				if([CapeString isEmpty:link] == FALSE) {
					[sb appendString:[[@" (" stringByAppendingString:link] stringByAppendingString:@")"]];
				}
				NSString* ref = [sg getReference];
				if([CapeString isEmpty:ref] == FALSE) {
					[sb appendString:[[@" {" stringByAppendingString:ref] stringByAppendingString:@"}"]];
				}
			}
		}
	}
	return([sb toString]);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* tag = @"p";
	if(self->heading > 0) {
		tag = [@"h" stringByAppendingString:([CapeString forInteger:self->heading])];
	}
	[sb appendString:@"<"];
	[sb appendString:tag];
	[sb appendString:@">"];
	if(self->segments != nil) {
		int n = 0;
		int m = [self->segments count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextSegment* sg = ((CapexRichTextSegment*)[self->segments objectAtIndex:n]);
			if(sg != nil) {
				BOOL aOpen = FALSE;
				NSString* text = [sg getText];
				NSString* link = [sg getLink];
				if([CapeString isEmpty:link] == FALSE) {
					if([sg getIsInline]) {
						[sb appendString:[[@"<img src=\"" stringByAppendingString:([CapexHTMLString sanitize:link])] stringByAppendingString:@"\" />"]];
					}
					else {
						NSString* targetblank = @"";
						if([sg getLinkPopup]) {
							targetblank = @" target=\"_blank\"";
						}
						[sb appendString:[[[[@"<a" stringByAppendingString:targetblank] stringByAppendingString:@" class=\"urlLink\" href=\""] stringByAppendingString:([CapexHTMLString sanitize:link])] stringByAppendingString:@"\">"]];
						aOpen = TRUE;
					}
				}
				if([CapeString isEmpty:[sg getReference]] == FALSE) {
					NSString* ref = [sg getReference];
					NSString* href = nil;
					if(refs != nil) {
						href = [refs getReferenceHref:ref];
						if([CapeString isEmpty:text]) {
							text = [refs getReferenceTitle:ref];
						}
					}
					if([CapeString isEmpty:href] == FALSE) {
						if([CapeString isEmpty:text]) {
							text = ref;
						}
						[sb appendString:[[@"<a class=\"referenceLink\" href=\"" stringByAppendingString:([CapexHTMLString sanitize:href])] stringByAppendingString:@"\">"]];
						aOpen = TRUE;
					}
				}
				BOOL span = FALSE;
				if([sg getBold] || [sg getItalic] || [sg getUnderline] || [CapeString isEmpty:[sg getColor]] == FALSE) {
					span = TRUE;
					[sb appendString:@"<span style=\""];
					if([sg getBold]) {
						[sb appendString:@" font-weight: bold;"];
					}
					if([sg getItalic]) {
						[sb appendString:@" font-style: italic;"];
					}
					if([sg getUnderline]) {
						[sb appendString:@" text-decoration: underline;"];
					}
					if([CapeString isEmpty:[sg getColor]] == FALSE) {
						[sb appendString:[[@" color: " stringByAppendingString:([CapexHTMLString sanitize:[sg getColor]])] stringByAppendingString:@""]];
					}
					[sb appendString:@"\">"];
				}
				if([sg getIsInline] == FALSE) {
					[sb appendString:[CapexHTMLString sanitize:text]];
				}
				if(span) {
					[sb appendString:@"</span>"];
				}
				if(aOpen) {
					[sb appendString:@"</a>"];
				}
			}
		}
	}
	[sb appendString:[[@"</" stringByAppendingString:tag] stringByAppendingString:@">"]];
	return([sb toString]);
}

- (CapexRichTextParagraph*) addSegment:(CapexRichTextSegment*)rts {
	if(rts == nil) {
		return(((CapexRichTextParagraph*)self));
	}
	if(self->segments == nil) {
		self->segments = [[NSMutableArray alloc] init];
	}
	[CapeVector append:self->segments object:rts];
	return(((CapexRichTextParagraph*)self));
}

- (void) setSegmentLink:(CapexRichTextSegment*)seg alink:(NSString*)alink {
	if(({ NSString* _s1 = alink; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[seg setLink:nil];
		return;
	}
	NSString* link = alink;
	if([CapeString startsWith:link str2:@">" offset:0]) {
		[seg setIsInline:TRUE];
		link = [CapeString subStringWithStringAndSignedInteger:link start:1];
	}
	if([CapeString startsWith:link str2:@"!" offset:0]) {
		[seg setLinkPopup:FALSE];
		link = [CapeString subStringWithStringAndSignedInteger:link start:1];
	}
	else {
		[seg setLinkPopup:TRUE];
	}
	[seg setLink:link];
}

- (void) parseSegments:(NSString*)txt {
	if(({ NSString* _s1 = txt; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	CapeStringBuilder* segmentsb = nil;
	CapeStringBuilder* linksb = nil;
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	id<CapeCharacterIterator> it = [CapeString iterate:txt];
	int c = ' ';
	int pc = ((int)0);
	CapexRichTextSegment* seg = [[CapexRichTextSegment alloc] init];
	while((c = [it getNextChar]) > 0) {
		if(pc == '[') {
			if(c == '[') {
				[sb appendCharacter:c];
				pc = ((int)0);
				continue;
			}
			if([sb count] > 0) {
				[seg setText:[sb toString]];
				[sb clear];
				[self addSegment:seg];
			}
			seg = [[CapexRichTextSegment alloc] init];
			linksb = [[CapeStringBuilder alloc] init];
			[linksb appendCharacter:c];
			pc = c;
			continue;
		}
		if(linksb != nil) {
			if(c == '|') {
				[self setSegmentLink:seg alink:[linksb toString]];
				[linksb clear];
				pc = c;
				continue;
			}
			if(c == ']') {
				NSString* xt = [linksb toString];
				if(({ NSString* _s1 = [seg getLink]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					[self setSegmentLink:seg alink:xt];
				}
				else {
					[seg setText:xt];
				}
				if([CapeString isEmpty:[seg getText]]) {
					NSString* ll = xt;
					if([CapeString startsWith:ll str2:@"http://" offset:0]) {
						ll = [CapeString subStringWithStringAndSignedInteger:ll start:7];
					}
					[seg setText:ll];
				}
				[self addSegment:seg];
				seg = [[CapexRichTextSegment alloc] init];
				linksb = nil;
			}
			else {
				[linksb appendCharacter:c];
			}
			pc = c;
			continue;
		}
		if(pc == '{') {
			if(c == '{') {
				[sb appendCharacter:c];
				pc = ((int)0);
				continue;
			}
			if([sb count] > 0) {
				[seg setText:[sb toString]];
				[sb clear];
				[self addSegment:seg];
			}
			seg = [[CapexRichTextSegment alloc] init];
			segmentsb = [[CapeStringBuilder alloc] init];
			[segmentsb appendCharacter:c];
			pc = c;
			continue;
		}
		if(segmentsb != nil) {
			if(c == '|') {
				[seg setReference:[segmentsb toString]];
				[segmentsb clear];
				pc = c;
				continue;
			}
			if(c == '}') {
				NSString* xt = [segmentsb toString];
				if(({ NSString* _s1 = [seg getReference]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					[seg setReference:xt];
				}
				else {
					[seg setText:xt];
				}
				[self addSegment:seg];
				seg = [[CapexRichTextSegment alloc] init];
				segmentsb = nil;
			}
			else {
				[segmentsb appendCharacter:c];
			}
			pc = c;
			continue;
		}
		if(pc == '*') {
			if(c == '*') {
				if([sb count] > 0) {
					[seg setText:[sb toString]];
					[sb clear];
					[self addSegment:seg];
				}
				if([seg getBold]) {
					seg = [[[CapexRichTextSegment alloc] init] setBold:FALSE];
				}
				else {
					seg = [[[CapexRichTextSegment alloc] init] setBold:TRUE];
				}
			}
			else {
				[sb appendCharacter:pc];
				[sb appendCharacter:c];
			}
			pc = ((int)0);
			continue;
		}
		if(pc == '_') {
			if(c == '_') {
				if([sb count] > 0) {
					[seg setText:[sb toString]];
					[sb clear];
					[self addSegment:seg];
				}
				if([seg getUnderline]) {
					seg = [[[CapexRichTextSegment alloc] init] setUnderline:FALSE];
				}
				else {
					seg = [[[CapexRichTextSegment alloc] init] setUnderline:TRUE];
				}
			}
			else {
				[sb appendCharacter:pc];
				[sb appendCharacter:c];
			}
			pc = ((int)0);
			continue;
		}
		if(pc == '\'') {
			if(c == '\'') {
				if([sb count] > 0) {
					[seg setText:[sb toString]];
					[sb clear];
					[self addSegment:seg];
				}
				if([seg getItalic]) {
					seg = [[[CapexRichTextSegment alloc] init] setItalic:FALSE];
				}
				else {
					seg = [[[CapexRichTextSegment alloc] init] setItalic:TRUE];
				}
			}
			else {
				[sb appendCharacter:pc];
				[sb appendCharacter:c];
			}
			pc = ((int)0);
			continue;
		}
		if(c != '*' && c != '_' && c != '\'' && c != '{' && c != '[') {
			[sb appendCharacter:c];
		}
		pc = c;
	}
	if((pc == '*' || pc == '_' || pc == '\'') && pc != '{' && pc != '[') {
		[sb appendCharacter:pc];
	}
	if([sb count] > 0) {
		[seg setText:[sb toString]];
		[sb clear];
		[self addSegment:seg];
	}
}

- (CapexRichTextStyledParagraph*) parse:(NSString*)text {
	if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(self);
	}
	NSString* txt = text;
	NSMutableArray* prefixes = [NSMutableArray arrayWithObjects: @"=", @"==", @"===", @"====", @"=====", nil];
	int n = 0;
	for(n = 0 ; n < [prefixes count] ; n++) {
		NSString* key = ((NSString*)[prefixes objectAtIndex:n]);
		if([CapeString startsWith:txt str2:[key stringByAppendingString:@" "] offset:0] && [CapeString endsWith:txt str2:[@" " stringByAppendingString:key]]) {
			[self setHeading:n + 1];
			txt = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:txt start:[CapeString getLength:key] + 1 length:[CapeString getLength:txt] - [CapeString getLength:key] * 2 - 2];
			if(!(({ NSString* _s1 = txt; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				txt = [CapeString strip:txt];
			}
			break;
		}
	}
	[self parseSegments:txt];
	return(self);
}

- (NSString*) toMarkup {
	NSString* ident = nil;
	if(self->heading == 1) {
		ident = @"=";
	}
	else {
		if(self->heading == 2) {
			ident = @"==";
		}
		else {
			if(self->heading == 3) {
				ident = @"===";
			}
			else {
				if(self->heading == 4) {
					ident = @"====";
				}
				else {
					if(self->heading == 5) {
						ident = @"=====";
					}
				}
			}
		}
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if([CapeString isEmpty:ident] == FALSE) {
		[sb appendString:ident];
		[sb appendCharacter:' '];
	}
	if(self->segments != nil) {
		int n = 0;
		int m = [self->segments count];
		for(n = 0 ; n < m ; n++) {
			CapexRichTextSegment* segment = ((CapexRichTextSegment*)[self->segments objectAtIndex:n]);
			if(segment != nil) {
				[sb appendString:[segment toMarkup]];
			}
		}
	}
	if([CapeString isEmpty:ident] == FALSE) {
		[sb appendCharacter:' '];
		[sb appendString:ident];
	}
	return([sb toString]);
}

- (int) getHeading {
	return(self->heading);
}

- (CapexRichTextStyledParagraph*) setHeading:(int)v {
	self->heading = v;
	return(self);
}

- (NSMutableArray*) getSegments {
	return(self->segments);
}

- (CapexRichTextStyledParagraph*) setSegments:(NSMutableArray*)v {
	self->segments = v;
	return(self);
}

@end
