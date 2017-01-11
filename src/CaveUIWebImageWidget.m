
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
#import "CaveUIAsynchronousImageWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveImage.h"
#import "CaveUIImageWidget.h"
#import "CapeError.h"
#import "CapeKeyValueList.h"
#import "CapexWebClient.h"
#import "CapexNativeWebClient.h"
#import "CapeLog.h"
#import "CapeLoggingContext.h"
#import "CaveUICustomContainerWidget.h"
#import "CapeKeyValuePair.h"
#import "CapeString.h"
#import "CaveUIWebImageWidget.h"

@implementation CaveUIWebImageWidget

- (CaveUIWebImageWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CaveUIWebImageWidget*) forPlaceholderImage:(id<CaveGuiApplicationContext>)context image:(CaveImage*)image {
	CaveUIWebImageWidget* v = [[CaveUIWebImageWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetPlaceholderImage:image];
	return(v);
}

- (CaveUIWebImageWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super initWithGuiApplicationContext:context] == nil) {
		return(nil);
	}
	return(self);
}

- (void) setWidgetImageResource:(NSString*)resName {
	CaveUIImageWidget* img = [self onStartLoading:FALSE];
	if(img != nil) {
		[img setWidgetImageResource:resName];
	}
	[self onEndLoading];
}

- (void) setWidgetImage:(CaveImage*)image {
	CaveUIImageWidget* img = [self onStartLoading:FALSE];
	if(img != nil) {
		[img setWidgetImage:image];
	}
	[self onEndLoading];
}

- (void) setWidgetImageUrlWithStringAndFunction:(NSString*)url callback:(void(^)(CapeError*))callback {
	[self setWidgetImageUrlWithStringAndKeyValueListAndBufferAndFunction:url headers:nil body:nil callback:callback];
}

- (void) setWidgetImageUrlWithStringAndKeyValueListAndBufferAndFunction:(NSString*)url headers:(CapeKeyValueList*)headers body:(NSMutableData*)body callback:(void(^)(CapeError*))callback {
	id<CapexWebClient> client = [CapexNativeWebClient instance];
	if(client == nil) {
		[CapeLog error:((id<CapeLoggingContext>)self->context) message:@"Failed to create web client."];
		if(callback != nil) {
			callback([CapeError forCode:@"noWebClient" detail:nil]);
		}
		return;
	}
	[CapeLog debug:((id<CapeLoggingContext>)self->context) message:[[[@"WebImageWidget" stringByAppendingString:@": Start loading image: `"] stringByAppendingString:url] stringByAppendingString:@"'"]];
	CaveUIImageWidget* img = [self onStartLoading:TRUE];
	NSString* uu = url;
	void (^cb)(CapeError*) = callback;
	[client query:@"GET" url:url headers:headers body:body callback:^void(NSString* rcode, CapeKeyValueList* rheaders, NSMutableData* rbody) {
		[self onEndLoading];
		if(rbody == nil) {
			[CapeLog error:((id<CapeLoggingContext>)self->context) message:[[[@"WebImageWidget" stringByAppendingString:@": FAILED loading image: `"] stringByAppendingString:uu] stringByAppendingString:@"'"]];
			if(cb != nil) {
				cb([CapeError forCode:@"failedToDownload" detail:nil]);
			}
			return;
		}
		NSString* mimeType = nil;
		NSMutableArray* hdrv = [rheaders asVector];
		if(hdrv != nil) {
			int n = 0;
			int m = [hdrv count];
			for(n = 0 ; n < m ; n++) {
				CapeKeyValuePair* hdr = ((CapeKeyValuePair*)[hdrv objectAtIndex:n]);
				if(hdr != nil) {
					if([CapeString equalsIgnoreCase:hdr->key str2:@"content-type"]) {
						NSString* vv = hdr->value;
						if(!(({ NSString* _s1 = vv; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
							int sc = [CapeString indexOfWithStringAndCharacterAndSignedInteger:vv c:';' start:0];
							if(sc < 0) {
								mimeType = vv;
							}
							else {
								mimeType = [CapeString getSubStringWithStringAndSignedInteger:vv start:sc];
							}
						}
					}
				}
			}
		}
		CaveImage* imgo = [self->context getImageForBuffer:rbody mimeType:mimeType];
		if(imgo == nil) {
			[CapeLog error:((id<CapeLoggingContext>)self->context) message:[@"WebImageWidget" stringByAppendingString:@": Failed to create image from the returned data"]];
			if(cb != nil) {
				cb([CapeError forCode:@"failedToCreateImage" detail:nil]);
			}
			return;
		}
		[CapeLog debug:((id<CapeLoggingContext>)self->context) message:[[[@"WebImageWidget" stringByAppendingString:@": DONE loading image: `"] stringByAppendingString:uu] stringByAppendingString:@"'"]];
		[img setWidgetImage:imgo];
	}];
}

@end
