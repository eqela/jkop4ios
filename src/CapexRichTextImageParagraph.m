
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
#import "CapeStringBuilder.h"
#import "CapexHTMLString.h"
#import "CapexRichTextImageParagraph.h"

@implementation CapexRichTextImageParagraph

{
	NSString* filename;
	int width;
}

- (CapexRichTextImageParagraph*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->width = 100;
	self->filename = nil;
	return(self);
}

- (NSString*) toMarkup {
	if(self->width >= 100) {
		return([[@"@image " stringByAppendingString:self->filename] stringByAppendingString:@"\n"]);
	}
	if(self->width >= 75) {
		return([[@"@image75 " stringByAppendingString:self->filename] stringByAppendingString:@"\n"]);
	}
	if(self->width >= 50) {
		return([[@"@image50 " stringByAppendingString:self->filename] stringByAppendingString:@"\n"]);
	}
	return([[@"@image25 " stringByAppendingString:self->filename] stringByAppendingString:@"\n"]);
}

- (NSString*) toText {
	return([[@"[image:" stringByAppendingString:self->filename] stringByAppendingString:@"]\n"]);
}

- (CapeDynamicMap*) toJson {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"type" value:((id)@"image")];
	[v setStringAndSignedInteger:@"width" value:self->width];
	[v setStringAndObject:@"filename" value:((id)self->filename)];
	return(v);
}

- (NSString*) toHtml:(id<CapexRichTextDocumentReferenceResolver>)refs {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(self->width >= 100) {
		[sb appendString:@"<div class=\"img100\">"];
	}
	else {
		if(self->width >= 75) {
			[sb appendString:@"<div class=\"img75\">"];
		}
		else {
			if(self->width >= 50) {
				[sb appendString:@"<div class=\"img50\">"];
			}
			else {
				[sb appendString:@"<div class=\"img25\">"];
			}
		}
	}
	[sb appendString:[[@"<img src=\"" stringByAppendingString:([CapexHTMLString sanitize:self->filename])] stringByAppendingString:@"\" />"]];
	[sb appendString:@"</div>\n"];
	return([sb toString]);
}

- (NSString*) getFilename {
	return(self->filename);
}

- (CapexRichTextImageParagraph*) setFilename:(NSString*)v {
	self->filename = v;
	return(self);
}

- (int) getWidth {
	return(self->width);
}

- (CapexRichTextImageParagraph*) setWidth:(int)v {
	self->width = v;
	return(self);
}

@end
