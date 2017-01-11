
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

@class CapexXMLMakerCData;
@class CapexXMLMakerStartElement;
@class CapexXMLMakerEndElement;
@class CapexXMLMakerElement;
@class CapexXMLMakerCustomXML;
@class CapeStringBuilder;
@class CapexXMLMaker;

@interface CapexXMLMakerCData : NSObject <CapeStringObject>
- (CapexXMLMakerCData*) init;
- (CapexXMLMakerCData*) initWithString:(NSString*)t;
- (NSString*) toString;
- (NSString*) getText;
- (CapexXMLMakerCData*) setText:(NSString*)v;
- (BOOL) getSimple;
- (CapexXMLMakerCData*) setSimple:(BOOL)v;
- (BOOL) getSingleLine;
- (CapexXMLMakerCData*) setSingleLine:(BOOL)v;
@end

@interface CapexXMLMakerStartElement : NSObject <CapeStringObject>
- (CapexXMLMakerStartElement*) init;
- (CapexXMLMakerStartElement*) initWithString:(NSString*)n;
- (CapexXMLMakerStartElement*) attribute:(NSString*)key value:(NSString*)value;
- (NSString*) toString;
- (NSString*) getName;
- (CapexXMLMakerStartElement*) setName:(NSString*)v;
- (NSMutableDictionary*) getAttributes;
- (CapexXMLMakerStartElement*) setAttributes:(NSMutableDictionary*)v;
- (BOOL) getSingle;
- (CapexXMLMakerStartElement*) setSingle:(BOOL)v;
- (BOOL) getSingleLine;
- (CapexXMLMakerStartElement*) setSingleLine:(BOOL)v;
@end

@interface CapexXMLMakerEndElement : NSObject <CapeStringObject>
- (CapexXMLMakerEndElement*) init;
- (CapexXMLMakerEndElement*) initWithString:(NSString*)n;
- (NSString*) toString;
- (NSString*) getName;
- (CapexXMLMakerEndElement*) setName:(NSString*)v;
@end

@interface CapexXMLMakerElement : CapexXMLMakerStartElement
- (CapexXMLMakerElement*) init;
- (CapexXMLMakerElement*) initWithString:(NSString*)name;
@end

@interface CapexXMLMakerCustomXML : NSObject
- (CapexXMLMakerCustomXML*) init;
- (CapexXMLMakerCustomXML*) initWithString:(NSString*)s;
- (NSString*) getString;
- (CapexXMLMakerCustomXML*) setString:(NSString*)v;
@end

@interface CapexXMLMaker : NSObject <CapeStringObject>
- (CapexXMLMaker*) init;
- (CapexXMLMaker*) startStringAndBoolean:(NSString*)element singleLine:(BOOL)singleLine;
- (CapexXMLMaker*) startStringAndStringAndStringAndBoolean:(NSString*)element k1:(NSString*)k1 v1:(NSString*)v1 singleLine:(BOOL)singleLine;
- (CapexXMLMaker*) startStringAndMapAndBoolean:(NSString*)element attrs:(NSMutableDictionary*)attrs singleLine:(BOOL)singleLine;
- (CapexXMLMaker*) element:(NSString*)element attrs:(NSMutableDictionary*)attrs;
- (CapexXMLMaker*) end:(NSString*)element;
- (CapexXMLMaker*) text:(NSString*)element;
- (CapexXMLMaker*) cdata:(NSString*)element;
- (CapexXMLMaker*) textElement:(NSString*)element text:(NSString*)text;
- (CapexXMLMaker*) add:(id)o;
- (NSString*) toString;
- (NSMutableArray*) getElements;
- (CapexXMLMaker*) setElements:(NSMutableArray*)v;
- (NSString*) getCustomHeader;
- (CapexXMLMaker*) setCustomHeader:(NSString*)v;
- (BOOL) getSingleLine;
- (CapexXMLMaker*) setSingleLine:(BOOL)v;
- (NSString*) getHeader;
- (CapexXMLMaker*) setHeader:(NSString*)v;
@end
