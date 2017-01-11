
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
#import "CapeApplicationContext.h"
#import "CapexGeoLocation.h"
#import "CapeVector.h"
#import "CapexGeoLocationManager.h"

@implementation CapexGeoLocationManager

{
	NSMutableArray* listeners;
}

+ (CapexGeoLocationManager*) forApplicationContext:(id<CapeApplicationContext>)context {
	return(nil);
}

- (CapexGeoLocationManager*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->listeners = nil;
	self->listeners = [[NSMutableArray alloc] init];
	return(self);
}

- (void) addListener:(void(^)(CapexGeoLocation*))l {
	[self->listeners addObject:l];
}

- (void) removeListener:(void(^)(CapexGeoLocation*))l {
	[CapeVector removeValue:self->listeners value:l];
}

- (void) removeAllListeners {
	[CapeVector clear:self->listeners];
}

- (void) notifyListeners:(CapexGeoLocation*)location {
	if(self->listeners != nil) {
		int n = 0;
		int m = [self->listeners count];
		for(n = 0 ; n < m ; n++) {
			void (^listener)(CapexGeoLocation*) = ((void(^)(CapexGeoLocation*))[self->listeners objectAtIndex:n]);
			if(listener != nil) {
				if(listener != nil) {
					listener(location);
				}
			}
		}
	}
}

- (void) startLocationUpdates:(void(^)(BOOL))callback {
}

- (void) stopLocationUpdates {
}

@end
