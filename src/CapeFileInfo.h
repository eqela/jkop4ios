
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

@protocol CapeFile;

extern int CapeFileInfoFILE_TYPE_UNKNOWN;
extern int CapeFileInfoFILE_TYPE_FILE;
extern int CapeFileInfoFILE_TYPE_DIR;

@interface CapeFileInfo : NSObject
- (CapeFileInfo*) init;
+ (CapeFileInfo*) forFile:(id<CapeFile>)file;
- (BOOL) isFile;
- (BOOL) isLink;
- (BOOL) isDirectory;
- (BOOL) exists;
- (id<CapeFile>) getFile;
- (CapeFileInfo*) setFile:(id<CapeFile>)v;
- (int) getSize;
- (CapeFileInfo*) setSize:(int)v;
- (int) getCreateTime;
- (CapeFileInfo*) setCreateTime:(int)v;
- (int) getAccessTime;
- (CapeFileInfo*) setAccessTime:(int)v;
- (int) getModifyTime;
- (CapeFileInfo*) setModifyTime:(int)v;
- (int) getOwnerUser;
- (CapeFileInfo*) setOwnerUser:(int)v;
- (int) getOwnerGroup;
- (CapeFileInfo*) setOwnerGroup:(int)v;
- (int) getMode;
- (CapeFileInfo*) setMode:(int)v;
- (BOOL) getExecutable;
- (CapeFileInfo*) setExecutable:(BOOL)v;
- (int) getType;
- (CapeFileInfo*) setType:(int)v;
- (BOOL) getLink;
- (CapeFileInfo*) setLink:(BOOL)v;
@end
