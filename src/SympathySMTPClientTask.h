
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
#import "CapeRunnable.h"

@protocol CapeLoggingContext;
@class SympathyURL;
@class SympathySMTPMessage;
@protocol SympathySMTPSenderListener;
@class SympathySMTPSender;

@interface SympathySMTPClientTask : NSObject <CapeRunnable>
- (SympathySMTPClientTask*) init;
- (void) run;
- (id<CapeLoggingContext>) getCtx;
- (SympathySMTPClientTask*) setCtx:(id<CapeLoggingContext>)v;
- (SympathyURL*) getServer;
- (SympathySMTPClientTask*) setServer:(SympathyURL*)v;
- (SympathySMTPMessage*) getMsg;
- (SympathySMTPClientTask*) setMsg:(SympathySMTPMessage*)v;
- (NSString*) getServerAddress;
- (SympathySMTPClientTask*) setServerAddress:(NSString*)v;
- (id<SympathySMTPSenderListener>) getListener;
- (SympathySMTPClientTask*) setListener:(id<SympathySMTPSenderListener>)v;
- (SympathySMTPSender*) getSender;
- (SympathySMTPClientTask*) setSender:(SympathySMTPSender*)v;
@end
