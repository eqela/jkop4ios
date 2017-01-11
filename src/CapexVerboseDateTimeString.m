
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
#import "CapeDateTime.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CapexVerboseDateTimeString.h"

@implementation CapexVerboseDateTimeString

- (CapexVerboseDateTimeString*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) forNow {
	return([CapexVerboseDateTimeString forDateTime:[CapeDateTime forNow]]);
}

+ (NSString*) forDateTime:(CapeDateTime*)dd {
	if(dd == nil) {
		return(@"NODATE");
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[CapexVerboseDateTimeString getShortDayName:[dd getWeekDay]]];
	[sb appendString:@", "];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getDayOfMonth] length:2 paddingString:@"0"]];
	[sb appendCharacter:' '];
	[sb appendString:[CapexVerboseDateTimeString getShortMonthName:[dd getMonth]]];
	[sb appendCharacter:' '];
	[sb appendString:[CapeString forInteger:[dd getYear]]];
	[sb appendCharacter:' '];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getHours] length:2 paddingString:@"0"]];
	[sb appendCharacter:':'];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getMinutes] length:2 paddingString:@"0"]];
	[sb appendCharacter:':'];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getSeconds] length:2 paddingString:@"0"]];
	[sb appendString:@" GMT"];
	return([sb toString]);
}

+ (NSString*) getTimeStringForDateTime:(CapeDateTime*)dd includeTimeZone:(BOOL)includeTimeZone {
	if(dd == nil) {
		return(@"NOTIME");
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getHours] length:2 paddingString:@"0"]];
	[sb appendCharacter:':'];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getMinutes] length:2 paddingString:@"0"]];
	[sb appendCharacter:':'];
	[sb appendString:[CapeString forIntegerWithPadding:[dd getSeconds] length:2 paddingString:@"0"]];
	if(includeTimeZone) {
		[sb appendString:@" GMT"];
	}
	return([sb toString]);
}

+ (NSString*) getDateStringForDateTime:(CapeDateTime*)dd {
	if(dd == nil) {
		return(@"NODATE");
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[CapexVerboseDateTimeString getLongMonthName:[dd getMonth]]];
	[sb appendCharacter:' '];
	[sb appendString:[CapeString forInteger:[dd getDayOfMonth]]];
	[sb appendString:@", "];
	[sb appendString:[CapeString forInteger:[dd getYear]]];
	return([sb toString]);
}

+ (NSString*) getShortDayName:(int)n {
	switch(n) {
		case 1: {
			return(@"Sun");
		}
		case 2: {
			return(@"Mon");
		}
		case 3: {
			return(@"Tue");
		}
		case 4: {
			return(@"Wed");
		}
		case 5: {
			return(@"Thu");
		}
		case 6: {
			return(@"Fri");
		}
		case 7: {
			return(@"Sat");
		}
	}
	return(nil);
}

+ (NSString*) getShortMonthName:(int)n {
	switch(n) {
		case 1: {
			return(@"Jan");
		}
		case 2: {
			return(@"Feb");
		}
		case 3: {
			return(@"Mar");
		}
		case 4: {
			return(@"Apr");
		}
		case 5: {
			return(@"May");
		}
		case 6: {
			return(@"Jun");
		}
		case 7: {
			return(@"Jul");
		}
		case 8: {
			return(@"Aug");
		}
		case 9: {
			return(@"Sep");
		}
		case 10: {
			return(@"Oct");
		}
		case 11: {
			return(@"Nov");
		}
		case 12: {
			return(@"Dec");
		}
	}
	return(nil);
}

+ (NSString*) getLongMonthName:(int)n {
	switch(n) {
		case 1: {
			return(@"January");
		}
		case 2: {
			return(@"February");
		}
		case 3: {
			return(@"March");
		}
		case 4: {
			return(@"April");
		}
		case 5: {
			return(@"May");
		}
		case 6: {
			return(@"June");
		}
		case 7: {
			return(@"July");
		}
		case 8: {
			return(@"August");
		}
		case 9: {
			return(@"September");
		}
		case 10: {
			return(@"October");
		}
		case 11: {
			return(@"November");
		}
		case 12: {
			return(@"December");
		}
	}
	return(nil);
}

@end
