
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
#import "CapexSQLTableColumnInfo.h"

int CapexSQLTableColumnInfoTYPE_INTEGER = 0;
int CapexSQLTableColumnInfoTYPE_STRING = 1;
int CapexSQLTableColumnInfoTYPE_TEXT = 2;
int CapexSQLTableColumnInfoTYPE_INTEGER_KEY = 3;
int CapexSQLTableColumnInfoTYPE_DOUBLE = 4;
int CapexSQLTableColumnInfoTYPE_BLOB = 5;
int CapexSQLTableColumnInfoTYPE_STRING_KEY = 6;

@implementation CapexSQLTableColumnInfo

{
	NSString* name;
	int type;
}

- (CapexSQLTableColumnInfo*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->type = 0;
	self->name = nil;
	return(self);
}

+ (CapexSQLTableColumnInfo*) instance:(NSString*)name type:(int)type {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:type]);
}

+ (CapexSQLTableColumnInfo*) forInteger:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_INTEGER]);
}

+ (CapexSQLTableColumnInfo*) forString:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_STRING]);
}

+ (CapexSQLTableColumnInfo*) forStringKey:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_STRING_KEY]);
}

+ (CapexSQLTableColumnInfo*) forText:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_TEXT]);
}

+ (CapexSQLTableColumnInfo*) forIntegerKey:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_INTEGER_KEY]);
}

+ (CapexSQLTableColumnInfo*) forDouble:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_DOUBLE]);
}

+ (CapexSQLTableColumnInfo*) forBlob:(NSString*)name {
	return([[[[CapexSQLTableColumnInfo alloc] init] setName:name] setType:CapexSQLTableColumnInfoTYPE_BLOB]);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexSQLTableColumnInfo*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (int) getType {
	return(self->type);
}

- (CapexSQLTableColumnInfo*) setType:(int)v {
	self->type = v;
	return(self);
}

@end
