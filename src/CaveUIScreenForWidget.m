
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
#import <objc/runtime.h>
#import "CaveScreenWithContext.h"
#import "CaveUIWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CaveKeyEvent.h"
#import "CaveKeyListener.h"
#import "CaveGuiApplicationContextForIOS.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUIScreenForWidget.h"

@implementation CaveUIScreenForWidget

{
	UIView* myWidget;
	int keyboardY;
	UIStatusBarStyle* statusBarStyle;
	NSUInteger* screenOrientation;
	CaveKeyEvent* keyEvent;
}

- (NSUInteger)supportedInterfaceOrientations {
	return(self->screenOrientation);
}
- (BOOL)shouldAutorotate {
	return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return(self->statusBarStyle);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}
- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillHide:(NSNotification *)note
{
	self->keyboardY = 0;
	[self updateContentViewSize];
}
- (void)keyboardWillShow:(NSNotification *)note
{
	NSDictionary *userInfo = note.userInfo;
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self->keyboardY = keyboardFrame.origin.y;
	[self updateContentViewSize];
}

+ (CaveUIScreenForWidget*) findScreenForWidget:(UIView*)widget {
	return(((CaveUIScreenForWidget*)({ id _v = [CaveUIWidget findScreen:widget]; [_v isKindOfClass:[CaveUIScreenForWidget class]] ? _v : nil; })));
}

- (CaveUIScreenForWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->keyEvent = nil;
	self->screenOrientation = UIInterfaceOrientationMaskAll;
	self->statusBarStyle = UIStatusBarStyleDefault;
	self->keyboardY = 0;
	self->myWidget = nil;
	self->context = nil;
	[self onPrepareScreen];
	return(self);
}

- (void) loadView {
	self.view = [[UIView alloc] init];
	[self initialize];
}

- (void) viewDidLayoutSubviews {
	[self updateContentViewSize];
}

- (void) enableDefaultStatusBarStyle {
	statusBarStyle = UIStatusBarStyleDefault;
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void) enableLightStatusBarStyle {
	statusBarStyle = UIStatusBarStyleLightContent;
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void) updateContentViewSize {
	if(self->keyboardY > 0) {
		self.view.subviews[0].frame = CGRectMake(0, 0, self.view.frame.size.width, self->keyboardY);
	}
	else {
		self.view.subviews[0].frame = self.view.frame;
	}
}

- (void) onBackKeyPressEvent {
	if(self->keyEvent == nil) {
		self->keyEvent = [[CaveKeyEvent alloc] init];
	}
	[self->keyEvent clear];
	[self->keyEvent setAction:CaveKeyEventACTION_DOWN];
	[self->keyEvent setKeyCode:CaveKeyEventKEY_BACK];
	[self deliverKeyEventToWidget:self->keyEvent widget:[self getWidget]];
}

- (void) deliverKeyEventToWidget:(CaveKeyEvent*)event widget:(UIView*)widget {
	if(widget == nil) {
		return;
	}
	NSMutableArray* array = [CaveUIWidget getChildren:widget];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			UIView* child = ((UIView*)[array objectAtIndex:n]);
			if(child != nil) {
				[self deliverKeyEventToWidget:event widget:child];
				if(event->isConsumed) {
					return;
				}
			}
		}
	}
	id<CaveKeyListener> kl = ((id<CaveKeyListener>)({ id _v = widget; [((NSObject*)_v) conformsToProtocol:@protocol(CaveKeyListener)] ? _v : nil; }));
	if(kl != nil) {
		[kl onKeyEvent:event];
		if(event->isConsumed) {
			return;
		}
	}
}

- (void) unlockOrientation {
	self->screenOrientation = UIInterfaceOrientationMaskAll;
}

- (void) lockToLandscapeOrientation {
	self->screenOrientation = UIInterfaceOrientationMaskLandscapeLeft;
}

- (void) lockToPortraitOrientation {
	self->screenOrientation = UIInterfaceOrientationMaskPortrait;
}

- (void) setContext:(id<CaveGuiApplicationContext>)context {
	self->context = context;
}

- (id<CaveGuiApplicationContext>) getContext {
	return(self->context);
}

- (id<CaveGuiApplicationContext>) createContext {
	id<CaveGuiApplicationContext> v = nil;
	v = ((id<CaveGuiApplicationContext>)[[CaveGuiApplicationContextForIOS alloc] init]);
	return(v);
}

- (void) onPrepareScreen {
}

- (void) initialize {
	if(self->context == nil) {
		self->context = [self createContext];
	}
}

- (void) cleanup {
}

- (UIView*) getWidget {
	return(self->myWidget);
}

- (void) setWidget:(CaveUICustomContainerWidget*)widget {
	if(self->myWidget != nil) {
		NSLog(@"%@", @"[cave.ui.ScreenForWidget.setWidget] (ScreenForWidget.sling:376:2): Nultiple calls to setWidget()");
		return;
	}
	if(widget == nil) {
		return;
	}
	self->myWidget = ((UIView*)widget);
	[widget setAllowResize:FALSE];
	[self.view addSubview:widget];
	[widget tryInitializeWidget];
	[widget setScreenForWidget:((UIViewController*)self)];
	[CaveUIWidget onWidgetAddedToParent:((UIView*)widget)];
	[CaveUIWidget notifyOnAddedToScreen:((UIView*)widget) screen:self];
}

@end
