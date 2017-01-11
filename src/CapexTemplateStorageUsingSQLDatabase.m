
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
#import "CapexTemplateStorage.h"
#import "CapexSQLDatabase.h"
#import "CapeString.h"
#import "CapexSQLStatement.h"
#import "CapeDynamicMap.h"
#import "CapexTemplateStorageUsingSQLDatabase.h"

@implementation CapexTemplateStorageUsingSQLDatabase

{
	CapexSQLDatabase* database;
	NSString* table;
	NSString* idColumn;
	NSString* contentColumn;
}

+ (CapexTemplateStorageUsingSQLDatabase*) forDatabase:(CapexSQLDatabase*)db table:(NSString*)table idColumn:(NSString*)idColumn contentColumn:(NSString*)contentColumn {
	CapexTemplateStorageUsingSQLDatabase* v = [[CapexTemplateStorageUsingSQLDatabase alloc] init];
	[v setDatabase:db];
	if(!(({ NSString* _s1 = table; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[v setTable:table];
	}
	if(!(({ NSString* _s1 = idColumn; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[v setIdColumn:idColumn];
	}
	if(!(({ NSString* _s1 = contentColumn; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		[v setContentColumn:contentColumn];
	}
	return(v);
}

- (CapexTemplateStorageUsingSQLDatabase*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->contentColumn = nil;
	self->idColumn = nil;
	self->table = nil;
	self->database = nil;
	self->table = @"templates";
	self->idColumn = @"id";
	self->contentColumn = @"content";
	return(self);
}

- (void) getTemplate:(NSString*)_x_id callback:(void(^)(NSString*))callback {
	if(callback == nil) {
		return;
	}
	if(self->database == nil || [CapeString isEmpty:self->table] || [CapeString isEmpty:_x_id]) {
		callback(nil);
		return;
	}
	id<CapexSQLStatement> stmt = [self->database prepare:[[[[@"SELECT content FROM " stringByAppendingString:self->table] stringByAppendingString:@" WHERE "] stringByAppendingString:self->idColumn] stringByAppendingString:@" = ?;"]];
	if(stmt == nil) {
		callback(nil);
		return;
	}
	[stmt addParamString:_x_id];
	void (^cb)(NSString*) = callback;
	[self->database querySingleRowWithSQLStatementAndFunction:stmt callback:^void(CapeDynamicMap* data) {
		if(data == nil) {
			cb(nil);
			return;
		}
		cb([data getString:@"content" defval:nil]);
	}];
}

- (CapexSQLDatabase*) getDatabase {
	return(self->database);
}

- (CapexTemplateStorageUsingSQLDatabase*) setDatabase:(CapexSQLDatabase*)v {
	self->database = v;
	return(self);
}

- (NSString*) getTable {
	return(self->table);
}

- (CapexTemplateStorageUsingSQLDatabase*) setTable:(NSString*)v {
	self->table = v;
	return(self);
}

- (NSString*) getIdColumn {
	return(self->idColumn);
}

- (CapexTemplateStorageUsingSQLDatabase*) setIdColumn:(NSString*)v {
	self->idColumn = v;
	return(self);
}

- (NSString*) getContentColumn {
	return(self->contentColumn);
}

- (CapexTemplateStorageUsingSQLDatabase*) setContentColumn:(NSString*)v {
	self->contentColumn = v;
	return(self);
}

@end
