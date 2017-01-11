
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
#import "CapexZipReaderEntry.h"
#import "CapeString.h"
#import "CapexZipReader.h"

@implementation CapexZipReader

- (CapexZipReader*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapexZipReader*) forFile:(id<CapeFile>)file {
	return(nil);
}

+ (BOOL) extractZipFileToDirectory:(id<CapeFile>)zipFile destDir:(id<CapeFile>)destDir listener:(void(^)(id<CapeFile>))listener {
	if(zipFile == nil || destDir == nil) {
		return(FALSE);
	}
	CapexZipReader* zf = [CapexZipReader forFile:zipFile];
	if(zf == nil) {
		return(FALSE);
	}
	if([destDir isDirectory] == FALSE) {
		[destDir createDirectoryRecursive];
	}
	if([destDir isDirectory] == FALSE) {
		return(FALSE);
	}
	NSMutableArray* array = [zf getEntries];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			CapexZipReaderEntry* entry = ((CapexZipReaderEntry*)[array objectAtIndex:n]);
			if(entry != nil) {
				NSString* ename = [entry getName];
				if([CapeString isEmpty:ename]) {
					continue;
				}
				id<CapeFile> dd = destDir;
				ename = [CapeString replaceStringAndCharacterAndCharacter:ename oldChar:'\\' newChar:'/'];
				NSMutableArray* array2 = [CapeString split:ename delim:'/' max:0];
				if(array2 != nil) {
					int n2 = 0;
					int m2 = [array2 count];
					for(n2 = 0 ; n2 < m2 ; n2++) {
						NSString* comp = ((NSString*)[array2 objectAtIndex:n2]);
						if(comp != nil) {
							if(({ NSString* _s1 = comp; NSString* _s2 = @"."; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = comp; NSString* _s2 = @".."; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								continue;
							}
							dd = [dd entry:comp];
						}
					}
				}
				if(listener != nil) {
					listener(dd);
				}
				if([entry writeToFile:dd] == FALSE) {
					return(FALSE);
				}
			}
		}
	}
	return(TRUE);
}

- (NSMutableArray*) getEntries {
}

@end
