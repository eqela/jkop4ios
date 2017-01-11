
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
#import "CaveLength.h"
#import "CaveFontDescription.h"

@implementation CaveFontDescription

{
	id<CapeFile> file;
	NSString* name;
	BOOL bold;
	BOOL italic;
	BOOL underline;
	CaveLength* size;
}

+ (CaveFontDescription*) forDefault {
	return([[CaveFontDescription alloc] init]);
}

- (CaveFontDescription*) forFile:(id<CapeFile>)file size:(CaveLength*)size {
	CaveFontDescription* v = [[CaveFontDescription alloc] init];
	[v setFile:file];
	if(size != nil) {
		[v setSize:size];
	}
	return(v);
}

- (CaveFontDescription*) forName:(NSString*)name size:(CaveLength*)size {
	CaveFontDescription* v = [[CaveFontDescription alloc] init];
	[v setName:name];
	if(size != nil) {
		[v setSize:size];
	}
	return(v);
}

- (CaveFontDescription*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->size = nil;
	self->underline = FALSE;
	self->italic = FALSE;
	self->bold = FALSE;
	self->name = nil;
	self->file = nil;
	self->file = nil;
	self->name = @"Sans";
	self->size = [CaveLength forMicroMeters:((double)2500)];
	self->bold = FALSE;
	self->italic = FALSE;
	self->underline = FALSE;
	return(self);
}

- (CaveFontDescription*) dup {
	CaveFontDescription* v = [[CaveFontDescription alloc] init];
	v->file = self->file;
	v->name = self->name;
	v->bold = self->bold;
	v->italic = self->italic;
	v->underline = self->underline;
	v->size = self->size;
	return(v);
}

- (id<CapeFile>) getFile {
	return(self->file);
}

- (CaveFontDescription*) setFile:(id<CapeFile>)v {
	self->file = v;
	return(self);
}

- (NSString*) getName {
	return(self->name);
}

- (CaveFontDescription*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (BOOL) getBold {
	return(self->bold);
}

- (CaveFontDescription*) setBold:(BOOL)v {
	self->bold = v;
	return(self);
}

- (BOOL) getItalic {
	return(self->italic);
}

- (CaveFontDescription*) setItalic:(BOOL)v {
	self->italic = v;
	return(self);
}

- (BOOL) getUnderline {
	return(self->underline);
}

- (CaveFontDescription*) setUnderline:(BOOL)v {
	self->underline = v;
	return(self);
}

- (CaveLength*) getSize {
	return(self->size);
}

- (CaveFontDescription*) setSize:(CaveLength*)v {
	self->size = v;
	return(self);
}

@end
