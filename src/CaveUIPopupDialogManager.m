
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
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUILayerWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUILabelWidget.h"
#import "CaveUIVerticalBoxWidget.h"
#import "CaveUIAlignWidget.h"
#import "CaveUITextInputWidget.h"
#import "CaveUIHorizontalBoxWidget.h"
#import "CaveUITextButtonWidget.h"
#import "CaveUIPopupWidget.h"
#import "CaveUIPopupDialogManager.h"

@implementation CaveUIPopupDialogManager

{
	id<CaveGuiApplicationContext> context;
	UIView* parent;
	CaveColor* backgroundColor;
	CaveColor* headerBackgroundColor;
	CaveColor* headerTextColor;
	CaveColor* messageTextColor;
	CaveColor* positiveButtonColor;
	CaveColor* negativeButtonColor;
}

- (CaveUIPopupDialogManager*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->negativeButtonColor = nil;
	self->positiveButtonColor = nil;
	self->messageTextColor = nil;
	self->headerTextColor = nil;
	self->headerBackgroundColor = nil;
	self->backgroundColor = nil;
	self->parent = nil;
	self->context = nil;
	return(self);
}

- (CaveUIPopupDialogManager*) initWithGuiApplicationContextAndUIView:(id<CaveGuiApplicationContext>)context parent:(UIView*)parent {
	if([super init] == nil) {
		return(nil);
	}
	self->negativeButtonColor = nil;
	self->positiveButtonColor = nil;
	self->messageTextColor = nil;
	self->headerTextColor = nil;
	self->headerBackgroundColor = nil;
	self->backgroundColor = nil;
	self->parent = nil;
	self->context = nil;
	self->context = context;
	self->parent = parent;
	self->positiveButtonColor = [CaveColor forRGB:128 g:204 b:128];
	self->negativeButtonColor = [CaveColor forRGB:204 g:128 b:128];
	self->backgroundColor = nil;
	self->headerBackgroundColor = nil;
	self->headerTextColor = nil;
	self->messageTextColor = nil;
	return(self);
}

- (CaveUIPopupDialogManager*) setButtonColor:(CaveColor*)color {
	self->positiveButtonColor = color;
	self->negativeButtonColor = color;
	return(self);
}

- (void) showTextInputDialog:(NSString*)title prompt:(NSString*)prompt callback:(void(^)(NSString*))callback {
	[self checkForDefaultColors];
	int mm2 = [self->context getWidthValue:@"2mm"];
	int mm3 = [self->context getWidthValue:@"3mm"];
	CaveUILayerWidget* widget = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	[widget setWidgetWidthRequest:[self->context getWidthValue:@"100mm"]];
	[widget addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->backgroundColor])];
	CaveUILabelWidget* titleLabel = [CaveUILabelWidget forText:self->context text:title];
	[titleLabel setWidgetFontSize:((double)mm3)];
	[titleLabel setWidgetTextColor:self->headerTextColor];
	[titleLabel setWidgetFontBold:TRUE];
	CaveUIVerticalBoxWidget* box = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[box addWidget:((UIView*)[[[[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context] addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->headerBackgroundColor])] addWidget:((UIView*)[[CaveUIAlignWidget forWidget:self->context widget:((UIView*)titleLabel) alignX:((double)0) alignY:0.5 margin:0] setWidgetMargin:mm3])]) weight:0.0];
	CaveUIVerticalBoxWidget* sbox = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[sbox setWidgetMargin:mm3];
	[sbox setWidgetSpacing:mm3];
	CaveUILabelWidget* messageLabel = [CaveUILabelWidget forText:self->context text:prompt];
	[messageLabel setWidgetTextAlign:CaveUILabelWidgetALIGN_CENTER];
	[messageLabel setWidgetFontSize:((double)mm3)];
	[messageLabel setWidgetTextColor:self->messageTextColor];
	[sbox addWidget:((UIView*)messageLabel) weight:0.0];
	CaveUITextInputWidget* input = [[CaveUITextInputWidget alloc] initWithGuiApplicationContext:self->context];
	[input setWidgetBackgroundColor:[CaveColor forRGB:200 g:200 b:200]];
	[input setWidgetPaddingWithSignedInteger:[self->context getHeightValue:@"2mm"]];
	[input setWidgetFontSize:((double)[self->context getHeightValue:@"3000um"])];
	[sbox addWidget:((UIView*)input) weight:0.0];
	CaveUIHorizontalBoxWidget* buttons = [[CaveUIHorizontalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[buttons setWidgetSpacing:mm3];
	CaveUITextButtonWidget* noButton = [CaveUITextButtonWidget forText:self->context text:@"Cancel" handler:nil];
	[noButton setWidgetBackgroundColor:self->positiveButtonColor];
	[buttons addWidget:((UIView*)noButton) weight:1.0];
	CaveUITextButtonWidget* yesButton = [CaveUITextButtonWidget forText:self->context text:@"OK" handler:nil];
	[yesButton setWidgetBackgroundColor:self->positiveButtonColor];
	[buttons addWidget:((UIView*)yesButton) weight:1.0];
	[sbox addWidget:((UIView*)buttons) weight:0.0];
	[box addWidget:((UIView*)sbox) weight:0.0];
	[widget addWidget:((UIView*)box)];
	CaveUIPopupWidget* pp = [CaveUIPopupWidget forContentWidget:self->context widget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)widget) margin:mm2])];
	void (^cb)(NSString*) = callback;
	[pp showPopup:self->parent];
	[yesButton setWidgetClickHandler:^void() {
		[pp hidePopup];
		if(cb != nil) {
			cb([input getWidgetText]);
		}
	}];
	[noButton setWidgetClickHandler:^void() {
		[pp hidePopup];
		if(cb != nil) {
			cb(nil);
		}
	}];
}

- (void) showMessageDialog:(NSString*)title message:(NSString*)message callback:(void(^)(void))callback {
	[self checkForDefaultColors];
	int mm2 = [self->context getWidthValue:@"2mm"];
	int mm3 = [self->context getWidthValue:@"3mm"];
	CaveUILayerWidget* widget = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	[widget setWidgetWidthRequest:[self->context getWidthValue:@"100mm"]];
	[widget addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor white]])];
	CaveUILabelWidget* titleLabel = [CaveUILabelWidget forText:self->context text:title];
	[titleLabel setWidgetFontSize:((double)mm3)];
	[titleLabel setWidgetTextColor:[CaveColor white]];
	[titleLabel setWidgetFontBold:TRUE];
	CaveUIVerticalBoxWidget* box = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[box addWidget:((UIView*)[[[[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context] addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor black]])] addWidget:((UIView*)[[CaveUIAlignWidget forWidget:self->context widget:((UIView*)titleLabel) alignX:((double)0) alignY:0.5 margin:0] setWidgetMargin:mm3])]) weight:0.0];
	CaveUIVerticalBoxWidget* sbox = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[sbox setWidgetMargin:mm3];
	[sbox setWidgetSpacing:mm3];
	CaveUILabelWidget* messageLabel = [CaveUILabelWidget forText:self->context text:message];
	[messageLabel setWidgetTextAlign:CaveUILabelWidgetALIGN_CENTER];
	[messageLabel setWidgetFontSize:((double)mm3)];
	[messageLabel setWidgetTextColor:self->messageTextColor];
	[sbox addWidget:((UIView*)messageLabel) weight:0.0];
	CaveUIHorizontalBoxWidget* buttons = [[CaveUIHorizontalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[buttons setWidgetSpacing:mm3];
	CaveUITextButtonWidget* okButton = [CaveUITextButtonWidget forText:self->context text:@"OK" handler:nil];
	[okButton setWidgetBackgroundColor:self->positiveButtonColor];
	[buttons addWidget:((UIView*)okButton) weight:1.0];
	[sbox addWidget:((UIView*)buttons) weight:0.0];
	[box addWidget:((UIView*)sbox) weight:0.0];
	[widget addWidget:((UIView*)box)];
	CaveUIPopupWidget* pp = [CaveUIPopupWidget forContentWidget:self->context widget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)widget) margin:mm2])];
	void (^cb)(void) = callback;
	[pp showPopup:self->parent];
	[okButton setWidgetClickHandler:^void() {
		[pp hidePopup];
		if(cb != nil) {
			cb();
		}
	}];
}

- (void) showConfirmDialog:(NSString*)title message:(NSString*)message okcallback:(void(^)(void))okcallback cancelcallback:(void(^)(void))cancelcallback {
	[self checkForDefaultColors];
	int mm2 = [self->context getWidthValue:@"2mm"];
	int mm3 = [self->context getWidthValue:@"3mm"];
	CaveUILayerWidget* widget = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context];
	[widget setWidgetWidthRequest:[self->context getWidthValue:@"100mm"]];
	[widget addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:[CaveColor white]])];
	CaveUILabelWidget* titleLabel = [CaveUILabelWidget forText:self->context text:title];
	[titleLabel setWidgetFontSize:((double)mm3)];
	[titleLabel setWidgetTextColor:self->headerTextColor];
	[titleLabel setWidgetFontBold:TRUE];
	CaveUIVerticalBoxWidget* box = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[box addWidget:((UIView*)[[[[CaveUILayerWidget alloc] initWithGuiApplicationContext:self->context] addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->headerBackgroundColor])] addWidget:((UIView*)[[CaveUIAlignWidget forWidget:self->context widget:((UIView*)titleLabel) alignX:((double)0) alignY:0.5 margin:0] setWidgetMargin:mm3])]) weight:0.0];
	CaveUIVerticalBoxWidget* sbox = [[CaveUIVerticalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[sbox setWidgetMargin:mm3];
	[sbox setWidgetSpacing:mm3];
	CaveUILabelWidget* messageLabel = [CaveUILabelWidget forText:self->context text:message];
	[messageLabel setWidgetTextAlign:CaveUILabelWidgetALIGN_CENTER];
	[messageLabel setWidgetFontSize:((double)mm3)];
	[messageLabel setWidgetTextColor:self->messageTextColor];
	[sbox addWidget:((UIView*)messageLabel) weight:0.0];
	CaveUIHorizontalBoxWidget* buttons = [[CaveUIHorizontalBoxWidget alloc] initWithGuiApplicationContext:self->context];
	[buttons setWidgetSpacing:mm3];
	CaveUITextButtonWidget* noButton = [CaveUITextButtonWidget forText:self->context text:@"NO" handler:nil];
	[noButton setWidgetBackgroundColor:self->positiveButtonColor];
	[buttons addWidget:((UIView*)noButton) weight:1.0];
	CaveUITextButtonWidget* yesButton = [CaveUITextButtonWidget forText:self->context text:@"YES" handler:nil];
	[yesButton setWidgetBackgroundColor:self->positiveButtonColor];
	[buttons addWidget:((UIView*)yesButton) weight:1.0];
	[sbox addWidget:((UIView*)buttons) weight:0.0];
	[box addWidget:((UIView*)sbox) weight:0.0];
	[widget addWidget:((UIView*)box)];
	CaveUIPopupWidget* pp = [CaveUIPopupWidget forContentWidget:self->context widget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)widget) margin:mm2])];
	void (^okcb)(void) = okcallback;
	void (^cancelcb)(void) = cancelcallback;
	[pp showPopup:self->parent];
	[yesButton setWidgetClickHandler:^void() {
		[pp hidePopup];
		if(okcb != nil) {
			okcb();
		}
	}];
	[noButton setWidgetClickHandler:^void() {
		[pp hidePopup];
		if(cancelcb != nil) {
			cancelcb();
		}
	}];
}

- (void) showErrorDialog:(NSString*)message callback:(void(^)(void))callback {
	[self showMessageDialog:@"Error" message:message callback:callback];
}

- (void) checkForDefaultColors {
	CaveColor* bgc = self->backgroundColor;
	if(bgc == nil) {
		self->backgroundColor = [CaveColor white];
	}
	CaveColor* hbg = self->headerBackgroundColor;
	if(hbg == nil) {
		self->headerBackgroundColor = [CaveColor black];
	}
	CaveColor* htc = self->headerTextColor;
	if(htc == nil) {
		if([self->headerBackgroundColor isDarkColor]) {
			self->headerTextColor = [CaveColor white];
		}
		else {
			self->headerTextColor = [CaveColor black];
		}
	}
	CaveColor* mtc = self->messageTextColor;
	if(mtc == nil) {
		if([self->backgroundColor isDarkColor]) {
			self->messageTextColor = [CaveColor white];
		}
		else {
			self->messageTextColor = [CaveColor black];
		}
	}
}

- (id<CaveGuiApplicationContext>) getContext {
	return(self->context);
}

- (CaveUIPopupDialogManager*) setContext:(id<CaveGuiApplicationContext>)v {
	self->context = v;
	return(self);
}

- (UIView*) getParent {
	return(self->parent);
}

- (CaveUIPopupDialogManager*) setParent:(UIView*)v {
	self->parent = v;
	return(self);
}

- (CaveColor*) getBackgroundColor {
	return(self->backgroundColor);
}

- (CaveUIPopupDialogManager*) setBackgroundColor:(CaveColor*)v {
	self->backgroundColor = v;
	return(self);
}

- (CaveColor*) getHeaderBackgroundColor {
	return(self->headerBackgroundColor);
}

- (CaveUIPopupDialogManager*) setHeaderBackgroundColor:(CaveColor*)v {
	self->headerBackgroundColor = v;
	return(self);
}

- (CaveColor*) getHeaderTextColor {
	return(self->headerTextColor);
}

- (CaveUIPopupDialogManager*) setHeaderTextColor:(CaveColor*)v {
	self->headerTextColor = v;
	return(self);
}

- (CaveColor*) getMessageTextColor {
	return(self->messageTextColor);
}

- (CaveUIPopupDialogManager*) setMessageTextColor:(CaveColor*)v {
	self->messageTextColor = v;
	return(self);
}

- (CaveColor*) getPositiveButtonColor {
	return(self->positiveButtonColor);
}

- (CaveUIPopupDialogManager*) setPositiveButtonColor:(CaveColor*)v {
	self->positiveButtonColor = v;
	return(self);
}

- (CaveColor*) getNegativeButtonColor {
	return(self->negativeButtonColor);
}

- (CaveUIPopupDialogManager*) setNegativeButtonColor:(CaveColor*)v {
	self->negativeButtonColor = v;
	return(self);
}

@end
