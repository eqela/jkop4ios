
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
#import "CapeLoggingContext.h"
#import "CapeLog.h"
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapeCharacterIterator.h"
#import "CapeVector.h"
#import "CapeEnvironment.h"
#import "CapeFileInstance.h"
#import "CapeDynamicMap.h"
#import "CapeIterator.h"
#import "CapeJSONObject.h"
#import "CapeVectorObject.h"
#import "CapeArrayObject.h"
#import "CapeDynamicVector.h"
#import "CapeStringObject.h"
#import "CapexHTMLString.h"
#import "CapeJSONEncoder.h"
#import "CapexRichTextDocument.h"
#import "CapeDateTime.h"
#import "CapexTextTemplate.h"

@class CapexTextTemplateTagData;

@interface CapexTextTemplateTagData : NSObject
{
	@public NSMutableArray* words;
}
- (CapexTextTemplateTagData*) init;
- (CapexTextTemplateTagData*) initWithVector:(NSMutableArray*)words;
@end

@implementation CapexTextTemplateTagData

- (CapexTextTemplateTagData*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->words = nil;
	return(self);
}

- (CapexTextTemplateTagData*) initWithVector:(NSMutableArray*)words {
	if([super init] == nil) {
		return(nil);
	}
	self->words = nil;
	self->words = words;
	return(self);
}

@end

int CapexTextTemplateTYPE_GENERIC = 0;
int CapexTextTemplateTYPE_HTML = 1;
int CapexTextTemplateTYPE_JSON = 2;

@implementation CapexTextTemplate

{
	NSMutableArray* tokens;
	NSString* text;
	NSString* markerBegin;
	NSString* markerEnd;
	id<CapeLoggingContext> logContext;
	int type;
	NSMutableArray* languagePreferences;
}

- (CapexTextTemplate*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->languagePreferences = nil;
	self->type = CapexTextTemplateTYPE_GENERIC;
	self->logContext = nil;
	self->markerEnd = nil;
	self->markerBegin = nil;
	self->text = nil;
	self->tokens = nil;
	return(self);
}

+ (CapexTextTemplate*) forFile:(id<CapeFile>)file markerBegin:(NSString*)markerBegin markerEnd:(NSString*)markerEnd type:(int)type includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext {
	if(file == nil) {
		return(nil);
	}
	NSString* text = [file getContentsString:@"UTF-8"];
	if(({ NSString* _s1 = text; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSMutableArray* ids = includeDirs;
	if(ids == nil) {
		ids = [[NSMutableArray alloc] init];
		[ids addObject:[file getParent]];
	}
	return([CapexTextTemplate forString:text markerBegin:markerBegin markerEnd:markerEnd type:type includeDirs:ids logContext:logContext]);
}

+ (CapexTextTemplate*) forString:(NSString*)text markerBegin:(NSString*)markerBegin markerEnd:(NSString*)markerEnd type:(int)type includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext {
	CapexTextTemplate* v = [[CapexTextTemplate alloc] init];
	[v setLogContext:logContext];
	[v setText:text];
	[v setType:type];
	[v setMarkerBegin:markerBegin];
	[v setMarkerEnd:markerEnd];
	if([v prepare:includeDirs] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (CapexTextTemplate*) forHTMLString:(NSString*)text includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext {
	CapexTextTemplate* v = [[CapexTextTemplate alloc] init];
	[v setLogContext:logContext];
	[v setText:text];
	[v setType:CapexTextTemplateTYPE_HTML];
	[v setMarkerBegin:@"<%"];
	[v setMarkerEnd:@"%>"];
	if([v prepare:includeDirs] == FALSE) {
		v = nil;
	}
	return(v);
}

+ (CapexTextTemplate*) forJSONString:(NSString*)text includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext {
	CapexTextTemplate* v = [[CapexTextTemplate alloc] init];
	[v setLogContext:logContext];
	[v setText:text];
	[v setType:CapexTextTemplateTYPE_JSON];
	[v setMarkerBegin:@"{{"];
	[v setMarkerEnd:@"}}"];
	if([v prepare:includeDirs] == FALSE) {
		v = nil;
	}
	return(v);
}

- (void) setLanguagePreference:(NSString*)language {
	self->languagePreferences = [[NSMutableArray alloc] init];
	if(!(({ NSString* _s1 = language; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[self->languagePreferences addObject:language];
	}
}

- (NSMutableArray*) tokenizeString:(NSString*)inputdata includeDirs:(NSMutableArray*)includeDirs {
	if(({ NSString* _s1 = self->markerBegin; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = self->markerEnd; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[CapeLog error:self->logContext message:@"No template markers were given"];
		return(nil);
	}
	if([CapeString getLength:self->markerBegin] != 2 || [CapeString getLength:self->markerEnd] != 2) {
		[CapeLog error:self->logContext message:[[[[@"Invalid template markers: `" stringByAppendingString:self->markerBegin] stringByAppendingString:@"' and `"] stringByAppendingString:self->markerEnd] stringByAppendingString:@"'"]];
		return(nil);
	}
	int mb1 = [CapeString charAt:self->markerBegin index:0];
	int mb2 = [CapeString charAt:self->markerBegin index:1];
	int me1 = [CapeString charAt:self->markerEnd index:0];
	int me2 = [CapeString charAt:self->markerEnd index:1];
	int pc = ' ';
	CapeStringBuilder* tag = nil;
	CapeStringBuilder* data = nil;
	id<CapeCharacterIterator> it = [CapeString iterate:inputdata];
	NSMutableArray* v = [[NSMutableArray alloc] init];
	while(it != nil) {
		int c = [it getNextChar];
		if(c <= 0) {
			break;
		}
		if(tag != nil) {
			if(pc == me1 && [tag count] > 2) {
				[tag appendCharacter:pc];
				[tag appendCharacter:c];
				if(c == me2) {
					NSString* tt = [tag toString];
					NSString* tts = [CapeString strip:[CapeString subStringWithStringAndSignedIntegerAndSignedInteger:tt start:2 length:[CapeString getLength:tt] - 4]];
					NSMutableArray* words = [CapeString quotedStringToVector:tts delim:' '];
					if(({ NSString* _s1 = [CapeVector get:words index:0]; NSString* _s2 = @"include"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						NSString* fileName = [CapeVector get:words index:1];
						if([CapeString isEmpty:fileName]) {
							[CapeLog warning:self->logContext message:@"Include tag with empty filename. Ignoring it."];
						}
						else {
							id<CapeFile> ff = nil;
							if([CapeEnvironment isAbsolutePath:fileName]) {
								ff = [CapeFileInstance forPath:fileName];
							}
							else {
								if(includeDirs != nil) {
									int n = 0;
									int m = [includeDirs count];
									for(n = 0 ; n < m ; n++) {
										id<CapeFile> includeDir = ((id<CapeFile>)[includeDirs objectAtIndex:n]);
										if(includeDir != nil) {
											id<CapeFile> x = [CapeFileInstance forRelativePath:fileName relativeTo:includeDir alwaysSupportWindowsPathnames:FALSE];
											if([x isFile]) {
												ff = x;
												break;
											}
										}
									}
								}
							}
							if(ff == nil || [ff isFile] == FALSE) {
								[CapeLog warning:self->logContext message:[[@"Included file was not found: `" stringByAppendingString:fileName] stringByAppendingString:@"'"]];
							}
							else {
								NSString* cc = [ff getContentsString:@"UTF-8"];
								if(({ NSString* _s1 = cc; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									[CapeLog warning:self->logContext message:[[@"Failed to read included file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
								}
								else {
									CapexTextTemplate* nt = [CapexTextTemplate forString:cc markerBegin:self->markerBegin markerEnd:self->markerEnd type:self->type includeDirs:includeDirs logContext:nil];
									if(nt == nil) {
										[CapeLog warning:self->logContext message:[[@"Failed to read included template file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
									}
									else {
										NSMutableArray* array = [nt getTokens];
										if(array != nil) {
											int n2 = 0;
											int m2 = [array count];
											for(n2 = 0 ; n2 < m2 ; n2++) {
												id token = ((id)[array objectAtIndex:n2]);
												if(token != nil) {
													[v addObject:token];
												}
											}
										}
									}
								}
							}
						}
					}
					else {
						[v addObject:[[CapexTextTemplateTagData alloc] initWithVector:words]];
					}
					tag = nil;
				}
			}
			else {
				if(c != me1) {
					[tag appendCharacter:c];
				}
			}
		}
		else {
			if(pc == mb1) {
				if(c == mb2) {
					if(data != nil) {
						[v addObject:data];
						data = nil;
					}
					tag = [[CapeStringBuilder alloc] init];
					[tag appendCharacter:pc];
					[tag appendCharacter:c];
				}
				else {
					if(data == nil) {
						data = [[CapeStringBuilder alloc] init];
					}
					[data appendCharacter:pc];
					[data appendCharacter:c];
				}
			}
			else {
				if(c != mb1) {
					if(data == nil) {
						data = [[CapeStringBuilder alloc] init];
					}
					[data appendCharacter:c];
				}
			}
		}
		pc = c;
	}
	if(pc == mb1) {
		if(data == nil) {
			data = [[CapeStringBuilder alloc] init];
		}
		[data appendCharacter:pc];
	}
	if(data != nil) {
		[v addObject:data];
		data = nil;
	}
	if(tag != nil) {
		[CapeLog error:self->logContext message:[[@"Unfinished tag: `" stringByAppendingString:([tag toString])] stringByAppendingString:@"'"]];
		return(nil);
	}
	return(v);
}

- (BOOL) prepare:(NSMutableArray*)includeDirs {
	NSString* str = self->text;
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		[CapeLog error:self->logContext message:@"No input string was specified."];
		return(FALSE);
	}
	self->tokens = [self tokenizeString:str includeDirs:includeDirs];
	if(self->tokens == nil) {
		return(FALSE);
	}
	return(TRUE);
}

- (NSString*) execute:(CapeDynamicMap*)vars includeDirs:(NSMutableArray*)includeDirs {
	if(self->tokens == nil) {
		[CapeLog error:self->logContext message:@"TextTemplate has not been prepared"];
		return(nil);
	}
	CapeStringBuilder* result = [[CapeStringBuilder alloc] init];
	if([self doExecute:self->tokens avars:vars result:result includeDirs:includeDirs] == FALSE) {
		return(nil);
	}
	return([result toString]);
}

- (NSString*) substituteVariables:(NSString*)orig vars:(CapeDynamicMap*)vars {
	if(({ NSString* _s1 = orig; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(orig);
	}
	if([CapeString indexOfWithStringAndStringAndSignedInteger:orig s:@"${" start:0] < 0) {
		return(orig);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	CapeStringBuilder* varbuf = nil;
	BOOL flag = FALSE;
	id<CapeCharacterIterator> it = [CapeString iterate:orig];
	while(it != nil) {
		int c = [it getNextChar];
		if(c <= 0) {
			break;
		}
		if(varbuf != nil) {
			if(c == '}') {
				NSString* varname = [varbuf toString];
				if(vars != nil) {
					NSString* varcut = nil;
					if([CapeString indexOfWithStringAndCharacterAndSignedInteger:varname c:'!' start:0] > 0) {
						id<CapeIterator> sp = [CapeVector iterate:[CapeString split:varname delim:'!' max:2]];
						varname = [sp next];
						varcut = [sp next];
					}
					NSString* r = [self getVariableValueString:vars varname:varname];
					if([CapeString isEmpty:varcut] == FALSE) {
						id<CapeCharacterIterator> itc = [CapeString iterate:varcut];
						int cx = ' ';
						while((cx = [itc getNextChar]) > 0) {
							int n = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:r c:cx start:-1];
							if(n < 0) {
								break;
							}
							r = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:r start:0 length:n];
						}
					}
					[sb appendString:r];
				}
				varbuf = nil;
			}
			else {
				[varbuf appendCharacter:c];
			}
			continue;
		}
		if(flag == TRUE) {
			flag = FALSE;
			if(c == '{') {
				varbuf = [[CapeStringBuilder alloc] init];
			}
			else {
				[sb appendCharacter:'$'];
				[sb appendCharacter:c];
			}
			continue;
		}
		if(c == '$') {
			flag = TRUE;
			continue;
		}
		[sb appendCharacter:c];
	}
	return([sb toString]);
}

- (id) getVariableValue:(CapeDynamicMap*)vars varname:(NSString*)varname {
	if(vars == nil || ({ NSString* _s1 = varname; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	id vv = [vars get:varname];
	if(vv != nil) {
		return(vv);
	}
	NSMutableArray* ll = [CapeString split:varname delim:'.' max:0];
	if([CapeVector getSize:ll] < 2) {
		return(nil);
	}
	NSString* nvar = ((NSString*)({ id _v = [CapeVector get:ll index:[CapeVector getSize:ll] - 1]; [_v isKindOfClass:[NSString class]] ? _v : nil; }));
	[CapeVector removeLast:ll];
	CapeDynamicMap* cc = vars;
	if(ll != nil) {
		int n = 0;
		int m = [ll count];
		for(n = 0 ; n < m ; n++) {
			NSString* vv2 = ((NSString*)[ll objectAtIndex:n]);
			if(vv2 != nil) {
				if(cc == nil) {
					return(nil);
				}
				id vv2o = [cc get:vv2];
				cc = ((CapeDynamicMap*)({ id _v = vv2o; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
				if(cc == nil && vv2o != nil && [((NSObject*)vv2o) conformsToProtocol:@protocol(CapeJSONObject)]) {
					cc = ((CapeDynamicMap*)({ id _v = [((id<CapeJSONObject>)vv2o) toJsonObject]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
				}
			}
		}
	}
	if(cc != nil) {
		return([cc get:nvar]);
	}
	return(nil);
}

- (NSString*) getVariableValueString:(CapeDynamicMap*)vars varname:(NSString*)varname {
	id v = [self getVariableValue:vars varname:varname];
	if(v == nil) {
		return(nil);
	}
	if([v isKindOfClass:[CapeDynamicMap class]]) {
		if(self->languagePreferences != nil) {
			if(self->languagePreferences != nil) {
				int n = 0;
				int m = [self->languagePreferences count];
				for(n = 0 ; n < m ; n++) {
					NSString* language = ((NSString*)[self->languagePreferences objectAtIndex:n]);
					if(language != nil) {
						NSString* s = [((CapeDynamicMap*)v) getString:language defval:nil];
						if(!(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
							return(s);
						}
					}
				}
			}
		}
		else {
			NSString* s = [((CapeDynamicMap*)v) getString:@"en" defval:nil];
			if(!(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				return(s);
			}
		}
		return(nil);
	}
	return([CapeString asStringWithObject:v]);
}

- (NSMutableArray*) getVariableValueVector:(CapeDynamicMap*)vars varname:(NSString*)varname {
	id v = [self getVariableValue:vars varname:varname];
	if(v == nil) {
		return(nil);
	}
	if([v isKindOfClass:[NSMutableArray class]]) {
		return(((NSMutableArray*)v));
	}
	if([((NSObject*)v) conformsToProtocol:@protocol(CapeVectorObject)]) {
		id<CapeVectorObject> vo = ((id<CapeVectorObject>)v);
		NSMutableArray* vv = [vo toVector];
		return(vv);
	}
	if([((NSObject*)v) conformsToProtocol:@protocol(CapeArrayObject)]) {
		id<CapeArrayObject> vo = ((id<CapeArrayObject>)({ id _v = v; [((NSObject*)_v) conformsToProtocol:@protocol(CapeArrayObject)] ? _v : nil; }));
		NSMutableArray* vv = [vo toArray];
		NSMutableArray* vvx = [CapeVector forArray:vv];
		return(vvx);
	}
	if([v isKindOfClass:[CapeDynamicVector class]]) {
		return([((CapeDynamicVector*)v) toVector]);
	}
	return(nil);
}

- (BOOL) handleBlock:(CapeDynamicMap*)vars tag:(NSMutableArray*)tag data:(NSMutableArray*)data result:(CapeStringBuilder*)result includeDirs:(NSMutableArray*)includeDirs {
	if(tag == nil) {
		return(FALSE);
	}
	NSString* tagname = [CapeVector get:tag index:0];
	if([CapeString isEmpty:tagname]) {
		return(FALSE);
	}
	if(({ NSString* _s1 = tagname; NSString* _s2 = @"for"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSString* varname = [CapeVector get:tag index:1];
		NSString* inword = [CapeVector get:tag index:2];
		NSString* origvar = [self substituteVariables:[CapeVector get:tag index:3] vars:vars];
		if([CapeString isEmpty:varname] || [CapeString isEmpty:origvar] || !(({ NSString* _s1 = inword; NSString* _s2 = @"in"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			[CapeLog error:self->logContext message:[[@"Invalid for tag: `" stringByAppendingString:([CapeString combine:tag delim:' ' unique:FALSE])] stringByAppendingString:@"'"]];
			return(FALSE);
		}
		int index = 0;
		[vars setStringAndObject:@"__for_first" value:((id)@"true")];
		NSMutableArray* vv = [self getVariableValueVector:vars varname:origvar];
		if(vv != nil) {
			int n = 0;
			int m = [vv count];
			for(n = 0 ; n < m ; n++) {
				id o = ((id)[vv objectAtIndex:n]);
				if(o != nil) {
					if(index % 2 == 0) {
						[vars setStringAndObject:@"__for_parity" value:((id)@"even")];
					}
					else {
						[vars setStringAndObject:@"__for_parity" value:((id)@"odd")];
					}
					[vars setStringAndObject:varname value:o];
					if([self doExecute:data avars:vars result:result includeDirs:includeDirs] == FALSE) {
						return(FALSE);
					}
					if(index == 0) {
						[vars setStringAndObject:@"__for_first" value:((id)@"false")];
					}
					index++;
				}
			}
		}
		[vars remove:@"__for_first"];
		[vars remove:@"__for_parity"];
		return(TRUE);
	}
	if(({ NSString* _s1 = tagname; NSString* _s2 = @"if"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSString* lvalue = [CapeVector get:tag index:1];
		if(({ NSString* _s1 = lvalue; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			return(TRUE);
		}
		NSString* _x_operator = [CapeVector get:tag index:2];
		if(({ NSString* _s1 = _x_operator; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			id varval = [self getVariableValue:vars varname:lvalue];
			if(varval == nil) {
				return(TRUE);
			}
			if([((NSObject*)varval) conformsToProtocol:@protocol(CapeVectorObject)]) {
				if([CapeVector isEmpty:[((id<CapeVectorObject>)varval) toVector]]) {
					return(TRUE);
				}
			}
			if([varval isKindOfClass:[CapeDynamicMap class]]) {
				CapeDynamicMap* value = ((CapeDynamicMap*)varval);
				if([value getCount] < 1) {
					return(TRUE);
				}
			}
			if([varval isKindOfClass:[NSString class]]) {
				if([CapeString isEmpty:((NSString*)varval)]) {
					return(TRUE);
				}
			}
			if([((NSObject*)varval) conformsToProtocol:@protocol(CapeStringObject)]) {
				if([CapeString isEmpty:[((id<CapeStringObject>)varval) toString]]) {
					return(TRUE);
				}
			}
			if([self doExecute:data avars:vars result:result includeDirs:includeDirs] == FALSE) {
				return(FALSE);
			}
			return(TRUE);
		}
		lvalue = [self substituteVariables:lvalue vars:vars];
		NSString* rvalue = [CapeVector get:tag index:3];
		if(!(({ NSString* _s1 = rvalue; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			rvalue = [self substituteVariables:rvalue vars:vars];
		}
		if(({ NSString* _s1 = lvalue; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString isEmpty:_x_operator] || ({ NSString* _s1 = rvalue; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			[CapeLog error:self->logContext message:[[@"Invalid if tag: `" stringByAppendingString:([CapeString combine:tag delim:' ' unique:FALSE])] stringByAppendingString:@"'"]];
			return(FALSE);
		}
		if(({ NSString* _s1 = _x_operator; NSString* _s2 = @"=="; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = _x_operator; NSString* _s2 = @"="; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = _x_operator; NSString* _s2 = @"is"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			if(!(({ NSString* _s1 = rvalue; NSString* _s2 = lvalue; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
				return(TRUE);
			}
			if([self doExecute:data avars:vars result:result includeDirs:includeDirs] == FALSE) {
				return(FALSE);
			}
			return(TRUE);
		}
		if(({ NSString* _s1 = _x_operator; NSString* _s2 = @"!="; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = _x_operator; NSString* _s2 = @"not"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			if(({ NSString* _s1 = rvalue; NSString* _s2 = lvalue; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				return(TRUE);
			}
			if([self doExecute:data avars:vars result:result includeDirs:includeDirs] == FALSE) {
				return(FALSE);
			}
			return(TRUE);
		}
		[CapeLog error:self->logContext message:[[[[@"Unknown operator `" stringByAppendingString:_x_operator] stringByAppendingString:@"' in if tag: `"] stringByAppendingString:([CapeString combine:tag delim:' ' unique:FALSE])] stringByAppendingString:@"'"]];
		return(FALSE);
	}
	return(FALSE);
}

- (BOOL) doExecute:(NSMutableArray*)data avars:(CapeDynamicMap*)avars result:(CapeStringBuilder*)result includeDirs:(NSMutableArray*)includeDirs {
	if(data == nil) {
		return(TRUE);
	}
	int blockctr = 0;
	NSMutableArray* blockdata = nil;
	NSMutableArray* blocktag = nil;
	CapeDynamicMap* vars = avars;
	if(vars == nil) {
		vars = [[CapeDynamicMap alloc] init];
	}
	if(data != nil) {
		int n2 = 0;
		int m = [data count];
		for(n2 = 0 ; n2 < m ; n2++) {
			id o = ((id)[data objectAtIndex:n2]);
			if(o != nil) {
				NSString* tagname = nil;
				NSMutableArray* words = nil;
				CapexTextTemplateTagData* tagData = ((CapexTextTemplateTagData*)({ id _v = o; [_v isKindOfClass:[CapexTextTemplateTagData class]] ? _v : nil; }));
				if(tagData != nil) {
					words = tagData->words;
					if(words != nil) {
						tagname = [CapeVector get:words index:0];
						if([CapeString isEmpty:tagname]) {
							[CapeLog warning:self->logContext message:@"Empty tag encountered. Ignoring it."];
							continue;
						}
					}
				}
				if(({ NSString* _s1 = tagname; NSString* _s2 = @"end"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					blockctr--;
					if(blockctr == 0 && blockdata != nil) {
						if([self handleBlock:vars tag:blocktag data:blockdata result:result includeDirs:includeDirs] == FALSE) {
							[CapeLog error:self->logContext message:@"Handling of a block failed"];
							continue;
						}
						blockdata = nil;
						blocktag = nil;
					}
				}
				if(blockctr > 0) {
					if(({ NSString* _s1 = tagname; NSString* _s2 = @"for"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = tagname; NSString* _s2 = @"if"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						blockctr++;
					}
					if(blockdata == nil) {
						blockdata = [[NSMutableArray alloc] init];
					}
					[blockdata addObject:o];
					continue;
				}
				if([o isKindOfClass:[NSString class]] || [((NSObject*)o) conformsToProtocol:@protocol(CapeStringObject)]) {
					[result appendString:[CapeString asStringWithObject:o]];
					continue;
				}
				if(({ NSString* _s1 = tagname; NSString* _s2 = @"="; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = tagname; NSString* _s2 = @"printstring"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					NSString* varname = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
					if([CapeString isEmpty:varname] == FALSE) {
						NSString* vv = [self getVariableValueString:vars varname:varname];
						if([CapeString isEmpty:vv] == FALSE) {
							if(self->type == CapexTextTemplateTYPE_HTML) {
								vv = [CapexHTMLString sanitize:vv];
							}
							[result appendString:vv];
						}
						else {
							NSString* defaultvalue = [self substituteVariables:[CapeVector get:words index:2] vars:vars];
							if([CapeString isEmpty:defaultvalue] == FALSE) {
								if(self->type == CapexTextTemplateTYPE_HTML) {
									defaultvalue = [CapexHTMLString sanitize:defaultvalue];
								}
								[result appendString:defaultvalue];
							}
						}
					}
				}
				else {
					if(({ NSString* _s1 = tagname; NSString* _s2 = @"printRaw"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						NSString* varname = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
						if([CapeString isEmpty:varname] == FALSE) {
							NSString* vv = [self getVariableValueString:vars varname:varname];
							if([CapeString isEmpty:vv] == FALSE) {
								[result appendString:vv];
							}
							else {
								NSString* defaultvalue = [self substituteVariables:[CapeVector get:words index:2] vars:vars];
								if([CapeString isEmpty:defaultvalue] == FALSE) {
									[result appendString:defaultvalue];
								}
							}
						}
					}
					else {
						if(({ NSString* _s1 = tagname; NSString* _s2 = @"catPath"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							BOOL hasSlash = FALSE;
							int n = 0;
							if(words != nil) {
								int n3 = 0;
								int m2 = [words count];
								for(n3 = 0 ; n3 < m2 ; n3++) {
									NSString* word = ((NSString*)[words objectAtIndex:n3]);
									if(word != nil) {
										n++;
										if(n == 1) {
											continue;
										}
										word = [self substituteVariables:word vars:vars];
										id<CapeCharacterIterator> it = [CapeString iterate:word];
										if(it == nil) {
											continue;
										}
										if(n > 2 && hasSlash == FALSE) {
											[result appendCharacter:'/'];
											hasSlash = TRUE;
										}
										while(TRUE) {
											int c = [it getNextChar];
											if(c < 1) {
												break;
											}
											if(c == '/') {
												if(hasSlash == FALSE) {
													[result appendCharacter:c];
													hasSlash = TRUE;
												}
											}
											else {
												[result appendCharacter:c];
												hasSlash = FALSE;
											}
										}
									}
								}
							}
						}
						else {
							if(({ NSString* _s1 = tagname; NSString* _s2 = @"printJson"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								NSString* varname = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
								if([CapeString isEmpty:varname] == FALSE) {
									id vv = [self getVariableValue:vars varname:varname];
									if(vv != nil) {
										[result appendString:[CapeJSONEncoder encode:vv niceFormatting:TRUE]];
									}
								}
							}
							else {
								if(({ NSString* _s1 = tagname; NSString* _s2 = @"printRichText"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									NSString* markup = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
									if([CapeString isEmpty:markup] == FALSE) {
										CapexRichTextDocument* doc = [CapexRichTextDocument forWikiMarkupString:markup];
										if(doc != nil) {
											[result appendString:[doc toHtml:nil]];
										}
									}
								}
								else {
									if(({ NSString* _s1 = tagname; NSString* _s2 = @"printDate"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										NSString* timestamp = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
										long long aslong = [CapeString toLong:timestamp];
										NSString* asstring = [[CapeDateTime forTimeSeconds:aslong] toStringDate:'/'];
										[result appendString:asstring];
									}
									else {
										if(({ NSString* _s1 = tagname; NSString* _s2 = @"printTime"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
											NSString* timestamp = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
											long long aslong = [CapeString toLong:timestamp];
											NSString* asstring = [[CapeDateTime forTimeSeconds:aslong] toStringTime:':'];
											[result appendString:asstring];
										}
										else {
											if(({ NSString* _s1 = tagname; NSString* _s2 = @"printDateTime"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
												NSString* timestamp = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
												long long aslong = [CapeString toLong:timestamp];
												CapeDateTime* dt = [CapeDateTime forTimeSeconds:aslong];
												[result appendString:[dt toStringDate:'/']];
												[result appendCharacter:' '];
												[result appendString:[dt toStringTime:':']];
											}
											else {
												if(({ NSString* _s1 = tagname; NSString* _s2 = @"import"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
													NSString* type = [CapeVector get:words index:1];
													NSString* filename = [self substituteVariables:[CapeVector get:words index:2] vars:vars];
													if([CapeString isEmpty:filename]) {
														[CapeLog warning:self->logContext message:@"Invalid import tag with empty filename"];
														continue;
													}
													id<CapeFile> ff = nil;
													if(includeDirs != nil) {
														int n4 = 0;
														int m3 = [includeDirs count];
														for(n4 = 0 ; n4 < m3 ; n4++) {
															id<CapeFile> dir = ((id<CapeFile>)[includeDirs objectAtIndex:n4]);
															if(dir != nil) {
																ff = [CapeFileInstance forRelativePath:filename relativeTo:dir alwaysSupportWindowsPathnames:FALSE];
																if(ff != nil && [ff isFile]) {
																	break;
																}
															}
														}
													}
													if(ff == nil || [ff isFile] == FALSE) {
														[CapeLog error:self->logContext message:[[@"Unable to find file to import: `" stringByAppendingString:filename] stringByAppendingString:@"'"]];
														continue;
													}
													[CapeLog debug:self->logContext message:[[@"Attempting to import file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
													NSString* content = [ff getContentsString:@"UTF-8"];
													if([CapeString isEmpty:content]) {
														[CapeLog error:self->logContext message:[[@"Unable to read import file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
														continue;
													}
													if(({ NSString* _s1 = type; NSString* _s2 = @"html"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
														content = [CapexHTMLString sanitize:content];
													}
													else {
														if(({ NSString* _s1 = type; NSString* _s2 = @"template"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
															CapexTextTemplate* t = [CapexTextTemplate forString:content markerBegin:self->markerBegin markerEnd:self->markerEnd type:self->type includeDirs:includeDirs logContext:nil];
															if(t == nil) {
																[CapeLog error:self->logContext message:[[@"Failed to parse imported template file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
																continue;
															}
															if([self doExecute:[t getTokens] avars:vars result:result includeDirs:includeDirs] == FALSE) {
																[CapeLog error:self->logContext message:[[@"Failed to process imported template file: `" stringByAppendingString:([ff getPath])] stringByAppendingString:@"'"]];
																continue;
															}
															content = nil;
														}
														else {
															if(({ NSString* _s1 = type; NSString* _s2 = @"raw"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																;
															}
															else {
																[CapeLog error:self->logContext message:[[@"Unknown type for import: `" stringByAppendingString:type] stringByAppendingString:@"'. Ignoring the import."]];
																continue;
															}
														}
													}
													if([CapeString isEmpty:content] == FALSE) {
														[result appendString:content];
													}
												}
												else {
													if(({ NSString* _s1 = tagname; NSString* _s2 = @"escapeHtml"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
														NSString* content = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
														if([CapeString isEmpty:content] == FALSE) {
															content = [CapexHTMLString sanitize:content];
															if([CapeString isEmpty:content] == FALSE) {
																[result appendString:content];
															}
														}
													}
													else {
														if(({ NSString* _s1 = tagname; NSString* _s2 = @"set"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
															if([CapeVector getSize:words] != 3) {
																[CapeLog warning:self->logContext message:[@"Invalid number of parameters for set tag encountered: " stringByAppendingString:([CapeString forInteger:[CapeVector getSize:words]])]];
																continue;
															}
															NSString* varname = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
															if([CapeString isEmpty:varname]) {
																[CapeLog warning:self->logContext message:@"Empty variable name in set tag encountered."];
																continue;
															}
															NSString* newValue = [self substituteVariables:[CapeVector get:words index:2] vars:vars];
															[vars setStringAndObject:varname value:((id)newValue)];
														}
														else {
															if(({ NSString* _s1 = tagname; NSString* _s2 = @"assign"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																if([CapeVector getSize:words] != 3) {
																	[CapeLog warning:self->logContext message:[@"Invalid number of parameters for assign tag encountered: " stringByAppendingString:([CapeString forInteger:[CapeVector getSize:words]])]];
																	continue;
																}
																NSString* varname = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
																if([CapeString isEmpty:varname]) {
																	[CapeLog warning:self->logContext message:@"Empty variable name in assign tag encountered."];
																	continue;
																}
																NSString* vv = [CapeVector get:words index:2];
																if(({ NSString* _s1 = vv; NSString* _s2 = @"none"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																	[vars remove:varname];
																}
																else {
																	[vars setStringAndObject:varname value:[self getVariableValue:vars varname:vv]];
																}
															}
															else {
																if(({ NSString* _s1 = tagname; NSString* _s2 = @"for"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = tagname; NSString* _s2 = @"if"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																	if(blockctr == 0) {
																		blocktag = words;
																	}
																	blockctr++;
																}
																else {
																	if(({ NSString* _s1 = tagname; NSString* _s2 = @"end"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																		;
																	}
																	else {
																		if(self->type == CapexTextTemplateTYPE_HTML) {
																			[self onHTMLTag:vars result:result includeDirs:includeDirs tagname:tagname words:words];
																		}
																		else {
																			if(self->type == CapexTextTemplateTYPE_JSON) {
																				[self onJSONTag:vars result:result includeDirs:includeDirs tagname:tagname words:words];
																			}
																			else {
																				;
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return(TRUE);
}

- (NSString*) basename:(NSString*)path {
	if(({ NSString* _s1 = path; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSString* v = @"";
	id<CapeIterator> comps = [CapeVector iterate:[CapeString split:path delim:'/' max:0]];
	if(comps != nil) {
		NSString* comp = [comps next];
		while(!(({ NSString* _s1 = comp; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			if([CapeString getLength:comp] > 0) {
				v = comp;
			}
			comp = [comps next];
		}
	}
	return(v);
}

- (void) onHTMLTag:(CapeDynamicMap*)vars result:(CapeStringBuilder*)result includeDirs:(NSMutableArray*)includeDirs tagname:(NSString*)tagname words:(NSMutableArray*)words {
	if(({ NSString* _s1 = tagname; NSString* _s2 = @"link"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSString* path = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
		NSString* text = [self substituteVariables:[CapeVector get:words index:2] vars:vars];
		if([CapeString isEmpty:text]) {
			text = [self basename:path];
		}
		if([CapeString isEmpty:text]) {
			return;
		}
		[result appendString:[[[[@"<a href=\"" stringByAppendingString:path] stringByAppendingString:@"\"><span>"] stringByAppendingString:text] stringByAppendingString:@"</span></a>"]];
		return;
	}
}

- (void) encodeJSONString:(NSString*)s sb:(CapeStringBuilder*)sb {
	if(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	id<CapeCharacterIterator> it = [CapeString iterate:s];
	if(it == nil) {
		return;
	}
	int c = ' ';
	while((c = [it getNextChar]) > 0) {
		if(c == '\"') {
			[sb appendCharacter:'\\'];
		}
		else {
			if(c == '\\') {
				[sb appendCharacter:'\\'];
			}
		}
		[sb appendCharacter:c];
	}
}

- (void) onJSONTag:(CapeDynamicMap*)vars result:(CapeStringBuilder*)result includeDirs:(NSMutableArray*)includeDirs tagname:(NSString*)tagname words:(NSMutableArray*)words {
	if(({ NSString* _s1 = tagname; NSString* _s2 = @"quotedstring"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		NSString* _x_string = [self substituteVariables:[CapeVector get:words index:1] vars:vars];
		[self encodeJSONString:_x_string sb:result];
	}
}

- (NSMutableArray*) getTokens {
	return(self->tokens);
}

- (CapexTextTemplate*) setTokens:(NSMutableArray*)v {
	self->tokens = v;
	return(self);
}

- (NSString*) getText {
	return(self->text);
}

- (CapexTextTemplate*) setText:(NSString*)v {
	self->text = v;
	return(self);
}

- (NSString*) getMarkerBegin {
	return(self->markerBegin);
}

- (CapexTextTemplate*) setMarkerBegin:(NSString*)v {
	self->markerBegin = v;
	return(self);
}

- (NSString*) getMarkerEnd {
	return(self->markerEnd);
}

- (CapexTextTemplate*) setMarkerEnd:(NSString*)v {
	self->markerEnd = v;
	return(self);
}

- (id<CapeLoggingContext>) getLogContext {
	return(self->logContext);
}

- (CapexTextTemplate*) setLogContext:(id<CapeLoggingContext>)v {
	self->logContext = v;
	return(self);
}

- (int) getType {
	return(self->type);
}

- (CapexTextTemplate*) setType:(int)v {
	self->type = v;
	return(self);
}

- (NSMutableArray*) getLanguagePreferences {
	return(self->languagePreferences);
}

- (CapexTextTemplate*) setLanguagePreferences:(NSMutableArray*)v {
	self->languagePreferences = v;
	return(self);
}

@end
