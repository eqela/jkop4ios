
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
#import "SympathyIOManagerSelect.h"
#import "CapeLoggingContext.h"
#import "SympathyIOManagerEntry.h"
#import "SympathyIOManagerTimer.h"
#import "SympathyIOManager.h"

@implementation SympathyIOManager

{
	BOOL executable;
}

- (SympathyIOManager*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->executable = FALSE;
	return(self);
}

+ (SympathyIOManager*) createDefault {
	return(((SympathyIOManager*)[[SympathyIOManagerSelect alloc] init]));
}

- (BOOL) execute:(id<CapeLoggingContext>)ctx {
	return(FALSE);
}

- (id<SympathyIOManagerEntry>) addWithReadListener:(id)o rrl:(void(^)(void))rrl {
	id<SympathyIOManagerEntry> v = [self add:o];
	if(v != nil) {
		[v setReadListener:rrl];
	}
	return(v);
}

- (id<SympathyIOManagerEntry>) addWithWriteListener:(id)o wrl:(void(^)(void))wrl {
	id<SympathyIOManagerEntry> v = [self add:o];
	if(v != nil) {
		[v setWriteListener:wrl];
	}
	return(v);
}

- (id<SympathyIOManagerEntry>) add:(id)o {
}

- (id<SympathyIOManagerTimer>) startTimer:(long long)delay handler:(BOOL(^)(void))handler {
}

- (void) stop {
}

- (BOOL) getExecutable {
	return(self->executable);
}

- (SympathyIOManager*) setExecutable:(BOOL)v {
	self->executable = v;
	return(self);
}

@end
