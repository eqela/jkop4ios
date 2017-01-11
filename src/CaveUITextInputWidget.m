
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
#import "CaveUIWidgetWithValue.h"
#import "CaveGuiApplicationContext.h"
#import "CaveColor.h"
#import "CaveUIWidget.h"
#import "CapeString.h"
#import "CaveUITextInputWidget.h"

int CaveUITextInputWidgetTYPE_DEFAULT = 0;
int CaveUITextInputWidgetTYPE_NONASSISTED = 1;
int CaveUITextInputWidgetTYPE_NAME = 2;
int CaveUITextInputWidgetTYPE_EMAIL_ADDRESS = 3;
int CaveUITextInputWidgetTYPE_URL = 4;
int CaveUITextInputWidgetTYPE_PHONE_NUMBER = 5;
int CaveUITextInputWidgetTYPE_PASSWORD = 6;
int CaveUITextInputWidgetTYPE_INTEGER = 7;
int CaveUITextInputWidgetTYPE_FLOAT = 8;
int CaveUITextInputWidgetTYPE_STREET_ADDRESS = 9;

@implementation CaveUITextInputWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	int widgetType;
	NSString* widgetPlaceholder;
	NSString* widgetText;
	int widgetPaddingLeft;
	int widgetPaddingTop;
	int widgetPaddingRight;
	int widgetPaddingBottom;
	NSString* widgetFontFamily;
	double widgetFontSize;
	CaveColor* widgetTextColor;
	CaveColor* widgetBackgroundColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
	if(field == self) {
		[field resignFirstResponder];
	}
	return YES;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, widgetPaddingLeft, widgetPaddingTop);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, widgetPaddingLeft, widgetPaddingTop);
}

- (CaveUITextInputWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetPaddingBottom = 0;
	self->widgetPaddingRight = 0;
	self->widgetPaddingTop = 0;
	self->widgetPaddingLeft = 0;
	self->widgetText = nil;
	self->widgetPlaceholder = nil;
	self->widgetType = 0;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUITextInputWidget*) forType:(id<CaveGuiApplicationContext>)context type:(int)type placeholder:(NSString*)placeholder {
	CaveUITextInputWidget* v = [[CaveUITextInputWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetType:type];
	[v setWidgetPlaceholder:placeholder];
	return(v);
}

- (CaveUITextInputWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetPaddingBottom = 0;
	self->widgetPaddingRight = 0;
	self->widgetPaddingTop = 0;
	self->widgetPaddingLeft = 0;
	self->widgetText = nil;
	self->widgetPlaceholder = nil;
	self->widgetType = 0;
	self->widgetContext = nil;
	self.delegate = self;
	self.autocorrectionType = UITextAutocorrectionTypeNo;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self->widgetContext = context;
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = ((double)[context getHeightValue:@"3mm"]);
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	[self updateWidgetFont];
	[self updateWidgetPadding];
	[self updateWidgetColors];
	return(self);
}

- (CaveUITextInputWidget*) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	[self updateWidgetColors];
	return(self);
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (CaveUITextInputWidget*) setWidgetBackgroundColor:(CaveColor*)color {
	self->widgetBackgroundColor = color;
	[self updateWidgetColors];
	return(self);
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (void) updateWidgetColors {
	CaveColor* textColor = self->widgetTextColor;
	if(textColor == nil) {
		if(self->widgetBackgroundColor != nil) {
			if([self->widgetBackgroundColor isLightColor]) {
				textColor = [CaveColor black];
			}
			else {
				textColor = [CaveColor white];
			}
		}
		else {
			textColor = [CaveColor black];
		}
	}
	CaveColor* bgc = self->widgetBackgroundColor;
	if(bgc != nil) {
		self.backgroundColor = [bgc toUIColor];
	}
	else {
		self.backgroundColor = nil;
	}
	self.textColor = [textColor toUIColor];
}

- (CaveUITextInputWidget*) setWidgetType:(int)type {
	self->widgetType = type;
	if(self->widgetType == CaveUITextInputWidgetTYPE_DEFAULT) {
		[self setKeyboardType:UIKeyboardTypeDefault];
		[self setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
		[self setAutocorrectionType:UITextAutocorrectionTypeDefault];
		[self setSpellCheckingType:UITextSpellCheckingTypeDefault];
	}
	else {
		if(self->widgetType == CaveUITextInputWidgetTYPE_NONASSISTED) {
			[self setKeyboardType:UIKeyboardTypeDefault];
			[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
			[self setAutocorrectionType:UITextAutocorrectionTypeNo];
			[self setSpellCheckingType:UITextSpellCheckingTypeNo];
		}
		else {
			if(self->widgetType == CaveUITextInputWidgetTYPE_NAME) {
				[self setKeyboardType:UIKeyboardTypeDefault];
				[self setAutocapitalizationType:UITextAutocapitalizationTypeWords];
				[self setAutocorrectionType:UITextAutocorrectionTypeNo];
				[self setSpellCheckingType:UITextSpellCheckingTypeNo];
			}
			else {
				if(self->widgetType == CaveUITextInputWidgetTYPE_EMAIL_ADDRESS) {
					[self setKeyboardType:UIKeyboardTypeEmailAddress];
					[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
					[self setAutocorrectionType:UITextAutocorrectionTypeNo];
					[self setSpellCheckingType:UITextSpellCheckingTypeNo];
				}
				else {
					if(self->widgetType == CaveUITextInputWidgetTYPE_URL) {
						[self setKeyboardType:UIKeyboardTypeURL];
						[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
						[self setAutocorrectionType:UITextAutocorrectionTypeNo];
						[self setSpellCheckingType:UITextSpellCheckingTypeNo];
					}
					else {
						if(self->widgetType == CaveUITextInputWidgetTYPE_PHONE_NUMBER) {
							[self setKeyboardType:UIKeyboardTypePhonePad];
							[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
							[self setAutocorrectionType:UITextAutocorrectionTypeNo];
							[self setSpellCheckingType:UITextSpellCheckingTypeNo];
						}
						else {
							if(self->widgetType == CaveUITextInputWidgetTYPE_PASSWORD) {
								[self setKeyboardType:UIKeyboardTypeDefault];
								[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
								[self setAutocorrectionType:UITextAutocorrectionTypeNo];
								[self setSpellCheckingType:UITextSpellCheckingTypeNo];
								[self setSecureTextEntry:YES];
							}
							else {
								if(self->widgetType == CaveUITextInputWidgetTYPE_INTEGER) {
									[self setKeyboardType:UIKeyboardTypeNumberPad];
									[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
									[self setAutocorrectionType:UITextAutocorrectionTypeNo];
									[self setSpellCheckingType:UITextSpellCheckingTypeNo];
								}
								else {
									if(self->widgetType == CaveUITextInputWidgetTYPE_FLOAT) {
										[self setKeyboardType:UIKeyboardTypeDecimalPad];
										[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
										[self setAutocorrectionType:UITextAutocorrectionTypeNo];
										[self setSpellCheckingType:UITextSpellCheckingTypeNo];
									}
									else {
										if(self->widgetType == CaveUITextInputWidgetTYPE_STREET_ADDRESS) {
											[self setKeyboardType:UIKeyboardTypeDefault];
											[self setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
											[self setAutocorrectionType:UITextAutocorrectionTypeNo];
											[self setSpellCheckingType:UITextSpellCheckingTypeNo];
										}
										else {
											[self setKeyboardType:UIKeyboardTypeDefault];
											[self setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
											[self setAutocorrectionType:UITextAutocorrectionTypeDefault];
											[self setSpellCheckingType:UITextSpellCheckingTypeDefault];
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
	return(self);
}

- (int) getWidgetType {
	return(self->widgetType);
}

- (CaveUITextInputWidget*) setWidgetText:(NSString*)text {
	self->widgetText = text;
	[self setText:text];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (NSString*) getWidgetText {
	return([self text]);
}

- (CaveUITextInputWidget*) setWidgetPlaceholder:(NSString*)placeholder {
	self->widgetPlaceholder = placeholder;
	[self setPlaceholder:placeholder];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (NSString*) getWidgetPlaceholder {
	return(self->widgetPlaceholder);
}

- (void) setWidgetPaddingWithSignedInteger:(int)padding {
	[self setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:padding t:padding r:padding b:padding];
}

- (void) setWidgetPaddingWithSignedIntegerAndSignedInteger:(int)x y:(int)y {
	[self setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:x t:y r:x b:y];
}

- (CaveUITextInputWidget*) setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:(int)l t:(int)t r:(int)r b:(int)b {
	if(l < 0 || t < 0 || r < 0 || b < 0) {
		return(self);
	}
	if(self->widgetPaddingLeft == l && self->widgetPaddingTop == t && self->widgetPaddingRight == r && self->widgetPaddingBottom == b) {
		return(self);
	}
	self->widgetPaddingLeft = l;
	self->widgetPaddingTop = t;
	self->widgetPaddingRight = r;
	self->widgetPaddingBottom = b;
	[self updateWidgetPadding];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (void) updateWidgetPadding {
}

- (CaveUITextInputWidget*) setWidgetFontFamily:(NSString*)family {
	self->widgetFontFamily = family;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextInputWidget*) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (void) updateWidgetFont {
	[self setMinimumFontSize:widgetFontSize];
}

- (void) setWidgetValue:(id)value {
	[self setWidgetText:[CapeString asStringWithObject:value]];
}

- (id) getWidgetValue {
	return(((id)[self getWidgetText]));
}

@end
