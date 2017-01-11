
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

@class CaveImage;
@protocol CaveGuiApplicationContext <CapeApplicationContext>
- (CaveImage*) getResourceImage:(NSString*)_x_id;
- (CaveImage*) getImageForBuffer:(NSMutableData*)buffer mimeType:(NSString*)mimeType;
- (void) showMessageDialogWithStringAndString:(NSString*)title message:(NSString*)message;
- (void) showMessageDialogWithStringAndStringAndFunction:(NSString*)title message:(NSString*)message callback:(void(^)(void))callback;
- (void) showConfirmDialog:(NSString*)title message:(NSString*)message okcallback:(void(^)(void))okcallback cancelcallback:(void(^)(void))cancelcallback;
- (void) showErrorDialogWithString:(NSString*)message;
- (void) showErrorDialogWithStringAndFunction:(NSString*)message callback:(void(^)(void))callback;
- (int) getScreenTopMargin;
- (int) getScreenWidth;
- (int) getScreenHeight;
- (int) getScreenDensity;
- (int) getHeightValue:(NSString*)spec;
- (int) getWidthValue:(NSString*)spec;
- (void) startTimer:(long long)timeout callback:(void(^)(void))callback;
@end
