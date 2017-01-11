
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

@protocol CapeArrayObject;
@protocol CapeObjectWithSize;
@class CapeArrayMyArrayObject;

/*
 * The Array class provides convenience methods for dealing with static array
 * objects. For dynamic array support, use vectors instead.
 */

@interface CapeArray : NSObject
- (CapeArray*) init;

/*
 * Returns the given array as an ArrayObject (which is an object type) that can be
 * used wherever an object is required.
 */

+ (id<CapeArrayObject>) asObject:(NSMutableArray*)array;
+ (BOOL) isEmpty:(NSMutableArray*)array;

/*
 * Creates a new vector object that will be composed of all the elements in the
 * given array. Essentially converts an array into a vector.
 */

+ (NSMutableArray*) toVector:(NSMutableArray*)array;
@end
