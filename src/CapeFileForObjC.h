
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

@protocol CapeFileReader;
@protocol CapeReader;
@protocol CapeSizedReader;
@protocol CapeClosable;
@protocol CapeSeekableReader;
@class CapeFileForObjCMyReader;
@protocol CapeFileWriter;
@protocol CapeWriter;
@protocol CapeSeekableWriter;
@class CapeFileForObjCMyWriter;
@protocol CapeFile;
@class CapeFileInfo;

@interface CapeFileForObjC : CapeFileAdapter
- (CapeFileForObjC*) init;
+ (id<CapeFile>) forPath:(NSString*)path;
- (CapeFileForObjC*) initWithString:(NSString*)path;
- (id<CapeFile>) entry:(NSString*)name;
- (id<CapeFileWriter>) write;
- (id<CapeFileWriter>) append;
- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace;
- (BOOL) rename:(NSString*)newname replace:(BOOL)replace;
- (BOOL) touch;
- (BOOL) setMode:(int)mode;
- (BOOL) setOwnerUser:(int)uid;
- (BOOL) setOwnerGroup:(int)gid;
- (BOOL) makeExecutable;
- (CapeFileInfo*) stat;
- (id<CapeFileReader>) read;
- (BOOL) exists;
- (BOOL) isExecutable;
- (BOOL) isFile;
- (BOOL) isDirectory;
- (BOOL) isLink;
- (BOOL) createFifo;
- (BOOL) createDirectory;
- (BOOL) createDirectoryRecursive;
- (BOOL) removeDirectory;
- (NSString*) getPath;
- (BOOL) isSame:(id<CapeFile>)file;
- (BOOL) remove;
- (BOOL) removeRecursive;
- (int) compareModificationTime:(id<CapeFile>)file;
- (NSString*) directoryName;
- (NSString*) baseName;
- (BOOL) isIdentical:(id<CapeFile>)file;
- (NSMutableData*) getContentsBuffer;
- (NSString*) getContentsString:(NSString*)encoding;
@end
