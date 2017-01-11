
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
#import "CapeWriter.h"
#import "CapePrintWriter.h"
#import "CapeClosable.h"
#import "CapeFlushableWriter.h"

@interface CapePrintWriterWrapper : NSObject <CapeWriter, CapePrintWriter, CapeClosable, CapeFlushableWriter>
- (CapePrintWriterWrapper*) init;
+ (id<CapePrintWriter>) forWriter:(id<CapeWriter>)writer;
- (BOOL) print:(NSString*)str;
- (BOOL) println:(NSString*)str;
- (int) write:(NSMutableData*)buf size:(int)size;
- (void) close;
- (void) flush;
- (id<CapeWriter>) getWriter;
- (CapePrintWriterWrapper*) setWriter:(id<CapeWriter>)v;
@end
