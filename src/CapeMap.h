
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

@protocol CapeMapObject;
@class CapeMapMyMapObject;
@protocol CapeIterator;

@interface CapeMap : NSObject
- (CapeMap*) init;
+ (id<CapeMapObject>) asObject:(NSMutableDictionary*)map;
+ (id) getMapAndDynamicAndDynamic:(NSMutableDictionary*)map key:(id)key ddf:(id)ddf;
+ (id) getMapAndDynamic:(NSMutableDictionary*)map key:(id)key;
+ (id) getValue:(NSMutableDictionary*)map key:(id)key;
+ (BOOL) set:(NSMutableDictionary*)data key:(id)key val:(id)val;
+ (BOOL) setValue:(NSMutableDictionary*)data key:(id)key val:(id)val;
+ (void) remove:(NSMutableDictionary*)data key:(id)key;
+ (int) count:(NSMutableDictionary*)data;
+ (BOOL) containsKey:(NSMutableDictionary*)data key:(id)key;
+ (BOOL) containsValue:(NSMutableDictionary*)data val:(id)val;
+ (void) clear:(NSMutableDictionary*)data;
+ (NSMutableDictionary*) dup:(NSMutableDictionary*)data;
+ (NSMutableArray*) getKeys:(NSMutableDictionary*)data;
+ (NSMutableArray*) getValues:(NSMutableDictionary*)data;
+ (id<CapeIterator>) iterateKeys:(NSMutableDictionary*)data;
+ (id<CapeIterator>) iterateValues:(NSMutableDictionary*)data;
@end
