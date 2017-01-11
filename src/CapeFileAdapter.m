
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
#import "CapeIterator.h"
#import "CapeFileReader.h"
#import "CapeFileWriter.h"
#import "CapeFileInfo.h"
#import "CapeReader.h"
#import "CapePrintReader.h"
#import "CapeOS.h"
#import "CapeFileInvalid.h"
#import "CapeFileInstance.h"
#import "CapeString.h"
#import "CapeEnvironment.h"
#import "CapeClosable.h"
#import "CapeWriter.h"
#import "CapeSizedReader.h"
#import "CapeFileAdapter.h"

@class CapeFileAdapterReadLineIterator;

@interface CapeFileAdapterReadLineIterator : NSObject <CapeIterator>
- (CapeFileAdapterReadLineIterator*) init;
- (NSString*) next;
- (CapePrintReader*) getReader;
- (CapeFileAdapterReadLineIterator*) setReader:(CapePrintReader*)v;
@end

@implementation CapeFileAdapterReadLineIterator

{
	CapePrintReader* reader;
}

- (CapeFileAdapterReadLineIterator*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->reader = nil;
	return(self);
}

- (NSString*) next {
	if(self->reader == nil) {
		return(nil);
	}
	NSString* v = [self->reader readLine];
	if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[self->reader close];
		self->reader = nil;
	}
	return(v);
}

- (CapePrintReader*) getReader {
	return(self->reader);
}

- (CapeFileAdapterReadLineIterator*) setReader:(CapePrintReader*)v {
	self->reader = v;
	return(self);
}

@end

@implementation CapeFileAdapter

- (CapeFileAdapter*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

- (id<CapeFile>) entry:(NSString*)name {
}

- (id<CapeIterator>) entries {
}

- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace {
}

- (BOOL) rename:(NSString*)newname replace:(BOOL)replace {
}

- (BOOL) touch {
}

- (id<CapeFileReader>) read {
}

- (id<CapeFileWriter>) write {
}

- (id<CapeFileWriter>) append {
}

- (CapeFileInfo*) stat {
}

- (BOOL) exists {
}

- (BOOL) isExecutable {
}

- (BOOL) createFifo {
}

- (BOOL) createDirectory {
}

- (BOOL) createDirectoryRecursive {
}

- (BOOL) removeDirectory {
}

- (NSString*) getPath {
}

- (BOOL) remove {
}

- (int) compareModificationTime:(id<CapeFile>)bf {
}

- (NSString*) directoryName {
}

- (BOOL) isIdentical:(id<CapeFile>)file {
}

- (BOOL) makeExecutable {
}

- (BOOL) isNewerThan:(id<CapeFile>)bf {
}

- (BOOL) isOlderThan:(id<CapeFile>)bf {
}

- (BOOL) writeFromReader:(id<CapeReader>)reader append:(BOOL)append {
}

- (id<CapeIterator>) readLines {
	id<CapeFileReader> rd = [self read];
	if(rd == nil) {
		return(nil);
	}
	return(((id<CapeIterator>)[[[CapeFileAdapterReadLineIterator alloc] init] setReader:[[CapePrintReader alloc] initWithReader:((id<CapeReader>)rd)]]));
}

- (BOOL) hasChangedSince:(long long)originalTimeStamp {
	long long nts = [self getLastModifiedTimeStamp];
	if(nts > originalTimeStamp) {
		return(TRUE);
	}
	return(FALSE);
}

- (long long) getLastModifiedTimeStamp {
	if([self isFile] == FALSE) {
		return(((long long)0));
	}
	CapeFileInfo* st = [self stat];
	if(st == nil) {
		return(((long long)0));
	}
	return(((long long)([st getModifyTime])));
}

- (BOOL) isSame:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	NSString* path = [self getPath];
	if(!(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && ({ NSString* _s1 = path; NSString* _s2 = [file getPath]; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) removeRecursive {
	CapeFileInfo* finfo = [self stat];
	if(finfo == nil) {
		return(TRUE);
	}
	if([finfo isDirectory] == FALSE || [finfo isLink] == TRUE) {
		return([self remove]);
	}
	id<CapeIterator> it = [self entries];
	while(it != nil) {
		id<CapeFile> f = ((id<CapeFile>)[it next]);
		if(f == nil) {
			break;
		}
		if([f removeRecursive] == FALSE) {
			return(FALSE);
		}
	}
	return([self removeDirectory]);
}

- (BOOL) isFile {
	CapeFileInfo* st = [self stat];
	if(st == nil) {
		return(FALSE);
	}
	return([st isFile]);
}

- (BOOL) isDirectory {
	CapeFileInfo* st = [self stat];
	if(st == nil) {
		return(FALSE);
	}
	return([st isDirectory]);
}

- (BOOL) isLink {
	CapeFileInfo* st = [self stat];
	if(st == nil) {
		return(FALSE);
	}
	return([st isLink]);
}

- (int) getSize {
	CapeFileInfo* st = [self stat];
	if(st == nil) {
		return(0);
	}
	return([st getSize]);
}

- (BOOL) setMode:(int)mode {
	return(FALSE);
}

- (BOOL) setOwnerUser:(int)uid {
	return(FALSE);
}

- (BOOL) setOwnerGroup:(int)gid {
	return(FALSE);
}

- (id<CapeFile>) asExecutable {
	if([CapeOS isWindows]) {
		if([self hasExtension:@"exe"] == FALSE && [self hasExtension:@"bat"] == FALSE && [self hasExtension:@"com"] == FALSE) {
			NSString* bn = [self baseName];
			id<CapeFile> exe = [self getSibling:[bn stringByAppendingString:@".exe"]];
			if([exe isFile]) {
				return(exe);
			}
			id<CapeFile> bat = [self getSibling:[bn stringByAppendingString:@".bat"]];
			if([bat isFile]) {
				return(bat);
			}
			id<CapeFile> com = [self getSibling:[bn stringByAppendingString:@".com"]];
			if([com isFile]) {
				return(com);
			}
			return(exe);
		}
	}
	return(((id<CapeFile>)self));
}

- (id<CapeFile>) getParent {
	NSString* path = [self dirName];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
	}
	return([CapeFileInstance forPath:path]);
}

- (id<CapeFile>) getSibling:(NSString*)name {
	id<CapeFile> pp = [self getParent];
	if(pp == nil) {
		return(nil);
	}
	return([pp entry:name]);
}

- (BOOL) hasExtension:(NSString*)ext {
	NSString* xx = [self extension];
	if(({ NSString* _s1 = xx; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	return([CapeString equalsIgnoreCase:xx str2:ext]);
}

- (NSString*) extension {
	NSString* bn = [self baseName];
	if(({ NSString* _s1 = bn; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int dot = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:bn c:'.' start:-1];
	if(dot < 0) {
		return(nil);
	}
	return([CapeString subStringWithStringAndSignedInteger:bn start:dot + 1]);
}

- (NSString*) baseNameWithoutExtension {
	NSString* bn = [self baseName];
	if(({ NSString* _s1 = bn; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int dot = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:bn c:'.' start:-1];
	if(dot < 0) {
		return(bn);
	}
	return([CapeString subStringWithStringAndSignedIntegerAndSignedInteger:bn start:0 length:dot]);
}

- (NSString*) dirName {
	NSString* path = [self getPath];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int delim = [CapeEnvironment getPathSeparator];
	int dp = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:path c:delim start:-1];
	if(dp < 0) {
		return(@".");
	}
	return([CapeString subStringWithStringAndSignedIntegerAndSignedInteger:path start:0 length:dp]);
}

- (NSString*) baseName {
	NSString* path = [self getPath];
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int delim = [CapeEnvironment getPathSeparator];
	int dp = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:path c:delim start:-1];
	if(dp < 0) {
		return(path);
	}
	return([CapeString subStringWithStringAndSignedInteger:path start:dp + 1]);
}

- (BOOL) copyFileTo:(id<CapeFile>)dest {
	if(dest == nil) {
		return(FALSE);
	}
	if([self isSame:dest]) {
		return(TRUE);
	}
	NSMutableData* buf = [NSMutableData dataWithLength:4096 * 4];
	if(buf == nil) {
		return(FALSE);
	}
	id<CapeFileReader> reader = [self read];
	if(reader == nil) {
		return(FALSE);
	}
	id<CapeFileWriter> writer = [dest write];
	if(writer == nil) {
		if([((NSObject*)reader) conformsToProtocol:@protocol(CapeClosable)]) {
			[((id<CapeClosable>)reader) close];
		}
		return(FALSE);
	}
	BOOL v = TRUE;
	int n = 0;
	while((n = [reader read:buf]) > 0) {
		int nr = [writer write:buf size:n];
		if(nr != n) {
			v = FALSE;
			break;
		}
	}
	if(v) {
		CapeFileInfo* fi = [self stat];
		if(fi != nil) {
			int mode = [fi getMode];
			if(mode != 0) {
				[dest setMode:mode];
			}
		}
	}
	else {
		[dest remove];
	}
	if(reader != nil && [((NSObject*)reader) conformsToProtocol:@protocol(CapeClosable)]) {
		[((id<CapeClosable>)reader) close];
	}
	if(writer != nil && [((NSObject*)writer) conformsToProtocol:@protocol(CapeClosable)]) {
		[((id<CapeClosable>)writer) close];
	}
	return(v);
}

- (BOOL) setContentsString:(NSString*)str encoding:(NSString*)encoding {
	if([CapeString isEmpty:encoding]) {
		return(FALSE);
	}
	return([self setContentsBuffer:[CapeString toBuffer:str charset:encoding]]);
}

- (BOOL) setContentsBuffer:(NSMutableData*)buffer {
	if(buffer == nil) {
		return(FALSE);
	}
	id<CapeFileWriter> writer = [self write];
	if(writer == nil) {
		return(FALSE);
	}
	if([writer write:buffer size:[buffer length]] < 0) {
		return(FALSE);
	}
	[writer close];
	return(TRUE);
}

- (NSString*) getContentsString:(NSString*)encoding {
	if([CapeString isEmpty:encoding]) {
		return(nil);
	}
	return([CapeString forBuffer:[self getContentsBuffer] encoding:encoding]);
}

- (NSMutableData*) getContentsBuffer {
	id<CapeFileReader> reader = [self read];
	if(reader == nil) {
		return(nil);
	}
	int sz = [reader getSize];
	NSMutableData* b = [NSMutableData dataWithLength:sz];
	if([reader read:b] < sz) {
		return(nil);
	}
	[reader close];
	return(b);
}

@end
