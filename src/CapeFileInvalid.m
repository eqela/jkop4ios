
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
#import "CapeFileAdapter.h"
#import "CapeFile.h"
#import "CapeFileReader.h"
#import "CapeFileWriter.h"
#import "CapeFileInfo.h"
#import "CapeReader.h"
#import "CapeIterator.h"
#import "CapeFileInvalid.h"

@implementation CapeFileInvalid

- (CapeFileInvalid*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

- (id<CapeFile>) entry:(NSString*)name {
	return(((id<CapeFile>)[[CapeFileInvalid alloc] init]));
}

- (BOOL) makeExecutable {
	return(FALSE);
}

- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace {
	return(FALSE);
}

- (BOOL) rename:(NSString*)newname replace:(BOOL)replace {
	return(FALSE);
}

- (BOOL) touch {
	return(FALSE);
}

- (id<CapeFileReader>) read {
	return(nil);
}

- (id<CapeFileWriter>) write {
	return(nil);
}

- (id<CapeFileWriter>) append {
	return(nil);
}

- (CapeFileInfo*) stat {
	return(nil);
}

- (BOOL) exists {
	return(FALSE);
}

- (BOOL) isExecutable {
	return(FALSE);
}

- (BOOL) createFifo {
	return(FALSE);
}

- (BOOL) createDirectory {
	return(FALSE);
}

- (BOOL) createDirectoryRecursive {
	return(FALSE);
}

- (BOOL) removeDirectory {
	return(FALSE);
}

- (NSString*) getPath {
	return(nil);
}

- (BOOL) isSame:(id<CapeFile>)file {
	return(FALSE);
}

- (BOOL) remove {
	return(FALSE);
}

- (BOOL) removeRecursive {
	return(FALSE);
}

- (int) compareModificationTime:(id<CapeFile>)file {
	return(0);
}

- (NSString*) directoryName {
	return(nil);
}

- (NSString*) baseName {
	return(nil);
}

- (BOOL) isIdentical:(id<CapeFile>)file {
	return(FALSE);
}

- (NSMutableData*) getContentsBuffer {
	return(nil);
}

- (NSString*) getContentsString:(NSString*)encoding {
	return(nil);
}

- (BOOL) setContentsBuffer:(NSMutableData*)buffer {
	return(FALSE);
}

- (BOOL) setContentsString:(NSString*)str encoding:(NSString*)encoding {
	return(FALSE);
}

- (BOOL) isNewerThan:(id<CapeFile>)bf {
	return(FALSE);
}

- (BOOL) isOlderThan:(id<CapeFile>)bf {
	return(FALSE);
}

- (BOOL) writeFromReader:(id<CapeReader>)reader append:(BOOL)append {
	return(FALSE);
}

- (id<CapeIterator>) entries {
	return(nil);
}

@end
