
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
#import "CapeString.h"
#import "CapeReader.h"
#import "CapeFile.h"
#import "CapeFileWriter.h"
#import "CapeClosable.h"
#import "CapeWriter.h"
#import "CapexZipReaderEntry.h"

@implementation CapexZipReaderEntry

{
	NSString* name;
	long long compressedSize;
	long long uncompressedSize;
	BOOL isDirectory;
}

- (CapexZipReaderEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isDirectory = FALSE;
	self->uncompressedSize = ((long long)0);
	self->compressedSize = ((long long)0);
	self->name = nil;
	return(self);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexZipReaderEntry*) setName:(NSString*)newName {
	self->name = [CapeString replaceStringAndCharacterAndCharacter:newName oldChar:'\\' newChar:'/'];
	if([CapeString endsWith:self->name str2:@"/"]) {
		self->isDirectory = TRUE;
		self->name = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:self->name start:0 length:[CapeString getLength:self->name] - 1];
	}
	return(self);
}

- (id<CapeReader>) getContentReader {
	return(nil);
}

- (BOOL) writeToFile:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	if([self getIsDirectory]) {
		return([file createDirectoryRecursive]);
	}
	id<CapeReader> reader = [self getContentReader];
	if(reader == nil) {
		return(FALSE);
	}
	id<CapeFile> fp = [file getParent];
	if(fp != nil) {
		[fp createDirectoryRecursive];
	}
	id<CapeFileWriter> writer = [file write];
	if(writer == nil) {
		if([((NSObject*)reader) conformsToProtocol:@protocol(CapeClosable)]) {
			[((id<CapeClosable>)reader) close];
		}
		return(FALSE);
	}
	NSMutableData* buf = [NSMutableData dataWithLength:4096 * 4];
	BOOL v = TRUE;
	int n = 0;
	while((n = [reader read:buf]) > 0) {
		int nr = [writer write:buf size:n];
		if(nr != n) {
			v = FALSE;
			break;
		}
	}
	if(v == FALSE) {
		[file remove];
	}
	if(reader != nil && [((NSObject*)reader) conformsToProtocol:@protocol(CapeClosable)]) {
		[((id<CapeClosable>)reader) close];
	}
	if(writer != nil && [((NSObject*)writer) conformsToProtocol:@protocol(CapeClosable)]) {
		[((id<CapeClosable>)writer) close];
	}
	return(v);
}

- (id<CapeFile>) writeToDir:(id<CapeFile>)dir fullPath:(BOOL)fullPath overwrite:(BOOL)overwrite {
	if(dir == nil || ({ NSString* _s1 = self->name; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	id<CapeFile> path = nil;
	if(fullPath == FALSE) {
		NSString* nn = nil;
		int r = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:self->name c:'/' start:-1];
		if(r < 1) {
			nn = self->name;
		}
		else {
			nn = [CapeString subStringWithStringAndSignedInteger:self->name start:r + 1];
		}
		if(({ NSString* _s1 = nn; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:nn] < 1) {
			return(nil);
		}
		path = [dir entry:nn];
	}
	else {
		path = dir;
		NSMutableArray* array = [CapeString split:self->name delim:'/' max:0];
		if(array != nil) {
			int n = 0;
			int m = [array count];
			for(n = 0 ; n < m ; n++) {
				NSString* x = ((NSString*)[array objectAtIndex:n]);
				if(x != nil) {
					if(!(({ NSString* _s1 = x; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString getLength:x] > 0) {
						path = [path entry:x];
					}
				}
			}
		}
		id<CapeFile> dd = [path getParent];
		if([dd isDirectory] == FALSE) {
			[dd createDirectoryRecursive];
		}
		if([dd isDirectory] == FALSE) {
			return(nil);
		}
	}
	if(overwrite == FALSE) {
		if([path exists]) {
			return(nil);
		}
	}
	if([self writeToFile:path] == FALSE) {
		return(nil);
	}
	return(path);
}

- (long long) getCompressedSize {
	return(self->compressedSize);
}

- (CapexZipReaderEntry*) setCompressedSize:(long long)v {
	self->compressedSize = v;
	return(self);
}

- (long long) getUncompressedSize {
	return(self->uncompressedSize);
}

- (CapexZipReaderEntry*) setUncompressedSize:(long long)v {
	self->uncompressedSize = v;
	return(self);
}

- (BOOL) getIsDirectory {
	return(self->isDirectory);
}

- (CapexZipReaderEntry*) setIsDirectory:(BOOL)v {
	self->isDirectory = v;
	return(self);
}

@end
