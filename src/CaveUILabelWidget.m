
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
#import "CaveUIWidget.h"
#import "CapeString.h"
#import "CaveUILabelWidget.h"

int CaveUILabelWidgetALIGN_LEFT = 0;
int CaveUILabelWidgetALIGN_CENTER = 1;
int CaveUILabelWidgetALIGN_RIGHT = 2;
int CaveUILabelWidgetALIGN_JUSTIFY = 3;

@implementation CaveUILabelWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetText;
	CaveColor* widgetTextColor;
	double widgetFontSize;
	BOOL widgetFontBold;
	NSString* widgetFontFamily;
	int widgetTextAlign;
}

- (CaveUILabelWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetTextAlign = 0;
	self->widgetFontFamily = nil;
	self->widgetFontBold = FALSE;
	self->widgetFontSize = 0.0;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUILabelWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text {
	CaveUILabelWidget* v = [[CaveUILabelWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetText:text];
	return(v);
}

- (CaveUILabelWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetTextAlign = 0;
	self->widgetFontFamily = nil;
	self->widgetFontBold = FALSE;
	self->widgetFontSize = 0.0;
	self->widgetTextColor = nil;
	self->widgetText = nil;
	self->widgetContext = nil;
	self->widgetContext = context;
	[self setWidgetTextColor:[CaveColor forRGB:0 g:0 b:0]];
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = ((double)[context getHeightValue:@"3mm"]);
	self->widgetFontBold = FALSE;
	[self setNumberOfLines:0];
	[self setTextAlignment:UITextAlignmentLeft];
	[self updateWidgetFont];
	return(self);
}

- (CaveUILabelWidget*) setWidgetText:(NSString*)text {
	self->widgetText = text;
	if(({ NSString* _s1 = self->widgetText; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		self->widgetText = @"";
	}
	[self setText:widgetText];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (NSString*) getWidgetText {
	return(self->widgetText);
}

- (CaveUILabelWidget*) setWidgetTextAlign:(int)align {
	self->widgetTextAlign = align;
	if(align == CaveUILabelWidgetALIGN_LEFT) {
		[self setTextAlignment:UITextAlignmentLeft];
	}
	else {
		if(align == CaveUILabelWidgetALIGN_CENTER) {
			[self setTextAlignment:UITextAlignmentCenter];
		}
		else {
			if(align == CaveUILabelWidgetALIGN_RIGHT) {
				[self setTextAlignment:UITextAlignmentRight];
			}
			else {
				if(align == CaveUILabelWidgetALIGN_JUSTIFY) {
					[self setTextAlignment:NSTextAlignmentJustified];
				}
				else {
					[self setTextAlignment:UITextAlignmentLeft];
				}
			}
		}
	}
	return(self);
}

- (int) getWidgetTextAlign {
	return(self->widgetTextAlign);
}

- (CaveUILabelWidget*) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	[self updateWidgetFont];
	return(self);
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (CaveUILabelWidget*) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	[self updateWidgetFont];
	return(self);
}

- (double) getFontSize {
	return(self->widgetFontSize);
}

- (CaveUILabelWidget*) setWidgetFontBold:(BOOL)bold {
	self->widgetFontBold = bold;
	[self updateWidgetFont];
	return(self);
}

- (CaveUILabelWidget*) setWidgetFontFamily:(NSString*)font {
	self->widgetFontFamily = font;
	[self updateWidgetFont];
	return(self);
}

- (void) updateWidgetFont {
	NSString* ff = self->widgetFontFamily;
	if([CapeString isEmpty:ff]) {
		ff = @"Arial";
	}
	if(self->widgetFontBold) {
		if(({ NSString* _s1 = ff; NSString* _s2 = @"Arial"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			ff = @"Arial-BoldMT";
		}
		else {
			if(({ NSString* _s1 = ff; NSString* _s2 = @"Helvetica"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				ff = @"Helvetica-Bold";
			}
			else {
				if(({ NSString* _s1 = ff; NSString* _s2 = @"Georgia"; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					ff = @"Georgia-Bold";
				}
			}
		}
	}
	[self setFont:[UIFont fontWithName:ff size:widgetFontSize]];
	if(self->widgetTextColor != nil) {
		[self setTextColor:[widgetTextColor toUIColor]];
	}
	else {
		[self setTextColor:nil];
	}
	[CaveUIWidget onChanged:((UIView*)self)];
}

@end
