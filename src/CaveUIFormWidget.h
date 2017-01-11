
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
#import <UIKit/UIKit.h>
#import "CaveUILayerWidget.h"

@class CaveUIFormWidgetAction;
@class CaveUITextInputWidget;
@class CaveUIFormWidgetMyStringListInputWidget;
@protocol CaveGuiApplicationContext;
@protocol CaveUIWidgetWithValue;
@class CaveUIFormWidgetStaticTextWidget;
@class CaveColor;
@class CaveUILabelWidget;
@class CaveUIFormDeclaration;
@class CaveUIAlignWidget;
@class CapeDynamicMap;
@class CaveUITextButtonWidget;
@class CaveUISelectWidget;
@class CaveUITextAreaWidget;
@class CaveUIFormDeclarationElement;
@class CaveUICustomContainerWidget;

@interface CaveUIFormWidget : CaveUILayerWidget
- (CaveUIFormWidget*) init;
+ (CaveUIFormWidget*) forDeclaration:(id<CaveGuiApplicationContext>)context form:(CaveUIFormDeclaration*)form;
- (CaveUIFormWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (CaveUILayerWidget*) getCustomFooterWidget;
- (CaveUIFormDeclaration*) getFormDeclaration;
- (CaveUIFormWidget*) setFormDeclaration:(CaveUIFormDeclaration*)value;
- (void) addActions;
- (void) addAction:(NSString*)label handler:(void(^)(void))handler;
- (void) setStyleForTextInputWidget:(CaveUITextInputWidget*)widget;
- (void) setStyleForTextButtonWidget:(CaveUITextButtonWidget*)widget;
- (void) setStyleForSelectWidget:(CaveUISelectWidget*)widget;
- (void) setStyleForTextAreaWidget:(CaveUITextAreaWidget*)widget;
- (void) setStyleForWidget:(UIView*)widget;
- (NSString*) asPlaceHolder:(NSString*)str;
- (CaveColor*) getBackgroundColorForElement:(CaveUIFormDeclarationElement*)element;
- (CaveColor*) getForegroundColorForElement:(CaveUIFormDeclarationElement*)element;
- (CaveColor*) getAdjustedForegroundColor:(CaveUIFormDeclarationElement*)element backgroundColor:(CaveColor*)backgroundColor;
- (UIView*) createWidgetForElement:(CaveUIFormDeclarationElement*)element;
- (void) addToContainerWithWeight:(CaveUICustomContainerWidget*)container child:(UIView*)child weight:(double)weight;
- (UIView*) createAndRegisterWidget:(CaveUIFormDeclarationElement*)element;
- (void) computeWidgetLayout:(int)widthConstraint;
- (void) initializeWidget;
- (void) setFormData:(CapeDynamicMap*)data;
- (void) setFieldData:(NSString*)_x_id value:(id)value;
- (void) getFormDataTo:(CapeDynamicMap*)data;
- (CapeDynamicMap*) getFormData;
- (void) clearFormData;
- (int) getElementSpacing;
- (CaveUIFormWidget*) setElementSpacing:(int)v;
- (int) getFormMargin;
- (CaveUIFormWidget*) setFormMargin:(int)v;
- (BOOL) getEnableFieldLabels;
- (CaveUIFormWidget*) setEnableFieldLabels:(BOOL)v;
- (int) getFormWidth;
- (CaveUIFormWidget*) setFormWidth:(int)v;
- (int) getFieldLabelFontSize;
- (CaveUIFormWidget*) setFieldLabelFontSize:(int)v;
- (CaveColor*) getWidgetBackgroundColor;
- (CaveUIFormWidget*) setWidgetBackgroundColor:(CaveColor*)v;
- (BOOL) getEnableScrolling;
- (CaveUIFormWidget*) setEnableScrolling:(BOOL)v;
- (BOOL) getFillContainerWidget;
- (CaveUIFormWidget*) setFillContainerWidget:(BOOL)v;
@end
