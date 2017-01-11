
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

@class CapeKeyValueList;
@class SympathyURL;
@class SympathyHTTPServerConnection;
@class SympathyHTTPServerBase;
@class SympathyHTTPServerCookie;
@protocol SympathyDataStream;
@protocol CapeIterator;
@class CapeKeyValuePair;
@class CapeDynamicVector;
@class CapeDynamicMap;
@class CapeError;
@protocol CapeFile;
@class SympathyHTTPServerResponse;

@interface SympathyHTTPServerRequest : NSObject
- (SympathyHTTPServerRequest*) init;
+ (SympathyHTTPServerRequest*) forDetails:(NSString*)method url:(NSString*)url version:(NSString*)version headers:(CapeKeyValueList*)headers;
- (void) setBodyReceiver:(id<SympathyDataStream>)receiver;
- (NSString*) getCacheId;
- (void) clearHeaders;
- (void) addHeader:(NSString*)key value:(NSString*)value;
- (void) setHeaders:(CapeKeyValueList*)headers;
- (NSString*) getHeader:(NSString*)name;
- (id<CapeIterator>) iterateHeaders;
- (SympathyURL*) getURL;
- (NSMutableDictionary*) getQueryParameters;
- (id<CapeIterator>) iterateQueryParameters;
- (NSString*) getQueryParameter:(NSString*)key;
- (NSString*) getURLPath;
- (NSString*) getRemoteIPAddress;
- (NSString*) getRemoteAddress;
- (BOOL) getConnectionClose;
- (NSString*) getETag;
- (NSMutableDictionary*) getCookieValues;
- (NSString*) getCookieValue:(NSString*)name;
- (NSString*) getBodyString;
- (id) getBodyJSONObject;
- (CapeDynamicVector*) getBodyJSONVector;
- (CapeDynamicMap*) getBodyJSONMap;
- (NSString*) getBodyJSONMapValue:(NSString*)key;
- (NSMutableDictionary*) getPostParameters;
- (NSString*) getPostParameter:(NSString*)key;
- (NSString*) getRelativeRequestPath:(NSString*)relativeTo;
- (void) initResources;
- (BOOL) hasMoreResources;
- (int) getRemainingResourceCount;
- (BOOL) acceptMethodAndResource:(NSString*)methodToAccept resource:(NSString*)resource mustBeLastResource:(BOOL)mustBeLastResource;
- (BOOL) acceptResource:(NSString*)resource mustBeLastResource:(BOOL)mustBeLastResource;
- (NSString*) peekResource;
- (int) getCurrentResource;
- (void) setCurrentResource:(int)value;
- (NSString*) popResource;
- (void) unpopResource;
- (void) resetResources;
- (NSMutableArray*) getRelativeResources;
- (NSString*) getRelativeResourcePath;
- (BOOL) isForResource:(NSString*)res;
- (BOOL) isForDirectory;
- (BOOL) isForPrefix:(NSString*)res;
- (BOOL) isGET;
- (BOOL) isPOST;
- (BOOL) isDELETE;
- (BOOL) isPUT;
- (BOOL) isPATCH;
- (void) sendJSONObject:(id)o;
- (void) sendJSONString:(NSString*)json;
- (void) sendJSONError:(CapeError*)error;
- (void) sendJSONOK:(id)data;
- (void) sendInternalError:(NSString*)text;
- (void) sendNotAllowed;
- (void) sendNotFound;
- (void) sendInvalidRequest:(NSString*)text;
- (void) sendTextString:(NSString*)text;
- (void) sendHTMLString:(NSString*)html;
- (void) sendXMLString:(NSString*)xml;
- (void) sendFile:(id<CapeFile>)file;
- (void) sendBuffer:(NSMutableData*)buffer mimeType:(NSString*)mimeType;
- (void) sendRedirect:(NSString*)url;
- (void) sendRedirectAsDirectory;
- (BOOL) isResponseSent;
- (void) addResponseCookie:(SympathyHTTPServerCookie*)cookie;
- (void) sendResponse:(SympathyHTTPServerResponse*)resp;
- (NSString*) getMethod;
- (SympathyHTTPServerRequest*) setMethod:(NSString*)v;
- (NSString*) getUrlString;
- (SympathyHTTPServerRequest*) setUrlString:(NSString*)v;
- (NSString*) getVersion;
- (SympathyHTTPServerRequest*) setVersion:(NSString*)v;
- (SympathyHTTPServerConnection*) getConnection;
- (SympathyHTTPServerRequest*) setConnection:(SympathyHTTPServerConnection*)v;
- (SympathyHTTPServerBase*) getServer;
- (SympathyHTTPServerRequest*) setServer:(SympathyHTTPServerBase*)v;
- (id) getData;
- (SympathyHTTPServerRequest*) setData:(id)v;
- (id) getSession;
- (SympathyHTTPServerRequest*) setSession:(id)v;
- (NSMutableData*) getBodyBuffer;
- (SympathyHTTPServerRequest*) setBodyBuffer:(NSMutableData*)v;
@end
