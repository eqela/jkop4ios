
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
#import "CapeDynamicMap.h"
#import "CapeJSONParser.h"
#import "CapeJSONEncoder.h"
#import "CapexPhysicalAddress.h"

@implementation CapexPhysicalAddress

{
	double latitude;
	double longitude;
	NSString* completeAddress;
	NSString* country;
	NSString* countryCode;
	NSString* administrativeArea;
	NSString* subAdministrativeArea;
	NSString* locality;
	NSString* subLocality;
	NSString* streetAddress;
	NSString* streetAddressDetail;
	NSString* postalCode;
}

- (CapexPhysicalAddress*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->postalCode = nil;
	self->streetAddressDetail = nil;
	self->streetAddress = nil;
	self->subLocality = nil;
	self->locality = nil;
	self->subAdministrativeArea = nil;
	self->administrativeArea = nil;
	self->countryCode = nil;
	self->country = nil;
	self->completeAddress = nil;
	self->longitude = 0.0;
	self->latitude = 0.0;
	return(self);
}

+ (CapexPhysicalAddress*) forString:(NSString*)str {
	CapexPhysicalAddress* v = [[CapexPhysicalAddress alloc] init];
	[v fromString:str];
	return(v);
}

- (void) fromString:(NSString*)str {
	CapeDynamicMap* data = nil;
	if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		data = ((CapeDynamicMap*)({ id _v = [CapeJSONParser parseString:str]; [_v isKindOfClass:[CapeDynamicMap class]] ? _v : nil; }));
	}
	if(data == nil) {
		data = [[CapeDynamicMap alloc] init];
	}
	self->latitude = [data getDouble:@"latitude" defval:0.0];
	self->longitude = [data getDouble:@"longitude" defval:0.0];
	self->completeAddress = [data getString:@"completeAddress" defval:nil];
	self->country = [data getString:@"country" defval:nil];
	self->countryCode = [data getString:@"countryCode" defval:nil];
	self->administrativeArea = [data getString:@"administrativeArea" defval:nil];
	self->subAdministrativeArea = [data getString:@"subAdministrativeArea" defval:nil];
	self->locality = [data getString:@"locality" defval:nil];
	self->subLocality = [data getString:@"subLocality" defval:nil];
	self->streetAddress = [data getString:@"streetAddress" defval:nil];
	self->streetAddressDetail = [data getString:@"streetAddressDetail" defval:nil];
	self->postalCode = [data getString:@"postalCode" defval:nil];
}

- (NSString*) toString {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[v setStringAndDouble:@"latitude" value:self->latitude];
	[v setStringAndDouble:@"longitude" value:self->longitude];
	[v setStringAndObject:@"completeAddress" value:((id)self->completeAddress)];
	[v setStringAndObject:@"country" value:((id)self->country)];
	[v setStringAndObject:@"countryCode" value:((id)self->countryCode)];
	[v setStringAndObject:@"administrativeArea" value:((id)self->administrativeArea)];
	[v setStringAndObject:@"subAdministrativeArea" value:((id)self->subAdministrativeArea)];
	[v setStringAndObject:@"locality" value:((id)self->locality)];
	[v setStringAndObject:@"subLocality" value:((id)self->subLocality)];
	[v setStringAndObject:@"streetAddress" value:((id)self->streetAddress)];
	[v setStringAndObject:@"streetAddressDetail" value:((id)self->streetAddressDetail)];
	[v setStringAndObject:@"postalCode" value:((id)self->postalCode)];
	return([CapeJSONEncoder encode:((id)v) niceFormatting:FALSE]);
}

- (double) getLatitude {
	return(self->latitude);
}

- (CapexPhysicalAddress*) setLatitude:(double)v {
	self->latitude = v;
	return(self);
}

- (double) getLongitude {
	return(self->longitude);
}

- (CapexPhysicalAddress*) setLongitude:(double)v {
	self->longitude = v;
	return(self);
}

- (NSString*) getCompleteAddress {
	return(self->completeAddress);
}

- (CapexPhysicalAddress*) setCompleteAddress:(NSString*)v {
	self->completeAddress = v;
	return(self);
}

- (NSString*) getCountry {
	return(self->country);
}

- (CapexPhysicalAddress*) setCountry:(NSString*)v {
	self->country = v;
	return(self);
}

- (NSString*) getCountryCode {
	return(self->countryCode);
}

- (CapexPhysicalAddress*) setCountryCode:(NSString*)v {
	self->countryCode = v;
	return(self);
}

- (NSString*) getAdministrativeArea {
	return(self->administrativeArea);
}

- (CapexPhysicalAddress*) setAdministrativeArea:(NSString*)v {
	self->administrativeArea = v;
	return(self);
}

- (NSString*) getSubAdministrativeArea {
	return(self->subAdministrativeArea);
}

- (CapexPhysicalAddress*) setSubAdministrativeArea:(NSString*)v {
	self->subAdministrativeArea = v;
	return(self);
}

- (NSString*) getLocality {
	return(self->locality);
}

- (CapexPhysicalAddress*) setLocality:(NSString*)v {
	self->locality = v;
	return(self);
}

- (NSString*) getSubLocality {
	return(self->subLocality);
}

- (CapexPhysicalAddress*) setSubLocality:(NSString*)v {
	self->subLocality = v;
	return(self);
}

- (NSString*) getStreetAddress {
	return(self->streetAddress);
}

- (CapexPhysicalAddress*) setStreetAddress:(NSString*)v {
	self->streetAddress = v;
	return(self);
}

- (NSString*) getStreetAddressDetail {
	return(self->streetAddressDetail);
}

- (CapexPhysicalAddress*) setStreetAddressDetail:(NSString*)v {
	self->streetAddressDetail = v;
	return(self);
}

- (NSString*) getPostalCode {
	return(self->postalCode);
}

- (CapexPhysicalAddress*) setPostalCode:(NSString*)v {
	self->postalCode = v;
	return(self);
}

@end
