
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
#import "CapexTemplateStorage.h"
#import "CapeFile.h"
#import "CapeString.h"
#import "CapexTemplateStorageUsingFiles.h"

@implementation CapexTemplateStorageUsingFiles

{
	id<CapeFile> directory;
	NSString* suffix;
}

+ (CapexTemplateStorageUsingFiles*) forDirectory:(id<CapeFile>)dir {
	CapexTemplateStorageUsingFiles* v = [[CapexTemplateStorageUsingFiles alloc] init];
	[v setDirectory:dir];
	return(v);
}

+ (CapexTemplateStorageUsingFiles*) forHTMLTemplateDirectory:(id<CapeFile>)dir {
	CapexTemplateStorageUsingFiles* v = [[CapexTemplateStorageUsingFiles alloc] init];
	[v setDirectory:dir];
	[v setSuffix:@".html.t"];
	return(v);
}

- (CapexTemplateStorageUsingFiles*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->suffix = nil;
	self->directory = nil;
	self->suffix = @".txt";
	return(self);
}

- (void) getTemplate:(NSString*)_x_id callback:(void(^)(NSString*))callback {
	if(callback == nil) {
		return;
	}
	if(self->directory == nil || [CapeString isEmpty:_x_id] || [CapeString indexOfWithStringAndCharacterAndSignedInteger:_x_id c:'/' start:0] >= 0 || [CapeString indexOfWithStringAndCharacterAndSignedInteger:_x_id c:'\\' start:0] >= 0) {
		callback(nil);
		return;
	}
	id<CapeFile> ff = [self->directory entry:[_x_id stringByAppendingString:self->suffix]];
	if([ff isFile] == FALSE) {
		callback(nil);
		return;
	}
	callback([ff getContentsString:@"UTF-8"]);
}

- (id<CapeFile>) getDirectory {
	return(self->directory);
}

- (CapexTemplateStorageUsingFiles*) setDirectory:(id<CapeFile>)v {
	self->directory = v;
	return(self);
}

- (NSString*) getSuffix {
	return(self->suffix);
}

- (CapexTemplateStorageUsingFiles*) setSuffix:(NSString*)v {
	self->suffix = v;
	return(self);
}

@end
