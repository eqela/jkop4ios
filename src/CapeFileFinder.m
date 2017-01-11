
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
#import "CapeIterator.h"
#import "CapeFile.h"
#import "CapeString.h"
#import "CapeStack.h"
#import "CapeVector.h"
#import "CapeFileFinder.h"

@class CapeFileFinderPattern;

@interface CapeFileFinderPattern : NSObject
- (CapeFileFinderPattern*) init;
- (CapeFileFinderPattern*) setPattern:(NSString*)pattern;
- (BOOL) match:(NSString*)check;
@end

@implementation CapeFileFinderPattern

{
	NSString* pattern;
	NSString* suffix;
	NSString* prefix;
}

- (CapeFileFinderPattern*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->prefix = nil;
	self->suffix = nil;
	self->pattern = nil;
	return(self);
}

- (CapeFileFinderPattern*) setPattern:(NSString*)pattern {
	self->pattern = pattern;
	if(!(({ NSString* _s1 = pattern; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if([CapeString startsWith:pattern str2:@"*" offset:0]) {
			self->suffix = [CapeString getSubStringWithStringAndSignedInteger:pattern start:1];
		}
		if([CapeString endsWith:pattern str2:@"*"]) {
			self->prefix = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:pattern start:0 length:[CapeString getLength:pattern] - 1];
		}
	}
	return(self);
}

- (BOOL) match:(NSString*)check {
	if(({ NSString* _s1 = check; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	if(({ NSString* _s1 = self->pattern; NSString* _s2 = check; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	if(!(({ NSString* _s1 = self->suffix; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString endsWith:check str2:self->suffix]) {
		return(TRUE);
	}
	if(!(({ NSString* _s1 = self->prefix; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString startsWith:check str2:self->prefix offset:0]) {
		return(TRUE);
	}
	return(FALSE);
}

@end

@implementation CapeFileFinder

{
	id<CapeFile> root;
	NSMutableArray* patterns;
	NSMutableArray* excludePatterns;
	CapeStack* stack;
	BOOL includeMatchingDirectories;
	BOOL includeDirectories;
}

+ (CapeFileFinder*) forRoot:(id<CapeFile>)root {
	return([[[CapeFileFinder alloc] init] setRoot:root]);
}

- (CapeFileFinder*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->includeDirectories = FALSE;
	self->includeMatchingDirectories = FALSE;
	self->stack = nil;
	self->excludePatterns = nil;
	self->patterns = nil;
	self->root = nil;
	self->patterns = [[NSMutableArray alloc] init];
	self->excludePatterns = [[NSMutableArray alloc] init];
	return(self);
}

- (CapeFileFinder*) setRoot:(id<CapeFile>)root {
	self->root = root;
	self->stack = nil;
	return(self);
}

- (CapeFileFinder*) addPattern:(NSString*)pattern {
	[self->patterns addObject:[[[CapeFileFinderPattern alloc] init] setPattern:pattern]];
	return(self);
}

- (CapeFileFinder*) addExcludePattern:(NSString*)pattern {
	[self->excludePatterns addObject:[[[CapeFileFinderPattern alloc] init] setPattern:pattern]];
	return(self);
}

- (BOOL) matchPattern:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	if([CapeVector getSize:self->patterns] < 1) {
		return(TRUE);
	}
	NSString* filename = [file baseName];
	if(self->patterns != nil) {
		int n = 0;
		int m = [self->patterns count];
		for(n = 0 ; n < m ; n++) {
			CapeFileFinderPattern* pattern = ((CapeFileFinderPattern*)[self->patterns objectAtIndex:n]);
			if(pattern != nil) {
				if([pattern match:filename]) {
					return(TRUE);
				}
			}
		}
	}
	return(FALSE);
}

- (BOOL) matchExcludePattern:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	if([CapeVector getSize:self->excludePatterns] < 1) {
		return(FALSE);
	}
	NSString* filename = [file baseName];
	if(self->excludePatterns != nil) {
		int n = 0;
		int m = [self->excludePatterns count];
		for(n = 0 ; n < m ; n++) {
			CapeFileFinderPattern* pattern = ((CapeFileFinderPattern*)[self->excludePatterns objectAtIndex:n]);
			if(pattern != nil) {
				if([pattern match:filename]) {
					return(TRUE);
				}
			}
		}
	}
	return(FALSE);
}

- (id<CapeFile>) next {
	while(TRUE) {
		if(self->stack == nil) {
			if(self->root == nil) {
				break;
			}
			id<CapeIterator> es = [self->root entries];
			self->root = nil;
			if(es == nil) {
				break;
			}
			self->stack = [[CapeStack alloc] init];
			[self->stack push:((id)es)];
		}
		id<CapeIterator> entries = ((id<CapeIterator>)[self->stack peek]);
		if(entries == nil) {
			self->stack = nil;
			break;
		}
		id<CapeFile> e = ((id<CapeFile>)[entries next]);
		if(e == nil) {
			[self->stack pop];
		}
		else {
			if([self matchExcludePattern:e]) {
				;
			}
			else {
				if([e isFile]) {
					if([self matchPattern:e]) {
						return(e);
					}
				}
				else {
					if(self->includeMatchingDirectories && [e isDirectory] && [self matchPattern:e]) {
						return(e);
					}
					else {
						if([e isDirectory] && [e isLink] == FALSE) {
							[self->stack push:((id)[e entries])];
							if(self->includeDirectories) {
								return(e);
							}
						}
					}
				}
			}
		}
	}
	return(nil);
}

- (BOOL) getIncludeMatchingDirectories {
	return(self->includeMatchingDirectories);
}

- (CapeFileFinder*) setIncludeMatchingDirectories:(BOOL)v {
	self->includeMatchingDirectories = v;
	return(self);
}

- (BOOL) getIncludeDirectories {
	return(self->includeDirectories);
}

- (CapeFileFinder*) setIncludeDirectories:(BOOL)v {
	self->includeDirectories = v;
	return(self);
}

@end
