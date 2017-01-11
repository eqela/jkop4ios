
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
#import "CaveUILayerWidget.h"
#import "CaveUITextInputWidget.h"
#import "CaveGuiApplicationContext.h"
#import "CapeDynamicVector.h"
#import "CapeStringBuilder.h"
#import "CapeString.h"
#import "CaveUIWidgetWithValue.h"
#import "CaveColor.h"
#import "CaveUILabelWidget.h"
#import "CaveUICustomContainerWidget.h"
#import "CaveUICanvasWidget.h"
#import "CaveUIFormDeclaration.h"
#import "CaveUIAlignWidget.h"
#import "CapeDynamicMap.h"
#import "CaveUITextButtonWidget.h"
#import "CaveUIWidget.h"
#import "CaveUISelectWidget.h"
#import "CaveUITextAreaWidget.h"
#import "CaveUIDateSelectorWidget.h"
#import "CaveUIVerticalBoxWidget.h"
#import "CaveUIHorizontalBoxWidget.h"
#import "CaveUIVerticalScrollerWidget.h"
#import "CapeMap.h"
#import "CaveUIFormWidget.h"

@class CaveUIFormWidgetAction;
@class CaveUIFormWidgetMyStringListInputWidget;
@class CaveUIFormWidgetStaticTextWidget;

@interface CaveUIFormWidgetAction : NSObject
{
	@public NSString* label;
	@public void (^handler)(void);
}
- (CaveUIFormWidgetAction*) init;
@end

@implementation CaveUIFormWidgetAction

- (CaveUIFormWidgetAction*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->handler = nil;
	self->label = nil;
	return(self);
}

@end

@interface CaveUIFormWidgetMyStringListInputWidget : CaveUITextInputWidget
- (CaveUIFormWidgetMyStringListInputWidget*) init;
- (CaveUIFormWidgetMyStringListInputWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (void) setWidgetValue:(id)value;
- (id) getWidgetValue;
@end

@implementation CaveUIFormWidgetMyStringListInputWidget

- (CaveUIFormWidgetMyStringListInputWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

- (CaveUIFormWidgetMyStringListInputWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	if([super initWithGuiApplicationContext:context] == nil) {
		return(nil);
	}
	return(self);
}

- (void) setWidgetValue:(id)value {
	CapeDynamicVector* vv = ((CapeDynamicVector*)({ id _v = value; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; }));
	if(vv == nil) {
		return;
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSMutableArray* array = [vv toVector];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* v = ((NSString*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
			if(v != nil) {
				if([sb count] > 0) {
					[sb appendString:@", "];
				}
				[sb appendString:v];
			}
		}
	}
	[self setWidgetText:[sb toString]];
}

- (id) getWidgetValue {
	CapeDynamicVector* v = [[CapeDynamicVector alloc] init];
	NSMutableArray* array = [CapeString split:[self getWidgetText] delim:',' max:0];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* _x_string = ((NSString*)[array objectAtIndex:n]);
			if(_x_string != nil) {
				[v appendObject:((id)[CapeString strip:_x_string])];
			}
		}
	}
	return(((id)v));
}

@end

@interface CaveUIFormWidgetStaticTextWidget : CaveUILayerWidget <CaveUIWidgetWithValue>
- (CaveUIFormWidgetStaticTextWidget*) init;
+ (CaveUIFormWidgetStaticTextWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text;
- (CaveUIFormWidgetStaticTextWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context;
- (void) initializeWidget;
- (void) setWidgetValue:(id)value;
- (id) getWidgetValue;
- (CaveColor*) getBackgroundColor;
- (CaveUIFormWidgetStaticTextWidget*) setBackgroundColor:(CaveColor*)v;
- (CaveColor*) getTextColor;
- (CaveUIFormWidgetStaticTextWidget*) setTextColor:(CaveColor*)v;
@end

@implementation CaveUIFormWidgetStaticTextWidget

{
	CaveColor* backgroundColor;
	CaveColor* textColor;
	CaveUILabelWidget* label;
}

- (CaveUIFormWidgetStaticTextWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->label = nil;
	self->textColor = nil;
	self->backgroundColor = nil;
	return(self);
}

+ (CaveUIFormWidgetStaticTextWidget*) forText:(id<CaveGuiApplicationContext>)context text:(NSString*)text {
	CaveUIFormWidgetStaticTextWidget* v = [[CaveUIFormWidgetStaticTextWidget alloc] initWithGuiApplicationContext:context];
	[v setWidgetValue:((id)text)];
	return(v);
}

- (CaveUIFormWidgetStaticTextWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	self->label = nil;
	self->textColor = nil;
	self->backgroundColor = nil;
	if([super initWithGuiApplicationContext:context] == nil) {
		return(nil);
	}
	return(self);
}

- (void) initializeWidget {
	[super initializeWidget];
	self->label = [[CaveUILabelWidget alloc] initWithGuiApplicationContext:self->context];
	CaveColor* color = self->textColor;
	if(color == nil) {
		if([self->backgroundColor isLightColor]) {
			color = [CaveColor forRGB:0 g:0 b:0];
		}
		else {
			color = [CaveColor forRGB:255 g:255 b:255];
		}
	}
	[self->label setWidgetTextColor:color];
	[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->backgroundColor])];
	[self addWidget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)self->label) margin:[self->context getHeightValue:@"1500um"]])];
}

- (void) setWidgetValue:(id)value {
	if(self->label != nil) {
		[self->label setWidgetText:[CapeString asStringWithObject:value]];
	}
}

- (id) getWidgetValue {
	if(self->label == nil) {
		return(nil);
	}
	return(((id)[self->label getWidgetText]));
}

- (CaveColor*) getBackgroundColor {
	return(self->backgroundColor);
}

- (CaveUIFormWidgetStaticTextWidget*) setBackgroundColor:(CaveColor*)v {
	self->backgroundColor = v;
	return(self);
}

- (CaveColor*) getTextColor {
	return(self->textColor);
}

- (CaveUIFormWidgetStaticTextWidget*) setTextColor:(CaveColor*)v {
	self->textColor = v;
	return(self);
}

@end

@implementation CaveUIFormWidget

{
	CaveUIFormDeclaration* formDeclaration;
	NSMutableDictionary* fieldsById;
	NSMutableArray* actions;
	int elementSpacing;
	int formMargin;
	CaveUIAlignWidget* alignWidget;
	BOOL enableFieldLabels;
	int formWidth;
	int fieldLabelFontSize;
	CaveUILayerWidget* customFooterWidget;
	CapeDynamicMap* queueData;
	CaveColor* widgetBackgroundColor;
	BOOL enableScrolling;
	BOOL fillContainerWidget;
}

- (CaveUIFormWidget*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->fillContainerWidget = FALSE;
	self->enableScrolling = TRUE;
	self->widgetBackgroundColor = nil;
	self->queueData = nil;
	self->customFooterWidget = nil;
	self->fieldLabelFontSize = 0;
	self->formWidth = 0;
	self->enableFieldLabels = TRUE;
	self->alignWidget = nil;
	self->formMargin = 0;
	self->elementSpacing = 0;
	self->actions = nil;
	self->fieldsById = nil;
	self->formDeclaration = nil;
	return(self);
}

+ (CaveUIFormWidget*) forDeclaration:(id<CaveGuiApplicationContext>)context form:(CaveUIFormDeclaration*)form {
	CaveUIFormWidget* v = [[CaveUIFormWidget alloc] initWithGuiApplicationContext:context];
	[v setFormDeclaration:form];
	return(v);
}

- (CaveUIFormWidget*) initWithGuiApplicationContext:(id<CaveGuiApplicationContext>)context {
	self->fillContainerWidget = FALSE;
	self->enableScrolling = TRUE;
	self->widgetBackgroundColor = nil;
	self->queueData = nil;
	self->customFooterWidget = nil;
	self->fieldLabelFontSize = 0;
	self->formWidth = 0;
	self->enableFieldLabels = TRUE;
	self->alignWidget = nil;
	self->formMargin = 0;
	self->elementSpacing = 0;
	self->actions = nil;
	self->fieldsById = nil;
	self->formDeclaration = nil;
	if([super initWithGuiApplicationContext:context] == nil) {
		return(nil);
	}
	self->fieldsById = [[NSMutableDictionary alloc] init];
	self->formMargin = [context getHeightValue:@"1mm"];
	self->formWidth = [context getWidthValue:@"120mm"];
	self->fieldLabelFontSize = [context getHeightValue:@"2000um"];
	self->elementSpacing = self->formMargin;
	self->customFooterWidget = [[CaveUILayerWidget alloc] initWithGuiApplicationContext:context];
	self->widgetBackgroundColor = [CaveColor forString:@"#EEEEEE"];
	return(self);
}

- (CaveUILayerWidget*) getCustomFooterWidget {
	return(self->customFooterWidget);
}

- (CaveUIFormDeclaration*) getFormDeclaration {
	return(self->formDeclaration);
}

- (CaveUIFormWidget*) setFormDeclaration:(CaveUIFormDeclaration*)value {
	self->formDeclaration = value;
	return(self);
}

- (void) addActions {
}

- (void) addAction:(NSString*)label handler:(void(^)(void))handler {
	if(({ NSString* _s1 = label; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return;
	}
	if(self->actions == nil) {
		self->actions = [[NSMutableArray alloc] init];
	}
	CaveUIFormWidgetAction* v = [[CaveUIFormWidgetAction alloc] init];
	v->label = label;
	v->handler = handler;
	[self->actions addObject:v];
}

- (void) setStyleForTextInputWidget:(CaveUITextInputWidget*)widget {
	[widget setWidgetBackgroundColor:[CaveColor white]];
	[widget setWidgetPaddingWithSignedInteger:[self->context getHeightValue:@"1500um"]];
	[widget setWidgetFontSize:((double)[self->context getHeightValue:@"3000um"])];
}

- (void) setStyleForTextButtonWidget:(CaveUITextButtonWidget*)widget {
	[widget setWidgetBackgroundColor:[CaveColor forString:@"blue"]];
	[CaveUIWidget setAlpha:((UIView*)widget) alpha:0.9];
}

- (void) setStyleForSelectWidget:(CaveUISelectWidget*)widget {
	[widget setWidgetBackgroundColor:[CaveColor white]];
	[widget setWidgetPadding:[self->context getHeightValue:@"1500um"]];
	[widget setWidgetFontSize:((double)[self->context getHeightValue:@"3000um"])];
}

- (void) setStyleForTextAreaWidget:(CaveUITextAreaWidget*)widget {
	[widget setWidgetBackgroundColor:[CaveColor white]];
	[widget setWidgetPaddingWithSignedInteger:[self->context getHeightValue:@"1500um"]];
	[widget setWidgetFontSize:((double)[self->context getHeightValue:@"3000um"])];
}

- (void) setStyleForWidget:(UIView*)widget {
	if([widget isKindOfClass:[CaveUITextInputWidget class]]) {
		[self setStyleForTextInputWidget:((CaveUITextInputWidget*)widget)];
	}
	else {
		if([widget isKindOfClass:[CaveUITextButtonWidget class]]) {
			[self setStyleForTextButtonWidget:((CaveUITextButtonWidget*)widget)];
		}
		else {
			if([widget isKindOfClass:[CaveUISelectWidget class]]) {
				[self setStyleForSelectWidget:((CaveUISelectWidget*)widget)];
			}
			else {
				if([widget isKindOfClass:[CaveUITextAreaWidget class]]) {
					[self setStyleForTextAreaWidget:((CaveUITextAreaWidget*)widget)];
				}
				else {
					NSMutableArray* array = [CaveUIWidget getChildren:widget];
					if(array != nil) {
						int n = 0;
						int m = [array count];
						for(n = 0 ; n < m ; n++) {
							UIView* child = ((UIView*)[array objectAtIndex:n]);
							if(child != nil) {
								[self setStyleForWidget:child];
							}
						}
					}
				}
			}
		}
	}
}

- (NSString*) asPlaceHolder:(NSString*)str {
	if(self->enableFieldLabels) {
		return(nil);
	}
	return(str);
}

- (CaveColor*) getBackgroundColorForElement:(CaveUIFormDeclarationElement*)element {
	if([element isKindOfClass:[CaveUIFormDeclarationGroup class]]) {
		return([CaveColor black]);
	}
	return([CaveColor white]);
}

- (CaveColor*) getForegroundColorForElement:(CaveUIFormDeclarationElement*)element {
	return(nil);
}

- (CaveColor*) getAdjustedForegroundColor:(CaveUIFormDeclarationElement*)element backgroundColor:(CaveColor*)backgroundColor {
	CaveColor* v = [self getForegroundColorForElement:element];
	if(v != nil) {
		return(v);
	}
	if(backgroundColor == nil) {
		return([CaveColor black]);
	}
	if([backgroundColor isWhite]) {
		return([CaveColor forRGB:100 g:100 b:100]);
	}
	if([backgroundColor isDarkColor]) {
		return([CaveColor white]);
	}
	return([CaveColor black]);
}

- (UIView*) createWidgetForElement:(CaveUIFormDeclarationElement*)element {
	if(element == nil) {
		return(nil);
	}
	if([element isKindOfClass:[CaveUIFormDeclarationDynamicElement class]]) {
		NSLog(@"%@", @"[cave.ui.FormWidget.createWidgetForElement] (FormWidget.sling:289:2): FIXME: DynamicElement");
	}
	else {
		if([element isKindOfClass:[CaveUIFormDeclarationTextInput class]]) {
			CaveUIFormDeclarationTextInput* ti = ((CaveUIFormDeclarationTextInput*)element);
			return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_DEFAULT placeholder:[self asPlaceHolder:[ti getLabel]]]));
		}
		else {
			if([element isKindOfClass:[CaveUIFormDeclarationRawTextInput class]]) {
				CaveUIFormDeclarationRawTextInput* ti = ((CaveUIFormDeclarationRawTextInput*)element);
				return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_NONASSISTED placeholder:[self asPlaceHolder:[ti getLabel]]]));
			}
			else {
				if([element isKindOfClass:[CaveUIFormDeclarationPasswordInput class]]) {
					CaveUIFormDeclarationPasswordInput* ti = ((CaveUIFormDeclarationPasswordInput*)element);
					return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_PASSWORD placeholder:[self asPlaceHolder:[ti getLabel]]]));
				}
				else {
					if([element isKindOfClass:[CaveUIFormDeclarationNameInput class]]) {
						CaveUIFormDeclarationNameInput* ti = ((CaveUIFormDeclarationNameInput*)element);
						return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_NAME placeholder:[self asPlaceHolder:[ti getLabel]]]));
					}
					else {
						if([element isKindOfClass:[CaveUIFormDeclarationEmailAddressInput class]]) {
							CaveUIFormDeclarationEmailAddressInput* ti = ((CaveUIFormDeclarationEmailAddressInput*)element);
							return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_EMAIL_ADDRESS placeholder:[self asPlaceHolder:[ti getLabel]]]));
						}
						else {
							if([element isKindOfClass:[CaveUIFormDeclarationPhoneNumberInput class]]) {
								CaveUIFormDeclarationPhoneNumberInput* ti = ((CaveUIFormDeclarationPhoneNumberInput*)element);
								return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_PHONE_NUMBER placeholder:[self asPlaceHolder:[ti getLabel]]]));
							}
							else {
								if([element isKindOfClass:[CaveUIFormDeclarationStreetAddressInput class]]) {
									CaveUIFormDeclarationStreetAddressInput* ti = ((CaveUIFormDeclarationStreetAddressInput*)element);
									return(((UIView*)[CaveUITextInputWidget forType:self->context type:CaveUITextInputWidgetTYPE_STREET_ADDRESS placeholder:[self asPlaceHolder:[ti getLabel]]]));
								}
								else {
									if([element isKindOfClass:[CaveUIFormDeclarationTextAreaInput class]]) {
										CaveUIFormDeclarationTextAreaInput* ta = ((CaveUIFormDeclarationTextAreaInput*)element);
										return(((UIView*)[CaveUITextAreaWidget forPlaceholder:self->context placeholder:[self asPlaceHolder:[ta getLabel]] rows:[ta getRows]]));
									}
									else {
										if([element isKindOfClass:[CaveUIFormDeclarationCodeInput class]]) {
											CaveUIFormDeclarationTextAreaInput* ta = ((CaveUIFormDeclarationTextAreaInput*)element);
											CaveUITextAreaWidget* v = [CaveUITextAreaWidget forPlaceholder:self->context placeholder:[self asPlaceHolder:[ta getLabel]] rows:[ta getRows]];
											[v configureMonospaceFont];
											return(((UIView*)v));
										}
										else {
											if([element isKindOfClass:[CaveUIFormDeclarationStaticTextElement class]]) {
												CaveUIFormDeclarationStaticTextElement* ti = ((CaveUIFormDeclarationStaticTextElement*)element);
												CaveUIFormWidgetStaticTextWidget* st = [CaveUIFormWidgetStaticTextWidget forText:self->context text:[ti getLabel]];
												CaveColor* bgc = [self getBackgroundColorForElement:((CaveUIFormDeclarationElement*)ti)];
												CaveColor* fgc = [self getAdjustedForegroundColor:((CaveUIFormDeclarationElement*)ti) backgroundColor:bgc];
												[st setBackgroundColor:bgc];
												[st setTextColor:fgc];
												return(((UIView*)st));
											}
											else {
												if([element isKindOfClass:[CaveUIFormDeclarationMultipleChoiceInput class]]) {
													CaveUIFormDeclarationMultipleChoiceInput* si = ((CaveUIFormDeclarationMultipleChoiceInput*)element);
													return(((UIView*)[CaveUISelectWidget forKeyValueList:self->context options:[si getValues]]));
												}
												else {
													if([element isKindOfClass:[CaveUIFormDeclarationDateInput class]]) {
														CaveUIFormDeclarationDateInput* ds = ((CaveUIFormDeclarationDateInput*)element);
														CaveUIDateSelectorWidget* v = [CaveUIDateSelectorWidget forContext:self->context];
														[v setSkipYears:[ds getSkipYears]];
														return(((UIView*)v));
													}
													else {
														if([element isKindOfClass:[CaveUIFormDeclarationStringListInput class]]) {
															CaveUIFormDeclarationStringListInput* ti = ((CaveUIFormDeclarationStringListInput*)element);
															CaveUIFormWidgetMyStringListInputWidget* v = [[CaveUIFormWidgetMyStringListInputWidget alloc] initWithGuiApplicationContext:self->context];
															[v setWidgetPlaceholder:[ti getLabel]];
															return(((UIView*)v));
														}
														else {
															if([element isKindOfClass:[CaveUIFormDeclarationContainer class]]) {
																CaveUICustomContainerWidget* v = nil;
																if([element isKindOfClass:[CaveUIFormDeclarationVerticalContainer class]]) {
																	CaveUIVerticalBoxWidget* vb = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
																	if(self->formWidth > 0) {
																		[vb setWidgetWidthRequest:self->formWidth];
																	}
																	[vb setWidgetSpacing:self->elementSpacing];
																	v = ((CaveUICustomContainerWidget*)vb);
																}
																else {
																	if([element isKindOfClass:[CaveUIFormDeclarationHorizontalContainer class]]) {
																		CaveUIHorizontalBoxWidget* hb = [CaveUIHorizontalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
																		[hb setWidgetSpacing:self->elementSpacing];
																		v = ((CaveUICustomContainerWidget*)hb);
																	}
																	else {
																		if([element isKindOfClass:[CaveUIFormDeclarationGroup class]]) {
																			CaveUIFormDeclarationGroup* g = ((CaveUIFormDeclarationGroup*)element);
																			CaveUIVerticalBoxWidget* vb = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
																			if(self->formWidth > 0) {
																				[vb setWidgetWidthRequest:self->formWidth];
																			}
																			[vb setWidgetSpacing:self->elementSpacing];
																			CaveUILayerWidget* wlayer = [CaveUILayerWidget forContext:self->context];
																			CaveColor* bgc = [self getBackgroundColorForElement:((CaveUIFormDeclarationElement*)g)];
																			[wlayer addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
																			CaveUILabelWidget* groupLabel = [CaveUILabelWidget forText:self->context text:[g getLabel]];
																			[groupLabel setWidgetTextColor:[self getAdjustedForegroundColor:((CaveUIFormDeclarationElement*)g) backgroundColor:bgc]];
																			[wlayer addWidget:((UIView*)[CaveUILayerWidget forWidget:self->context widget:((UIView*)groupLabel) margin:[self->context getHeightValue:@"2mm"]])];
																			[vb addWidget:((UIView*)wlayer) weight:0.0];
																			v = ((CaveUICustomContainerWidget*)vb);
																		}
																		else {
																			if([element isKindOfClass:[CaveUIFormDeclarationTab class]]) {
																				NSLog(@"%@", @"[cave.ui.FormWidget.createWidgetForElement] (FormWidget.sling:387:3): FIXME");
																				return(nil);
																			}
																			else {
																				NSLog(@"%@", @"[cave.ui.FormWidget.createWidgetForElement] (FormWidget.sling:391:3): Unsupported form declaration container encountered.");
																				return(nil);
																			}
																		}
																	}
																}
																NSMutableArray* array = [((CaveUIFormDeclarationContainer*)element) getChildren];
																if(array != nil) {
																	int n = 0;
																	int m = [array count];
																	for(n = 0 ; n < m ; n++) {
																		CaveUIFormDeclarationElement* child = ((CaveUIFormDeclarationElement*)[array objectAtIndex:n]);
																		if(child != nil) {
																			UIView* ww = [self createAndRegisterWidget:child];
																			if(ww != nil) {
																				if(self->enableFieldLabels && [child isKindOfClass:[CaveUIFormDeclarationInputElement class]]) {
																					CaveUILayerWidget* wlayer = [CaveUILayerWidget forContext:self->context];
																					CaveColor* bgc = [self getBackgroundColorForElement:child];
																					[wlayer addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:bgc])];
																					CaveUIVerticalBoxWidget* wbox = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
																					NSString* txt = [((CaveUIFormDeclarationInputElement*)child) getLabel];
																					if([CapeString isEmpty:txt] == FALSE) {
																						CaveUILabelWidget* lw = [CaveUILabelWidget forText:self->context text:txt];
																						[lw setWidgetTextColor:[self getAdjustedForegroundColor:child backgroundColor:bgc]];
																						[lw setWidgetFontSize:((double)self->fieldLabelFontSize)];
																						int ss = [self->context getHeightValue:@"1mm"];
																						[wbox addWidget:((UIView*)[[[[CaveUILayerWidget forWidget:self->context widget:((UIView*)lw) margin:0] setWidgetMarginLeft:ss] setWidgetMarginRight:ss] setWidgetMarginTop:ss]) weight:0.0];
																					}
																					[wbox addWidget:ww weight:[child getWeight]];
																					[wlayer addWidget:((UIView*)wbox)];
																					[self addToContainerWithWeight:v child:((UIView*)wlayer) weight:[child getWeight]];
																				}
																				else {
																					[self addToContainerWithWeight:v child:ww weight:[child getWeight]];
																				}
																			}
																		}
																	}
																}
																return(((UIView*)v));
															}
															else {
																NSLog(@"%@", @"[cave.ui.FormWidget.createWidgetForElement] (FormWidget.sling:425:2): FIXME");
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
					}
				}
			}
		}
	}
	return(nil);
}

- (void) addToContainerWithWeight:(CaveUICustomContainerWidget*)container child:(UIView*)child weight:(double)weight {
	if(weight <= 0.0) {
		[container addWidget:child];
	}
	else {
		if([container isKindOfClass:[CaveUIHorizontalBoxWidget class]]) {
			[((CaveUIHorizontalBoxWidget*)container) addWidget:child weight:weight];
		}
		else {
			if([container isKindOfClass:[CaveUIVerticalBoxWidget class]]) {
				[((CaveUIVerticalBoxWidget*)container) addWidget:child weight:weight];
			}
			else {
				NSLog(@"%@", @"[cave.ui.FormWidget.addToContainerWithWeight] (FormWidget.sling:442:2): Tried to add a widget with weight to a container that is not a box. Ignoring weight.");
				[container addWidget:child];
			}
		}
	}
}

- (UIView*) createAndRegisterWidget:(CaveUIFormDeclarationElement*)element {
	UIView* v = [self createWidgetForElement:element];
	if(v == nil) {
		return(nil);
	}
	[self setStyleForWidget:v];
	NSString* _x_id = [element getId];
	if([CapeString isEmpty:_x_id] == FALSE) {
		({ id _v = v; id _o = self->fieldsById; id _k = _x_id; _v == nil ? [_o removeObjectForKey:_k] : [_o setObject:_v forKey:_k]; });
	}
	return(v);
}

- (void) computeWidgetLayout:(int)widthConstraint {
	if(self->alignWidget != nil) {
		if(widthConstraint >= [self->context getWidthValue:@"120mm"]) {
			[self->alignWidget setAlignForIndex:0 alignX:0.5 alignY:0.5];
		}
		else {
			[self->alignWidget setAlignForIndex:0 alignX:0.5 alignY:((double)0)];
		}
	}
	[super computeWidgetLayout:widthConstraint];
}

- (void) initializeWidget {
	[super initializeWidget];
	CaveUIFormDeclaration* declaration = [self getFormDeclaration];
	if(declaration == nil) {
		return;
	}
	CaveUIFormDeclarationContainer* root = [declaration getRoot];
	if(root == nil) {
		return;
	}
	if(self->widgetBackgroundColor != nil) {
		[self addWidget:((UIView*)[CaveUICanvasWidget forColor:self->context color:self->widgetBackgroundColor])];
	}
	CaveUIVerticalBoxWidget* box = [CaveUIVerticalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
	[box setWidgetMargin:self->formMargin];
	[box setWidgetSpacing:self->formMargin];
	UIView* topWidget = [self createAndRegisterWidget:((CaveUIFormDeclarationElement*)root)];
	if(topWidget != nil) {
		[box addWidget:topWidget weight:1.0];
	}
	if(self->queueData != nil) {
		[self setFormData:self->queueData];
	}
	if(self->actions == nil) {
		[self addActions];
	}
	if(self->actions != nil) {
		CaveUIHorizontalBoxWidget* hbox = [CaveUIHorizontalBoxWidget forContext:self->context widgetMargin:0 widgetSpacing:0];
		[hbox setWidgetSpacing:[self->context getHeightValue:@"1mm"]];
		if(self->actions != nil) {
			int n = 0;
			int m = [self->actions count];
			for(n = 0 ; n < m ; n++) {
				CaveUIFormWidgetAction* action = ((CaveUIFormWidgetAction*)[self->actions objectAtIndex:n]);
				if(action != nil) {
					CaveUITextButtonWidget* button = [CaveUITextButtonWidget forText:self->context text:action->label handler:action->handler];
					[self setStyleForTextButtonWidget:button];
					[hbox addWidget:((UIView*)button) weight:((double)1)];
				}
			}
		}
		[box addWidget:((UIView*)hbox) weight:0.0];
	}
	[box addWidget:((UIView*)self->customFooterWidget) weight:0.0];
	UIView* finalWidget = nil;
	if(self->fillContainerWidget) {
		finalWidget = ((UIView*)box);
	}
	else {
		self->alignWidget = [CaveUIAlignWidget forWidget:self->context widget:((UIView*)box) alignX:0.5 alignY:0.5 margin:0];
		finalWidget = ((UIView*)self->alignWidget);
	}
	if(self->enableScrolling) {
		CaveUIVerticalScrollerWidget* scroller = [CaveUIVerticalScrollerWidget forWidget:self->context widget:finalWidget];
		[self addWidget:((UIView*)scroller)];
	}
	else {
		[self addWidget:finalWidget];
	}
}

- (void) setFormData:(CapeDynamicMap*)data {
	if([CapeMap count:self->fieldsById] < 1) {
		self->queueData = data;
	}
	else {
		NSMutableArray* keys = [CapeMap getKeys:self->fieldsById];
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					id value = nil;
					if(data != nil) {
						value = [data get:key];
					}
					[self setFieldData:key value:value];
				}
			}
		}
	}
}

- (void) setFieldData:(NSString*)_x_id value:(id)value {
	id<CaveUIWidgetWithValue> widget = ((id<CaveUIWidgetWithValue>)({ id _v = [CapeMap getMapAndDynamic:self->fieldsById key:((id)_x_id)]; [((NSObject*)_v) conformsToProtocol:@protocol(CaveUIWidgetWithValue)] ? _v : nil; }));
	if(widget == nil) {
		return;
	}
	[widget setWidgetValue:value];
}

- (void) getFormDataTo:(CapeDynamicMap*)data {
	if(data == nil) {
		return;
	}
	NSMutableArray* keys = [CapeMap getKeys:self->fieldsById];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				id<CaveUIWidgetWithValue> widget = ((id<CaveUIWidgetWithValue>)({ id _v = [CapeMap getMapAndDynamic:self->fieldsById key:((id)key)]; [((NSObject*)_v) conformsToProtocol:@protocol(CaveUIWidgetWithValue)] ? _v : nil; }));
				if(widget == nil) {
					continue;
				}
				[data setStringAndObject:key value:[widget getWidgetValue]];
			}
		}
	}
}

- (CapeDynamicMap*) getFormData {
	CapeDynamicMap* v = [[CapeDynamicMap alloc] init];
	[self getFormDataTo:v];
	return(v);
}

- (void) clearFormData {
	CapeDynamicMap* clearData = [[CapeDynamicMap alloc] init];
	NSMutableArray* keys = [CapeMap getKeys:self->fieldsById];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				[clearData setStringAndObject:key value:nil];
			}
		}
	}
	[self setFormData:clearData];
}

- (int) getElementSpacing {
	return(self->elementSpacing);
}

- (CaveUIFormWidget*) setElementSpacing:(int)v {
	self->elementSpacing = v;
	return(self);
}

- (int) getFormMargin {
	return(self->formMargin);
}

- (CaveUIFormWidget*) setFormMargin:(int)v {
	self->formMargin = v;
	return(self);
}

- (BOOL) getEnableFieldLabels {
	return(self->enableFieldLabels);
}

- (CaveUIFormWidget*) setEnableFieldLabels:(BOOL)v {
	self->enableFieldLabels = v;
	return(self);
}

- (int) getFormWidth {
	return(self->formWidth);
}

- (CaveUIFormWidget*) setFormWidth:(int)v {
	self->formWidth = v;
	return(self);
}

- (int) getFieldLabelFontSize {
	return(self->fieldLabelFontSize);
}

- (CaveUIFormWidget*) setFieldLabelFontSize:(int)v {
	self->fieldLabelFontSize = v;
	return(self);
}

- (CaveColor*) getWidgetBackgroundColor {
	return(self->widgetBackgroundColor);
}

- (CaveUIFormWidget*) setWidgetBackgroundColor:(CaveColor*)v {
	self->widgetBackgroundColor = v;
	return(self);
}

- (BOOL) getEnableScrolling {
	return(self->enableScrolling);
}

- (CaveUIFormWidget*) setEnableScrolling:(BOOL)v {
	self->enableScrolling = v;
	return(self);
}

- (BOOL) getFillContainerWidget {
	return(self->fillContainerWidget);
}

- (CaveUIFormWidget*) setFillContainerWidget:(BOOL)v {
	self->fillContainerWidget = v;
	return(self);
}

@end
