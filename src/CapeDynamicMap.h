
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
#import "CapeDuplicateable.h"
#import "CapeIterateable.h"

@class CapeDynamicVector;
@protocol CapeIterator;

@interface CapeDynamicMap : NSObject <CapeDuplicateable, CapeIterateable>
+ (CapeDynamicMap*) asDynamicMap:(id)object;
+ (CapeDynamicMap*) forObjectMap:(NSMutableDictionary*)map;
+ (CapeDynamicMap*) forStringMap:(NSMutableDictionary*)map;
- (CapeDynamicMap*) init;
- (id) duplicate;
- (CapeDynamicMap*) duplicateMap;
- (CapeDynamicMap*) mergeFrom:(CapeDynamicMap*)other;
- (CapeDynamicMap*) setStringAndObject:(NSString*)key value:(id)value;
- (CapeDynamicMap*) setStringAndBuffer:(NSString*)key value:(NSMutableData*)value;
- (CapeDynamicMap*) setStringAndSignedInteger:(NSString*)key value:(int)value;
- (CapeDynamicMap*) setStringAndBoolean:(NSString*)key value:(BOOL)value;
- (CapeDynamicMap*) setStringAndDouble:(NSString*)key value:(double)value;
- (id) get:(NSString*)key;
- (NSString*) getString:(NSString*)key defval:(NSString*)defval;
- (int) getInteger:(NSString*)key defval:(int)defval;
- (BOOL) getBoolean:(NSString*)key defval:(BOOL)defval;
- (double) getDouble:(NSString*)key defval:(double)defval;
- (NSMutableData*) getBuffer:(NSString*)key;
- (CapeDynamicVector*) getDynamicVector:(NSString*)key;
- (NSMutableArray*) getVector:(NSString*)key;
- (CapeDynamicMap*) getDynamicMap:(NSString*)key;
- (NSMutableArray*) getKeys;
- (id<CapeIterator>) iterate;
- (id<CapeIterator>) iterateKeys;
- (id<CapeIterator>) iterateValues;
- (void) remove:(NSString*)key;
- (void) clear;
- (int) getCount;
- (BOOL) containsKey:(NSString*)key;
@end
