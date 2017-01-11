
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
#import "SympathySMTPMessage.h"
#import "CapeDynamicVector.h"
#import "CapeString.h"
#import "CapeStringBuilder.h"
#import "CapeFile.h"
#import "CapexMimeTypeRegistry.h"
#import "CapexBase64Encoder.h"
#import "SympathySMTPMultipartMessage.h"

@implementation SympathySMTPMultipartMessage

{
	CapeDynamicVector* attachments;
	NSString* message;
}

- (SympathySMTPMultipartMessage*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->message = nil;
	self->attachments = nil;
	[self setContentType:@"multipart/mixed"];
	return(self);
}

- (NSString*) getMessageBody {
	if(self->attachments == nil || [self->attachments getSize] < 1) {
		return(nil);
	}
	if([CapeString isEmpty:self->message] == FALSE) {
		return(self->message);
	}
	NSString* subject = [self getSubject];
	NSString* date = [self getDate];
	NSString* myName = [self getMyName];
	NSString* myAddress = [self getMyAddress];
	NSString* text = [self getText];
	CapeDynamicVector* recipientsTo = [self getRcptsTo];
	CapeDynamicVector* recipientsCC = [self getRcptsCC];
	NSString* messageID = [self getMessageID];
	NSString* replyTo = [self getReplyTo];
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"From: "];
	[sb appendString:myName];
	[sb appendString:@" <"];
	[sb appendString:myAddress];
	if([CapeString isEmpty:replyTo] == FALSE) {
		[sb appendString:@">\r\nReply-To: "];
		[sb appendString:myName];
		[sb appendString:@" <"];
		[sb appendString:replyTo];
	}
	[sb appendString:@">\r\nTo: "];
	BOOL first = TRUE;
	if(recipientsTo != nil) {
		NSMutableArray* array = [recipientsTo toVector];
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
	if(recipientsCC != nil) {
		NSMutableArray* array2 = [recipientsCC toVector];
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
	[sb appendString:subject];
	[sb appendString:@"\r\nMIME-Version: 1.0"];
	[sb appendString:@"\r\nContent-Type: "];
	[sb appendString:@"multipart/mixed"];
	[sb appendString:@"; boundary=\"XXXXboundarytext\""];
	[sb appendString:@"\r\nDate: "];
	[sb appendString:date];
	[sb appendString:@"\r\nMessage-ID: <"];
	[sb appendString:messageID];
	[sb appendString:@">\r\n\r\n"];
	[sb appendString:@"This is a multipart message in MIME format."];
	[sb appendString:@"\r\n"];
	[sb appendString:@"\r\n--XXXXboundarytext"];
	[sb appendString:@"\r\nContent-Type: text/plain"];
	[sb appendString:@"\r\n"];
	[sb appendString:@"\r\n"];
	[sb appendString:text];
	NSMutableArray* array3 = [self->attachments toVector];
	if(array3 != nil) {
		int n3 = 0;
		int m3 = [array3 count];
		for(n3 = 0 ; n3 < m3 ; n3++) {
			id<CapeFile> file = ((id<CapeFile>)({ id _v = ((id)[array3 objectAtIndex:n3]); [((NSObject*)_v) conformsToProtocol:@protocol(CapeFile)] ? _v : nil; }));
			if(file != nil) {
				[sb appendString:@"\r\n--XXXXboundarytext"];
				[sb appendString:@"\r\nContent-Type: "];
				NSString* contentType = [CapexMimeTypeRegistry typeForFile:file];
				if([CapeString isEmpty:contentType] == FALSE && [CapeString getIndexOfWithStringAndStringAndSignedInteger:contentType s:@"text" start:0] == 0) {
					[sb appendString:contentType];
					[sb appendString:@"\r\nContent-Disposition: attachment; filename="];
					[sb appendString:[file baseName]];
					[sb appendString:@"\r\n"];
					[sb appendString:@"\r\n"];
					[sb appendString:[file getContentsString:@"UTF8"]];
				}
				else {
					[sb appendString:contentType];
					[sb appendString:@"\r\nContent-Transfer-Encoding: Base64"];
					[sb appendString:@"\r\nContent-Disposition: attachment filename="];
					[sb appendString:[file baseName]];
					[sb appendString:@"\r\n"];
					[sb appendString:@"\r\n"];
					[sb appendString:[CapexBase64Encoder encode:[file getContentsBuffer]]];
				}
			}
		}
	}
	[sb appendString:@"\r\n"];
	[sb appendString:@"\r\n--XXXXboundarytext--"];
	return(self->message = [sb toString]);
}

- (CapeDynamicVector*) getAttachments {
	return(self->attachments);
}

- (SympathySMTPMultipartMessage*) setAttachments:(CapeDynamicVector*)v {
	self->attachments = v;
	return(self);
}

@end
