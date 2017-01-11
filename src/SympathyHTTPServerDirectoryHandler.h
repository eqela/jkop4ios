
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
#import "SympathyHTTPServerRequestHandlerAdapter.h"

@protocol CapeFile;
@class CapeDynamicMap;
@class SympathyHTTPServerRequest;

@interface SympathyHTTPServerDirectoryHandler : SympathyHTTPServerRequestHandlerAdapter
- (SympathyHTTPServerDirectoryHandler*) init;
+ (SympathyHTTPServerDirectoryHandler*) forDirectory:(id<CapeFile>)dir;
- (void) addTemplateIncludeDir:(id<CapeFile>)dir;
- (SympathyHTTPServerDirectoryHandler*) setIndexFiles:(NSMutableArray*)files;
- (SympathyHTTPServerDirectoryHandler*) setServerName:(NSString*)name;
- (NSString*) getServerName;
- (void) getDirectoryEntries:(id<CapeFile>)dir allEntries:(NSMutableArray*)allEntries dirs:(NSMutableArray*)dirs files:(NSMutableArray*)files;
- (CapeDynamicMap*) dirToJSONObject:(id<CapeFile>)dir;
- (NSString*) dirToJSON:(id<CapeFile>)dir;
- (CapeDynamicMap*) getTemplateVariablesForFile:(id<CapeFile>)file;
- (NSString*) dirToHTML:(id<CapeFile>)dir;
- (BOOL) onGET:(SympathyHTTPServerRequest*)req;
- (BOOL) getListDirectories;
- (SympathyHTTPServerDirectoryHandler*) setListDirectories:(BOOL)v;
- (BOOL) getProcessTemplateFiles;
- (SympathyHTTPServerDirectoryHandler*) setProcessTemplateFiles:(BOOL)v;
- (id<CapeFile>) getDirectory;
- (SympathyHTTPServerDirectoryHandler*) setDirectory:(id<CapeFile>)v;
- (int) getMaxAge;
- (SympathyHTTPServerDirectoryHandler*) setMaxAge:(int)v;
- (NSString*) getServerURL;
- (SympathyHTTPServerDirectoryHandler*) setServerURL:(NSString*)v;
- (NSMutableArray*) getIndexFiles;
- (NSMutableArray*) getTemplateIncludeDirs;
- (SympathyHTTPServerDirectoryHandler*) setTemplateIncludeDirs:(NSMutableArray*)v;
- (CapeDynamicMap*) getTemplateData;
- (SympathyHTTPServerDirectoryHandler*) setTemplateData:(CapeDynamicMap*)v;
@end
