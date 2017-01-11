
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

@class CapeStringBuilder;
@class CapeDynamicMap;

@interface CapexRichTextSegment : NSObject
- (CapexRichTextSegment*) init;
- (void) addMarkupModifiers:(CapeStringBuilder*)sb;
- (NSString*) toMarkup;
- (CapeDynamicMap*) toJson;
- (NSString*) getText;
- (CapexRichTextSegment*) setText:(NSString*)v;
- (BOOL) getBold;
- (CapexRichTextSegment*) setBold:(BOOL)v;
- (BOOL) getItalic;
- (CapexRichTextSegment*) setItalic:(BOOL)v;
- (BOOL) getUnderline;
- (CapexRichTextSegment*) setUnderline:(BOOL)v;
- (NSString*) getColor;
- (CapexRichTextSegment*) setColor:(NSString*)v;
- (NSString*) getLink;
- (CapexRichTextSegment*) setLink:(NSString*)v;
- (NSString*) getReference;
- (CapexRichTextSegment*) setReference:(NSString*)v;
- (BOOL) getIsInline;
- (CapexRichTextSegment*) setIsInline:(BOOL)v;
- (BOOL) getLinkPopup;
- (CapexRichTextSegment*) setLinkPopup:(BOOL)v;
@end
