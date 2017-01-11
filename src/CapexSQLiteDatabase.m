
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
#import "CapexSQLDatabase.h"
#import "CapeFile.h"
#import "CapeLoggingContext.h"
#import "CapeLog.h"
#import "CapexSQLStatement.h"
#import "CapexSQLResultSetIterator.h"
#import "CapeDynamicMap.h"
#import "CapeString.h"
#import "CapexSQLTableColumnInfo.h"
#import "CapeStringBuilder.h"
#import "CapexSQLiteDatabase.h"

@implementation CapexSQLiteDatabase

- (CapexSQLiteDatabase*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (CapexSQLiteDatabase*) instance {
	NSLog(@"%@", @"[capex.SQLiteDatabase.instance] (SQLiteDatabase.sling:40:2): Not implemented");
	return(nil);
}

+ (CapexSQLiteDatabase*) forFile:(id<CapeFile>)file allowCreate:(BOOL)allowCreate logger:(id<CapeLoggingContext>)logger {
	if(file == nil) {
		return(nil);
	}
	CapexSQLiteDatabase* v = [CapexSQLiteDatabase instance];
	if(v == nil) {
		return(nil);
	}
	if(logger != nil) {
		[v setLogger:logger];
	}
	if([file isFile] == FALSE) {
		if(allowCreate == FALSE) {
			return(nil);
		}
		id<CapeFile> pp = [file getParent];
		if([pp isDirectory] == FALSE) {
			if([pp createDirectoryRecursive] == FALSE) {
				[CapeLog error:((id<CapeLoggingContext>)({ id _v = [v getLogger]; [((NSObject*)_v) conformsToProtocol:@protocol(CapeLoggingContext)] ? _v : nil; })) message:[@"Failed to create directory: " stringByAppendingString:([pp getPath])]];
			}
		}
		if([v initialize:file create:TRUE] == FALSE) {
			v = nil;
		}
	}
	else {
		if([v initialize:file create:FALSE] == FALSE) {
			v = nil;
		}
	}
	return(v);
}

- (NSString*) getDatabaseTypeId {
	return(@"sqlite");
}

- (BOOL) initialize:(id<CapeFile>)file create:(BOOL)create {
	return(TRUE);
}

- (CapeDynamicMap*) querySingleRow:(id<CapexSQLStatement>)stmt {
	CapexSQLResultSetIterator* it = [self querySQLStatement:stmt];
	if(it == nil) {
		return(nil);
	}
	CapeDynamicMap* v = [it next];
	return(v);
}

- (BOOL) tableExists:(NSString*)table {
	if(({ NSString* _s1 = table; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(FALSE);
	}
	id<CapexSQLStatement> stmt = [self prepare:@"SELECT name FROM sqlite_master WHERE type='table' AND name=?;"];
	if(stmt == nil) {
		return(FALSE);
	}
	[stmt addParamString:table];
	CapeDynamicMap* sr = [self querySingleRow:stmt];
	if(sr == nil) {
		return(FALSE);
	}
	if([CapeString equals:table str2:[sr getString:@"name" defval:nil]] == FALSE) {
		return(FALSE);
	}
	return(TRUE);
}

- (void) queryAllTableNamesWithFunction:(void(^)(NSMutableArray*))callback {
	NSMutableArray* v = [self queryAllTableNames];
	if(callback != nil) {
		callback(v);
	}
}

- (NSMutableArray*) queryAllTableNames {
	id<CapexSQLStatement> stmt = [self prepare:@"SELECT name FROM sqlite_master WHERE type='table';"];
	if(stmt == nil) {
		return(nil);
	}
	CapexSQLResultSetIterator* it = [self querySQLStatement:stmt];
	if(it == nil) {
		return(nil);
	}
	NSMutableArray* v = [[NSMutableArray alloc] init];
	while(TRUE) {
		CapeDynamicMap* o = [it next];
		if(o == nil) {
			break;
		}
		NSString* name = [o getString:@"name" defval:nil];
		if([CapeString isEmpty:name] == FALSE) {
			[v addObject:name];
		}
	}
	return(v);
}

- (NSString*) columnToCreateString:(CapexSQLTableColumnInfo*)cc {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:[cc getName]];
	[sb appendCharacter:' '];
	int tt = [cc getType];
	if(tt == CapexSQLTableColumnInfoTYPE_INTEGER_KEY) {
		[sb appendString:@"INTEGER PRIMARY KEY AUTOINCREMENT"];
	}
	else {
		if(tt == CapexSQLTableColumnInfoTYPE_STRING_KEY) {
			[sb appendString:@"TEXT PRIMARY KEY"];
		}
		else {
			if(tt == CapexSQLTableColumnInfoTYPE_INTEGER) {
				[sb appendString:@"INTEGER"];
			}
			else {
				if(tt == CapexSQLTableColumnInfoTYPE_STRING) {
					[sb appendString:@"VARCHAR(255)"];
				}
				else {
					if(tt == CapexSQLTableColumnInfoTYPE_TEXT) {
						[sb appendString:@"TEXT"];
					}
					else {
						if(tt == CapexSQLTableColumnInfoTYPE_BLOB) {
							[sb appendString:@"BLOB"];
						}
						else {
							if(tt == CapexSQLTableColumnInfoTYPE_DOUBLE) {
								[sb appendString:@"REAL"];
							}
							else {
								[CapeLog error:[self getLogger] message:[@"Unknown column type: " stringByAppendingString:([CapeString forInteger:tt])]];
								[sb appendString:@"UNKNOWN"];
							}
						}
					}
				}
			}
		}
	}
	return([sb toString]);
}

- (id<CapexSQLStatement>) prepareCreateTableStatement:(NSString*)table columns:(NSMutableArray*)columns {
	if(({ NSString* _s1 = table; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || columns == nil) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"CREATE TABLE "];
	[sb appendString:table];
	[sb appendString:@" ("];
	BOOL first = TRUE;
	if(columns != nil) {
		int n = 0;
		int m = [columns count];
		for(n = 0 ; n < m ; n++) {
			CapexSQLTableColumnInfo* column = ((CapexSQLTableColumnInfo*)[columns objectAtIndex:n]);
			if(column != nil) {
				if(first == FALSE) {
					[sb appendCharacter:','];
				}
				[sb appendCharacter:' '];
				[sb appendString:[self columnToCreateString:column]];
				first = FALSE;
			}
		}
	}
	[sb appendString:@" );"];
	return([self prepare:[sb toString]]);
}

- (id<CapexSQLStatement>) prepareDeleteTableStatement:(NSString*)table {
	if(({ NSString* _s1 = table; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"DROP TABLE "];
	[sb appendString:table];
	[sb appendString:@";"];
	return([self prepare:[sb toString]]);
}

- (id<CapexSQLStatement>) prepareCreateIndexStatement:(NSString*)table column:(NSString*)column unique:(BOOL)unique {
	if(({ NSString* _s1 = table; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = column; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		return(nil);
	}
	NSString* unq = @"";
	if(unique) {
		unq = @"UNIQUE ";
	}
	NSString* sql = [[[[[[[[[[@"CREATE " stringByAppendingString:unq] stringByAppendingString:@"INDEX "] stringByAppendingString:table] stringByAppendingString:@"_"] stringByAppendingString:column] stringByAppendingString:@" ON "] stringByAppendingString:table] stringByAppendingString:@" ("] stringByAppendingString:column] stringByAppendingString:@")"];
	return([self prepare:sql]);
}

@end
