
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
#import "CapeFileReader.h"
#import "CapeReader.h"
#import "CapeSizedReader.h"
#import "CapeClosable.h"
#import "CapeSeekableReader.h"
#import "CapeFileWriter.h"
#import "CapeWriter.h"
#import "CapeSeekableWriter.h"
#import "CapeBuffer.h"
#import "CapeFile.h"
#import "CapeFileInfo.h"
#import "CapeString.h"
#import "CapeFileForObjC.h"

@class CapeFileForObjCMyReader;
@class CapeFileForObjCMyWriter;

@interface CapeFileForObjCMyReader : NSObject <CapeFileReader, CapeReader, CapeSizedReader, CapeClosable, CapeSeekableReader>
- (CapeFileForObjCMyReader*) init;
- (void) close;
- (BOOL) setCurrentPosition:(int64_t)n;
- (int64_t) getCurrentPosition;
- (int) read:(NSMutableData*)buf;
- (NSMutableData*) readAll;
- (NSFileHandle*) getHandle;
- (CapeFileForObjCMyReader*) setHandle:(NSFileHandle*)v;
- (int) getSize;
- (CapeFileForObjCMyReader*) setSize:(int)v;
@end

@implementation CapeFileForObjCMyReader

{
	NSFileHandle* handle;
	int size;
}

- (CapeFileForObjCMyReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->size = 0;
	self->handle = nil;
	return(self);
}

- (void) close {
	if(self->handle == nil) {
		return;
	}
	[handle closeFile];
	self->handle = nil;
}

- (BOOL) setCurrentPosition:(int64_t)n {
	if(self->handle == nil) {
		return(FALSE);
	}
	BOOL v = TRUE;
	@try {
		[handle seekToFileOffset:n];
	}
	@catch(NSException* e) {
		v = false;
	}
	return(v);
}

- (int64_t) getCurrentPosition {
	if(self->handle == nil) {
		return(((int64_t)0));
	}
	int64_t v = ((int64_t)0);
	@try {
		v = [handle offsetInFile];
	}
	@catch(NSException* e) {
		v = 0;
	}
	return(v);
}

- (int) read:(NSMutableData*)buf {
	if(buf == nil || self->handle == nil) {
		return(0);
	}
	NSMutableData* data = nil;
	int mx = [buf length];
	data = [handle readDataOfLength:mx];
	if(data == nil) {
		return(0);
	}
	int dlen = [data length];
	if(dlen < 1) {
		return(0);
	}
	[buf setData:data];
	return(dlen);
}

- (NSMutableData*) readAll {
	return([handle readDataToEndOfFile]);
}

- (NSFileHandle*) getHandle {
	return(self->handle);
}

- (CapeFileForObjCMyReader*) setHandle:(NSFileHandle*)v {
	self->handle = v;
	return(self);
}

- (int) getSize {
	return(self->size);
}

- (CapeFileForObjCMyReader*) setSize:(int)v {
	self->size = v;
	return(self);
}

@end

@interface CapeFileForObjCMyWriter : NSObject <CapeFileWriter, CapeWriter, CapeClosable, CapeSeekableWriter>
- (CapeFileForObjCMyWriter*) init;
- (int) write:(NSMutableData*)buffer size:(int)size;
- (BOOL) setCurrentPosition:(int64_t)n;
- (int64_t) getCurrentPosition;
- (void) close;
- (NSFileHandle*) getHandle;
- (CapeFileForObjCMyWriter*) setHandle:(NSFileHandle*)v;
@end

@implementation CapeFileForObjCMyWriter

{
	NSFileHandle* handle;
}

- (CapeFileForObjCMyWriter*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->handle = nil;
	return(self);
}

- (int) write:(NSMutableData*)buffer size:(int)size {
	if(buffer == nil) {
		return(0);
	}
	NSMutableData* ptr = buffer;
	if(size >= 0 && size != [CapeBuffer getSize:ptr]) {
		ptr = [CapeBuffer getSubBuffer:ptr offset:((long long)0) size:((long long)size) alwaysNewBuffer:FALSE];
	}
	long long v = [CapeBuffer getSize:ptr];
	@try {
		[handle writeData:ptr];
	}
	@catch(NSException* e) {
		v = -1;
	}
	return(((int)v));
}

- (BOOL) setCurrentPosition:(int64_t)n {
	if(self->handle == nil) {
		return(FALSE);
	}
	BOOL v = TRUE;
	@try {
		[handle seekToFileOffset:n];
	}
	@catch(NSException* e) {
		v = false;
	}
	return(v);
}

- (int64_t) getCurrentPosition {
	if(self->handle == nil) {
		return(((int64_t)0));
	}
	int64_t v = ((int64_t)0);
	@try {
		v = [handle offsetInFile];
	}
	@catch(NSException* e) {
		v = 0;
	}
	return(v);
}

- (void) close {
	if(self->handle == nil) {
		return;
	}
	[handle closeFile];
	self->handle = nil;
}

- (NSFileHandle*) getHandle {
	return(self->handle);
}

- (CapeFileForObjCMyWriter*) setHandle:(NSFileHandle*)v {
	self->handle = v;
	return(self);
}

@end

@implementation CapeFileForObjC

{
	NSString* path;
	NSFileManager* manager;
}

- (CapeFileForObjC*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->manager = nil;
	self->path = nil;
	return(self);
}

+ (id<CapeFile>) forPath:(NSString*)path {
	return(((id<CapeFile>)[[CapeFileForObjC alloc] initWithString:path]));
}

- (CapeFileForObjC*) initWithString:(NSString*)path {
	if([super init] == nil) {
		return(nil);
	}
	self->manager = nil;
	self->path = nil;
	self->path = [path stringByStandardizingPath];
	manager = [NSFileManager defaultManager];
	return(self);
}

- (id<CapeFile>) entry:(NSString*)name {
	return(((id<CapeFile>)[[CapeFileForObjC alloc] initWithString:[[self->path stringByAppendingString:@"/"] stringByAppendingString:name]]));
}

- (id<CapeFileWriter>) write {
	return(((id<CapeFileWriter>)[self getMyWriter:TRUE]));
}

- (id<CapeFileWriter>) append {
	return(((id<CapeFileWriter>)[self getMyWriter:FALSE]));
}

- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: move");
	return(FALSE);
}

- (BOOL) rename:(NSString*)newname replace:(BOOL)replace {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: rename");
	return(FALSE);
}

- (BOOL) touch {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: touch");
	return(FALSE);
}

- (BOOL) setMode:(int)mode {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: setMode");
	return(FALSE);
}

- (BOOL) setOwnerUser:(int)uid {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: setOwnerUser");
	return(FALSE);
}

- (BOOL) setOwnerGroup:(int)gid {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: setOwnerGroup");
	return(FALSE);
}

- (BOOL) makeExecutable {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: makeExecutable");
	return(FALSE);
}

- (CapeFileInfo*) stat {
	CapeFileInfo* v = [[CapeFileInfo alloc] init];
	[v setFile:((id<CapeFile>)self)];
	NSDictionary* dict = nil;
	dict = [manager attributesOfItemAtPath:path error:nil];
	[v setSize:[[dict objectForKey:NSFileSize] integerValue]];
	[v setCreateTime:[[dict objectForKey:NSFileCreationDate] timeIntervalSince1970]];
	[v setAccessTime:0];
	[v setModifyTime:[[dict objectForKey:NSFileModificationDate] timeIntervalSince1970]];
	[v setOwnerUser:[[dict objectForKey:NSFileOwnerAccountID] integerValue]];
	[v setOwnerGroup:[[dict objectForKey:NSFileGroupOwnerAccountID] integerValue]];
	[v setMode:0];
	if([manager isExecutableFileAtPath:path]) {
		[v setExecutable:YES];
	}
	if([NSFileTypeSymbolicLink isEqualToString:[dict objectForKey:NSFileType]]) {
		[v setLink:YES];
	}
	if([self isFile]) {
		[v setType:CapeFileInfoFILE_TYPE_FILE];
	}
	else {
		if([self isDirectory]) {
			[v setType:CapeFileInfoFILE_TYPE_DIR];
		}
	}
	return(v);
}

- (CapeFileForObjCMyReader*) getMyReader {
	NSFileHandle* handle = nil;
	handle = [NSFileHandle fileHandleForReadingAtPath:path];
	if(handle == nil) {
		return(nil);
	}
	CapeFileForObjCMyReader* v = [[CapeFileForObjCMyReader alloc] init];
	[v setSize:[self getSize]];
	[v setHandle:handle];
	return(v);
}

- (CapeFileForObjCMyWriter*) getMyWriter:(BOOL)truncate {
	if([self exists] == FALSE) {
		[manager createFileAtPath:path contents:nil attributes:nil];
	}
	NSFileHandle* handle = nil;
	handle = [NSFileHandle fileHandleForWritingAtPath:path];
	if(handle == nil) {
		return(nil);
	}
	if(truncate) {
		[handle truncateFileAtOffset:0];
	}
	CapeFileForObjCMyWriter* v = [[CapeFileForObjCMyWriter alloc] init];
	[v setHandle:handle];
	return(v);
}

- (id<CapeFileReader>) read {
	return(((id<CapeFileReader>)[self getMyReader]));
}

- (BOOL) exists {
	return([manager fileExistsAtPath:path]);
}

- (BOOL) isExecutable {
	return([manager isExecutableFileAtPath:path]);
}

- (BOOL) isFile {
	BOOL v = FALSE;
	BOOL isdir = FALSE;
	v = [manager fileExistsAtPath:path isDirectory:&isdir];
	if(v == FALSE) {
		return(FALSE);
	}
	return(!isdir);
}

- (BOOL) isDirectory {
	BOOL v = FALSE;
	BOOL isdir = FALSE;
	v = [manager fileExistsAtPath:path isDirectory:&isdir];
	if(v == FALSE) {
		return(FALSE);
	}
	return(isdir);
}

- (BOOL) isLink {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: isLink");
	return(FALSE);
}

- (BOOL) createFifo {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: createFifo");
	return(FALSE);
}

- (BOOL) createDirectory {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: createDirectory");
	return(FALSE);
}

- (BOOL) createDirectoryRecursive {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: createDirectoryRecursive");
	return(FALSE);
}

- (BOOL) removeDirectory {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: removeDirectory");
	return(FALSE);
}

- (NSString*) getPath {
	return(self->path);
}

- (BOOL) isSame:(id<CapeFile>)file {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: isSame");
	return(FALSE);
}

- (BOOL) remove {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: remove");
	return(FALSE);
}

- (BOOL) removeRecursive {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: removeRecursive");
	return(FALSE);
}

- (int) compareModificationTime:(id<CapeFile>)file {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: compareModificationTime");
	return(0);
}

- (NSString*) directoryName {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: directoryName");
	return(nil);
}

- (NSString*) baseName {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: baseName");
	return(nil);
}

- (BOOL) isIdentical:(id<CapeFile>)file {
	NSLog(@"%@", @"--- stub --- cape.FileForObjC :: isIdentical");
	return(FALSE);
}

- (NSMutableData*) getContentsBuffer {
	CapeFileForObjCMyReader* rr = [self getMyReader];
	if(rr == nil) {
		return(nil);
	}
	return([rr readAll]);
}

- (NSString*) getContentsString:(NSString*)encoding {
	NSMutableData* b = [self getContentsBuffer];
	if(b == nil) {
		return(nil);
	}
	return([CapeString forBuffer:b encoding:encoding]);
}

@end
