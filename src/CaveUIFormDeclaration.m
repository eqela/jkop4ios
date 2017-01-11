
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
#import "CapeDynamicMap.h"
#import "CaveImage.h"
#import "CapeKeyValueList.h"
#import "CapeStack.h"
#import "CapeString.h"
#import "CapeVector.h"
#import "CaveUIFormDeclaration.h"

@class CaveUIFormDeclarationElement;
@class CaveUIFormDeclarationInputElement;
@class CaveUIFormDeclarationDynamicElement;
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
@class CaveUIFormDeclarationPhotoCaptureInput;
@class CaveUIFormDeclarationRadioGroupInput;
@class CaveUIFormDeclarationMultipleChoiceInput;
@class CaveUIFormDeclarationDateInput;
@class CaveUIFormDeclarationTextAreaInput;
@class CaveUIFormDeclarationCodeInput;
@class CaveUIFormDeclarationStaticTextElement;
@class CaveUIFormDeclarationStringListInput;

@implementation CaveUIFormDeclarationElement

{
	NSString* _x_id;
	double weight;
}

- (CaveUIFormDeclarationElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->weight = 0.0;
	self->_x_id = nil;
	return(self);
}

- (NSString*) getId {
	return(self->_x_id);
}

- (CaveUIFormDeclarationElement*) setId:(NSString*)v {
	self->_x_id = v;
	return(self);
}

- (double) getWeight {
	return(self->weight);
}

- (CaveUIFormDeclarationElement*) setWeight:(double)v {
	self->weight = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationInputElement

{
	NSString* label;
	NSString* description;
}

- (CaveUIFormDeclarationInputElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->description = nil;
	self->label = nil;
	return(self);
}

- (NSString*) getLabel {
	return(self->label);
}

- (CaveUIFormDeclarationInputElement*) setLabel:(NSString*)v {
	self->label = v;
	return(self);
}

- (NSString*) getDescription {
	return(self->description);
}

- (CaveUIFormDeclarationInputElement*) setDescription:(NSString*)v {
	self->description = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationDynamicElement

{
	NSString* type;
	CapeDynamicMap* properties;
}

- (CaveUIFormDeclarationDynamicElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->properties = nil;
	self->type = nil;
	return(self);
}

- (NSString*) getType {
	return(self->type);
}

- (CaveUIFormDeclarationDynamicElement*) setType:(NSString*)v {
	self->type = v;
	return(self);
}

- (CapeDynamicMap*) getProperties {
	return(self->properties);
}

- (CaveUIFormDeclarationDynamicElement*) setProperties:(CapeDynamicMap*)v {
	self->properties = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationContainer

{
	NSMutableArray* children;
}

- (CaveUIFormDeclarationContainer*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->children = nil;
	return(self);
}

- (void) addToChildren:(CaveUIFormDeclarationElement*)element {
	if(element == nil) {
		return;
	}
	if(self->children == nil) {
		self->children = [[NSMutableArray alloc] init];
	}
	[self->children addObject:element];
}

- (NSMutableArray*) getChildren {
	return(self->children);
}

- (CaveUIFormDeclarationContainer*) setChildren:(NSMutableArray*)v {
	self->children = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationGroup

{
	NSString* label;
	NSString* description;
}

- (CaveUIFormDeclarationGroup*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->description = nil;
	self->label = nil;
	return(self);
}

- (NSString*) getLabel {
	return(self->label);
}

- (CaveUIFormDeclarationGroup*) setLabel:(NSString*)v {
	self->label = v;
	return(self);
}

- (NSString*) getDescription {
	return(self->description);
}

- (CaveUIFormDeclarationGroup*) setDescription:(NSString*)v {
	self->description = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationTab

{
	NSString* label;
}

- (CaveUIFormDeclarationTab*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->label = nil;
	return(self);
}

- (NSString*) getLabel {
	return(self->label);
}

- (CaveUIFormDeclarationTab*) setLabel:(NSString*)v {
	self->label = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationVerticalContainer

- (CaveUIFormDeclarationVerticalContainer*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationHorizontalContainer

- (CaveUIFormDeclarationHorizontalContainer*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationTextInput

- (CaveUIFormDeclarationTextInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationRawTextInput

- (CaveUIFormDeclarationRawTextInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationPasswordInput

- (CaveUIFormDeclarationPasswordInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationNameInput

- (CaveUIFormDeclarationNameInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationEmailAddressInput

- (CaveUIFormDeclarationEmailAddressInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationPhoneNumberInput

- (CaveUIFormDeclarationPhoneNumberInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationStreetAddressInput

- (CaveUIFormDeclarationStreetAddressInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationWithIconInput

{
	CaveImage* icon;
	void (^action)(void);
}

- (CaveUIFormDeclarationWithIconInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->action = nil;
	self->icon = nil;
	return(self);
}

- (CaveImage*) getIcon {
	return(self->icon);
}

- (CaveUIFormDeclarationWithIconInput*) setIcon:(CaveImage*)v {
	self->icon = v;
	return(self);
}

- (void(^)(void)) getAction {
	return(self->action);
}

- (CaveUIFormDeclarationWithIconInput*) setAction:(void(^)(void))v {
	self->action = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationPhotoCaptureInput

{
	CaveImage* defaultImage;
}

- (CaveUIFormDeclarationPhotoCaptureInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->defaultImage = nil;
	return(self);
}

- (CaveImage*) getDefaultImage {
	return(self->defaultImage);
}

- (CaveUIFormDeclarationPhotoCaptureInput*) setDefaultImage:(CaveImage*)v {
	self->defaultImage = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationRadioGroupInput

{
	NSMutableArray* items;
	NSString* groupName;
}

- (CaveUIFormDeclarationRadioGroupInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->groupName = nil;
	self->items = nil;
	return(self);
}

- (NSMutableArray*) getItems {
	return(self->items);
}

- (CaveUIFormDeclarationRadioGroupInput*) setItems:(NSMutableArray*)v {
	self->items = v;
	return(self);
}

- (NSString*) getGroupName {
	return(self->groupName);
}

- (CaveUIFormDeclarationRadioGroupInput*) setGroupName:(NSString*)v {
	self->groupName = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationMultipleChoiceInput

{
	CapeKeyValueList* values;
}

- (CaveUIFormDeclarationMultipleChoiceInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->values = nil;
	return(self);
}

- (CapeKeyValueList*) getValues {
	return(self->values);
}

- (CaveUIFormDeclarationMultipleChoiceInput*) setValues:(CapeKeyValueList*)v {
	self->values = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationDateInput

{
	int skipYears;
}

- (CaveUIFormDeclarationDateInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->skipYears = 0;
	return(self);
}

- (int) getSkipYears {
	return(self->skipYears);
}

- (CaveUIFormDeclarationDateInput*) setSkipYears:(int)v {
	self->skipYears = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationTextAreaInput

{
	int rows;
}

- (CaveUIFormDeclarationTextAreaInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->rows = 0;
	return(self);
}

- (int) getRows {
	return(self->rows);
}

- (CaveUIFormDeclarationTextAreaInput*) setRows:(int)v {
	self->rows = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationCodeInput

{
	int rows;
}

- (CaveUIFormDeclarationCodeInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->rows = 0;
	return(self);
}

- (int) getRows {
	return(self->rows);
}

- (CaveUIFormDeclarationCodeInput*) setRows:(int)v {
	self->rows = v;
	return(self);
}

@end

@implementation CaveUIFormDeclarationStaticTextElement

- (CaveUIFormDeclarationStaticTextElement*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclarationStringListInput

- (CaveUIFormDeclarationStringListInput*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

@end

@implementation CaveUIFormDeclaration

{
	CaveUIFormDeclarationContainer* root;
	CapeStack* stack;
}

- (CaveUIFormDeclaration*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->stack = nil;
	self->root = nil;
	self->root = ((CaveUIFormDeclarationContainer*)[[CaveUIFormDeclarationVerticalContainer alloc] init]);
	self->stack = [[CapeStack alloc] init];
	[self->stack push:((id)self->root)];
	return(self);
}

- (CaveUIFormDeclarationContainer*) getRoot {
	return(self->root);
}

- (CaveUIFormDeclarationElement*) addElement:(CaveUIFormDeclarationElement*)element {
	CaveUIFormDeclarationContainer* current = ((CaveUIFormDeclarationContainer*)[self->stack peek]);
	if(current != nil) {
		[current addToChildren:element];
	}
	return(element);
}

- (CaveUIFormDeclarationElement*) startVerticalContainer {
	CaveUIFormDeclarationVerticalContainer* vc = [[CaveUIFormDeclarationVerticalContainer alloc] init];
	[self addElement:((CaveUIFormDeclarationElement*)vc)];
	[self->stack push:((id)vc)];
	return(((CaveUIFormDeclarationElement*)vc));
}

- (CaveUIFormDeclarationElement*) endVerticalContainer {
	CaveUIFormDeclarationVerticalContainer* cc = ((CaveUIFormDeclarationVerticalContainer*)({ id _v = [self->stack peek]; [_v isKindOfClass:[CaveUIFormDeclarationVerticalContainer class]] ? _v : nil; }));
	if(cc != nil) {
		[self->stack pop];
	}
	return(((CaveUIFormDeclarationElement*)cc));
}

- (CaveUIFormDeclarationElement*) startHorizontalContainer {
	CaveUIFormDeclarationHorizontalContainer* vc = [[CaveUIFormDeclarationHorizontalContainer alloc] init];
	[self addElement:((CaveUIFormDeclarationElement*)vc)];
	[self->stack push:((id)vc)];
	return(((CaveUIFormDeclarationElement*)vc));
}

- (CaveUIFormDeclarationElement*) endHorizontalContainer {
	CaveUIFormDeclarationHorizontalContainer* cc = ((CaveUIFormDeclarationHorizontalContainer*)({ id _v = [self->stack peek]; [_v isKindOfClass:[CaveUIFormDeclarationHorizontalContainer class]] ? _v : nil; }));
	if(cc != nil) {
		[self->stack pop];
	}
	return(((CaveUIFormDeclarationElement*)cc));
}

- (CaveUIFormDeclarationElement*) startGroup:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationGroup* group = [[CaveUIFormDeclarationGroup alloc] init];
	[group setId:_x_id];
	[group setLabel:label];
	[group setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)group)];
	[self->stack push:((id)group)];
	return(((CaveUIFormDeclarationElement*)group));
}

- (CaveUIFormDeclarationElement*) endGroup {
	CaveUIFormDeclarationGroup* cc = ((CaveUIFormDeclarationGroup*)({ id _v = [self->stack peek]; [_v isKindOfClass:[CaveUIFormDeclarationGroup class]] ? _v : nil; }));
	if(cc != nil) {
		[self->stack pop];
	}
	return(((CaveUIFormDeclarationElement*)cc));
}

- (CaveUIFormDeclarationElement*) startTab:(NSString*)_x_id label:(NSString*)label {
	CaveUIFormDeclarationTab* tab = [[CaveUIFormDeclarationTab alloc] init];
	[tab setId:_x_id];
	[tab setLabel:label];
	[self addElement:((CaveUIFormDeclarationElement*)tab)];
	[self->stack push:((id)tab)];
	return(((CaveUIFormDeclarationElement*)tab));
}

- (CaveUIFormDeclarationElement*) endTab {
	CaveUIFormDeclarationTab* cc = ((CaveUIFormDeclarationTab*)({ id _v = [self->stack peek]; [_v isKindOfClass:[CaveUIFormDeclarationTab class]] ? _v : nil; }));
	if(cc != nil) {
		[self->stack pop];
	}
	return(((CaveUIFormDeclarationElement*)cc));
}

- (CaveUIFormDeclarationElement*) addDynamicElement:(NSString*)type properties:(CapeDynamicMap*)properties {
	CaveUIFormDeclarationDynamicElement* v = [[CaveUIFormDeclarationDynamicElement alloc] init];
	[v setType:type];
	[v setProperties:properties];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addTextInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationTextInput* v = [[CaveUIFormDeclarationTextInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addRawTextInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationRawTextInput* v = [[CaveUIFormDeclarationRawTextInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addPasswordInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationPasswordInput* v = [[CaveUIFormDeclarationPasswordInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addNameInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationNameInput* v = [[CaveUIFormDeclarationNameInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addEmailAddressInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationEmailAddressInput* v = [[CaveUIFormDeclarationEmailAddressInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addPhoneNumberInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationPhoneNumberInput* v = [[CaveUIFormDeclarationPhoneNumberInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addStreetAddressInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationStreetAddressInput* v = [[CaveUIFormDeclarationStreetAddressInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addMultipleChoiceInputWithStringAndStringAndStringAndArrayOfString:(NSString*)_x_id label:(NSString*)label description:(NSString*)description values:(NSMutableArray*)values {
	CapeKeyValueList* vvs = [[CapeKeyValueList alloc] init];
	if(values != nil) {
		int n = 0;
		int m = [values count];
		for(n = 0 ; n < m ; n++) {
			NSString* value = ((NSString*)[values objectAtIndex:n]);
			if(value != nil) {
				NSMutableArray* comps = [CapeString split:value delim:':' max:2];
				NSString* kk = [CapeVector get:comps index:0];
				NSString* vv = [CapeVector get:comps index:1];
				if(({ NSString* _s1 = vv; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
					vv = kk;
				}
				[vvs addDynamicAndDynamic:((id)kk) val:((id)vv)];
			}
		}
	}
	return([self addMultipleChoiceInputWithStringAndStringAndStringAndKeyValueList:_x_id label:label description:description values:vvs]);
}

- (CaveUIFormDeclarationElement*) addMultipleChoiceInputWithStringAndStringAndStringAndKeyValueList:(NSString*)_x_id label:(NSString*)label description:(NSString*)description values:(CapeKeyValueList*)values {
	CaveUIFormDeclarationMultipleChoiceInput* v = [[CaveUIFormDeclarationMultipleChoiceInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setValues:values];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addDateInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description skipYears:(int)skipYears {
	CaveUIFormDeclarationDateInput* v = [[CaveUIFormDeclarationDateInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setSkipYears:skipYears];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addPhotoCaptureInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description defImage:(CaveImage*)defImage {
	CaveUIFormDeclarationPhotoCaptureInput* v = [[CaveUIFormDeclarationPhotoCaptureInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setDefaultImage:defImage];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addCodeInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description rows:(int)rows {
	CaveUIFormDeclarationCodeInput* v = [[CaveUIFormDeclarationCodeInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setRows:rows];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addTextAreaInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description rows:(int)rows {
	CaveUIFormDeclarationTextAreaInput* v = [[CaveUIFormDeclarationTextAreaInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setRows:rows];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addStaticTextElement:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationStaticTextElement* v = [[CaveUIFormDeclarationStaticTextElement alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addRadioGroupInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description groupname:(NSString*)groupname items:(NSMutableArray*)items {
	CaveUIFormDeclarationRadioGroupInput* v = [[CaveUIFormDeclarationRadioGroupInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setItems:items];
	[v setGroupName:groupname];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addWithIconInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description icon:(CaveImage*)icon action:(void(^)(void))action {
	CaveUIFormDeclarationWithIconInput* v = [[CaveUIFormDeclarationWithIconInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[v setIcon:icon];
	[v setAction:action];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

- (CaveUIFormDeclarationElement*) addStringListInput:(NSString*)_x_id label:(NSString*)label description:(NSString*)description {
	CaveUIFormDeclarationStringListInput* v = [[CaveUIFormDeclarationStringListInput alloc] init];
	[v setId:_x_id];
	[v setLabel:label];
	[v setDescription:description];
	[self addElement:((CaveUIFormDeclarationElement*)v)];
	return(((CaveUIFormDeclarationElement*)v));
}

@end
