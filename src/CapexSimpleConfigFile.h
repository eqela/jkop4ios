
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
@class CapeDynamicMap;
@class CapeKeyValueList;
@class CapeDynamicVector;
@protocol CapeIterator;
@class CapeKeyValuePair;

@interface CapexSimpleConfigFile : NSObject
+ (CapexSimpleConfigFile*) forFile:(id<CapeFile>)file;
+ (CapexSimpleConfigFile*) forMap:(CapeDynamicMap*)map;
+ (CapeDynamicMap*) readFileAsMap:(id<CapeFile>)file;
- (CapexSimpleConfigFile*) init;
- (id<CapeFile>) getFile;
- (id<CapeFile>) getRelativeFile:(NSString*)fileName;
- (void) clear;
- (CapexSimpleConfigFile*) setDataAsMap:(CapeDynamicMap*)map;
- (CapeDynamicMap*) getDataAsMap;
- (CapeDynamicMap*) getDynamicMapValue:(NSString*)key defval:(CapeDynamicMap*)defval;
- (CapeDynamicVector*) getDynamicVectorValue:(NSString*)key defval:(CapeDynamicVector*)defval;
- (NSString*) getStringValue:(NSString*)key defval:(NSString*)defval;
- (int) getIntegerValue:(NSString*)key defval:(int)defval;
- (double) getDoubleValue:(NSString*)key defval:(double)defval;
- (BOOL) getBooleanValue:(NSString*)key defval:(BOOL)defval;
- (id<CapeFile>) getFileValue:(NSString*)key defval:(id<CapeFile>)defval;
- (id<CapeIterator>) iterate;
- (BOOL) read:(id<CapeFile>)file;
- (BOOL) write:(id<CapeFile>)outfile;
@end
