
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
@class CapeKeyValueList;
@protocol CapeReader;
@class SympathyHTTPServerRequest;
@class SympathyHTTPServerCookie;
@protocol CapeSizedReader;

@interface SympathyHTTPServerResponse : NSObject
- (SympathyHTTPServerResponse*) init;
+ (SympathyHTTPServerResponse*) forFile:(id<CapeFile>)file maxCachedSize:(int)maxCachedSize;
+ (SympathyHTTPServerResponse*) forBuffer:(NSMutableData*)data mimetype:(NSString*)mimetype;
+ (SympathyHTTPServerResponse*) forString:(NSString*)text mimetype:(NSString*)mimetype;
+ (SympathyHTTPServerResponse*) forTextString:(NSString*)text;
+ (SympathyHTTPServerResponse*) forHTMLString:(NSString*)html;
+ (SympathyHTTPServerResponse*) forXMLString:(NSString*)xml;
+ (SympathyHTTPServerResponse*) forJSONObject:(id)o;
+ (SympathyHTTPServerResponse*) forJSONString:(NSString*)json;
+ (SympathyHTTPServerResponse*) forHTTPInvalidRequest:(NSString*)message;
+ (SympathyHTTPServerResponse*) forHTTPInternalError:(NSString*)message;
+ (SympathyHTTPServerResponse*) forHTTPNotImplemented:(NSString*)message;
+ (SympathyHTTPServerResponse*) forHTTPNotAllowed:(NSString*)message;
+ (SympathyHTTPServerResponse*) forHTTPNotFound:(NSString*)message;
+ (SympathyHTTPServerResponse*) forHTTPForbidden:(NSString*)message;
+ (SympathyHTTPServerResponse*) forRedirect:(NSString*)url;
+ (SympathyHTTPServerResponse*) forHTTPMovedPermanently:(NSString*)url;
+ (SympathyHTTPServerResponse*) forHTTPMovedTemporarily:(NSString*)url;
- (SympathyHTTPServerResponse*) setETag:(NSString*)eTag;
- (NSString*) getETag;
- (SympathyHTTPServerResponse*) setStatus:(NSString*)status;
- (NSString*) getStatus;
- (int) getCacheTtl;
- (SympathyHTTPServerResponse*) enableCaching:(int)ttl;
- (SympathyHTTPServerResponse*) disableCaching;
- (SympathyHTTPServerResponse*) enableCORS:(SympathyHTTPServerRequest*)req;
- (SympathyHTTPServerResponse*) addHeader:(NSString*)key value:(NSString*)value;
- (void) addCookie:(SympathyHTTPServerCookie*)cookie;
- (SympathyHTTPServerResponse*) setBodyWithBuffer:(NSMutableData*)buf;
- (SympathyHTTPServerResponse*) setBodyWithString:(NSString*)str;
- (SympathyHTTPServerResponse*) setBodyWithFile:(id<CapeFile>)file;
- (SympathyHTTPServerResponse*) setBodyWithSizedReader:(id<CapeSizedReader>)reader;
- (id<CapeReader>) getBody;
- (CapeKeyValueList*) getHeaders;
- (SympathyHTTPServerResponse*) setHeaders:(CapeKeyValueList*)v;
- (NSString*) getMessage;
- (SympathyHTTPServerResponse*) setMessage:(NSString*)v;
@end
