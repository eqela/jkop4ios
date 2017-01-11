
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

@class CapexTextTemplateTagData;
@protocol CapeFile;
@protocol CapeLoggingContext;
@class CapeDynamicMap;
@class CapeStringBuilder;

extern int CapexTextTemplateTYPE_GENERIC;
extern int CapexTextTemplateTYPE_HTML;
extern int CapexTextTemplateTYPE_JSON;

@interface CapexTextTemplate : NSObject
- (CapexTextTemplate*) init;
+ (CapexTextTemplate*) forFile:(id<CapeFile>)file markerBegin:(NSString*)markerBegin markerEnd:(NSString*)markerEnd type:(int)type includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext;
+ (CapexTextTemplate*) forString:(NSString*)text markerBegin:(NSString*)markerBegin markerEnd:(NSString*)markerEnd type:(int)type includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext;
+ (CapexTextTemplate*) forHTMLString:(NSString*)text includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext;
+ (CapexTextTemplate*) forJSONString:(NSString*)text includeDirs:(NSMutableArray*)includeDirs logContext:(id<CapeLoggingContext>)logContext;
- (void) setLanguagePreference:(NSString*)language;
- (BOOL) prepare:(NSMutableArray*)includeDirs;
- (NSString*) execute:(CapeDynamicMap*)vars includeDirs:(NSMutableArray*)includeDirs;
- (id) getVariableValue:(CapeDynamicMap*)vars varname:(NSString*)varname;
- (NSString*) getVariableValueString:(CapeDynamicMap*)vars varname:(NSString*)varname;
- (NSMutableArray*) getVariableValueVector:(CapeDynamicMap*)vars varname:(NSString*)varname;
- (BOOL) handleBlock:(CapeDynamicMap*)vars tag:(NSMutableArray*)tag data:(NSMutableArray*)data result:(CapeStringBuilder*)result includeDirs:(NSMutableArray*)includeDirs;
- (void) encodeJSONString:(NSString*)s sb:(CapeStringBuilder*)sb;
- (NSMutableArray*) getTokens;
- (CapexTextTemplate*) setTokens:(NSMutableArray*)v;
- (NSString*) getText;
- (CapexTextTemplate*) setText:(NSString*)v;
- (NSString*) getMarkerBegin;
- (CapexTextTemplate*) setMarkerBegin:(NSString*)v;
- (NSString*) getMarkerEnd;
- (CapexTextTemplate*) setMarkerEnd:(NSString*)v;
- (id<CapeLoggingContext>) getLogContext;
- (CapexTextTemplate*) setLogContext:(id<CapeLoggingContext>)v;
- (int) getType;
- (CapexTextTemplate*) setType:(int)v;
- (NSMutableArray*) getLanguagePreferences;
- (CapexTextTemplate*) setLanguagePreferences:(NSMutableArray*)v;
@end
