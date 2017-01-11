
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
#import "CavePointerEvent.h"

int CavePointerEventDOWN = 0;
int CavePointerEventMOVE = 1;
int CavePointerEventCANCEL = 2;
int CavePointerEventUP = 3;

@implementation CavePointerEvent

- (CavePointerEvent*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isConsumed = FALSE;
	self->y = 0.0;
	self->x = 0.0;
	self->action = 0;
	self->pointerId = 0;
	return(self);
}

- (void) consume {
	self->isConsumed = TRUE;
}

- (int) getPointerId {
	return(self->pointerId);
}

- (CavePointerEvent*) setPointerId:(int)value {
	self->pointerId = value;
	return(self);
}

- (int) getAction {
	return(self->action);
}

- (CavePointerEvent*) setAction:(int)value {
	self->action = value;
	return(self);
}

- (double) getX {
	return(self->x);
}

- (CavePointerEvent*) setX:(double)value {
	self->x = value;
	return(self);
}

- (double) getY {
	return(self->y);
}

- (CavePointerEvent*) setY:(double)value {
	self->y = value;
	return(self);
}

- (BOOL) isInside:(double)xc yc:(double)yc width:(double)width height:(double)height {
	if(self->x >= xc && self->x < xc + width && self->y >= yc && self->y < yc + height) {
		return(TRUE);
	}
	return(FALSE);
}

@end
