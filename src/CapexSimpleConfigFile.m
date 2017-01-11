
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
#import "CapeDynamicMap.h"
#import "CapeKeyValueList.h"
#import "CapeIterator.h"
#import "CapeKeyValuePair.h"
#import "CapeJSONParser.h"
#import "CapeDynamicVector.h"
#import "CapeString.h"
#import "CapeFileReader.h"
#import "CapePrintReader.h"
#import "CapeReader.h"
#import "CapeStringBuilder.h"
#import "CapeVector.h"
#import "CapePrintWriter.h"
#import "CapePrintWriterWrapper.h"
#import "CapeWriter.h"
#import "CapexSimpleConfigFile.h"

@implementation CapexSimpleConfigFile

{
	CapeKeyValueList* data;
	CapeDynamicMap* mapData;
	id<CapeFile> file;
}

+ (CapexSimpleConfigFile*) forFile:(id<CapeFile>)file {
	CapexSimpleConfigFile* v = [[CapexSimpleConfigFile alloc] init];
	if([v read:file] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (CapexSimpleConfigFile*) forMap:(CapeDynamicMap*)map {
	CapexSimpleConfigFile* v = [[CapexSimpleConfigFile alloc] init];
	[v setDataAsMap:map];
	return(v);
}

+ (CapeDynamicMap*) readFileAsMap:(id<CapeFile>)file {
	CapexSimpleConfigFile* cf = [CapexSimpleConfigFile forFile:file];
	if(cf == nil) {
		return(nil);
	}
	return([cf getDataAsMap]);
}

- (CapexSimpleConfigFile*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->file = nil;
	self->mapData = nil;
	self->data = nil;
	self->data = [[CapeKeyValueList alloc] init];
	return(self);
}

- (id<CapeFile>) getFile {
	return(self->file);
}

- (id<CapeFile>) getRelativeFile:(NSString*)fileName {
	if(self->file == nil || ({ NSString* _s1 = fileName; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	id<CapeFile> p = [self->file getParent];
	if(p == nil) {
		return(nil);
	}
	return([p entry:fileName]);
}

- (void) clear {
	[self->data clear];
	self->mapData = nil;
}

- (CapexSimpleConfigFile*) setDataAsMap:(CapeDynamicMap*)map {
	[self clear];
	id<CapeIterator> keys = [map iterateKeys];
	while(keys != nil) {
		NSString* key = [keys next];
		if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		[self->data addDynamicAndDynamic:((id)key) val:((id)[map getString:key defval:nil])];
	}
	return(self);
}

- (CapeDynamicMap*) getDataAsMap {
	if(self->mapData == nil) {
		self->mapData = [[CapeDynamicMap alloc] init];
		id<CapeIterator> it = [self->data iterate];
		while(it != nil) {
			CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
			if(kvp == nil) {
				break;
			}
			[self->mapData setStringAndObject:kvp->key value:kvp->value];
		}
	}
	return(self->mapData);
}

- (CapeDynamicMap*) getDynamicMapValue:(NSString*)key defval:(CapeDynamicMap*)defval {
	NSString* str = [self getStringValue:key defval:nil];
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(defval);
	}
	CapeDynamicMap* v = ((CapeDynamicMap*)({ id _v = [CapeJSONParser parseString:str]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
	if(v == nil) {
		return(defval);
	}
	return(v);
}

- (CapeDynamicVector*) getDynamicVectorValue:(NSString*)key defval:(CapeDynamicVector*)defval {
	NSString* str = [self getStringValue:key defval:nil];
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(defval);
	}
	CapeDynamicVector* v = ((CapeDynamicVector*)({ id _v = [CapeJSONParser parseString:str]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; }));
	if(v == nil) {
		return(defval);
	}
	return(v);
}

- (NSString*) getStringValue:(NSString*)key defval:(NSString*)defval {
	CapeDynamicMap* map = [self getDataAsMap];
	if(map == nil) {
		return(defval);
	}
	NSString* v = [map getString:key defval:nil];
	if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(defval);
	}
	if([CapeString startsWith:v str2:@"\"\"\"\n" offset:0] && [CapeString endsWith:v str2:@"\n\"\"\""]) {
		v = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:v start:4 length:[CapeString getLength:v] - 8];
	}
	return(v);
}

- (int) getIntegerValue:(NSString*)key defval:(int)defval {
	CapeDynamicMap* map = [self getDataAsMap];
	if(map == nil) {
		return(defval);
	}
	return([map getInteger:key defval:defval]);
}

- (double) getDoubleValue:(NSString*)key defval:(double)defval {
	CapeDynamicMap* map = [self getDataAsMap];
	if(map == nil) {
		return(defval);
	}
	return([map getDouble:key defval:defval]);
}

- (BOOL) getBooleanValue:(NSString*)key defval:(BOOL)defval {
	CapeDynamicMap* map = [self getDataAsMap];
	if(map == nil) {
		return(defval);
	}
	return([map getBoolean:key defval:defval]);
}

- (id<CapeFile>) getFileValue:(NSString*)key defval:(id<CapeFile>)defval {
	id<CapeFile> v = [self getRelativeFile:[self getStringValue:key defval:nil]];
	if(v == nil) {
		return(defval);
	}
	return(v);
}

- (id<CapeIterator>) iterate {
	if(self->data == nil) {
		return(nil);
	}
	return([self->data iterate]);
}

- (BOOL) read:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	id<CapeFileReader> reader = [file read];
	if(reader == nil) {
		return(FALSE);
	}
	CapePrintReader* ins = [[CapePrintReader alloc] initWithReader:((id<CapeReader>)reader)];
	NSString* line = nil;
	NSString* tag = nil;
	CapeStringBuilder* lineBuffer = nil;
	NSString* terminator = nil;
	while(!(({ NSString* _s1 = line = [ins readLine]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(lineBuffer != nil) {
			[lineBuffer appendString:line];
			if(({ NSString* _s1 = line; NSString* _s2 = terminator; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				line = [lineBuffer toString];
				lineBuffer = nil;
				terminator = nil;
			}
			else {
				[lineBuffer appendCharacter:'\n'];
				continue;
			}
		}
		line = [CapeString strip:line];
		if([CapeString isEmpty:line] || [CapeString startsWith:line str2:@"#" offset:0]) {
			continue;
		}
		if([CapeString endsWith:line str2:@"{"]) {
			if([CapeString indexOfWithStringAndCharacterAndSignedInteger:line c:':' start:0] < 0) {
				if(({ NSString* _s1 = tag; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					tag = [CapeString strip:[CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:line start:0 length:[CapeString getLength:line] - 1]];
				}
				continue;
			}
			else {
				lineBuffer = [[CapeStringBuilder alloc] init];
				[lineBuffer appendString:line];
				[lineBuffer appendCharacter:'\n'];
				terminator = @"}";
				continue;
			}
		}
		if([CapeString endsWith:line str2:@"["]) {
			lineBuffer = [[CapeStringBuilder alloc] init];
			[lineBuffer appendString:line];
			[lineBuffer appendCharacter:'\n'];
			terminator = @"]";
			continue;
		}
		if([CapeString endsWith:line str2:@"\"\"\""]) {
			lineBuffer = [[CapeStringBuilder alloc] init];
			[lineBuffer appendString:line];
			[lineBuffer appendCharacter:'\n'];
			terminator = @"\"\"\"";
			continue;
		}
		if(!(({ NSString* _s1 = tag; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && ({ NSString* _s1 = line; NSString* _s2 = @"}"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			tag = nil;
			continue;
		}
		NSMutableArray* sp = [CapeString split:line delim:':' max:2];
		if(sp == nil) {
			continue;
		}
		NSString* key = [CapeString strip:[CapeVector get:sp index:0]];
		NSString* val = [CapeString strip:[CapeVector get:sp index:1]];
		if([CapeString startsWith:val str2:@"\"" offset:0] && [CapeString endsWith:val str2:@"\""]) {
			val = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:val start:1 length:[CapeString getLength:val] - 2];
		}
		if([CapeString isEmpty:key]) {
			continue;
		}
		if(!(({ NSString* _s1 = tag; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			key = [[[key stringByAppendingString:@"["] stringByAppendingString:tag] stringByAppendingString:@"]"];
		}
		[self->data addDynamicAndDynamic:((id)key) val:((id)val)];
	}
	self->file = file;
	return(TRUE);
}

- (BOOL) write:(id<CapeFile>)outfile {
	if(outfile == nil || self->data == nil) {
		return(FALSE);
	}
	id<CapePrintWriter> os = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)[outfile write])];
	if(os == nil) {
		return(FALSE);
	}
	id<CapeIterator> it = [self->data iterate];
	while(it != nil) {
		CapeKeyValuePair* kvp = ((CapeKeyValuePair*)[it next]);
		if(kvp == nil) {
			break;
		}
		[os println:[[(kvp->key) stringByAppendingString:@": "] stringByAppendingString:(kvp->value)]];
	}
	return(TRUE);
}

@end
