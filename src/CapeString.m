
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
#import "CapeIntegerObject.h"
#import "CapeDoubleObject.h"
#import "CapeBooleanObject.h"
#import "CapeCharacterObject.h"
#import "CapeJSONEncoder.h"
#import "CapeStringBuilder.h"
#import "CapeBuffer.h"
#import "CapeVector.h"
#import "CapeCharacterIterator.h"
#import "CapeCharacterIteratorForString.h"
#import "CapeMap.h"
#import "CapeString.h"

@implementation CapeString

- (CapeString*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (NSString*) asStringWithObject:(id)obj {
	if(obj == nil) {
		return(nil);
	}
	if([obj isKindOfClass:[NSString class]]) {
		return(((NSString*)obj));
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeStringObject)]) {
		return([((id<CapeStringObject>)obj) toString]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeIntegerObject)]) {
		return([CapeString forInteger:[((id<CapeIntegerObject>)obj) toInteger]]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeDoubleObject)]) {
		return([CapeString forDouble:[((id<CapeDoubleObject>)obj) toDouble]]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeBooleanObject)]) {
		return([CapeString forBoolean:[((id<CapeBooleanObject>)obj) toBoolean]]);
	}
	if([((NSObject*)obj) conformsToProtocol:@protocol(CapeCharacterObject)]) {
		return([CapeString forCharacter:[((id<CapeCharacterObject>)obj) toCharacter]]);
	}
	NSString* js = [CapeJSONEncoder encode:obj niceFormatting:TRUE];
	if(!(({ NSString* _s1 = js; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(js);
	}
	return(nil);
}

+ (NSString*) asStringWithSignedInteger:(int)value {
	return([CapeString forInteger:value]);
}

+ (NSString*) asStringWithDouble:(double)value {
	return([CapeString forDouble:value]);
}

+ (NSString*) asStringWithBuffer:(NSMutableData*)value {
	return([CapeString forUTF8Buffer:value]);
}

+ (NSString*) asStringWithBoolean:(BOOL)value {
	return([CapeString forBoolean:value]);
}

+ (NSString*) asStringWithCharacter:(int)value {
	return([CapeString forCharacter:value]);
}

+ (NSString*) asStringWithFloat:(float)value {
	return([CapeString forFloat:value]);
}

+ (BOOL) isEmpty:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	if([CapeString getLength:str] < 1) {
		return(TRUE);
	}
	return(FALSE);
}

+ (NSString*) forBuffer:(NSMutableData*)data encoding:(NSString*)encoding {
	if(data == nil) {
		return(nil);
	}
	if([CapeString equalsIgnoreCase:@"UTF8" str2:encoding] || [CapeString equalsIgnoreCase:@"UTF-8" str2:encoding]) {
		return([CapeString forUTF8Buffer:data]);
	}
	if([CapeString equalsIgnoreCase:@"UCS2" str2:encoding] || [CapeString equalsIgnoreCase:@"UCS-2" str2:encoding]) {
		return([CapeString forUCS2Buffer:data]);
	}
	if([CapeString equalsIgnoreCase:@"ASCII" str2:encoding]) {
		return([CapeString forASCIIBuffer:data]);
	}
	return(nil);
}

+ (NSString*) forASCIIBuffer:(NSMutableData*)data {
	if(data == nil) {
		return(nil);
	}
	return([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
}

+ (NSString*) forUTF8Buffer:(NSMutableData*)data {
	if(data == nil) {
		return(nil);
	}
	return([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

+ (NSString*) forUCS2Buffer:(NSMutableData*)data {
	if(data == nil) {
		return(nil);
	}
	return([[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding]);
}

+ (NSString*) forCharArray:(NSMutableArray*)chars offset:(int)offset count:(int)count {
	if(chars == nil) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.forCharArray] (String.sling:344:2): Not implemented");
	return(nil);
}

+ (NSString*) forBoolean:(BOOL)vv {
	if(vv == TRUE) {
		return(@"true");
	}
	return(@"false");
}

+ (NSString*) forInteger:(int)vv {
	return([NSString stringWithFormat:@"%d", vv]);
}

+ (NSString*) forLong:(long long)vv {
	return([NSString stringWithFormat:@"%d", vv]);
}

+ (NSString*) forIntegerWithPadding:(int)vv length:(int)length paddingString:(NSString*)paddingString {
	NSString* r = [CapeString forInteger:vv];
	if(({ NSString* _s1 = r; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int ll = [CapeString getLength:r];
	if(ll >= length) {
		return(r);
	}
	NSString* ps = paddingString;
	if(({ NSString* _s1 = ps; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		ps = @"0";
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	int n = 0;
	for(n = 0 ; n < length - ll ; n++) {
		[sb appendString:ps];
	}
	[sb appendString:r];
	return([sb toString]);
}

+ (NSString*) forIntegerHex:(int)vv {
	return([NSString stringWithFormat:@"%X", vv]);
}

+ (NSString*) forCharacter:(int)vv {
	int32_t vvv = (int32_t)htonl(vv);
	return([[NSString alloc] initWithBytes:&vvv length:4 encoding:NSUTF32BigEndianStringEncoding]);
}

+ (NSString*) forFloat:(float)vv {
	return([NSString stringWithFormat:@"%f", vv]);
}

+ (NSString*) forDouble:(double)vv {
	return([NSString stringWithFormat:@"%f", vv]);
}

+ (NSMutableData*) toUTF8Buffer:(NSString*)str {
	return([CapeString toBuffer:str charset:@"UTF8"]);
}

+ (NSMutableData*) toBuffer:(NSString*)str charset:(NSString*)charset {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = charset; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	if([CapeString equalsIgnoreCase:@"UTF8" str2:charset] || [CapeString equalsIgnoreCase:@"UTF-8" str2:charset]) {
		NSMutableData* v = nil;
		v = [[str dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
		return(v);
	}
	NSMutableArray* bytes = [CapeString getBytesUnsignedWithStringAndString:str charset:charset];
	if(bytes == nil) {
		return(nil);
	}
	int c = [bytes count];
	NSMutableData* bb = [NSMutableData dataWithLength:c];
	int n = 0;
	for(n = 0 ; n < c ; n++) {
		[CapeBuffer setByte:bb offset:((long long)n) value:(uint8_t)({ NSNumber* _v = (NSNumber*)[bytes objectAtIndex:n]; _v == nil ? 0 : _v.intValue; })];
	}
	return(bb);
}

+ (NSMutableArray*) getBytesUnsignedWithString:(NSString*)str {
	return([CapeString getBytesUnsignedWithStringAndString:str charset:@"UTF-8"]);
}

+ (NSMutableArray*) getBytesUnsignedWithStringAndString:(NSString*)str charset:(NSString*)charset {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = charset; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.getBytesUnsigned] (String.sling:649:2): Not implemented");
	return(nil);
}

+ (NSMutableArray*) getBytesSignedWithString:(NSString*)str {
	return([CapeString getBytesSignedWithStringAndString:str charset:@"UTF-8"]);
}

+ (NSMutableArray*) getBytesSignedWithStringAndString:(NSString*)str charset:(NSString*)charset {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = charset; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.getBytesSigned] (String.sling:699:2): Not implemented");
	return(nil);
}

+ (int) getLength:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return([str length]);
}

+ (NSString*) appendStringAndString:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(str2);
	}
	if(({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(str1);
	}
	return([str1 stringByAppendingString:str2]);
}

+ (NSString*) appendStringAndSignedInteger:(NSString*)str intvalue:(int)intvalue {
	return([CapeString appendStringAndString:str str2:[CapeString forInteger:intvalue]]);
}

+ (NSString*) appendStringAndCharacter:(NSString*)str charvalue:(int)charvalue {
	return([CapeString appendStringAndString:str str2:[CapeString forCharacter:charvalue]]);
}

+ (NSString*) appendStringAndFloat:(NSString*)str floatvalue:(float)floatvalue {
	return([CapeString appendStringAndString:str str2:[CapeString forFloat:floatvalue]]);
}

+ (NSString*) appendStringAndDouble:(NSString*)str doublevalue:(double)doublevalue {
	return([CapeString appendStringAndString:str str2:[CapeString forDouble:doublevalue]]);
}

+ (NSString*) appendStringAndBoolean:(NSString*)str boolvalue:(BOOL)boolvalue {
	return([CapeString appendStringAndString:str str2:[CapeString forBoolean:boolvalue]]);
}

+ (NSString*) toLowerCase:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([str lowercaseString]);
}

+ (NSString*) toUpperCase:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	return([str uppercaseString]);
}

+ (int) charAt:(NSString*)str index:(int)index {
	return([CapeString getChar:str index:index]);
}

+ (int) getChar:(NSString*)str index:(int)index {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(((int)0));
	}
	return(str == nil || index < 0 || index >= [str length] ? 0 : [str characterAtIndex:index]);
}

+ (BOOL) equals:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	return([str1 isEqualToString:str2]);
}

+ (BOOL) equalsIgnoreCase:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	return([str1 caseInsensitiveCompare:str2] == NSOrderedSame);
}

+ (int) compare:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return(({ NSComparisonResult _r = [str1 compare:str2]; _r == NSOrderedAscending ? -1 : (_r == NSOrderedSame ? 0 : 1); }));
}

+ (int) compareToIgnoreCase:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return(({ NSComparisonResult _r = [str1 caseInsensitiveCompare:str2]; _r == NSOrderedAscending ? -1 : (_r == NSOrderedSame ? 0 : 1); }));
}

+ (int) getHashCode:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	return([str hash]);
}

+ (int) indexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start {
	return([CapeString getIndexOfWithStringAndCharacterAndSignedInteger:str c:c start:start]);
}

+ (int) getIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(-1);
	}
	int v = 0;
	NSRange r = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c", c]] options:0 range:NSMakeRange(start, [str length]-start)];
	if(r.location == NSNotFound) {
		v = -1;
	}
	else {
		v = r.location;
	}
	return(v);
}

+ (int) indexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start {
	return([CapeString getIndexOfWithStringAndStringAndSignedInteger:str s:s start:start]);
}

+ (int) getIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(-1);
	}
	return([str rangeOfString:s options:0 range:NSMakeRange(start, [str length]-start)].location);
}

+ (int) lastIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start {
	return([CapeString getLastIndexOfWithStringAndCharacterAndSignedInteger:str c:c start:start]);
}

+ (int) getLastIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(-1);
	}
	return([str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c", c]] options:NSBackwardsSearch range:NSMakeRange(0, start < 0 ? [str length] : start)].location);
}

+ (int) lastIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start {
	return([CapeString getLastIndexOfWithStringAndStringAndSignedInteger:str s:s start:start]);
}

+ (int) getLastIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(-1);
	}
	return([str rangeOfString:s options:NSBackwardsSearch range:NSMakeRange(0, start < 0 ? [str length] : start)].location);
}

+ (NSString*) subStringWithStringAndSignedInteger:(NSString*)str start:(int)start {
	return([CapeString getSubStringWithStringAndSignedInteger:str start:start]);
}

+ (NSString*) getSubStringWithStringAndSignedInteger:(NSString*)str start:(int)start {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	if(start >= [CapeString getLength:str]) {
		return(@"");
	}
	int ss = start;
	if(ss < 0) {
		ss = 0;
	}
	return([str substringFromIndex:ss]);
}

+ (NSString*) subStringWithStringAndSignedIntegerAndSignedInteger:(NSString*)str start:(int)start length:(int)length {
	return([CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:str start:start length:length]);
}

+ (NSString*) getSubStringWithStringAndSignedIntegerAndSignedInteger:(NSString*)str start:(int)start length:(int)length {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	int strl = [CapeString getLength:str];
	if(start >= strl) {
		return(@"");
	}
	int ss = start;
	if(ss < 0) {
		ss = 0;
	}
	int ll = length;
	if(ll > strl - start) {
		ll = strl - start;
	}
	return([str substringWithRange:NSMakeRange(ss, ll)]);
}

+ (BOOL) contains:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	return([str1 containsString:str2]);
}

+ (BOOL) startsWith:(NSString*)str1 str2:(NSString*)str2 offset:(int)offset {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	NSString* nstr = nil;
	if(offset > 0) {
		nstr = [CapeString getSubStringWithStringAndSignedInteger:str1 start:offset];
	}
	else {
		nstr = str1;
	}
	return([nstr hasPrefix:str2]);
}

+ (BOOL) endsWith:(NSString*)str1 str2:(NSString*)str2 {
	if(({ NSString* _s1 = str1; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = str2; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	return([str1 hasSuffix:str2]);
}

+ (NSString*) strip:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.strip] (String.sling:1463:2): Not Implemented");
	return(nil);
}

+ (NSString*) replaceStringAndCharacterAndCharacter:(NSString*)str oldChar:(int)oldChar newChar:(int)newChar {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.replace] (String.sling:1489:2): Not Implemented");
	return(nil);
}

+ (NSString*) replaceStringAndStringAndString:(NSString*)str target:(NSString*)target replacement:(NSString*)replacement {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.replace] (String.sling:1515:2): Not Implemented");
	return(nil);
}

+ (NSMutableArray*) toCharArray:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSLog(@"%@", @"[cape.String.toCharArray] (String.sling:1539:2): Not Implemented");
	return(nil);
}

+ (NSMutableArray*) split:(NSString*)str delim:(int)delim max:(int)max {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(v);
	}
	int n = 0;
	while(TRUE) {
		if(max > 0 && [CapeVector getSize:v] >= max - 1) {
			[CapeVector append:v object:[CapeString subStringWithStringAndSignedInteger:str start:n]];
			break;
		}
		int x = [CapeString indexOfWithStringAndCharacterAndSignedInteger:str c:delim start:n];
		if(x < 0) {
			[CapeVector append:v object:[CapeString subStringWithStringAndSignedInteger:str start:n]];
			break;
		}
		[CapeVector append:v object:[CapeString subStringWithStringAndSignedIntegerAndSignedInteger:str start:n length:x - n]];
		n = x + 1;
	}
	return(v);
}

+ (BOOL) isInteger:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	if(it == nil) {
		return(FALSE);
	}
	while(TRUE) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		if(c < '0' || c > '9') {
			return(FALSE);
		}
	}
	return(TRUE);
}

+ (int) toInteger:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(0);
	}
	int v = 0;
	int m = [CapeString getLength:str];
	int n = 0;
	for(n = 0 ; n < m ; n++) {
		int c = [CapeString charAt:str index:n];
		if(c >= '0' && c <= '9') {
			v = v * 10;
			v += ((int)(c - '0'));
		}
		else {
			break;
		}
	}
	return(v);
}

+ (long long) toLong:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(((long long)0));
	}
	long long v = ((long long)0);
	int m = [CapeString getLength:str];
	int n = 0;
	for(n = 0 ; n < m ; n++) {
		int c = [CapeString charAt:str index:n];
		if(c >= '0' && c <= '9') {
			v = v * 10;
			v += ((long long)(c - '0'));
		}
		else {
			break;
		}
	}
	return(v);
}

+ (int) toIntegerFromHex:(NSString*)str {
	if([CapeString isEmpty:str]) {
		return(0);
	}
	int v = 0;
	int m = [CapeString getLength:str];
	int n = 0;
	for(n = 0 ; n < m ; n++) {
		int c = [CapeString charAt:str index:n];
		if(c >= '0' && c <= '9') {
			v = v * 16;
			v += ((int)(c - '0'));
		}
		else {
			if(c >= 'a' && c <= 'f') {
				v = v * 16;
				v += ((int)(10 + c - 'a'));
			}
			else {
				if(c >= 'A' && c <= 'F') {
					v = v * 16;
					v += ((int)(10 + c - 'A'));
				}
				else {
					break;
				}
			}
		}
	}
	return(v);
}

+ (double) toDouble:(NSString*)str {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0.0);
	}
	return([str doubleValue]);
}

+ (id<CapeCharacterIterator>) iterate:(NSString*)_x_string {
	return(((id<CapeCharacterIterator>)[[CapeCharacterIteratorForString alloc] initWithString:_x_string]));
}

+ (NSString*) reverse:(NSString*)_x_string {
	if(({ NSString* _s1 = _x_string; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	id<CapeCharacterIterator> it = [CapeString iterate:_x_string];
	int c = ' ';
	while((c = [it getNextChar]) > 0) {
		[sb insertSignedIntegerAndCharacter:0 c:c];
	}
	return([sb toString]);
}

+ (id<CapeCharacterIterator>) iterateReverse:(NSString*)_x_string {
	return([CapeString iterate:[CapeString reverse:_x_string]]);
}

+ (NSString*) padToLength:(NSString*)_x_string length:(int)length align:(int)align paddingCharacter:(int)paddingCharacter {
	int ll = 0;
	if(({ NSString* _s1 = _x_string; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		ll = 0;
	}
	else {
		ll = [CapeString getLength:_x_string];
	}
	if(ll >= length) {
		return(_x_string);
	}
	int add = length - ll;
	int n = 0;
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	if(align < 0) {
		[sb appendString:_x_string];
		for(n = 0 ; n < add ; n++) {
			[sb appendCharacter:paddingCharacter];
		}
	}
	else {
		if(align > 0) {
			int ff = add / 2;
			int ss = add - ff;
			for(n = 0 ; n < ff ; n++) {
				[sb appendCharacter:paddingCharacter];
			}
			[sb appendString:_x_string];
			for(n = 0 ; n < ss ; n++) {
				[sb appendCharacter:paddingCharacter];
			}
		}
		else {
			for(n = 0 ; n < add ; n++) {
				[sb appendCharacter:paddingCharacter];
			}
			[sb appendString:_x_string];
		}
	}
	return([sb toString]);
}

+ (NSMutableArray*) quotedStringToVector:(NSString*)str delim:(int)delim {
	NSMutableArray* v = [[NSMutableArray alloc] init];
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(v);
	}
	BOOL dquote = FALSE;
	BOOL quote = FALSE;
	CapeStringBuilder* sb = nil;
	int c = ' ';
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	while((c = [it getNextChar]) > 0) {
		if(c == '\"' && quote == FALSE) {
			dquote = !dquote;
		}
		else {
			if(c == '\'' && dquote == FALSE) {
				quote = !quote;
			}
			else {
				if(quote == FALSE && dquote == FALSE && c == delim) {
					if(sb != nil) {
						NSString* r = [sb toString];
						if(({ NSString* _s1 = r; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							r = @"";
						}
						[v addObject:r];
					}
					sb = nil;
				}
				else {
					if(sb == nil) {
						sb = [[CapeStringBuilder alloc] init];
					}
					[sb appendCharacter:c];
				}
			}
		}
		if((quote == TRUE || dquote == TRUE) && sb == nil) {
			sb = [[CapeStringBuilder alloc] init];
		}
	}
	if(sb != nil) {
		NSString* r = [sb toString];
		if(({ NSString* _s1 = r; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			r = @"";
		}
		[v addObject:r];
	}
	return(v);
}

+ (NSMutableDictionary*) quotedStringToMap:(NSString*)str delim:(int)delim {
	NSMutableDictionary* v = [[NSMutableDictionary alloc] init];
	NSMutableArray* vector = [CapeString quotedStringToVector:str delim:delim];
	if(vector != nil) {
		int n = 0;
		int m = [vector count];
		for(n = 0 ; n < m ; n++) {
			NSString* c = ((NSString*)[vector objectAtIndex:n]);
			if(c != nil) {
				NSMutableArray* sp = [CapeString split:c delim:'=' max:2];
				NSString* key = ((NSString*)[sp objectAtIndex:0]);
				NSString* val = ((NSString*)[sp objectAtIndex:1]);
				if([CapeString isEmpty:key] == FALSE) {
					({ id _v = val; id _o = v; id _k = key; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
				}
			}
		}
	}
	return(v);
}

+ (NSString*) combine:(NSMutableArray*)strings delim:(int)delim unique:(BOOL)unique {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSMutableDictionary* flags = nil;
	if(unique) {
		flags = [[NSMutableDictionary alloc] init];
	}
	if(strings != nil) {
		int n = 0;
		int m = [strings count];
		for(n = 0 ; n < m ; n++) {
			NSString* o = ((NSString*)[strings objectAtIndex:n]);
			if(o != nil) {
				if(({ NSString* _s1 = o; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					continue;
				}
				if(flags != nil) {
					if(!(({ NSString* _s1 = [CapeMap getMapAndDynamic:flags key:((id)o)]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
						continue;
					}
					[CapeMap set:flags key:((id)o) val:((id)@"true")];
				}
				if(delim > 0 && [sb count] > 0) {
					[sb appendCharacter:delim];
				}
				[sb appendString:o];
			}
		}
	}
	return([sb toString]);
}

+ (BOOL) validateCharacters:(NSString*)str validator:(BOOL(^)(int))validator {
	if(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	id<CapeCharacterIterator> it = [CapeString iterate:str];
	if(it == nil) {
		return(FALSE);
	}
	while(TRUE) {
		int c = [it getNextChar];
		if(c < 1) {
			break;
		}
		if(validator(c) == FALSE) {
			return(FALSE);
		}
	}
	return(TRUE);
}

@end
