
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
@class CaveLength;

@interface CaveFontDescription : NSObject
+ (CaveFontDescription*) forDefault;
- (CaveFontDescription*) forFile:(id<CapeFile>)file size:(CaveLength*)size;
- (CaveFontDescription*) forName:(NSString*)name size:(CaveLength*)size;
- (CaveFontDescription*) init;
- (CaveFontDescription*) dup;
- (id<CapeFile>) getFile;
- (CaveFontDescription*) setFile:(id<CapeFile>)v;
- (NSString*) getName;
- (CaveFontDescription*) setName:(NSString*)v;
- (BOOL) getBold;
- (CaveFontDescription*) setBold:(BOOL)v;
- (BOOL) getItalic;
- (CaveFontDescription*) setItalic:(BOOL)v;
- (BOOL) getUnderline;
- (CaveFontDescription*) setUnderline:(BOOL)v;
- (CaveLength*) getSize;
- (CaveFontDescription*) setSize:(CaveLength*)v;
@end
