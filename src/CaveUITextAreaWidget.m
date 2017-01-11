
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
#import "CaveUITextAreaWidget.h"

@implementation CaveUITextAreaWidget

{
	id<CaveGuiApplicationContext> widgetContext;
	NSString* widgetPlaceholder;
	int widgetPaddingLeft;
	int widgetPaddingTop;
	int widgetPaddingRight;
	int widgetPaddingBottom;
	int widgetRows;
	CaveColor* widgetTextColor;
	CaveColor* widgetBackgroundColor;
	NSString* widgetFontFamily;
	double widgetFontSize;
}

- (CaveUITextAreaWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetRows = 0;
	self->widgetPaddingBottom = 0;
	self->widgetPaddingRight = 0;
	self->widgetPaddingTop = 0;
	self->widgetPaddingLeft = 0;
	self->widgetPlaceholder = nil;
	self->widgetContext = nil;
	return(self);
}

+ (CaveUITextAreaWidget*) forPlaceholder:(id<CaveGuiApplicationContext>)context placeholder:(NSString*)placeholder rows:(int)rows {
	CaveUITextAreaWidget* v = [[CaveUITextAreaWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetPlaceholder:placeholder];
	[v setWidgetRows:rows];
	return(v);
}

- (CaveUITextAreaWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super init] == nil) {
		return(nil);
	}
	self->widgetFontSize = 0.0;
	self->widgetFontFamily = nil;
	self->widgetBackgroundColor = nil;
	self->widgetTextColor = nil;
	self->widgetRows = 0;
	self->widgetPaddingBottom = 0;
	self->widgetPaddingRight = 0;
	self->widgetPaddingTop = 0;
	self->widgetPaddingLeft = 0;
	self->widgetPlaceholder = nil;
	self->widgetContext = nil;
	self->widgetFontFamily = @"Arial";
	self->widgetFontSize = ((double)[context getHeightValue:@"3mm"]);
	self->widgetTextColor = nil;
	self->widgetBackgroundColor = nil;
	self->widgetContext = context;
	[self updateWidgetFont];
	[self updateWidgetPadding];
	[self updateWidgetColors];
	return(self);
}

- (void) configureMonospaceFont {
	[self setWidgetFontFamily:@"monospace"];
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

- (void) updateWidgetFont {
	NSLog(@"%@", @"[cave.ui.TextAreaWidget.updateWidgetFont] (TextAreaWidget.sling:163:2): Not implemented");
}

- (CaveUITextAreaWidget*) setWidgetFontFamily:(NSString*)family {
	self->widgetFontFamily = family;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextAreaWidget*) setWidgetFontSize:(double)fontSize {
	self->widgetFontSize = fontSize;
	[self updateWidgetFont];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextAreaWidget*) setWidgetTextColor:(CaveColor*)color {
	self->widgetTextColor = color;
	[self updateWidgetColors];
	return(self);
}

- (CaveColor*) getWidgetTextColor {
	return(self->widgetTextColor);
}

- (CaveUITextAreaWidget*) setWidgetBackgroundColor:(CaveColor*)color {
	self->widgetBackgroundColor = color;
	[self updateWidgetColors];
	return(self);
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveUITextAreaWidget*) setWidgetRows:(int)row {
	self->widgetRows = row;
	NSLog(@"%@", @"[cave.ui.TextAreaWidget.setWidgetRows] (TextAreaWidget.sling:229:2): Not implemented");
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextAreaWidget*) setWidgetText:(NSString*)text {
	[self setText:text];
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextAreaWidget*) setWidgetPlaceholder:(NSString*)placeholder {
	self->widgetPlaceholder = placeholder;
	NSLog(@"%@", @"[cave.ui.TextAreaWidget.setWidgetPlaceholder] (TextAreaWidget.sling:271:2): Not implemented");
	[CaveUIWidget onChanged:((UIView*)self)];
	return(self);
}

- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedInteger:(int)padding {
	return([self setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:padding t:padding r:padding b:padding]);
}

- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedIntegerAndSignedInteger:(int)lr tb:(int)tb {
	return([self setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:lr t:tb r:lr b:tb]);
}

- (CaveUITextAreaWidget*) setWidgetPaddingWithSignedIntegerAndSignedIntegerAndSignedIntegerAndSignedInteger:(int)l t:(int)t r:(int)r b:(int)b {
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
	return(self);
}

- (void) updateWidgetPadding {
	NSLog(@"%@", @"[cave.ui.TextAreaWidget.updateWidgetPadding] (TextAreaWidget.sling:317:2): Not implemented");
}

- (NSString*) getWidgetText {
	return([self text]);
}

- (NSString*) getWidgetPlaceholder {
	return(self->widgetPlaceholder);
}

- (CaveUITextAreaWidget*) setWidgetFontStyle:(NSString*)resName {
	NSLog(@"%@", @"[cave.ui.TextAreaWidget.setWidgetFontStyle] (TextAreaWidget.sling:353:2): Not implemented");
	return(self);
}

- (void) setWidgetValue:(id)value {
	[self setWidgetText:[CapeString asStringWithObject:value]];
}

- (id) getWidgetValue {
	return(((id)[self getWidgetText]));
}

@end
