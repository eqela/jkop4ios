
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

@protocol CapeIterator;
@class CapeVectorVectorIterator;

@interface CapeVector : NSObject
- (CapeVector*) init;
+ (NSMutableArray*) asVector:(id)obj;
+ (NSMutableArray*) forIterator:(id<CapeIterator>)iterator;
+ (NSMutableArray*) forArray:(NSMutableArray*)array;
+ (void) append:(NSMutableArray*)vector object:(id)object;
+ (int) getSize:(NSMutableArray*)vector;
+ (id) getAt:(NSMutableArray*)vector index:(int)index;
+ (id) get:(NSMutableArray*)vector index:(int)index;
+ (void) set:(NSMutableArray*)vector index:(int)index val:(id)val;
+ (id) remove:(NSMutableArray*)vector index:(int)index;
+ (id) popFirst:(NSMutableArray*)vector;
+ (void) removeFirst:(NSMutableArray*)vector;
+ (id) popLast:(NSMutableArray*)vector;
+ (void) removeLast:(NSMutableArray*)vector;
+ (int) removeValue:(NSMutableArray*)vector value:(id)value;
+ (void) clear:(NSMutableArray*)vector;
+ (BOOL) isEmpty:(NSMutableArray*)vector;
+ (void) removeRange:(NSMutableArray*)vector index:(int)index count:(int)count;
+ (id<CapeIterator>) iterate:(NSMutableArray*)vector;
+ (id<CapeIterator>) iterateReverse:(NSMutableArray*)vector;
+ (void) sort:(NSMutableArray*)vector comparer:(int(^)(id,id))comparer;
+ (void) sortReverse:(NSMutableArray*)vector comparer:(int(^)(id,id))comparer;
@end
