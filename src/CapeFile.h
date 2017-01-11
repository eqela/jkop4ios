
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

@protocol CapeIterator;
@protocol CapeFileReader;
@protocol CapeFileWriter;
@class CapeFileInfo;
@protocol CapeReader;
@protocol CapeFile
- (id<CapeFile>) entry:(NSString*)name;
- (id<CapeFile>) asExecutable;
- (id<CapeFile>) getParent;
- (id<CapeFile>) getSibling:(NSString*)name;
- (BOOL) hasExtension:(NSString*)ext;
- (NSString*) extension;
- (id<CapeIterator>) entries;
- (BOOL) move:(id<CapeFile>)dest replace:(BOOL)replace;
- (BOOL) rename:(NSString*)newname replace:(BOOL)replace;
- (BOOL) touch;
- (id<CapeFileReader>) read;
- (id<CapeFileWriter>) write;
- (id<CapeFileWriter>) append;
- (BOOL) setMode:(int)mode;
- (BOOL) setOwnerUser:(int)uid;
- (BOOL) setOwnerGroup:(int)gid;
- (BOOL) makeExecutable;
- (CapeFileInfo*) stat;
- (int) getSize;
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
- (BOOL) writeFromReader:(id<CapeReader>)reader append:(BOOL)append;
- (BOOL) copyFileTo:(id<CapeFile>)dest;
- (int) compareModificationTime:(id<CapeFile>)file;
- (BOOL) isNewerThan:(id<CapeFile>)file;
- (BOOL) isOlderThan:(id<CapeFile>)file;
- (NSString*) directoryName;
- (NSString*) baseName;
- (NSString*) baseNameWithoutExtension;
- (BOOL) isIdentical:(id<CapeFile>)file;
- (NSMutableData*) getContentsBuffer;
- (NSString*) getContentsString:(NSString*)encoding;
- (BOOL) setContentsBuffer:(NSMutableData*)buf;
- (BOOL) setContentsString:(NSString*)str encoding:(NSString*)encoding;
- (BOOL) hasChangedSince:(long long)originalTimeStamp;
- (long long) getLastModifiedTimeStamp;
- (id<CapeIterator>) readLines;
@end
