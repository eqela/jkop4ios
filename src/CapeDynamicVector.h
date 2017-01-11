
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
#import "CapeVectorObject.h"
#import "CapeObjectWithSize.h"

@class CapeDynamicMap;
@protocol CapeIterator;

@interface CapeDynamicVector : NSObject <CapeDuplicateable, CapeIterateable, CapeVectorObject, CapeObjectWithSize>
+ (CapeDynamicVector*) asDynamicVector:(id)object;
+ (CapeDynamicVector*) forStringVector:(NSMutableArray*)vector;
+ (CapeDynamicVector*) forObjectVector:(NSMutableArray*)vector;
- (CapeDynamicVector*) init;
- (NSMutableArray*) toVector;
- (NSMutableArray*) toVectorOfStrings;
- (NSMutableArray*) toVectorOfDynamicMaps;
- (id) duplicate;
- (CapeDynamicVector*) appendObject:(id)object;
- (CapeDynamicVector*) appendSignedInteger:(int)value;
- (CapeDynamicVector*) appendBoolean:(BOOL)value;
- (CapeDynamicVector*) appendDouble:(double)value;
- (CapeDynamicVector*) setSignedIntegerAndObject:(int)index object:(id)object;
- (CapeDynamicVector*) setSignedIntegerAndSignedInteger:(int)index value:(int)value;
- (CapeDynamicVector*) setSignedIntegerAndBoolean:(int)index value:(BOOL)value;
- (CapeDynamicVector*) setSignedIntegerAndDouble:(int)index value:(double)value;
- (id) get:(int)index;
- (NSString*) getString:(int)index defval:(NSString*)defval;
- (int) getInteger:(int)index defval:(int)defval;
- (BOOL) getBoolean:(int)index defval:(BOOL)defval;
- (double) getDouble:(int)index defval:(double)defval;
- (CapeDynamicMap*) getMap:(int)index;
- (CapeDynamicVector*) getVector:(int)index;
- (id<CapeIterator>) iterate;
- (void) remove:(int)index;
- (void) clear;
- (int) getSize;
- (void) sort;
- (void) sortFunction:(int(^)(id,id))comparer;
- (void) sortReverse;
- (void) sortReverseWithFunction:(int(^)(id,id))comparer;
@end
