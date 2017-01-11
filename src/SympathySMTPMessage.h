
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

@class CapeDynamicVector;

@interface SympathySMTPMessage : NSObject
- (SympathySMTPMessage*) init;
- (SympathySMTPMessage*) generateMessageID:(NSString*)host;
- (NSString*) getDate;
- (NSString*) getReplyTo;
- (SympathySMTPMessage*) setDate:(NSString*)date;
- (SympathySMTPMessage*) setMessageID:(NSString*)_x_id;
- (SympathySMTPMessage*) setReplyTo:(NSString*)v;
- (NSString*) getMessageID;
- (CapeDynamicVector*) getAllRcpts;
- (CapeDynamicVector*) getRcptsTo;
- (CapeDynamicVector*) getRcptsCC;
- (CapeDynamicVector*) getRcptsBCC;
- (NSString*) getSubject;
- (NSString*) getContentType;
- (NSString*) getText;
- (NSString*) getMyName;
- (NSString*) getMyAddress;
- (SympathySMTPMessage*) setSubject:(NSString*)s;
- (SympathySMTPMessage*) setContentType:(NSString*)c;
- (SympathySMTPMessage*) setText:(NSString*)t;
- (SympathySMTPMessage*) setMyName:(NSString*)n;
- (SympathySMTPMessage*) setMyAddress:(NSString*)a;
- (SympathySMTPMessage*) setTo:(NSString*)address;
- (SympathySMTPMessage*) addTo:(NSString*)address;
- (SympathySMTPMessage*) addCC:(NSString*)address;
- (SympathySMTPMessage*) addBCC:(NSString*)address;
- (SympathySMTPMessage*) setRecipients:(CapeDynamicVector*)to cc:(CapeDynamicVector*)cc bcc:(CapeDynamicVector*)bcc;
- (int) getSizeBytes;
- (NSString*) getMessageBody;
- (CapeDynamicVector*) getExcludeAddresses;
- (SympathySMTPMessage*) setExcludeAddresses:(CapeDynamicVector*)v;
@end
