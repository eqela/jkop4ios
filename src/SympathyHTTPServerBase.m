
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
#import "SympathyNetworkServer.h"
#import "SympathyContentCache.h"
#import "SympathyIOManagerTimer.h"
#import "SympathyNetworkConnection.h"
#import "SympathyHTTPServerConnection.h"
#import "CapeSystemClock.h"
#import "SympathyNetworkConnectionManager.h"
#import "SympathyIOManager.h"
#import "CapeLog.h"
#import "CapeString.h"
#import "SympathyHTTPServerRequest.h"
#import "SympathyHTTPServerResponse.h"
#import "SympathyHTTPServerBase.h"

@implementation SympathyHTTPServerBase

{
	int writeBufferSize;
	int smallBodyLimit;
	int timeoutDelay;
	int maintenanceTimerDelay;
	NSString* serverName;
	BOOL enableCaching;
	BOOL allowCORS;
	SympathyContentCache* cache;
	id<SympathyIOManagerTimer> timeoutTimer;
	id<SympathyIOManagerTimer> maintenanceTimer;
}

- (SympathyHTTPServerBase*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->maintenanceTimer = nil;
	self->timeoutTimer = nil;
	self->cache = nil;
	self->allowCORS = TRUE;
	self->enableCaching = TRUE;
	self->serverName = nil;
	self->maintenanceTimerDelay = 60;
	self->timeoutDelay = 30;
	self->smallBodyLimit = 32 * 1024;
	self->writeBufferSize = 1024 * 512;
	[self setPort:8080];
	[self setServerName:[[@"Jkop for iOS" stringByAppendingString:@"/"] stringByAppendingString:@"1.0.20170111"]];
	return(self);
}

- (SympathyNetworkConnection*) createConnectionObject {
	return(((SympathyNetworkConnection*)[[SympathyHTTPServerConnection alloc] init]));
}

- (void) onRefresh {
}

- (BOOL) onTimeoutTimer {
	NSMutableArray* cfc = [[NSMutableArray alloc] init];
	long long now = [CapeSystemClock asSeconds];
	[self forEachConnection:^void(SympathyNetworkConnection* connection) {
		SympathyHTTPServerConnection* httpc = ((SympathyHTTPServerConnection*)({ id _v = connection; [_v isKindOfClass:[SympathyHTTPServerConnection class]] ? _v : nil; }));
		if(httpc == nil) {
			return;
		}
		if(([httpc getResponses] >= [httpc getRequests] || [httpc getIsWaitingForBodyReceiver]) && now - [httpc getLastActivity] >= self->timeoutDelay) {
			[cfc addObject:httpc];
		}
	}];
	if(cfc != nil) {
		int n = 0;
		int m = [cfc count];
		for(n = 0 ; n < m ; n++) {
			SympathyHTTPServerConnection* wsc = ((SympathyHTTPServerConnection*)[cfc objectAtIndex:n]);
			if(wsc != nil) {
				[wsc close];
			}
		}
	}
	return(TRUE);
}

- (BOOL) onMaintenanceTimer {
	if(self->cache != nil) {
		[self->cache onMaintenance];
	}
	[self onMaintenance];
	return(TRUE);
}

- (void) onMaintenance {
}

- (id<SympathyIOManagerTimer>) startTimer:(long long)delay handler:(BOOL(^)(void))handler {
	if(self->ioManager == nil) {
		return(nil);
	}
	return([self->ioManager startTimer:delay handler:handler]);
}

- (BOOL) initialize {
	if([super initialize] == FALSE) {
		return(FALSE);
	}
	if(self->timeoutDelay < 1) {
		[CapeLog debug:self->logContext message:[@"HTTPServerBase" stringByAppendingString:@": Timeout timer disabled"]];
	}
	else {
		[CapeLog debug:self->logContext message:[[[@"HTTPServerBase" stringByAppendingString:@": Starting a timeout timer with a "] stringByAppendingString:([CapeString forInteger:self->timeoutDelay])] stringByAppendingString:@" second delay."]];
		self->timeoutTimer = [self->ioManager startTimer:((long long)self->timeoutDelay) * 1000000 handler:^BOOL() {
			return([self onTimeoutTimer]);
		}];
		if(self->timeoutTimer == nil) {
			[CapeLog error:self->logContext message:[@"HTTPServerBase" stringByAppendingString:@": Failed to start timeout timer"]];
		}
	}
	if(self->maintenanceTimerDelay < 1) {
		[CapeLog debug:self->logContext message:@"Maintenance timer disabled"];
	}
	else {
		[CapeLog debug:self->logContext message:[[[@"HTTPServerBase" stringByAppendingString:@": Starting a maintenance timer with a "] stringByAppendingString:([CapeString forInteger:self->maintenanceTimerDelay])] stringByAppendingString:@" second delay."]];
		self->maintenanceTimer = [self->ioManager startTimer:((long long)self->maintenanceTimerDelay) * 1000000 handler:^BOOL() {
			return([self onMaintenanceTimer]);
		}];
		if(self->maintenanceTimer == nil) {
			[CapeLog error:self->logContext message:[@"HTTPServerBase" stringByAppendingString:@": Failed to start maintenance timer"]];
		}
	}
	[CapeLog info:self->logContext message:[[[@"HTTPServerBase" stringByAppendingString:@": initialized: `"] stringByAppendingString:([self getServerName])] stringByAppendingString:@"'"]];
	return(TRUE);
}

- (void) cleanup {
	[super cleanup];
	if(self->maintenanceTimer != nil) {
		[self->maintenanceTimer stop];
		self->maintenanceTimer = nil;
	}
	if(self->timeoutTimer != nil) {
		[self->timeoutTimer stop];
		self->timeoutTimer = nil;
	}
}

- (SympathyHTTPServerResponse*) createOptionsResponse:(SympathyHTTPServerRequest*)req {
	return([[[[SympathyHTTPServerResponse alloc] init] setStatus:@"200"] addHeader:@"Content-Length" value:@"0"]);
}

- (void) onRequest:(SympathyHTTPServerRequest*)req {
	[req sendResponse:[SympathyHTTPServerResponse forHTTPNotFound:nil]];
}

- (void) handleIncomingRequest:(SympathyHTTPServerRequest*)req {
	if(req == nil) {
		return;
	}
	if(self->cache != nil) {
		NSString* cid = [req getCacheId];
		if(!(({ NSString* _s1 = cid; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			SympathyHTTPServerResponse* resp = ((SympathyHTTPServerResponse*)({ id _v = [self->cache get:cid]; [_v isKindOfClass:[SympathyHTTPServerResponse class]] ? _v : nil; }));
			if(resp != nil) {
				[req sendResponse:resp];
				return;
			}
		}
	}
	if(({ NSString* _s1 = [req getMethod]; NSString* _s2 = @"OPTIONS"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		SympathyHTTPServerResponse* resp = [self createOptionsResponse:req];
		if(resp != nil) {
			[req sendResponse:resp];
			return;
		}
	}
	[self onRequest:req];
}

- (void) sendResponse:(SympathyHTTPServerConnection*)connection req:(SympathyHTTPServerRequest*)req resp:(SympathyHTTPServerResponse*)resp {
	if(connection == nil) {
		return;
	}
	if(self->allowCORS) {
		[resp enableCORS:req];
	}
	if(self->enableCaching && [resp getCacheTtl] > 0) {
		NSString* cid = [req getCacheId];
		if(!(({ NSString* _s1 = cid; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			if(self->cache == nil) {
				self->cache = [[SympathyContentCache alloc] init];
			}
			[self->cache set:cid content:((id)resp) ttl:[resp getCacheTtl]];
		}
	}
	[connection sendResponse:req aresp:resp];
}

- (void) onRequestComplete:(SympathyHTTPServerRequest*)request resp:(SympathyHTTPServerResponse*)resp bytesSent:(int)bytesSent remoteAddress:(NSString*)remoteAddress {
}

- (int) getWriteBufferSize {
	return(self->writeBufferSize);
}

- (SympathyHTTPServerBase*) setWriteBufferSize:(int)v {
	self->writeBufferSize = v;
	return(self);
}

- (int) getSmallBodyLimit {
	return(self->smallBodyLimit);
}

- (SympathyHTTPServerBase*) setSmallBodyLimit:(int)v {
	self->smallBodyLimit = v;
	return(self);
}

- (int) getTimeoutDelay {
	return(self->timeoutDelay);
}

- (SympathyHTTPServerBase*) setTimeoutDelay:(int)v {
	self->timeoutDelay = v;
	return(self);
}

- (int) getMaintenanceTimerDelay {
	return(self->maintenanceTimerDelay);
}

- (SympathyHTTPServerBase*) setMaintenanceTimerDelay:(int)v {
	self->maintenanceTimerDelay = v;
	return(self);
}

- (NSString*) getServerName {
	return(self->serverName);
}

- (SympathyHTTPServerBase*) setServerName:(NSString*)v {
	self->serverName = v;
	return(self);
}

- (BOOL) getEnableCaching {
	return(self->enableCaching);
}

- (SympathyHTTPServerBase*) setEnableCaching:(BOOL)v {
	self->enableCaching = v;
	return(self);
}

- (BOOL) getAllowCORS {
	return(self->allowCORS);
}

- (SympathyHTTPServerBase*) setAllowCORS:(BOOL)v {
	self->allowCORS = v;
	return(self);
}

@end
