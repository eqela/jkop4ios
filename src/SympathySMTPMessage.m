
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
#import "CapeDynamicVector.h"
#import "CapexVerboseDateTimeString.h"
#import "CapeString.h"
#import "CapeSystemClock.h"
#import "CapeRandom.h"
#import "CapeBuffer.h"
#import "CapeStringBuilder.h"
#import "SympathySMTPMessage.h"

int SympathySMTPMessageCounter = 0;

@implementation SympathySMTPMessage

{
	CapeDynamicVector* rcptsTo;
	CapeDynamicVector* rcptsCC;
	CapeDynamicVector* rcptsBCC;
	NSString* replyTo;
	NSString* subject;
	NSString* contentType;
	NSString* text;
	NSString* myName;
	NSString* myAddress;
	NSString* messageBody;
	NSString* messageID;
	NSString* date;
	CapeDynamicVector* excludeAddresses;
}

- (SympathySMTPMessage*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->excludeAddresses = nil;
	self->date = nil;
	self->messageID = nil;
	self->messageBody = nil;
	self->myAddress = nil;
	self->myName = nil;
	self->text = nil;
	self->contentType = nil;
	self->subject = nil;
	self->replyTo = nil;
	self->rcptsBCC = nil;
	self->rcptsCC = nil;
	self->rcptsTo = nil;
	self->date = [CapexVerboseDateTimeString forNow];
	return(self);
}

- (void) onChanged {
	self->messageBody = nil;
}

- (SympathySMTPMessage*) generateMessageID:(NSString*)host {
	self->messageID = [[[[[[([CapeString forInteger:((int)[CapeSystemClock asSeconds])]) stringByAppendingString:@"-"] stringByAppendingString:([CapeString forInteger:((int)[[[CapeRandom alloc] init] nextIntWithSigned32bitInteger:((int32_t)1000000)])])] stringByAppendingString:@"-"] stringByAppendingString:([CapeString forInteger:SympathySMTPMessageCounter])] stringByAppendingString:@"@"] stringByAppendingString:host];
	SympathySMTPMessageCounter++;
	[self onChanged];
	return(self);
}

- (NSString*) getDate {
	return(self->date);
}

- (NSString*) getReplyTo {
	return(self->replyTo);
}

- (SympathySMTPMessage*) setDate:(NSString*)date {
	self->date = date;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setMessageID:(NSString*)_x_id {
	self->messageID = _x_id;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setReplyTo:(NSString*)v {
	self->replyTo = v;
	[self onChanged];
	return(self);
}

- (NSString*) getMessageID {
	return(self->messageID);
}

- (BOOL) isExcludedAddress:(NSString*)add {
	if(self->excludeAddresses == nil || [self->excludeAddresses getSize] < 1) {
		return(FALSE);
	}
	NSMutableArray* array = [self->excludeAddresses toVector];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* ea = ((NSString*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
			if(ea != nil) {
				if([CapeString equals:ea str2:add]) {
					return(TRUE);
				}
			}
		}
	}
	return(FALSE);
}

- (CapeDynamicVector*) getAllRcpts {
	CapeDynamicVector* rcpts = [[CapeDynamicVector alloc] init];
	if(self->rcptsTo != nil) {
		NSMutableArray* array = [self->rcptsTo toVector];
		if(array != nil) {
			int n = 0;
			int m = [array count];
			for(n = 0 ; n < m ; n++) {
				NSString* r = ((NSString*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(r != nil) {
					if([self isExcludedAddress:r]) {
						continue;
					}
					[rcpts appendObject:((id)r)];
				}
			}
		}
	}
	if(self->rcptsCC != nil) {
		NSMutableArray* array2 = [self->rcptsCC toVector];
		if(array2 != nil) {
			int n2 = 0;
			int m2 = [array2 count];
			for(n2 = 0 ; n2 < m2 ; n2++) {
				NSString* r = ((NSString*)({ id _v = ((id)[array2 objectAtIndex:n2]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(r != nil) {
					if([self isExcludedAddress:r]) {
						continue;
					}
					[rcpts appendObject:((id)r)];
				}
			}
		}
	}
	if(self->rcptsBCC != nil) {
		NSMutableArray* array3 = [self->rcptsBCC toVector];
		if(array3 != nil) {
			int n3 = 0;
			int m3 = [array3 count];
			for(n3 = 0 ; n3 < m3 ; n3++) {
				NSString* r = ((NSString*)({ id _v = ((id)[array3 objectAtIndex:n3]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(r != nil) {
					if([self isExcludedAddress:r]) {
						continue;
					}
					[rcpts appendObject:((id)r)];
				}
			}
		}
	}
	return(rcpts);
}

- (CapeDynamicVector*) getRcptsTo {
	return(self->rcptsTo);
}

- (CapeDynamicVector*) getRcptsCC {
	return(self->rcptsCC);
}

- (CapeDynamicVector*) getRcptsBCC {
	return(self->rcptsBCC);
}

- (NSString*) getSubject {
	return(self->subject);
}

- (NSString*) getContentType {
	return(self->contentType);
}

- (NSString*) getText {
	return(self->text);
}

- (NSString*) getMyName {
	return(self->myName);
}

- (NSString*) getMyAddress {
	return(self->myAddress);
}

- (SympathySMTPMessage*) setSubject:(NSString*)s {
	self->subject = s;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setContentType:(NSString*)c {
	self->contentType = c;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setText:(NSString*)t {
	self->text = t;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setMyName:(NSString*)n {
	self->myName = n;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setMyAddress:(NSString*)a {
	self->myAddress = a;
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setTo:(NSString*)address {
	self->rcptsTo = [[CapeDynamicVector alloc] init];
	[self->rcptsTo appendObject:((id)address)];
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) addTo:(NSString*)address {
	if([CapeString isEmpty:address] == FALSE) {
		if(self->rcptsTo == nil) {
			self->rcptsTo = [[CapeDynamicVector alloc] init];
		}
		[self->rcptsTo appendObject:((id)address)];
	}
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) addCC:(NSString*)address {
	if([CapeString isEmpty:address] == FALSE) {
		if(self->rcptsCC == nil) {
			self->rcptsCC = [[CapeDynamicVector alloc] init];
		}
		[self->rcptsCC appendObject:((id)address)];
	}
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) addBCC:(NSString*)address {
	if([CapeString isEmpty:address] == FALSE) {
		if(self->rcptsBCC == nil) {
			self->rcptsBCC = [[CapeDynamicVector alloc] init];
		}
		[self->rcptsBCC appendObject:((id)address)];
	}
	[self onChanged];
	return(self);
}

- (SympathySMTPMessage*) setRecipients:(CapeDynamicVector*)to cc:(CapeDynamicVector*)cc bcc:(CapeDynamicVector*)bcc {
	self->rcptsTo = to;
	self->rcptsCC = cc;
	self->rcptsBCC = bcc;
	[self onChanged];
	return(self);
}

- (int) getSizeBytes {
	NSString* b = [self getMessageBody];
	if(({ NSString* _s1 = b; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(0);
	}
	NSMutableData* bb = [CapeString toUTF8Buffer:b];
	if(bb == nil) {
		return(0);
	}
	return(((int)[CapeBuffer getSize:bb]));
}

- (NSString*) getMessageBody {
	if(!(({ NSString* _s1 = self->messageBody; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return(self->messageBody);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"From: "];
	[sb appendString:self->myName];
	[sb appendString:@" <"];
	[sb appendString:self->myAddress];
	if([CapeString isEmpty:self->replyTo] == FALSE) {
		[sb appendString:@">\r\nReply-To: "];
		[sb appendString:self->myName];
		[sb appendString:@" <"];
		[sb appendString:self->replyTo];
	}
	[sb appendString:@">\r\nTo: "];
	BOOL first = TRUE;
	if(self->rcptsTo != nil) {
		NSMutableArray* array = [self->rcptsTo toVector];
		if(array != nil) {
			int n = 0;
			int m = [array count];
			for(n = 0 ; n < m ; n++) {
				NSString* to = ((NSString*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(to != nil) {
					if(first == FALSE) {
						[sb appendString:@", "];
					}
					[sb appendString:to];
					first = FALSE;
				}
			}
		}
	}
	[sb appendString:@"\r\nCc: "];
	first = TRUE;
	if(self->rcptsCC != nil) {
		NSMutableArray* array2 = [self->rcptsCC toVector];
		if(array2 != nil) {
			int n2 = 0;
			int m2 = [array2 count];
			for(n2 = 0 ; n2 < m2 ; n2++) {
				NSString* to = ((NSString*)({ id _v = ((id)[array2 objectAtIndex:n2]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(to != nil) {
					if(first == FALSE) {
						[sb appendString:@", "];
					}
					[sb appendString:to];
					first = FALSE;
				}
			}
		}
	}
	[sb appendString:@"\r\nSubject: "];
	[sb appendString:self->subject];
	[sb appendString:@"\r\nContent-Type: "];
	[sb appendString:self->contentType];
	[sb appendString:@"\r\nDate: "];
	[sb appendString:self->date];
	[sb appendString:@"\r\nMessage-ID: <"];
	[sb appendString:self->messageID];
	[sb appendString:@">\r\n\r\n"];
	[sb appendString:self->text];
	self->messageBody = [sb toString];
	return(self->messageBody);
}

- (CapeDynamicVector*) getExcludeAddresses {
	return(self->excludeAddresses);
}

- (SympathySMTPMessage*) setExcludeAddresses:(CapeDynamicVector*)v {
	self->excludeAddresses = v;
	return(self);
}

@end
