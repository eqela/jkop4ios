
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
#import "CapeFileInfo.h"

int CapeFileInfoFILE_TYPE_UNKNOWN = 0;
int CapeFileInfoFILE_TYPE_FILE = 1;
int CapeFileInfoFILE_TYPE_DIR = 2;

@implementation CapeFileInfo

{
	id<CapeFile> file;
	int size;
	int createTime;
	int accessTime;
	int modifyTime;
	int ownerUser;
	int ownerGroup;
	int mode;
	BOOL executable;
	int type;
	BOOL link;
}

- (CapeFileInfo*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->link = FALSE;
	self->type = 0;
	self->executable = FALSE;
	self->mode = 0;
	self->ownerGroup = 0;
	self->ownerUser = 0;
	self->modifyTime = 0;
	self->accessTime = 0;
	self->createTime = 0;
	self->size = 0;
	self->file = nil;
	return(self);
}

+ (CapeFileInfo*) forFile:(id<CapeFile>)file {
	if(file == nil) {
		return([[CapeFileInfo alloc] init]);
	}
	return([file stat]);
}

- (BOOL) isFile {
	if(self->type == CapeFileInfoFILE_TYPE_FILE) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isLink {
	return(self->link);
}

- (BOOL) isDirectory {
	if(self->type == CapeFileInfoFILE_TYPE_DIR) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) exists {
	return([self isFile] || [self isDirectory] || [self isLink]);
}

- (id<CapeFile>) getFile {
	return(self->file);
}

- (CapeFileInfo*) setFile:(id<CapeFile>)v {
	self->file = v;
	return(self);
}

- (int) getSize {
	return(self->size);
}

- (CapeFileInfo*) setSize:(int)v {
	self->size = v;
	return(self);
}

- (int) getCreateTime {
	return(self->createTime);
}

- (CapeFileInfo*) setCreateTime:(int)v {
	self->createTime = v;
	return(self);
}

- (int) getAccessTime {
	return(self->accessTime);
}

- (CapeFileInfo*) setAccessTime:(int)v {
	self->accessTime = v;
	return(self);
}

- (int) getModifyTime {
	return(self->modifyTime);
}

- (CapeFileInfo*) setModifyTime:(int)v {
	self->modifyTime = v;
	return(self);
}

- (int) getOwnerUser {
	return(self->ownerUser);
}

- (CapeFileInfo*) setOwnerUser:(int)v {
	self->ownerUser = v;
	return(self);
}

- (int) getOwnerGroup {
	return(self->ownerGroup);
}

- (CapeFileInfo*) setOwnerGroup:(int)v {
	self->ownerGroup = v;
	return(self);
}

- (int) getMode {
	return(self->mode);
}

- (CapeFileInfo*) setMode:(int)v {
	self->mode = v;
	return(self);
}

- (BOOL) getExecutable {
	return(self->executable);
}

- (CapeFileInfo*) setExecutable:(BOOL)v {
	self->executable = v;
	return(self);
}

- (int) getType {
	return(self->type);
}

- (CapeFileInfo*) setType:(int)v {
	self->type = v;
	return(self);
}

- (BOOL) getLink {
	return(self->link);
}

- (CapeFileInfo*) setLink:(BOOL)v {
	self->link = v;
	return(self);
}

@end
