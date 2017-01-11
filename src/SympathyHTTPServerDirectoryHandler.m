
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
#import "CapeFile.h"
#import "CapeDynamicMap.h"
#import "SympathyHTTPServerBase.h"
#import "CapeIterator.h"
#import "CapeDynamicVector.h"
#import "CapeJSONEncoder.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerResponse.h"
#import "CapeLog.h"
#import "CapexTextTemplate.h"
#import "SympathyHTTPServerDirectoryHandler.h"

@implementation SympathyHTTPServerDirectoryHandler

{
	BOOL listDirectories;
	BOOL processTemplateFiles;
	id<CapeFile> directory;
	int maxAge;
	NSString* serverURL;
	NSMutableArray* indexFiles;
	NSMutableArray* templateIncludeDirs;
	NSString* serverName;
	CapeDynamicMap* templateData;
}

- (SympathyHTTPServerDirectoryHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->templateData = nil;
	self->serverName = nil;
	self->templateIncludeDirs = nil;
	self->indexFiles = nil;
	self->serverURL = nil;
	self->maxAge = 300;
	self->directory = nil;
	self->processTemplateFiles = FALSE;
	self->listDirectories = FALSE;
	return(self);
}

+ (SympathyHTTPServerDirectoryHandler*) forDirectory:(id<CapeFile>)dir {
	SympathyHTTPServerDirectoryHandler* v = [[SympathyHTTPServerDirectoryHandler alloc] init];
	[v setDirectory:dir];
	return(v);
}

- (void) addTemplateIncludeDir:(id<CapeFile>)dir {
	if(dir == nil) {
		return;
	}
	if(self->templateIncludeDirs == nil) {
		self->templateIncludeDirs = [[NSMutableArray alloc] init];
	}
	[self->templateIncludeDirs addObject:dir];
}

- (SympathyHTTPServerDirectoryHandler*) setIndexFiles:(NSMutableArray*)files {
	self->indexFiles = [[NSMutableArray alloc] init];
	if(files != nil) {
		int n = 0;
		int m = [files count];
		for(n = 0 ; n < m ; n++) {
			NSString* file = ((NSString*)[files objectAtIndex:n]);
			if(file != nil) {
				[self->indexFiles addObject:file];
			}
		}
	}
	return(self);
}

- (SympathyHTTPServerDirectoryHandler*) setServerName:(NSString*)name {
	self->serverName = name;
	return(self);
}

- (NSString*) getServerName {
	if(!(({ NSString* _s1 = self->serverName; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(self->serverName);
	}
	SympathyHTTPServerBase* server = [self getServer];
	if(server == nil) {
		return(nil);
	}
	return([server getServerName]);
}

- (void) getDirectoryEntries:(id<CapeFile>)dir allEntries:(NSMutableArray*)allEntries dirs:(NSMutableArray*)dirs files:(NSMutableArray*)files {
	if(dir == nil) {
		return;
	}
	id<CapeIterator> entries = [dir entries];
	while(entries != nil) {
		id<CapeFile> entry = ((id<CapeFile>)[entries next]);
		if(entry == nil) {
			break;
		}
		NSString* name = [entry baseName];
		if(dirs != nil && [entry isDirectory]) {
			[dirs addObject:name];
		}
		if(files != nil && [entry isFile]) {
			[files addObject:name];
		}
		if(allEntries != nil) {
			[allEntries addObject:name];
		}
	}
}

- (CapeDynamicMap*) dirToJSONObject:(id<CapeFile>)dir {
	NSMutableArray* allEntries = [[NSMutableArray alloc] init];
	NSMutableArray* dirs = [[NSMutableArray alloc] init];
	NSMutableArray* files = [[NSMutableArray alloc] init];
	[self getDirectoryEntries:dir allEntries:allEntries dirs:dirs files:files];
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndObject:@"files" value:((id)[CapeDynamicVector forStringVector:files])];
	[v setStringAndObject:@"dirs" value:((id)[CapeDynamicVector forStringVector:dirs])];
	[v setStringAndObject:@"all" value:((id)[CapeDynamicVector forStringVector:allEntries])];
	return(v);
}

- (NSString*) dirToJSON:(id<CapeFile>)dir {
	return([CapeJSONEncoder encode:((id)[self dirToJSONObject:dir]) niceFormatting:TRUE]);
}

- (CapeDynamicMap*) getTemplateVariablesForFile:(id<CapeFile>)file {
	return(nil);
}

- (NSString*) dirToHTML:(id<CapeFile>)dir {
	if(dir == nil) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"<html>\n"];
	[sb appendString:@"<head>\n"];
	[sb appendString:@"<title>"];
	[sb appendString:[dir baseName]];
	[sb appendString:@"</title>\n"];
	[sb appendString:@"<style>\n"];
	[sb appendString:@"* { font-face: arial; font-size: 12px; }\n"];
	[sb appendString:@"h1 { font-face: arial; font-size: 14px; font-style: bold; border-bottom: solid 1px black; padding: 4px; margin: 4px}\n"];
	[sb appendString:@"#content a { text-decoration: none; color: #000080; }\n"];
	[sb appendString:@"#content a:hover { text-decoration: none; color: #FFFFFF; font-weight: bold; }\n"];
	[sb appendString:@".entry { padding: 4px; }\n"];
	[sb appendString:@".entry:hover { background-color: #AAAACC; }\n"];
	[sb appendString:@".dir { font-weight: bold; }\n"];
	[sb appendString:@".even { background-color: #DDDDDD; }\n"];
	[sb appendString:@".odd { background-color: #EEEEEE; }\n"];
	[sb appendString:@"#footer { border-top: 1px solid black; padding: 4px; margin: 4px; font-size: 10px; text-align: right; }\n"];
	[sb appendString:@"#footer a { font-size: 10px; text-decoration: none; color: #000000; }\n"];
	[sb appendString:@"#footer a:hover { font-size: 10px; text-decoration: underline; color: #000000; }\n"];
	[sb appendString:@"</style>\n"];
	[sb appendString:@"<meta name=\"viewport\" content=\"initial-scale=1,maximum-scale=1\" />\n"];
	[sb appendString:@"</head>\n"];
	[sb appendString:@"<body>\n"];
	[sb appendString:@"<h1>"];
	[sb appendString:[dir baseName]];
	[sb appendString:@"</h1>\n"];
	[sb appendString:@"<div id=\"content\">\n"];
	NSMutableArray* dirs = [[NSMutableArray alloc] init];
	NSMutableArray* files = [[NSMutableArray alloc] init];
	[self getDirectoryEntries:dir allEntries:nil dirs:dirs files:files];
	int n = 0;
	if(dirs != nil) {
		int n2 = 0;
		int m = [dirs count];
		for(n2 = 0 ; n2 < m ; n2++) {
			NSString* dn = ((NSString*)[dirs objectAtIndex:n2]);
			if(dn != nil) {
				NSString* cc = nil;
				if(n % 2 == 0) {
					cc = @"even";
				}
				else {
					cc = @"odd";
				}
				[sb appendString:@"<a href=\""];
				[sb appendString:dn];
				[sb appendString:@"/\"><div class=\"entry dir "];
				[sb appendString:cc];
				[sb appendString:@"\">"];
				[sb appendString:dn];
				[sb appendString:@"/</div></a>\n"];
				n++;
			}
		}
	}
	if(files != nil) {
		int n3 = 0;
		int m2 = [files count];
		for(n3 = 0 ; n3 < m2 ; n3++) {
			NSString* fn = ((NSString*)[files objectAtIndex:n3]);
			if(fn != nil) {
				NSString* cc = nil;
				if(n % 2 == 0) {
					cc = @"even";
				}
				else {
					cc = @"odd";
				}
				[sb appendString:@"<a href=\""];
				[sb appendString:fn];
				[sb appendString:@"\"><div class=\"entry "];
				[sb appendString:cc];
				[sb appendString:@"\">"];
				[sb appendString:fn];
				[sb appendString:@"</div></a>\n"];
				n++;
			}
		}
	}
	[sb appendString:@"</div>\n"];
	[sb appendString:@"<div id=\"footer\">"];
	NSString* serverName = [self getServerName];
	if([CapeString isEmpty:serverName] == FALSE) {
		if([CapeString isEmpty:self->serverURL] == FALSE) {
			[sb appendString:@"Generated by <a href=\""];
			if([CapeString contains:self->serverURL str2:@"://"] == FALSE) {
				[sb appendString:@"http://"];
			}
			[sb appendString:self->serverURL];
			[sb appendString:@"\">"];
			[sb appendString:serverName];
			[sb appendString:@"</a>\n"];
		}
		else {
			[sb appendString:@"Generated by "];
			[sb appendString:serverName];
			[sb appendString:@"\n"];
		}
	}
	[sb appendString:@"</div>\n"];
	[sb appendString:@"</body>\n"];
	[sb appendString:@"</html>\n"];
	return([sb toString]);
}

- (BOOL) onGET:(SympathyHTTPServerRequest*)req {
	if(self->directory == nil) {
		return(FALSE);
	}
	id<CapeFile> dd = self->directory;
	while(TRUE) {
		NSString* comp = [req popResource];
		if(({ NSString* _s1 = comp; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		dd = [dd entry:comp];
	}
	if([dd isDirectory]) {
		if(self->indexFiles != nil) {
			int n = 0;
			int m = [self->indexFiles count];
			for(n = 0 ; n < m ; n++) {
				NSString* indexFile = ((NSString*)[self->indexFiles objectAtIndex:n]);
				if(indexFile != nil) {
					id<CapeFile> ff = [dd entry:indexFile];
					if([ff isFile]) {
						dd = ff;
						break;
					}
				}
			}
		}
	}
	if([dd isDirectory]) {
		if([req isForDirectory] == FALSE) {
			[req sendRedirectAsDirectory];
			return(TRUE);
		}
		if(self->listDirectories == FALSE) {
			return(FALSE);
		}
		[req sendHTMLString:[self dirToHTML:dd]];
		return(TRUE);
	}
	if([dd exists] == FALSE && self->processTemplateFiles) {
		NSString* bn = [dd baseName];
		id<CapeFile> nf = [[dd getParent] entry:[bn stringByAppendingString:@".t"]];
		if([nf isFile]) {
			dd = nf;
		}
		else {
			nf = [[dd getParent] entry:[bn stringByAppendingString:@".html.t"]];
			if([nf isFile]) {
				dd = nf;
			}
		}
	}
	if([dd isFile]) {
		SympathyHTTPServerResponse* resp = nil;
		if(self->processTemplateFiles) {
			NSString* bn = [dd baseName];
			BOOL isJSONTemplate = FALSE;
			BOOL isHTMLTemplate = FALSE;
			BOOL isCSSTemplate = FALSE;
			if([CapeString endsWith:bn str2:@".html.t"]) {
				isHTMLTemplate = TRUE;
			}
			else {
				if([CapeString endsWith:bn str2:@".css.t"]) {
					isCSSTemplate = TRUE;
				}
				else {
					if([CapeString endsWith:bn str2:@".json.t"]) {
						isJSONTemplate = TRUE;
					}
				}
			}
			if(isHTMLTemplate || isCSSTemplate || isJSONTemplate) {
				NSString* data = [dd getContentsString:@"UTF-8"];
				if(({ NSString* _s1 = data; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					[CapeLog error:self->logContext message:[[@"Failed to read template file content: `" stringByAppendingString:([dd getPath])] stringByAppendingString:@"'"]];
					[req sendResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
					return(TRUE);
				}
				NSMutableArray* includeDirs = [[NSMutableArray alloc] init];
				[includeDirs addObject:[dd getParent]];
				if(self->templateIncludeDirs != nil) {
					int n2 = 0;
					int m2 = [self->templateIncludeDirs count];
					for(n2 = 0 ; n2 < m2 ; n2++) {
						id<CapeFile> dir = ((id<CapeFile>)[self->templateIncludeDirs objectAtIndex:n2]);
						if(dir != nil) {
							[includeDirs addObject:dir];
						}
					}
				}
				CapexTextTemplate* tt = nil;
				if(isHTMLTemplate || isCSSTemplate) {
					tt = [CapexTextTemplate forHTMLString:data includeDirs:includeDirs logContext:self->logContext];
				}
				else {
					tt = [CapexTextTemplate forJSONString:data includeDirs:includeDirs logContext:self->logContext];
				}
				if(tt == nil) {
					[CapeLog error:self->logContext message:[[@"Failed to process template file content: `" stringByAppendingString:([dd getPath])] stringByAppendingString:@"'"]];
					[req sendResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
					return(TRUE);
				}
				CapeDynamicMap* tdata = self->templateData;
				CapeDynamicMap* dynamicData = [self getTemplateVariablesForFile:dd];
				if(dynamicData != nil) {
					if(tdata == nil) {
						tdata = dynamicData;
					}
					else {
						[tdata mergeFrom:dynamicData];
					}
				}
				NSString* text = [tt execute:tdata includeDirs:includeDirs];
				if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					[CapeLog error:self->logContext message:[[@"Failed to execute template: `" stringByAppendingString:([dd getPath])] stringByAppendingString:@"'"]];
					[req sendResponse:[SympathyHTTPServerResponse forHTTPInternalError:nil]];
					return(TRUE);
				}
				if(isHTMLTemplate) {
					resp = [SympathyHTTPServerResponse forHTMLString:text];
				}
				else {
					if(isCSSTemplate) {
						resp = [SympathyHTTPServerResponse forString:text mimetype:@"text/css"];
					}
					else {
						resp = [SympathyHTTPServerResponse forJSONString:text];
					}
				}
			}
		}
		if(resp == nil) {
			resp = [SympathyHTTPServerResponse forFile:dd maxCachedSize:-1];
		}
		if(self->maxAge > 0) {
			[resp addHeader:@"Cache-Control" value:[@"max-age=" stringByAppendingString:([CapeString forInteger:self->maxAge])]];
		}
		[req sendResponse:resp];
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) getListDirectories {
	return(self->listDirectories);
}

- (SympathyHTTPServerDirectoryHandler*) setListDirectories:(BOOL)v {
	self->listDirectories = v;
	return(self);
}

- (BOOL) getProcessTemplateFiles {
	return(self->processTemplateFiles);
}

- (SympathyHTTPServerDirectoryHandler*) setProcessTemplateFiles:(BOOL)v {
	self->processTemplateFiles = v;
	return(self);
}

- (id<CapeFile>) getDirectory {
	return(self->directory);
}

- (SympathyHTTPServerDirectoryHandler*) setDirectory:(id<CapeFile>)v {
	self->directory = v;
	return(self);
}

- (int) getMaxAge {
	return(self->maxAge);
}

- (SympathyHTTPServerDirectoryHandler*) setMaxAge:(int)v {
	self->maxAge = v;
	return(self);
}

- (NSString*) getServerURL {
	return(self->serverURL);
}

- (SympathyHTTPServerDirectoryHandler*) setServerURL:(NSString*)v {
	self->serverURL = v;
	return(self);
}

- (NSMutableArray*) getIndexFiles {
	return(self->indexFiles);
}

- (NSMutableArray*) getTemplateIncludeDirs {
	return(self->templateIncludeDirs);
}

- (SympathyHTTPServerDirectoryHandler*) setTemplateIncludeDirs:(NSMutableArray*)v {
	self->templateIncludeDirs = v;
	return(self);
}

- (CapeDynamicMap*) getTemplateData {
	return(self->templateData);
}

- (SympathyHTTPServerDirectoryHandler*) setTemplateData:(CapeDynamicMap*)v {
	self->templateData = v;
	return(self);
}

@end
