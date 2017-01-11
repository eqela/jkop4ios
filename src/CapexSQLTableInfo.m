
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
#import "CapexSQLTableColumnIndexInfo.h"
#import "CapeString.h"
#import "CapexSQLTableInfo.h"

@implementation CapexSQLTableInfo

{
	NSString* name;
	NSMutableArray* columns;
	NSMutableArray* indexes;
}

- (CapexSQLTableInfo*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->indexes = nil;
	self->columns = nil;
	self->name = nil;
	return(self);
}

+ (CapexSQLTableInfo*) forName:(NSString*)name {
	return([[[CapexSQLTableInfo alloc] init] setName:name]);
}

+ (CapexSQLTableInfo*) forDetails:(NSString*)name columns:(NSMutableArray*)columns indexes:(NSMutableArray*)indexes uniqueIndexes:(NSMutableArray*)uniqueIndexes {
	CapexSQLTableInfo* v = [[CapexSQLTableInfo alloc] init];
	[v setName:name];
	if(columns != nil) {
		int n = 0;
		int m = [columns count];
		for(n = 0 ; n < m ; n++) {
			CapexSQLTableColumnInfo* column = ((CapexSQLTableColumnInfo*)[columns objectAtIndex:n]);
			if(column != nil) {
				[v addColumn:column];
			}
		}
	}
	if(indexes != nil) {
		int n2 = 0;
		int m2 = [indexes count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			NSString* index = ((NSString*)[indexes objectAtIndex:n2]);
			if(index != nil) {
				[v addIndex:index];
			}
		}
	}
	if(uniqueIndexes != nil) {
		int n3 = 0;
		int m3 = [uniqueIndexes count];
		for(n3 = 0 ; n3 < m3 ; n3++) {
			NSString* uniqueIndex = ((NSString*)[uniqueIndexes objectAtIndex:n3]);
			if(uniqueIndex != nil) {
				[v addUniqueIndex:uniqueIndex];
			}
		}
	}
	return(v);
}

- (CapexSQLTableInfo*) addColumn:(CapexSQLTableColumnInfo*)info {
	if(info == nil) {
		return(self);
	}
	if(self->columns == nil) {
		self->columns = [[NSMutableArray alloc] init];
	}
	[self->columns addObject:info];
	return(self);
}

- (CapexSQLTableInfo*) addIntegerColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forInteger:name]]);
}

- (CapexSQLTableInfo*) addStringColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forString:name]]);
}

- (CapexSQLTableInfo*) addStringKeyColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forStringKey:name]]);
}

- (CapexSQLTableInfo*) addTextColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forText:name]]);
}

- (CapexSQLTableInfo*) addIntegerKeyColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forIntegerKey:name]]);
}

- (CapexSQLTableInfo*) addDoubleColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forDouble:name]]);
}

- (CapexSQLTableInfo*) addBlobColumn:(NSString*)name {
	return([self addColumn:[CapexSQLTableColumnInfo forBlob:name]]);
}

- (CapexSQLTableInfo*) addIndex:(NSString*)column {
	if([CapeString isEmpty:column] == FALSE) {
		if(self->indexes == nil) {
			self->indexes = [[NSMutableArray alloc] init];
		}
		[self->indexes addObject:[[[[CapexSQLTableColumnIndexInfo alloc] init] setColumn:column] setUnique:FALSE]];
	}
	return(self);
}

- (CapexSQLTableInfo*) addUniqueIndex:(NSString*)column {
	if([CapeString isEmpty:column] == FALSE) {
		if(self->indexes == nil) {
			self->indexes = [[NSMutableArray alloc] init];
		}
		[self->indexes addObject:[[[[CapexSQLTableColumnIndexInfo alloc] init] setColumn:column] setUnique:TRUE]];
	}
	return(self);
}

- (NSString*) getName {
	return(self->name);
}

- (CapexSQLTableInfo*) setName:(NSString*)v {
	self->name = v;
	return(self);
}

- (NSMutableArray*) getColumns {
	return(self->columns);
}

- (CapexSQLTableInfo*) setColumns:(NSMutableArray*)v {
	self->columns = v;
	return(self);
}

- (NSMutableArray*) getIndexes {
	return(self->indexes);
}

- (CapexSQLTableInfo*) setIndexes:(NSMutableArray*)v {
	self->indexes = v;
	return(self);
}

@end
