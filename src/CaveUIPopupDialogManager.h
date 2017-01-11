
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
#import <UIKit/UIKit.h>

@protocol CaveGuiApplicationContext;
@class CaveColor;

@interface CaveUIPopupDialogManager : NSObject
- (CaveUIPopupDialogManager*) init;
- (CaveUIPopupDialogManager*) initWithGuiApplicationContextAndUIView:(id<CaveGuiApplicationContext>)context parent:(UIView*)parent;
- (CaveUIPopupDialogManager*) setButtonColor:(CaveColor*)color;
- (void) showTextInputDialog:(NSString*)title prompt:(NSString*)prompt callback:(void(^)(NSString*))callback;
- (void) showMessageDialog:(NSString*)title message:(NSString*)message callback:(void(^)(void))callback;
- (void) showConfirmDialog:(NSString*)title message:(NSString*)message okcallback:(void(^)(void))okcallback cancelcallback:(void(^)(void))cancelcallback;
- (void) showErrorDialog:(NSString*)message callback:(void(^)(void))callback;
- (void) checkForDefaultColors;
- (id<CaveGuiApplicationContext>) getContext;
- (CaveUIPopupDialogManager*) setContext:(id<CaveGuiApplicationContext>)v;
- (UIView*) getParent;
- (CaveUIPopupDialogManager*) setParent:(UIView*)v;
- (CaveColor*) getBackgroundColor;
- (CaveUIPopupDialogManager*) setBackgroundColor:(CaveColor*)v;
- (CaveColor*) getHeaderBackgroundColor;
- (CaveUIPopupDialogManager*) setHeaderBackgroundColor:(CaveColor*)v;
- (CaveColor*) getHeaderTextColor;
- (CaveUIPopupDialogManager*) setHeaderTextColor:(CaveColor*)v;
- (CaveColor*) getMessageTextColor;
- (CaveUIPopupDialogManager*) setMessageTextColor:(CaveColor*)v;
- (CaveColor*) getPositiveButtonColor;
- (CaveUIPopupDialogManager*) setPositiveButtonColor:(CaveColor*)v;
- (CaveColor*) getNegativeButtonColor;
- (CaveUIPopupDialogManager*) setNegativeButtonColor:(CaveColor*)v;
@end
