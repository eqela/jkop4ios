
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
#import "CapeBufferDataReceiver.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeBuffer.h"
#import "CapeFile.h"
#import "CapeCurrentProcess.h"
#import "CapeEnvironment.h"
#import "CapeFileInstance.h"
#import "CapeVector.h"
#import "CapeOS.h"
#import "CapeMap.h"
#import "CapeProcess.h"
#import "CapeProcessWithIO.h"
#import "CapeProcessLauncher.h"

@class CapeProcessLauncherMyStringPipeHandler;
@class CapeProcessLauncherMyBufferPipeHandler;
@class CapeProcessLauncherQuietPipeHandler;

@interface CapeProcessLauncherMyStringPipeHandler : NSObject <CapeBufferDataReceiver>
- (CapeProcessLauncherMyStringPipeHandler*) init;
- (void) onBufferData:(NSMutableData*)data size:(long long)size;
- (CapeStringBuilder*) getBuilder;
- (CapeProcessLauncherMyStringPipeHandler*) setBuilder:(CapeStringBuilder*)v;
- (NSString*) getEncoding;
- (CapeProcessLauncherMyStringPipeHandler*) setEncoding:(NSString*)v;
@end

@implementation CapeProcessLauncherMyStringPipeHandler

{
	CapeStringBuilder* builder;
	NSString* encoding;
}

- (CapeProcessLauncherMyStringPipeHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->encoding = nil;
	self->builder = nil;
	self->encoding = @"UTF-8";
	return(self);
}

- (void) onBufferData:(NSMutableData*)data size:(long long)size {
	if(self->builder == nil || data == nil || size < 1) {
		return;
	}
	NSString* str = [CapeString forBuffer:[CapeBuffer getSubBuffer:data offset:((long long)0) size:size alwaysNewBuffer:FALSE] encoding:self->encoding];
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	[self->builder appendString:str];
}

- (CapeStringBuilder*) getBuilder {
	return(self->builder);
}

- (CapeProcessLauncherMyStringPipeHandler*) setBuilder:(CapeStringBuilder*)v {
	self->builder = v;
	return(self);
}

- (NSString*) getEncoding {
	return(self->encoding);
}

- (CapeProcessLauncherMyStringPipeHandler*) setEncoding:(NSString*)v {
	self->encoding = v;
	return(self);
}

@end

@interface CapeProcessLauncherMyBufferPipeHandler : NSObject <CapeBufferDataReceiver>
- (CapeProcessLauncherMyBufferPipeHandler*) init;
- (void) onBufferData:(NSMutableData*)newData size:(long long)size;
- (NSMutableData*) getData;
- (CapeProcessLauncherMyBufferPipeHandler*) setData:(NSMutableData*)v;
@end

@implementation CapeProcessLauncherMyBufferPipeHandler

{
	NSMutableData* data;
}

- (CapeProcessLauncherMyBufferPipeHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->data = nil;
	return(self);
}

- (void) onBufferData:(NSMutableData*)newData size:(long long)size {
	self->data = [CapeBuffer append:self->data toAppend:newData size:size];
}

- (NSMutableData*) getData {
	return(self->data);
}

- (CapeProcessLauncherMyBufferPipeHandler*) setData:(NSMutableData*)v {
	self->data = v;
	return(self);
}

@end

@interface CapeProcessLauncherQuietPipeHandler : NSObject <CapeBufferDataReceiver>
- (CapeProcessLauncherQuietPipeHandler*) init;
- (void) onBufferData:(NSMutableData*)data size:(long long)size;
@end

@implementation CapeProcessLauncherQuietPipeHandler

- (CapeProcessLauncherQuietPipeHandler*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

- (void) onBufferData:(NSMutableData*)data size:(long long)size {
}

@end

@implementation CapeProcessLauncher

{
	id<CapeFile> file;
	NSMutableArray* params;
	NSMutableDictionary* env;
	id<CapeFile> cwd;
	int uid;
	int gid;
	BOOL trapSigint;
	BOOL replaceSelf;
	BOOL pipePty;
	BOOL startGroup;
	BOOL noCmdWindow;
	CapeStringBuilder* errorBuffer;
}

+ (CapeProcessLauncher*) forSelf {
	id<CapeFile> exe = [CapeCurrentProcess getExecutableFile];
	if(exe == nil) {
		return(nil);
	}
	CapeProcessLauncher* v = [[CapeProcessLauncher alloc] init];
	[v setFile:exe];
	return(v);
}

+ (CapeProcessLauncher*) forFile:(id<CapeFile>)file params:(NSMutableArray*)params {
	if(file == nil || [file isFile] == FALSE) {
		return(nil);
	}
	CapeProcessLauncher* v = [[CapeProcessLauncher alloc] init];
	[v setFile:file];
	if(params != nil) {
		int n = 0;
		int m = [params count];
		for(n = 0 ; n < m ; n++) {
			NSString* param = ((NSString*)[params objectAtIndex:n]);
			if(param != nil) {
				[v addToParamsWithString:param];
			}
		}
	}
	return(v);
}

+ (CapeProcessLauncher*) forCommand:(NSString*)command params:(NSMutableArray*)params {
	if([CapeString isEmpty:command]) {
		return(nil);
	}
	id<CapeFile> file = nil;
	if([CapeString indexOfWithStringAndCharacterAndSignedInteger:command c:[CapeEnvironment getPathSeparator] start:0] >= 0) {
		file = [CapeFileInstance forPath:command];
	}
	else {
		file = [CapeEnvironment findCommand:command];
	}
	return([CapeProcessLauncher forFile:file params:params]);
}

+ (CapeProcessLauncher*) forString:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(nil);
	}
	NSMutableArray* arr = [CapeString quotedStringToVector:str delim:' '];
	if(arr == nil || [CapeVector getSize:arr] < 1) {
		return(nil);
	}
	int vsz = [CapeVector getSize:arr];
	NSString* cmd = ((NSString*)[arr objectAtIndex:0]);
	NSMutableArray* params = nil;
	int paramCount = vsz - 1;
	if(paramCount > 0) {
		params = [[NSMutableArray alloc] initWithCapacity:paramCount];
		for(int n = 1 ; n < vsz ; n++) {
			[params insertObject:(id)({ id _v = ((NSString*)[arr objectAtIndex:n]); _v == nil ? [NSNull null] : _v; }) atIndex:n - 1];
		}
	}
	return([CapeProcessLauncher forCommand:cmd params:params]);
}

- (CapeProcessLauncher*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->errorBuffer = nil;
	self->noCmdWindow = FALSE;
	self->startGroup = FALSE;
	self->pipePty = FALSE;
	self->replaceSelf = FALSE;
	self->trapSigint = TRUE;
	self->gid = -1;
	self->uid = -1;
	self->cwd = nil;
	self->env = nil;
	self->params = nil;
	self->file = nil;
	self->params = [[NSMutableArray alloc] init];
	self->env = [[NSMutableDictionary alloc] init];
	return(self);
}

- (void) appendProperParam:(CapeStringBuilder*)sb p:(NSString*)p {
	BOOL noQuotes = FALSE;
	if([CapeOS isWindows]) {
		int rc = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:p c:' ' start:-1];
		if(rc < 0) {
			noQuotes = TRUE;
		}
	}
	[sb appendCharacter:' '];
	if(noQuotes) {
		[sb appendString:p];
	}
	else {
		[sb appendCharacter:'\"'];
		[sb appendString:p];
		[sb appendCharacter:'\"'];
	}
}

- (NSString*) toString:(BOOL)includeEnv {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(includeEnv) {
		NSMutableArray* keys = [CapeMap getKeys:self->env];
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					[sb appendString:key];
					[sb appendString:@"="];
					[sb appendString:((NSString*)[self->env objectForKey:key])];
					[sb appendString:@" "];
				}
			}
		}
	}
	[sb appendString:@"\""];
	if(self->file != nil) {
		[sb appendString:[self->file getPath]];
	}
	[sb appendString:@"\""];
	if(self->params != nil) {
		int n2 = 0;
		int m2 = [self->params count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			NSString* p = ((NSString*)[self->params objectAtIndex:n2]);
			if(p != nil) {
				[self appendProperParam:sb p:p];
			}
		}
	}
	return([sb toString]);
}

- (CapeProcessLauncher*) addToParamsWithString:(NSString*)arg {
	if(!(({ NSString* _s1 = arg; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->params == nil) {
			self->params = [[NSMutableArray alloc] init];
		}
		[self->params addObject:arg];
	}
	return(self);
}

- (CapeProcessLauncher*) addToParamsWithFile:(id<CapeFile>)file {
	if(file != nil) {
		[self addToParamsWithString:[file getPath]];
	}
	return(self);
}

- (CapeProcessLauncher*) addToParamsWithVector:(NSMutableArray*)params {
	if(params != nil) {
		int n = 0;
		int m = [params count];
		for(n = 0 ; n < m ; n++) {
			NSString* s = ((NSString*)[params objectAtIndex:n]);
			if(s != nil) {
				[self addToParamsWithString:s];
			}
		}
	}
	return(self);
}

- (void) setEnvVariable:(NSString*)key val:(NSString*)val {
	if(!(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		if(self->env == nil) {
			self->env = [[NSMutableDictionary alloc] init];
		}
		({ id _v = val; id _o = self->env; id _k = key; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
}

- (id<CapeProcess>) startProcess:(BOOL)wait pipeHandler:(id<CapeBufferDataReceiver>)pipeHandler withIO:(BOOL)withIO {
	NSLog(@"%@", @"[cape.ProcessLauncher.startProcess] (ProcessLauncher.sling:278:2): Not implemented");
	return(nil);
}

- (id<CapeProcess>) start {
	return([self startProcess:FALSE pipeHandler:nil withIO:FALSE]);
}

- (id<CapeProcessWithIO>) startWithIO {
	return(((id<CapeProcessWithIO>)({ id _v = [self startProcess:FALSE pipeHandler:nil withIO:TRUE]; [((NSObject*)_v) conformsToProtocol:@protocol(CapeProcessWithIO)] ? _v : nil; })));
}

- (int) execute {
	id<CapeProcess> cp = [self startProcess:TRUE pipeHandler:nil withIO:FALSE];
	if(cp == nil) {
		return(-1);
	}
	return([cp getExitStatus]);
}

- (int) executeSilent {
	id<CapeProcess> cp = [self startProcess:TRUE pipeHandler:((id<CapeBufferDataReceiver>)[[CapeProcessLauncherQuietPipeHandler alloc] init]) withIO:FALSE];
	if(cp == nil) {
		return(-1);
	}
	return([cp getExitStatus]);
}

- (int) executeToStringBuilder:(CapeStringBuilder*)output {
	CapeProcessLauncherMyStringPipeHandler* msp = [[CapeProcessLauncherMyStringPipeHandler alloc] init];
	[msp setBuilder:output];
	id<CapeProcess> cp = [self startProcess:TRUE pipeHandler:((id<CapeBufferDataReceiver>)msp) withIO:FALSE];
	if(cp == nil) {
		return(-1);
	}
	return([cp getExitStatus]);
}

- (NSString*) executeToString {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if([self executeToStringBuilder:sb] < 0) {
		return(nil);
	}
	return([sb toString]);
}

- (NSMutableData*) executeToBuffer {
	CapeProcessLauncherMyBufferPipeHandler* ph = [[CapeProcessLauncherMyBufferPipeHandler alloc] init];
	id<CapeProcess> cp = [self startProcess:TRUE pipeHandler:((id<CapeBufferDataReceiver>)ph) withIO:FALSE];
	if(cp == nil) {
		return(nil);
	}
	return([ph getData]);
}

- (int) executeToPipe:(id<CapeBufferDataReceiver>)pipeHandler {
	id<CapeProcess> cp = [self startProcess:TRUE pipeHandler:pipeHandler withIO:FALSE];
	if(cp == nil) {
		return(-1);
	}
	return([cp getExitStatus]);
}

- (id<CapeFile>) getFile {
	return(self->file);
}

- (CapeProcessLauncher*) setFile:(id<CapeFile>)v {
	self->file = v;
	return(self);
}

- (NSMutableArray*) getParams {
	return(self->params);
}

- (CapeProcessLauncher*) setParams:(NSMutableArray*)v {
	self->params = v;
	return(self);
}

- (NSMutableDictionary*) getEnv {
	return(self->env);
}

- (CapeProcessLauncher*) setEnv:(NSMutableDictionary*)v {
	self->env = v;
	return(self);
}

- (id<CapeFile>) getCwd {
	return(self->cwd);
}

- (CapeProcessLauncher*) setCwd:(id<CapeFile>)v {
	self->cwd = v;
	return(self);
}

- (int) getUid {
	return(self->uid);
}

- (CapeProcessLauncher*) setUid:(int)v {
	self->uid = v;
	return(self);
}

- (int) getGid {
	return(self->gid);
}

- (CapeProcessLauncher*) setGid:(int)v {
	self->gid = v;
	return(self);
}

- (BOOL) getTrapSigint {
	return(self->trapSigint);
}

- (CapeProcessLauncher*) setTrapSigint:(BOOL)v {
	self->trapSigint = v;
	return(self);
}

- (BOOL) getReplaceSelf {
	return(self->replaceSelf);
}

- (CapeProcessLauncher*) setReplaceSelf:(BOOL)v {
	self->replaceSelf = v;
	return(self);
}

- (BOOL) getPipePty {
	return(self->pipePty);
}

- (CapeProcessLauncher*) setPipePty:(BOOL)v {
	self->pipePty = v;
	return(self);
}

- (BOOL) getStartGroup {
	return(self->startGroup);
}

- (CapeProcessLauncher*) setStartGroup:(BOOL)v {
	self->startGroup = v;
	return(self);
}

- (BOOL) getNoCmdWindow {
	return(self->noCmdWindow);
}

- (CapeProcessLauncher*) setNoCmdWindow:(BOOL)v {
	self->noCmdWindow = v;
	return(self);
}

- (CapeStringBuilder*) getErrorBuffer {
	return(self->errorBuffer);
}

- (CapeProcessLauncher*) setErrorBuffer:(CapeStringBuilder*)v {
	self->errorBuffer = v;
	return(self);
}

@end
