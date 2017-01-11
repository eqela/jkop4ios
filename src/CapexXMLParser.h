
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

@class CapeDynamicMap;
@class CapexXMLParserStartElement;
@class CapexXMLParserEndElement;
@class CapexXMLParserCharacterData;
@class CapexXMLParserComment;
@protocol CapeCharacterIterator;
@class CapeStringBuilder;
@protocol CapeFile;
@class CapexXMLParser;

@interface CapexXMLParserStartElement : NSObject
- (CapexXMLParserStartElement*) init;
- (NSString*) getParam:(NSString*)pname;
- (NSString*) getName;
- (CapexXMLParserStartElement*) setName:(NSString*)v;
- (CapeDynamicMap*) getParams;
- (CapexXMLParserStartElement*) setParams:(CapeDynamicMap*)v;
@end

@interface CapexXMLParserEndElement : NSObject
- (CapexXMLParserEndElement*) init;
- (NSString*) getName;
- (CapexXMLParserEndElement*) setName:(NSString*)v;
@end

@interface CapexXMLParserCharacterData : NSObject
- (CapexXMLParserCharacterData*) init;
- (NSString*) getData;
- (CapexXMLParserCharacterData*) setData:(NSString*)v;
@end

@interface CapexXMLParserComment : NSObject
- (CapexXMLParserComment*) init;
- (NSString*) getText;
- (CapexXMLParserComment*) setText:(NSString*)v;
@end

@interface CapexXMLParser : NSObject
- (CapexXMLParser*) init;
+ (CapeDynamicMap*) parseAsTreeObject:(NSString*)xml ignoreWhiteSpace:(BOOL)ignoreWhiteSpace;
+ (CapexXMLParser*) forFile:(id<CapeFile>)file;
+ (CapexXMLParser*) forString:(NSString*)_x_string;
+ (CapexXMLParser*) forIterator:(id<CapeCharacterIterator>)it;
- (id) next;
- (BOOL) getIgnoreWhiteSpace;
- (CapexXMLParser*) setIgnoreWhiteSpace:(BOOL)v;
@end
