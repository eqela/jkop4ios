
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

@class CapexPaperConfigurationSize;
@class CapexPaperSize;
@class CapexPaperOrientation;
@class CapexPaperConfiguration;

@interface CapexPaperConfigurationSize : NSObject
{
	@public double width;
	@public double height;
}
- (CapexPaperConfigurationSize*) init;
- (CapexPaperConfigurationSize*) initWithDoubleAndDouble:(double)w h:(double)h;
- (double) getHeight;
- (double) getWidth;
@end

@interface CapexPaperConfiguration : NSObject
- (CapexPaperConfiguration*) init;
+ (CapexPaperConfiguration*) forDefault;
+ (CapexPaperConfiguration*) forA4Portrait;
+ (CapexPaperConfiguration*) forA4Landscape;
- (CapexPaperConfigurationSize*) getSizeInches;
- (CapexPaperConfigurationSize*) getRawSizeInches;
- (CapexPaperConfigurationSize*) getSizeDots:(int)dpi;
- (CapexPaperSize*) getSize;
- (CapexPaperConfiguration*) setSize:(CapexPaperSize*)v;
- (CapexPaperOrientation*) getOrientation;
- (CapexPaperConfiguration*) setOrientation:(CapexPaperOrientation*)v;
@end
