
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
#import "CapeStringObject.h"

@class CapeKeyValueList;

@interface SympathyURL : NSObject <CapeStringObject>
- (SympathyURL*) init;
+ (SympathyURL*) forString:(NSString*)str normalizePath:(BOOL)normalizePath;
- (SympathyURL*) dup;
- (NSString*) toString;
- (NSString*) toStringNohost;
- (void) parse:(NSString*)astr doNormalizePath:(BOOL)doNormalizePath;
- (int) getPortInt;
- (NSString*) getQueryParameter:(NSString*)key;
- (NSString*) getScheme;
- (SympathyURL*) setScheme:(NSString*)v;
- (NSString*) getUsername;
- (SympathyURL*) setUsername:(NSString*)v;
- (NSString*) getPassword;
- (SympathyURL*) setPassword:(NSString*)v;
- (NSString*) getHost;
- (SympathyURL*) setHost:(NSString*)v;
- (NSString*) getPort;
- (SympathyURL*) setPort:(NSString*)v;
- (NSString*) getPath;
- (SympathyURL*) setPath:(NSString*)v;
- (NSString*) getFragment;
- (SympathyURL*) setFragment:(NSString*)v;
- (CapeKeyValueList*) getRawQueryParameters;
- (SympathyURL*) setRawQueryParameters:(CapeKeyValueList*)v;
- (NSMutableDictionary*) getQueryParameters;
- (SympathyURL*) setQueryParameters:(NSMutableDictionary*)v;
- (NSString*) getOriginal;
- (SympathyURL*) setOriginal:(NSString*)v;
- (BOOL) getPercentOnly;
- (SympathyURL*) setPercentOnly:(BOOL)v;
- (BOOL) getEncodeUnreservedChars;
- (SympathyURL*) setEncodeUnreservedChars:(BOOL)v;
@end
