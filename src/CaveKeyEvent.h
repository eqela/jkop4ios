
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

extern int CaveKeyEventACTION_NONE;
extern int CaveKeyEventACTION_DOWN;
extern int CaveKeyEventACTION_UP;
extern int CaveKeyEventKEY_NONE;
extern int CaveKeyEventKEY_SPACE;
extern int CaveKeyEventKEY_ENTER;
extern int CaveKeyEventKEY_TAB;
extern int CaveKeyEventKEY_ESCAPE;
extern int CaveKeyEventKEY_BACKSPACE;
extern int CaveKeyEventKEY_SHIFT;
extern int CaveKeyEventKEY_CONTROL;
extern int CaveKeyEventKEY_ALT;
extern int CaveKeyEventKEY_CAPSLOCK;
extern int CaveKeyEventKEY_NUMLOCK;
extern int CaveKeyEventKEY_LEFT;
extern int CaveKeyEventKEY_UP;
extern int CaveKeyEventKEY_RIGHT;
extern int CaveKeyEventKEY_DOWN;
extern int CaveKeyEventKEY_INSERT;
extern int CaveKeyEventKEY_DELETE;
extern int CaveKeyEventKEY_HOME;
extern int CaveKeyEventKEY_END;
extern int CaveKeyEventKEY_PAGEUP;
extern int CaveKeyEventKEY_PAGEDOWN;
extern int CaveKeyEventKEY_F1;
extern int CaveKeyEventKEY_F2;
extern int CaveKeyEventKEY_F3;
extern int CaveKeyEventKEY_F4;
extern int CaveKeyEventKEY_F5;
extern int CaveKeyEventKEY_F6;
extern int CaveKeyEventKEY_F7;
extern int CaveKeyEventKEY_F8;
extern int CaveKeyEventKEY_F9;
extern int CaveKeyEventKEY_F10;
extern int CaveKeyEventKEY_F11;
extern int CaveKeyEventKEY_F12;
extern int CaveKeyEventKEY_SUPER;
extern int CaveKeyEventKEY_BACK;

@interface CaveKeyEvent : NSObject
{
	@public BOOL isConsumed;
}
- (CaveKeyEvent*) init;
- (void) consume;
- (BOOL) isKeyPress:(int)key;
- (BOOL) isKey:(int)key;
- (BOOL) isString:(NSString*)value;
- (BOOL) isCharacter:(int)value;
- (void) clear;
- (int) getAction;
- (CaveKeyEvent*) setAction:(int)v;
- (int) getKeyCode;
- (CaveKeyEvent*) setKeyCode:(int)v;
- (NSString*) getStringValue;
- (CaveKeyEvent*) setStringValue:(NSString*)v;
- (BOOL) getShift;
- (CaveKeyEvent*) setShift:(BOOL)v;
- (BOOL) getControl;
- (CaveKeyEvent*) setControl:(BOOL)v;
- (BOOL) getCommand;
- (CaveKeyEvent*) setCommand:(BOOL)v;
- (BOOL) getAlt;
- (CaveKeyEvent*) setAlt:(BOOL)v;
@end
