
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

@protocol CapeIterator;
@protocol CapeFileReader;
@protocol CapeFileWriter;
@class CapeFileInfo;
@protocol CapeReader;
@class CapeFileAdapterReadLineIterator;
@class CapePrintReader;

@interface CapeFileAdapter : NSObject <CapeFile>
- (CapeFileAdapter*) init;
- (id<CapeFile>) entry:(NSString*)name;
- (id<CapeIterator>) entries;
- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace;
- (BOOL) rename:(NSString*)newname replace:(BOOL)replace;
- (BOOL) touch;
- (id<CapeFileReader>) read;
- (id<CapeFileWriter>) write;
- (id<CapeFileWriter>) append;
- (CapeFileInfo*) stat;
- (BOOL) exists;
- (BOOL) isExecutable;
- (BOOL) createFifo;
- (BOOL) createDirectory;
- (BOOL) createDirectoryRecursive;
- (BOOL) removeDirectory;
- (NSString*) getPath;
- (BOOL) remove;
- (int) compareModificationTime:(id<CapeFile>)bf;
- (NSString*) directoryName;
- (BOOL) isIdentical:(id<CapeFile>)file;
- (BOOL) makeExecutable;
- (BOOL) isNewerThan:(id<CapeFile>)bf;
- (BOOL) isOlderThan:(id<CapeFile>)bf;
- (BOOL) writeFromReader:(id<CapeReader>)reader append:(BOOL)append;
- (id<CapeIterator>) readLines;
- (BOOL) hasChangedSince:(long long)originalTimeStamp;
- (long long) getLastModifiedTimeStamp;
- (BOOL) isSame:(id<CapeFile>)file;
- (BOOL) removeRecursive;
- (BOOL) isFile;
- (BOOL) isDirectory;
- (BOOL) isLink;
- (int) getSize;
- (BOOL) setMode:(int)mode;
- (BOOL) setOwnerUser:(int)uid;
- (BOOL) setOwnerGroup:(int)gid;
- (id<CapeFile>) asExecutable;
- (id<CapeFile>) getParent;
- (id<CapeFile>) getSibling:(NSString*)name;
- (BOOL) hasExtension:(NSString*)ext;
- (NSString*) extension;
- (NSString*) baseNameWithoutExtension;
- (NSString*) dirName;
- (NSString*) baseName;
- (BOOL) copyFileTo:(id<CapeFile>)dest;
- (BOOL) setContentsString:(NSString*)str encoding:(NSString*)encoding;
- (BOOL) setContentsBuffer:(NSMutableData*)buffer;
- (NSString*) getContentsString:(NSString*)encoding;
- (NSMutableData*) getContentsBuffer;
@end
