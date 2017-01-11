
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
#import "CapexRichTextDocument.h"
#import "CapeLineReader.h"
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapexRichTextPreformattedParagraph.h"
#import "CapexRichTextBlockParagraph.h"
#import "CapexRichTextParagraph.h"
#import "CapexRichTextSeparatorParagraph.h"
#import "CapexRichTextContentParagraph.h"
#import "CapexRichTextImageParagraph.h"
#import "CapeVector.h"
#import "CapexRichTextReferenceParagraph.h"
#import "CapexRichTextLinkParagraph.h"
#import "CapeCharacterIterator.h"
#import "CapexRichTextStyledParagraph.h"
#import "CapePrintReader.h"
#import "CapeReader.h"
#import "CapeStringLineReader.h"
#import "CapexRichTextWikiMarkupParser.h"

@implementation CapexRichTextWikiMarkupParser

{
	id<CapeFile> file;
	NSString* data;
}

- (CapexRichTextWikiMarkupParser*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	self->file = nil;
	return(self);
}

+ (CapexRichTextDocument*) parseFile:(id<CapeFile>)file {
	return([[[[CapexRichTextWikiMarkupParser alloc] init] setFile:file] parse]);
}

+ (CapexRichTextDocument*) parseString:(NSString*)data {
	return([[[[CapexRichTextWikiMarkupParser alloc] init] setData:data] parse]);
}

- (NSString*) skipEmptyLines:(id<CapeLineReader>)pr {
	NSString* line = nil;
	while(!(({ NSString* _s1 = line = [pr readLine]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		line = [CapeString strip:line];
		if(!(({ NSString* _s1 = line; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString startsWith:line str2:@"#" offset:0]) {
			continue;
		}
		if([CapeString isEmpty:line] == FALSE) {
			break;
		}
	}
	return(line);
}

- (CapexRichTextPreformattedParagraph*) readPreformattedParagraph:(NSString*)_x_id pr:(id<CapeLineReader>)pr {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* line = nil;
	while(!(({ NSString* _s1 = line = [pr readLine]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([CapeString startsWith:line str2:@"---" offset:0] && [CapeString endsWith:line str2:@"---"]) {
			NSString* lid = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:line start:3 length:[CapeString getLength:line] - 6];
			if(!(({ NSString* _s1 = lid; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				lid = [CapeString strip:lid];
			}
			if([CapeString isEmpty:_x_id]) {
				if([CapeString isEmpty:lid]) {
					break;
				}
			}
			else {
				if([CapeString equals:_x_id str2:lid]) {
					break;
				}
			}
		}
		[sb appendString:line];
		[sb appendCharacter:'\n'];
	}
	return([[[[CapexRichTextPreformattedParagraph alloc] init] setId:_x_id] setText:[sb toString]]);
}

- (CapexRichTextBlockParagraph*) readBlockParagraph:(NSString*)_x_id pr:(id<CapeLineReader>)pr {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* line = nil;
	while(!(({ NSString* _s1 = line = [pr readLine]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([CapeString startsWith:line str2:@"--" offset:0] && [CapeString endsWith:line str2:@"--"]) {
			NSString* lid = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:line start:2 length:[CapeString getLength:line] - 4];
			if(!(({ NSString* _s1 = lid; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				lid = [CapeString strip:lid];
			}
			if([CapeString isEmpty:_x_id]) {
				if([CapeString isEmpty:lid]) {
					break;
				}
			}
			else {
				if([CapeString equals:_x_id str2:lid]) {
					break;
				}
			}
		}
		[sb appendString:line];
		[sb appendCharacter:'\n'];
	}
	return([[[[CapexRichTextBlockParagraph alloc] init] setId:_x_id] setText:[sb toString]]);
}

- (BOOL) processInput:(id<CapeLineReader>)pr doc:(CapexRichTextDocument*)doc {
	NSString* line = [self skipEmptyLines:pr];
	if(({ NSString* _s1 = line; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(({ NSString* _s1 = line; NSString* _s2 = @"-"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[doc addParagraph:((CapexRichTextParagraph*)[[CapexRichTextSeparatorParagraph alloc] init])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@content " offset:0]) {
		NSString* _x_id = [CapeString subStringWithStringAndSignedInteger:line start:9];
		if(!(({ NSString* _s1 = _x_id; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			_x_id = [CapeString strip:_x_id];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[CapexRichTextContentParagraph alloc] init] setContentId:_x_id])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@image " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:7];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[CapexRichTextImageParagraph alloc] init] setFilename:ref])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@image100 " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:10];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[CapexRichTextImageParagraph alloc] init] setFilename:ref])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@image75 " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:9];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[[CapexRichTextImageParagraph alloc] init] setFilename:ref] setWidth:75])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@image50 " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:9];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[[CapexRichTextImageParagraph alloc] init] setFilename:ref] setWidth:50])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@image25 " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:9];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		[doc addParagraph:((CapexRichTextParagraph*)[[[[CapexRichTextImageParagraph alloc] init] setFilename:ref] setWidth:25])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@reference " offset:0]) {
		NSString* ref = [CapeString subStringWithStringAndSignedInteger:line start:11];
		if(!(({ NSString* _s1 = ref; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			ref = [CapeString strip:ref];
		}
		NSMutableArray* sq = [CapeString quotedStringToVector:ref delim:' '];
		NSString* rrf = [CapeVector getAt:sq index:0];
		NSString* txt = [CapeVector getAt:sq index:1];
		[doc addParagraph:((CapexRichTextParagraph*)[[[[CapexRichTextReferenceParagraph alloc] init] setReference:rrf] setText:txt])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@set " offset:0]) {
		NSString* link = [CapeString subStringWithStringAndSignedInteger:line start:5];
		if(!(({ NSString* _s1 = link; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			link = [CapeString strip:link];
		}
		NSMutableArray* sq = [CapeString quotedStringToVector:link delim:' '];
		NSString* key = [CapeVector getAt:sq index:0];
		NSString* val = [CapeVector getAt:sq index:1];
		if([CapeString isEmpty:key]) {
			return(TRUE);
		}
		[doc setMetadata:key v:val];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"@link " offset:0]) {
		NSString* link = [CapeString subStringWithStringAndSignedInteger:line start:6];
		if(!(({ NSString* _s1 = link; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			link = [CapeString strip:link];
		}
		NSMutableArray* sq = [CapeString quotedStringToVector:link delim:' '];
		NSString* url = [CapeVector getAt:sq index:0];
		NSString* txt = [CapeVector getAt:sq index:1];
		NSString* flags = [CapeVector getAt:sq index:2];
		if([CapeString isEmpty:txt]) {
			txt = url;
		}
		CapexRichTextLinkParagraph* v = [[CapexRichTextLinkParagraph alloc] init];
		[v setLink:url];
		[v setText:txt];
		if([CapeString equals:@"internal" str2:flags]) {
			[v setPopup:FALSE];
		}
		else {
			[v setPopup:TRUE];
		}
		[doc addParagraph:((CapexRichTextParagraph*)v)];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"---" offset:0] && [CapeString endsWith:line str2:@"---"]) {
		NSString* _x_id = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:line start:3 length:[CapeString getLength:line] - 6];
		if(!(({ NSString* _s1 = _x_id; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			_x_id = [CapeString strip:_x_id];
		}
		if([CapeString isEmpty:_x_id]) {
			_x_id = nil;
		}
		[doc addParagraph:((CapexRichTextParagraph*)[self readPreformattedParagraph:_x_id pr:pr])];
		return(TRUE);
	}
	if([CapeString startsWith:line str2:@"--" offset:0] && [CapeString endsWith:line str2:@"--"]) {
		NSString* _x_id = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:line start:2 length:[CapeString getLength:line] - 4];
		if(!(({ NSString* _s1 = _x_id; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			_x_id = [CapeString strip:_x_id];
		}
		if([CapeString isEmpty:_x_id]) {
			_x_id = nil;
		}
		[doc addParagraph:((CapexRichTextParagraph*)[self readBlockParagraph:_x_id pr:pr])];
		return(TRUE);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	int pc = ((int)0);
	do {
		line = [CapeString strip:line];
		if([CapeString isEmpty:line]) {
			break;
		}
		if([CapeString startsWith:line str2:@"#" offset:0] == FALSE) {
			id<CapeCharacterIterator> it = [CapeString iterate:line];
			int c = ' ';
			if([sb count] > 0 && pc != ' ') {
				[sb appendCharacter:' '];
				pc = ' ';
			}
			while((c = [it getNextChar]) > 0) {
				if(c == ' ' || c == '\t' || c == '\r' || c == '\n') {
					if(pc == ' ') {
						continue;
					}
					c = ' ';
				}
				[sb appendCharacter:c];
				pc = c;
			}
		}
	}
	while(!(({ NSString* _s1 = line = [pr readLine]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })));
	NSString* s = [sb toString];
	if([CapeString isEmpty:s]) {
		return(FALSE);
	}
	[doc addParagraph:((CapexRichTextParagraph*)[CapexRichTextStyledParagraph forString:s])];
	return(TRUE);
}

- (CapexRichTextDocument*) parse {
	id<CapeLineReader> pr = nil;
	if(self->file != nil) {
		pr = ((id<CapeLineReader>)[[CapePrintReader alloc] initWithReader:((id<CapeReader>)[self->file read])]);
	}
	else {
		if(!(({ NSString* _s1 = self->data; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			pr = ((id<CapeLineReader>)[[CapeStringLineReader alloc] initWithString:self->data]);
		}
	}
	if(pr == nil) {
		return(nil);
	}
	CapexRichTextDocument* v = [[CapexRichTextDocument alloc] init];
	while([self processInput:pr doc:v]) {
		;
	}
	return(v);
}

- (id<CapeFile>) getFile {
	return(self->file);
}

- (CapexRichTextWikiMarkupParser*) setFile:(id<CapeFile>)v {
	self->file = v;
	return(self);
}

- (NSString*) getData {
	return(self->data);
}

- (CapexRichTextWikiMarkupParser*) setData:(NSString*)v {
	self->data = v;
	return(self);
}

@end
