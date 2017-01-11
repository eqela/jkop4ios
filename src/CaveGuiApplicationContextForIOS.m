
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
#import <sys/utsname.h>
#import "CaveGuiApplicationContext.h"
#import "CapeFile.h"
#import "CapeString.h"
#import "CapeCurrentProcess.h"
#import "CaveImage.h"
#import "CaveImageForIOS.h"
#import "CaveIOSDeviceInfo.h"
#import "CaveLength.h"
#import "CaveGuiApplicationContextForIOS.h"

@class CaveGuiApplicationContextForIOSMyAlertDelegate;

@interface CaveGuiApplicationContextForIOSMyAlertDelegate : NSObject <UIAlertViewDelegate>
- (CaveGuiApplicationContextForIOSMyAlertDelegate*) init;
- (void) onDismissed:(int)index;
- (void(^)(void)) getCallback;
- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setCallback:(void(^)(void))v;
- (void(^)(void)) getOkCallback;
- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setOkCallback:(void(^)(void))v;
- (void(^)(void)) getCancelCallback;
- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setCancelCallback:(void(^)(void))v;
@end

@implementation CaveGuiApplicationContextForIOSMyAlertDelegate

{
	void (^callback)(void);
	void (^okCallback)(void);
	void (^cancelCallback)(void);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self onDismissed:buttonIndex];
}

- (CaveGuiApplicationContextForIOSMyAlertDelegate*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->cancelCallback = nil;
	self->okCallback = nil;
	self->callback = nil;
	return(self);
}

- (void) onDismissed:(int)index {
	if(index == 0 && self->cancelCallback != nil) {
		self->cancelCallback();
		return;
	}
	if(index == 1 && self->okCallback != nil) {
		self->okCallback();
		return;
	}
	if(self->callback != nil) {
		self->callback();
	}
}

- (void(^)(void)) getCallback {
	return(self->callback);
}

- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setCallback:(void(^)(void))v {
	self->callback = v;
	return(self);
}

- (void(^)(void)) getOkCallback {
	return(self->okCallback);
}

- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setOkCallback:(void(^)(void))v {
	self->okCallback = v;
	return(self);
}

- (void(^)(void)) getCancelCallback {
	return(self->cancelCallback);
}

- (CaveGuiApplicationContextForIOSMyAlertDelegate*) setCancelCallback:(void(^)(void))v {
	self->cancelCallback = v;
	return(self);
}

@end

@implementation CaveGuiApplicationContextForIOS

{
	CaveGuiApplicationContextForIOSMyAlertDelegate* myDelegate;
	CaveIOSDeviceInfo* deviceInfo;
}

- (CaveGuiApplicationContextForIOS*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->deviceInfo = nil;
	self->myDelegate = nil;
	return(self);
}

- (void) logError:(NSString*)message {
	NSLog(@"%@", [@"[ERROR] " stringByAppendingString:message]);
}

- (void) logWarning:(NSString*)message {
	NSLog(@"%@", [@"[WARNING] " stringByAppendingString:message]);
}

- (void) logInfo:(NSString*)message {
	NSLog(@"%@", [@"[INFO] " stringByAppendingString:message]);
}

- (void) logDebug:(NSString*)message {
	NSLog(@"%@", [@"[DEBUG] " stringByAppendingString:message]);
}

- (id<CapeFile>) getApplicationDataDirectory {
	NSLog(@"%@", @"[cave.GuiApplicationContextForIOS.getApplicationDataDirectory] (GuiApplicationContextForIOS@target_iosoc.sling:50:1): Not implemented");
	return(nil);
}

- (CaveImage*) getResourceImage:(NSString*)_x_id {
	if([CapeString isEmpty:_x_id]) {
		return(nil);
	}
	id<CapeFile> cp = [CapeCurrentProcess getExecutableFile];
	if(cp == nil) {
		return(nil);
	}
	id<CapeFile> bundleDir = [cp getParent];
	if(bundleDir == nil) {
		return(nil);
	}
	id<CapeFile> f = [bundleDir entry:[_x_id stringByAppendingString:@".png"]];
	if([f isFile] == FALSE) {
		f = [bundleDir entry:[_x_id stringByAppendingString:@".jpg"]];
	}
	if([f isFile] == FALSE) {
		return(nil);
	}
	return(((CaveImage*)[CaveImageForIOS forFile:f]));
}

- (CaveImage*) getImageForBuffer:(NSMutableData*)buffer mimeType:(NSString*)mimeType {
	NSLog(@"%@", @"[cave.GuiApplicationContextForIOS.getImageForBuffer] (GuiApplicationContextForIOS@target_iosoc.sling:79:1): Not implemented");
	return(nil);
}

- (CaveGuiApplicationContextForIOSMyAlertDelegate*) getMyAlertDelegate {
	if(self->myDelegate == nil) {
		self->myDelegate = [[CaveGuiApplicationContextForIOSMyAlertDelegate alloc] init];
	}
	return(self->myDelegate);
}

- (void) showMessageDialogWithStringAndString:(NSString*)title message:(NSString*)message {
	[self showMessageDialogWithStringAndStringAndFunction:title message:message callback:nil];
}

- (void) showMessageDialogWithStringAndStringAndFunction:(NSString*)title message:(NSString*)message callback:(void(^)(void))callback {
	CaveGuiApplicationContextForIOSMyAlertDelegate* dg = nil;
	if(callback != nil) {
		dg = [self getMyAlertDelegate];
		[dg setCallback:callback];
	}
	UIAlertView* alert = [[UIAlertView alloc]
	initWithTitle:title
	message:message
	delegate:dg
	cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
}

- (void) showConfirmDialog:(NSString*)title message:(NSString*)message okcallback:(void(^)(void))okcallback cancelcallback:(void(^)(void))cancelcallback {
	CaveGuiApplicationContextForIOSMyAlertDelegate* dg = nil;
	if(okcallback != nil || cancelcallback != nil) {
		dg = [self getMyAlertDelegate];
		[dg setOkCallback:okcallback];
		[dg setCancelCallback:cancelcallback];
	}
	UIAlertView* alert = [[UIAlertView alloc]
	initWithTitle:title
	message:message
	delegate:dg
	cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", nil];
	[alert show];
}

- (void) showErrorDialogWithString:(NSString*)message {
	[self showErrorDialogWithStringAndFunction:message callback:nil];
}

- (void) showErrorDialogWithStringAndFunction:(NSString*)message callback:(void(^)(void))callback {
	CaveGuiApplicationContextForIOSMyAlertDelegate* dg = nil;
	if(callback != nil) {
		dg = [self getMyAlertDelegate];
		[dg setCallback:callback];
	}
	UIAlertView* alert = [[UIAlertView alloc]
	initWithTitle:@"ERROR"
	message:message
	delegate:dg
	cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
}

- (int) getScreenTopMargin {
	int v = 0;
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	v = MIN(statusBarSize.width, statusBarSize.height);
	return(v);
}

- (int) getScreenWidth {
	return([[self getDeviceInfo] getScreenWidth]);
}

- (int) getScreenHeight {
	return([[self getDeviceInfo] getScreenHeight]);
}

- (NSString*) getMachineName {
	NSString* v = nil;
	struct utsname si;
	if(uname(&si) >= 0) {
		v = [NSString stringWithCString:si.machine encoding:NSUTF8StringEncoding];
	}
	return(v);
}

- (CaveIOSDeviceInfo*) detectDeviceInfo {
	NSString* name = [self getMachineName];
	if(({ NSString* _s1 = name; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		;
	}
	else {
		if([CapeString startsWith:name str2:@"iPhone" offset:0]) {
			if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone8,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 6S" dpi:326]);
			}
			else {
				if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone8,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 6S Plus" dpi:401]);
				}
				else {
					if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone8,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						return([CaveIOSDeviceInfo forDetails:name name:@"iPhone SE" dpi:326]);
					}
					else {
						if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone9,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone9,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 7" dpi:326]);
						}
						else {
							if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone9,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone9,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 7 Plus" dpi:401]);
							}
							else {
								if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone1,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 1" dpi:163]);
								}
								else {
									if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone1,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 3G" dpi:163]);
									}
									else {
										if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone2,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
											return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 3G" dpi:163]);
										}
										else {
											if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone3,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone3,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone3,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
												return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 4" dpi:326]);
											}
											else {
												if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone4,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
													return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 4S" dpi:326]);
												}
												else {
													if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone5,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone5,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
														return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 5" dpi:326]);
													}
													else {
														if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone5,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone5,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
															return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 5C" dpi:326]);
														}
														else {
															if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone6,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPhone6,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 5S" dpi:326]);
															}
															else {
																if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone7,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																	return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 6" dpi:326]);
																}
																else {
																	if(({ NSString* _s1 = name; NSString* _s2 = @"iPhone7,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																		return([CaveIOSDeviceInfo forDetails:name name:@"iPhone 6 Plus" dpi:401]);
																	}
																	else {
																		return([CaveIOSDeviceInfo forDetails:name name:@"iPhone (unknown)" dpi:326]);
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		else {
			if([CapeString startsWith:name str2:@"iPod" offset:0]) {
				if(({ NSString* _s1 = name; NSString* _s2 = @"iPod1,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 1G" dpi:163]);
				}
				else {
					if(({ NSString* _s1 = name; NSString* _s2 = @"iPod2,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 2G" dpi:163]);
					}
					else {
						if(({ NSString* _s1 = name; NSString* _s2 = @"iPod3,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 3G" dpi:163]);
						}
						else {
							if(({ NSString* _s1 = name; NSString* _s2 = @"iPod4,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 4G" dpi:326]);
							}
							else {
								if(({ NSString* _s1 = name; NSString* _s2 = @"iPod5,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 5G" dpi:326]);
								}
								else {
									if(({ NSString* _s1 = name; NSString* _s2 = @"iPod7,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch 6G" dpi:326]);
									}
									else {
										return([CaveIOSDeviceInfo forDetails:name name:@"iPod Touch (unknown)" dpi:326]);
									}
								}
							}
						}
					}
				}
			}
			else {
				if([CapeString startsWith:name str2:@"iPad" offset:0]) {
					if(({ NSString* _s1 = name; NSString* _s2 = @"iPad1,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						return([CaveIOSDeviceInfo forDetails:name name:@"iPad 1G" dpi:132]);
					}
					else {
						if(({ NSString* _s1 = name; NSString* _s2 = @"iPad2,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad2,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad2,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad2,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							return([CaveIOSDeviceInfo forDetails:name name:@"iPad 2" dpi:132]);
						}
						else {
							if(({ NSString* _s1 = name; NSString* _s2 = @"iPad3,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad3,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad3,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								return([CaveIOSDeviceInfo forDetails:name name:@"iPad 3" dpi:264]);
							}
							else {
								if(({ NSString* _s1 = name; NSString* _s2 = @"iPad3,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad3,5"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad3,6"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
									return([CaveIOSDeviceInfo forDetails:name name:@"iPad 4" dpi:264]);
								}
								else {
									if(({ NSString* _s1 = name; NSString* _s2 = @"iPad4,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										return([CaveIOSDeviceInfo forDetails:name name:@"iPad Air" dpi:264]);
									}
									else {
										if(({ NSString* _s1 = name; NSString* _s2 = @"iPad5,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad5,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
											return([CaveIOSDeviceInfo forDetails:name name:@"iPad Air 2" dpi:264]);
										}
										else {
											if(({ NSString* _s1 = name; NSString* _s2 = @"iPad2,5"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad2,6"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad2,7"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
												return([CaveIOSDeviceInfo forDetails:name name:@"iPad Mini 1G" dpi:163]);
											}
											else {
												if(({ NSString* _s1 = name; NSString* _s2 = @"iPad4,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,5"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,6"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
													return([CaveIOSDeviceInfo forDetails:name name:@"iPad Mini 2" dpi:326]);
												}
												else {
													if(({ NSString* _s1 = name; NSString* _s2 = @"iPad4,7"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,8"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad4,9"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
														return([CaveIOSDeviceInfo forDetails:name name:@"iPad Mini 3" dpi:326]);
													}
													else {
														if(({ NSString* _s1 = name; NSString* _s2 = @"iPad5,1"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad5,2"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
															return([CaveIOSDeviceInfo forDetails:name name:@"iPad Mini 4" dpi:326]);
														}
														else {
															if(({ NSString* _s1 = name; NSString* _s2 = @"iPad6,7"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad6,8"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																return([CaveIOSDeviceInfo forDetails:name name:@"iPad Pro 12.9in" dpi:264]);
															}
															else {
																if(({ NSString* _s1 = name; NSString* _s2 = @"iPad6,3"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = name; NSString* _s2 = @"iPad6,4"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
																	return([CaveIOSDeviceInfo forDetails:name name:@"iPad Pro 9.7in" dpi:264]);
																}
																else {
																	return([CaveIOSDeviceInfo forDetails:name name:@"iPad (unknown)" dpi:264]);
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				else {
					if([CapeString startsWith:name str2:@"Watch" offset:0]) {
						return([CaveIOSDeviceInfo forDetails:name name:@"Apple Watch" dpi:326]);
					}
					else {
						if(({ NSString* _s1 = name; NSString* _s2 = @"i386"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
							return([CaveIOSDeviceInfo forDetails:name name:@"iOS Simulator x86" dpi:0]);
						}
						else {
							if(({ NSString* _s1 = name; NSString* _s2 = @"x86_64"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
								return([CaveIOSDeviceInfo forDetails:name name:@"iOS Simulator x64" dpi:0]);
							}
						}
					}
				}
			}
		}
	}
	return([CaveIOSDeviceInfo forDetails:name name:@"Apple Device (unknown)" dpi:326]);
}

- (CaveIOSDeviceInfo*) getDeviceInfo {
	if(self->deviceInfo == nil) {
		self->deviceInfo = [self detectDeviceInfo];
		int width = 0;
		int height = 0;
		double scale = 0.0;
		width = [[UIScreen mainScreen] bounds].size.width;
		height = [[UIScreen mainScreen] bounds].size.height;
		scale = [[UIScreen mainScreen] nativeScale];
		[self->deviceInfo setScreenWidth:width];
		[self->deviceInfo setScreenHeight:height];
		[self->deviceInfo setScale:scale];
		if([self->deviceInfo getDpi] < 1) {
			int ss = ((int)(163 * scale));
			if(ss > 400) {
				ss = 401;
			}
			[self->deviceInfo setDpi:ss];
		}
		[self logDebug:[@"Device detected: " stringByAppendingString:([self->deviceInfo toString])]];
	}
	return(self->deviceInfo);
}

- (int) getScreenDensity {
	return([[self getDeviceInfo] getDpi]);
}

- (double) getScreenScaleFactor {
	return([[self getDeviceInfo] getScale]);
}

- (int) getHeightValue:(NSString*)spec {
	return([CaveLength asPoints:spec ppi:[self getScreenDensity]] / [self getScreenScaleFactor]);
}

- (int) getWidthValue:(NSString*)spec {
	return([CaveLength asPoints:spec ppi:[self getScreenDensity]] / [self getScreenScaleFactor]);
}

- (void) startTimer:(long long)timeout callback:(void(^)(void))callback {
	dispatch_time_t dtt = dispatch_time(DISPATCH_TIME_NOW, timeout * 1000000);
	dispatch_after(dtt, dispatch_get_main_queue(), ^(void) {
		callback();
	});
}

@end
