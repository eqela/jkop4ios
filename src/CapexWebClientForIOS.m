
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
#import "CapexWebClient.h"
#import "CapeKeyValueList.h"
#import "CapeIterator.h"
#import "CapeKeyValuePair.h"
#import "CapexWebClientForIOS.h"

@class CapexWebClientForIOSMyRequestListener;

@interface CapexWebClientForIOSMyRequestListener : NSObject <NSURLConnectionDelegate>
- (CapexWebClientForIOSMyRequestListener*) init;
- (void(^)(NSString*,CapeKeyValueList*,NSMutableData*)) getCallback;
- (CapexWebClientForIOSMyRequestListener*) setCallback:(void(^)(NSString*,CapeKeyValueList*,NSMutableData*))v;
@end

@implementation CapexWebClientForIOSMyRequestListener

{
	void (^callback)(NSString*,CapeKeyValueList*,NSMutableData*);
	NSMutableData* responseData;
	NSString* responseCode;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// A response has been received, this is where we initialize the instance var you created
	// so that we can append data to it in the didReceiveData method
	// Furthermore, this method is called each time there is a redirect so reinitializing it
	// also serves to clear it
	NSLog(@"Receiving HTTP response ..");
	responseCode = @"200"; // FIXME: Not always this ..
	// FIXME: HTTP Headers ..
	responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"HTTP data received");
	[responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	return nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Finished receiving HTTP response");
	callback(responseCode, nil, responseData);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"HTTP connection failed: %@", error);
	callback(nil, nil, nil);
}

- (CapexWebClientForIOSMyRequestListener*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->responseCode = nil;
	self->responseData = nil;
	self->callback = nil;
	return(self);
}

- (void(^)(NSString*,CapeKeyValueList*,NSMutableData*)) getCallback {
	return(self->callback);
}

- (CapexWebClientForIOSMyRequestListener*) setCallback:(void(^)(NSString*,CapeKeyValueList*,NSMutableData*))v {
	self->callback = v;
	return(self);
}

@end

@implementation CapexWebClientForIOS

{
	CapexWebClientForIOSMyRequestListener* requestListener;
}

- (CapexWebClientForIOS*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->requestListener = nil;
	return(self);
}

- (void) query:(NSString*)method url:(NSString*)url headers:(CapeKeyValueList*)headers body:(NSMutableData*)body callback:(void(^)(NSString*,CapeKeyValueList*,NSMutableData*))callback {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	request.HTTPMethod = method;
	if(headers != nil) {
		id<CapeIterator> iter = [headers iterate];
		while(TRUE) {
			CapeKeyValuePair* nh = ((CapeKeyValuePair*)[iter next]);
			if(nh == nil) {
				break;
			}
			NSString* key = nh->key;
			NSString* value = nh->value;
			[request setValue:value forHTTPHeaderField:key];
		}
	}
	if(self->requestListener == nil) {
		self->requestListener = [[CapexWebClientForIOSMyRequestListener alloc] init];
	}
	[self->requestListener setCallback:callback];
	request.HTTPBody = body;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:requestListener];
}

@end
