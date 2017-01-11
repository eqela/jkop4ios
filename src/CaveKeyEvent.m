
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
#import "CaveKeyEvent.h"

int CaveKeyEventACTION_NONE = 0;
int CaveKeyEventACTION_DOWN = 1;
int CaveKeyEventACTION_UP = 2;
int CaveKeyEventKEY_NONE = 0;
int CaveKeyEventKEY_SPACE = 1;
int CaveKeyEventKEY_ENTER = 2;
int CaveKeyEventKEY_TAB = 3;
int CaveKeyEventKEY_ESCAPE = 4;
int CaveKeyEventKEY_BACKSPACE = 5;
int CaveKeyEventKEY_SHIFT = 6;
int CaveKeyEventKEY_CONTROL = 7;
int CaveKeyEventKEY_ALT = 8;
int CaveKeyEventKEY_CAPSLOCK = 9;
int CaveKeyEventKEY_NUMLOCK = 10;
int CaveKeyEventKEY_LEFT = 11;
int CaveKeyEventKEY_UP = 12;
int CaveKeyEventKEY_RIGHT = 13;
int CaveKeyEventKEY_DOWN = 14;
int CaveKeyEventKEY_INSERT = 15;
int CaveKeyEventKEY_DELETE = 16;
int CaveKeyEventKEY_HOME = 17;
int CaveKeyEventKEY_END = 18;
int CaveKeyEventKEY_PAGEUP = 19;
int CaveKeyEventKEY_PAGEDOWN = 20;
int CaveKeyEventKEY_F1 = 21;
int CaveKeyEventKEY_F2 = 22;
int CaveKeyEventKEY_F3 = 23;
int CaveKeyEventKEY_F4 = 24;
int CaveKeyEventKEY_F5 = 25;
int CaveKeyEventKEY_F6 = 26;
int CaveKeyEventKEY_F7 = 27;
int CaveKeyEventKEY_F8 = 28;
int CaveKeyEventKEY_F9 = 29;
int CaveKeyEventKEY_F10 = 30;
int CaveKeyEventKEY_F11 = 31;
int CaveKeyEventKEY_F12 = 32;
int CaveKeyEventKEY_SUPER = 33;
int CaveKeyEventKEY_BACK = 34;

@implementation CaveKeyEvent

{
	int action;
	int keyCode;
	NSString* stringValue;
	BOOL shift;
	BOOL control;
	BOOL command;
	BOOL alt;
}

- (CaveKeyEvent*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->isConsumed = FALSE;
	self->alt = FALSE;
	self->command = FALSE;
	self->control = FALSE;
	self->shift = FALSE;
	self->stringValue = nil;
	self->keyCode = 0;
	self->action = 0;
	return(self);
}

- (void) consume {
	self->isConsumed = TRUE;
}

- (BOOL) isKeyPress:(int)key {
	if(self->action == CaveKeyEventACTION_DOWN && self->keyCode == key) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isKey:(int)key {
	if(self->keyCode == key) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isString:(NSString*)value {
	if(({ NSString* _s1 = value; NSString* _s2 = self->stringValue; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) isCharacter:(int)value {
	if(!(({ NSString* _s1 = self->stringValue; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) && [CapeString getChar:self->stringValue index:0] == value) {
		return(TRUE);
	}
	return(FALSE);
}

- (void) clear {
	self->action = 0;
	self->keyCode = 0;
	self->stringValue = nil;
	self->isConsumed = FALSE;
}

- (int) getAction {
	return(self->action);
}

- (CaveKeyEvent*) setAction:(int)v {
	self->action = v;
	return(self);
}

- (int) getKeyCode {
	return(self->keyCode);
}

- (CaveKeyEvent*) setKeyCode:(int)v {
	self->keyCode = v;
	return(self);
}

- (NSString*) getStringValue {
	return(self->stringValue);
}

- (CaveKeyEvent*) setStringValue:(NSString*)v {
	self->stringValue = v;
	return(self);
}

- (BOOL) getShift {
	return(self->shift);
}

- (CaveKeyEvent*) setShift:(BOOL)v {
	self->shift = v;
	return(self);
}

- (BOOL) getControl {
	return(self->control);
}

- (CaveKeyEvent*) setControl:(BOOL)v {
	self->control = v;
	return(self);
}

- (BOOL) getCommand {
	return(self->command);
}

- (CaveKeyEvent*) setCommand:(BOOL)v {
	self->command = v;
	return(self);
}

- (BOOL) getAlt {
	return(self->alt);
}

- (CaveKeyEvent*) setAlt:(BOOL)v {
	self->alt = v;
	return(self);
}

@end
