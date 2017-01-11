
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
#import "CapeSystemClock.h"
#import "CapeTimeValue.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapeDateTime.h"

@implementation CapeDateTime

{
	long long timeSeconds;
	int weekDay;
	int dayOfMonth;
	int month;
	int year;
	int hours;
	int minutes;
	int seconds;
	BOOL utc;
}

- (CapeDateTime*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->utc = FALSE;
	self->seconds = 0;
	self->minutes = 0;
	self->hours = 0;
	self->year = 0;
	self->month = 0;
	self->dayOfMonth = 0;
	self->weekDay = 0;
	self->timeSeconds = ((long long)0);
	return(self);
}

+ (CapeDateTime*) forNow {
	return([CapeDateTime forTimeSeconds:[CapeSystemClock asSeconds]]);
}

+ (CapeDateTime*) forTimeSeconds:(long long)seconds {
	CapeDateTime* v = [[CapeDateTime alloc] init];
	if(v == nil) {
		return(nil);
	}
	[v setTimeSeconds:seconds];
	return(v);
}

+ (CapeDateTime*) forTimeValue:(CapeTimeValue*)tv {
	if(tv == nil) {
		return(nil);
	}
	return([CapeDateTime forTimeSeconds:[tv getSeconds]]);
}

- (void) onTimeSecondsChanged:(long long)seconds {
	struct tm lt;
	long long tp = self->timeSeconds;
	if(self->utc == FALSE) {
		localtime_r((const time_t*)&tp, &lt);
	}
	else {
		gmtime_r((const time_t*)&tp, &lt);
	}
	int dwday = 0;
	int dday = 0;
	int dmonth = 0;
	int dyear = 0;
	int dhours = 0;
	int dmins = 0;
	int dseconds = 0;
	dwday = lt.tm_wday + 1;
	dday = lt.tm_mday;
	dmonth = lt.tm_mon + 1;
	dyear = 1900 + lt.tm_year;
	dhours = lt.tm_hour;
	dmins = lt.tm_min;
	dseconds = lt.tm_sec;
	self->year = dyear;
	self->month = dmonth;
	self->dayOfMonth = dday;
	self->weekDay = dwday;
	self->hours = dhours;
	self->minutes = dmins;
	self->seconds = dseconds;
}

- (long long) getTimeSeconds {
	return(self->timeSeconds);
}

- (void) setTimeSeconds:(long long)seconds {
	self->timeSeconds = seconds;
	[self onTimeSecondsChanged:seconds];
}

- (NSString*) toStringDate:(int)delim {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[CapeString forIntegerWithPadding:[self getYear] length:4 paddingString:nil]];
	if(delim > 0) {
		[sb appendCharacter:delim];
	}
	[sb appendString:[CapeString forIntegerWithPadding:[self getMonth] length:2 paddingString:nil]];
	if(delim > 0) {
		[sb appendCharacter:delim];
	}
	[sb appendString:[CapeString forIntegerWithPadding:[self getDayOfMonth] length:2 paddingString:nil]];
	return([sb toString]);
}

- (NSString*) toStringTime:(int)delim {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[CapeString forIntegerWithPadding:[self getHours] length:2 paddingString:nil]];
	if(delim > 0) {
		[sb appendCharacter:delim];
	}
	[sb appendString:[CapeString forIntegerWithPadding:[self getMinutes] length:2 paddingString:nil]];
	if(delim > 0) {
		[sb appendCharacter:delim];
	}
	[sb appendString:[CapeString forIntegerWithPadding:[self getSeconds] length:2 paddingString:nil]];
	return([sb toString]);
}

- (NSString*) toStringDateTime {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[self toStringDate:'-']];
	[sb appendString:@" "];
	[sb appendString:[self toStringTime:'-']];
	return([sb toString]);
}

- (NSString*) toString {
	return([self toStringDateTime]);
}

- (int) getWeekDay {
	return(self->weekDay);
}

- (CapeDateTime*) setWeekDay:(int)v {
	self->weekDay = v;
	return(self);
}

- (int) getDayOfMonth {
	return(self->dayOfMonth);
}

- (CapeDateTime*) setDayOfMonth:(int)v {
	self->dayOfMonth = v;
	return(self);
}

- (int) getMonth {
	return(self->month);
}

- (CapeDateTime*) setMonth:(int)v {
	self->month = v;
	return(self);
}

- (int) getYear {
	return(self->year);
}

- (CapeDateTime*) setYear:(int)v {
	self->year = v;
	return(self);
}

- (int) getHours {
	return(self->hours);
}

- (CapeDateTime*) setHours:(int)v {
	self->hours = v;
	return(self);
}

- (int) getMinutes {
	return(self->minutes);
}

- (CapeDateTime*) setMinutes:(int)v {
	self->minutes = v;
	return(self);
}

- (int) getSeconds {
	return(self->seconds);
}

- (CapeDateTime*) setSeconds:(int)v {
	self->seconds = v;
	return(self);
}

- (BOOL) getUtc {
	return(self->utc);
}

- (CapeDateTime*) setUtc:(BOOL)v {
	self->utc = v;
	return(self);
}

@end
