
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

@class CaveUIFormDeclarationElement;
@class CaveUIFormDeclarationInputElement;
@class CaveUIFormDeclarationDynamicElement;
@class CapeDynamicMap;
@class CaveUIFormDeclarationContainer;
@class CaveUIFormDeclarationGroup;
@class CaveUIFormDeclarationTab;
@class CaveUIFormDeclarationVerticalContainer;
@class CaveUIFormDeclarationHorizontalContainer;
@class CaveUIFormDeclarationTextInput;
@class CaveUIFormDeclarationRawTextInput;
@class CaveUIFormDeclarationPasswordInput;
@class CaveUIFormDeclarationNameInput;
@class CaveUIFormDeclarationEmailAddressInput;
@class CaveUIFormDeclarationPhoneNumberInput;
@class CaveUIFormDeclarationStreetAddressInput;
@class CaveUIFormDeclarationWithIconInput;
@class CaveImage;
@class CaveUIFormDeclarationPhotoCaptureInput;
@class CaveUIFormDeclarationRadioGroupInput;
@class CaveUIFormDeclarationMultipleChoiceInput;
@class CapeKeyValueList;
@class CaveUIFormDeclarationDateInput;
@class CaveUIFormDeclarationTextAreaInput;
@class CaveUIFormDeclarationCodeInput;
@class CaveUIFormDeclarationStaticTextElement;
@class CaveUIFormDeclarationStringListInput;
@class CapeStack;
@class CaveUIFormDeclaration;

@interface CaveUIFormDeclarationElement : NSObject
- (CaveUIFormDeclarationElement*) init;
- (NSString*) getId;
- (CaveUIFormDeclarationElement*) setId:(NSString*)v;
- (double) getWeight;
- (CaveUIFormDeclarationElement*) setWeight:(double)v;
@end

@interface CaveUIFormDeclarationInputElement : CaveUIFormDeclarationElement
- (CaveUIFormDeclarationInputElement*) init;
- (NSString*) getLabel;
- (CaveUIFormDeclarationInputElement*) setLabel:(NSString*)v;
- (NSString*) getDescription;
- (CaveUIFormDeclarationInputElement*) setDescription:(NSString*)v;
@end

@interface CaveUIFormDeclarationDynamicElement : CaveUIFormDeclarationElement
- (CaveUIFormDeclarationDynamicElement*) init;
- (NSString*) getType;
- (CaveUIFormDeclarationDynamicElement*) setType:(NSString*)v;
- (CapeDynamicMap*) getProperties;
- (CaveUIFormDeclarationDynamicElement*) setProperties:(CapeDynamicMap*)v;
@end

@interface CaveUIFormDeclarationContainer : CaveUIFormDeclarationElement
- (CaveUIFormDeclarationContainer*) init;
- (void) addToChildren:(CaveUIFormDeclarationElement*)element;
- (NSMutableArray*) getChildren;
- (CaveUIFormDeclarationContainer*) setChildren:(NSMutableArray*)v;
@end

@interface CaveUIFormDeclarationGroup : CaveUIFormDeclarationContainer
- (CaveUIFormDeclarationGroup*) init;
- (NSString*) getLabel;
- (CaveUIFormDeclarationGroup*) setLabel:(NSString*)v;
- (NSString*) getDescription;
- (CaveUIFormDeclarationGroup*) setDescription:(NSString*)v;
@end

@interface CaveUIFormDeclarationTab : CaveUIFormDeclarationContainer
- (CaveUIFormDeclarationTab*) init;
- (NSString*) getLabel;
- (CaveUIFormDeclarationTab*) setLabel:(NSString*)v;
@end

@interface CaveUIFormDeclarationVerticalContainer : CaveUIFormDeclarationContainer
- (CaveUIFormDeclarationVerticalContainer*) init;
@end

@interface CaveUIFormDeclarationHorizontalContainer : CaveUIFormDeclarationContainer
- (CaveUIFormDeclarationHorizontalContainer*) init;
@end

@interface CaveUIFormDeclarationTextInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationTextInput*) init;
@end

@interface CaveUIFormDeclarationRawTextInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationRawTextInput*) init;
@end

@interface CaveUIFormDeclarationPasswordInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationPasswordInput*) init;
@end

@interface CaveUIFormDeclarationNameInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationNameInput*) init;
@end

@interface CaveUIFormDeclarationEmailAddressInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationEmailAddressInput*) init;
@end

@interface CaveUIFormDeclarationPhoneNumberInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationPhoneNumberInput*) init;
@end

@interface CaveUIFormDeclarationStreetAddressInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationStreetAddressInput*) init;
@end

@interface CaveUIFormDeclarationWithIconInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationWithIconInput*) init;
- (CaveImage*) getIcon;
- (CaveUIFormDeclarationWithIconInput*) setIcon:(CaveImage*)v;
- (void(^)(void)) getAction;
- (CaveUIFormDeclarationWithIconInput*) setAction:(void(^)(void))v;
@end

@interface CaveUIFormDeclarationPhotoCaptureInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationPhotoCaptureInput*) init;
- (CaveImage*) getDefaultImage;
- (CaveUIFormDeclarationPhotoCaptureInput*) setDefaultImage:(CaveImage*)v;
@end

@interface CaveUIFormDeclarationRadioGroupInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationRadioGroupInput*) init;
- (NSMutableArray*) getItems;
- (CaveUIFormDeclarationRadioGroupInput*) setItems:(NSMutableArray*)v;
- (NSString*) getGroupName;
- (CaveUIFormDeclarationRadioGroupInput*) setGroupName:(NSString*)v;
@end

@interface CaveUIFormDeclarationMultipleChoiceInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationMultipleChoiceInput*) init;
- (CapeKeyValueList*) getValues;
- (CaveUIFormDeclarationMultipleChoiceInput*) setValues:(CapeKeyValueList*)v;
@end

@interface CaveUIFormDeclarationDateInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationDateInput*) init;
- (int) getSkipYears;
- (CaveUIFormDeclarationDateInput*) setSkipYears:(int)v;
@end

@interface CaveUIFormDeclarationTextAreaInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationTextAreaInput*) init;
- (int) getRows;
- (CaveUIFormDeclarationTextAreaInput*) setRows:(int)v;
@end

@interface CaveUIFormDeclarationCodeInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationCodeInput*) init;
- (int) getRows;
- (CaveUIFormDeclarationCodeInput*) setRows:(int)v;
@end

@interface CaveUIFormDeclarationStaticTextElement : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationStaticTextElement*) init;
@end

@interface CaveUIFormDeclarationStringListInput : CaveUIFormDeclarationInputElement
- (CaveUIFormDeclarationStringListInput*) init;
@end

@interface CaveUIFormDeclaration : NSObject
- (CaveUIFormDeclaration*) init;
- (CaveUIFormDeclarationContainer*) getRoot;
- (CaveUIFormDeclarationElement*) addElement:(CaveUIFormDeclarationElement*)element;
- (CaveUIFormDeclarationElement*) startVerticalContainer;
- (CaveUIFormDeclarationElement*) endVerticalContainer;
- (CaveUIFormDeclarationElement*) startHorizontalContainer;
- (CaveUIFormDeclarationElement*) endHorizontalContainer;
- (CaveUIFormDeclarationElement*) startGroup:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) endGroup;
- (CaveUIFormDeclarationElement*) startTab:(NSString*)_x_id label:(NSString*)label;
- (CaveUIFormDeclarationElement*) endTab;
- (CaveUIFormDeclarationElement*) addDynamicElement:(NSString*)type properties:(CapeDynamicMap*)properties;
- (CaveUIFormDeclarationElement*) addTextInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addRawTextInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addPasswordInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addNameInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addEmailAddressInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addPhoneNumberInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addStreetAddressInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addMultipleChoiceInputWithStringAndStringAndStringAndArrayOfString:(NSString*)_x_id label:(NSString*)label description:(NSString*)description values:(NSMutableArray*)values;
- (CaveUIFormDeclarationElement*) addMultipleChoiceInputWithStringAndStringAndStringAndKeyValueList:(NSString*)_x_id label:(NSString*)label description:(NSString*)description values:(CapeKeyValueList*)values;
- (CaveUIFormDeclarationElement*) addDateInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description skipYears:(int)skipYears;
- (CaveUIFormDeclarationElement*) addPhotoCaptureInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description defImage:(CaveImage*)defImage;
- (CaveUIFormDeclarationElement*) addCodeInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description rows:(int)rows;
- (CaveUIFormDeclarationElement*) addTextAreaInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description rows:(int)rows;
- (CaveUIFormDeclarationElement*) addStaticTextElement:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
- (CaveUIFormDeclarationElement*) addRadioGroupInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description groupname:(NSString*)groupname items:(NSMutableArray*)items;
- (CaveUIFormDeclarationElement*) addWithIconInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description icon:(CaveImage*)icon action:(void(^)(void))action;
- (CaveUIFormDeclarationElement*) addStringListInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description;
@end
