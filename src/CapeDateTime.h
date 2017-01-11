
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

@class CapeTimeValue;

@interface CapeDateTime : NSObject <CapeStringObject>
- (CapeDateTime*) init;
+ (CapeDateTime*) forNow;
+ (CapeDateTime*) forTimeSeconds:(long long)seconds;
+ (CapeDateTime*) forTimeValue:(CapeTimeValue*)tv;
- (void) onTimeSecondsChanged:(long long)seconds;
- (long long) getTimeSeconds;
- (void) setTimeSeconds:(long long)seconds;
- (NSString*) toStringDate:(int)delim;
- (NSString*) toStringTime:(int)delim;
- (NSString*) toStringDateTime;
- (NSString*) toString;
- (int) getWeekDay;
- (CapeDateTime*) setWeekDay:(int)v;
- (int) getDayOfMonth;
- (CapeDateTime*) setDayOfMonth:(int)v;
- (int) getMonth;
- (CapeDateTime*) setMonth:(int)v;
- (int) getYear;
- (CapeDateTime*) setYear:(int)v;
- (int) getHours;
- (CapeDateTime*) setHours:(int)v;
- (int) getMinutes;
- (CapeDateTime*) setMinutes:(int)v;
- (int) getSeconds;
- (CapeDateTime*) setSeconds:(int)v;
- (BOOL) getUtc;
- (CapeDateTime*) setUtc:(BOOL)v;
@end
