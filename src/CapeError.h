
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

@interface CapeError : NSObject <CapeStringObject>
- (CapeError*) init;
+ (CapeError*) forCode:(NSString*)code detail:(NSString*)detail;
+ (CapeError*) forMessage:(NSString*)message;
+ (CapeError*) instance:(NSString*)code message:(NSString*)message detail:(NSString*)detail;
+ (CapeError*) set:(CapeError*)error code:(NSString*)code message:(NSString*)message;
+ (CapeError*) setErrorCode:(CapeError*)error code:(NSString*)code;
+ (CapeError*) setErrorMessage:(CapeError*)error message:(NSString*)message;
+ (BOOL) isError:(id)o;
+ (NSString*) asString:(CapeError*)error;
- (CapeError*) clear;
- (NSString*) toStringWithDefault:(NSString*)defaultError;
- (NSString*) toString;
- (NSString*) getCode;
- (CapeError*) setCode:(NSString*)v;
- (NSString*) getMessage;
- (CapeError*) setMessage:(NSString*)v;
- (NSString*) getDetail;
- (CapeError*) setDetail:(NSString*)v;
@end
