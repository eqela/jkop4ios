
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
#import "CapeString.h"
#import "CaveIOSDeviceInfo.h"

@implementation CaveIOSDeviceInfo

{
	NSString* _x_id;
	NSString* name;
	int dpi;
	double scale;
	int screenWidth;
	int screenHeight;
}

- (CaveIOSDeviceInfo*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->screenHeight = 0;
	self->screenWidth = 0;
	self->scale = 0.0;
	self->dpi = 0;
	self->name = nil;
	self->_x_id = nil;
	return(self);
}

+ (CaveIOSDeviceInfo*) forDetails:(NSString*)_x_id name:(NSString*)name dpi:(int)dpi {
	CaveIOSDeviceInfo* v = [[CaveIOSDeviceInfo alloc] init];
	[v setId:_x_id];
	[v setName:name];
	[v setDpi:dpi];
	return(v);
}

- (NSString*) toString {
	return([[[[[[[[[[[self->name stringByAppendingString:@" ("] stringByAppendingString:self->_x_id] stringByAppendingString:@") "] stringByAppendingString:([CapeString forInteger:self->screenWidth])] stringByAppendingString:@"x"] stringByAppendingString:([CapeString forInteger:self->screenHeight])] stringByAppendingString:@" ("] stringByAppendingString:([CapeString forDouble:self->scale])] stringByAppendingString:@"x) @ "] stringByAppendingString:([CapeString forInteger:self->dpi])] stringByAppendingString:@"DPI"]);
}

- (NSString*) getId {
	return(self->_x_id);
}

- (CaveIOSDeviceInfo*) setId:(NSString*)v {
	self->_x_id = v;
	return(self);
}

- (NSString*) getName {
	return(self->name);
}

- (CaveIOSDeviceInfo*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (int) getDpi {
	return(self->dpi);
}

- (CaveIOSDeviceInfo*) setDpi:(int)v {
	self->dpi = v;
	return(self);
}

- (double) getScale {
	return(self->scale);
}

- (CaveIOSDeviceInfo*) setScale:(double)v {
	self->scale = v;
	return(self);
}

- (int) getScreenWidth {
	return(self->screenWidth);
}

- (CaveIOSDeviceInfo*) setScreenWidth:(int)v {
	self->screenWidth = v;
	return(self);
}

- (int) getScreenHeight {
	return(self->screenHeight);
}

- (CaveIOSDeviceInfo*) setScreenHeight:(int)v {
	self->screenHeight = v;
	return(self);
}

@end
