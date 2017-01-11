
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
#import "CapeLoggingContext.h"
#import "CapexSQLStatement.h"
#import "CapexSQLTableColumnInfo.h"
#import "CapexSQLResultSetIterator.h"
#import "CapeDynamicMap.h"
#import "CapexSQLTableInfo.h"
#import "CapeString.h"
#import "CapexSQLTableColumnIndexInfo.h"
#import "CapeStringBuilder.h"
#import "CapexSQLOrderingRule.h"
#import "CapeMap.h"
#import "CapeStringObject.h"
#import "CapeIntegerObject.h"
#import "CapeInteger.h"
#import "CapeDoubleObject.h"
#import "CapeDouble.h"
#import "CapeBufferObject.h"
#import "CapeIterator.h"
#import "CapeBuffer.h"
#import "CapexSQLDatabase.h"

@implementation CapexSQLDatabase

{
	id<CapeLoggingContext> logger;
}

- (CapexSQLDatabase*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->logger = nil;
	return(self);
}

- (id<CapexSQLStatement>) prepare:(NSString*)sql {
}

- (NSString*) getDatabaseTypeId {
}

- (id<CapexSQLStatement>) prepareCreateTableStatement:(NSString*)table columns:(NSMutableArray*)columns {
}

- (id<CapexSQLStatement>) prepareDeleteTableStatement:(NSString*)table {
}

- (id<CapexSQLStatement>) prepareCreateIndexStatement:(NSString*)table column:(NSString*)column unique:(BOOL)unique {
}

- (void) closeFunction:(void(^)(void))callback {
}

- (void) executeSQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(BOOL))callback {
}

- (void) querySQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(CapexSQLResultSetIterator*))callback {
}

- (void) querySingleRowWithSQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(CapeDynamicMap*))callback {
}

- (void) tableExistsWithStringAndFunction:(NSString*)table callback:(void(^)(BOOL))callback {
}

- (void) queryAllTableNamesWithFunction:(void(^)(NSMutableArray*))callback {
}

- (void) close {
}

- (BOOL) executeSQLStatement:(id<CapexSQLStatement>)stmt {
}

- (CapexSQLResultSetIterator*) querySQLStatement:(id<CapexSQLStatement>)stmt {
}

- (CapeDynamicMap*) querySingleRowWithSQLStatement:(id<CapexSQLStatement>)stmt {
}

- (BOOL) tableExistsWithString:(NSString*)table {
}

- (NSMutableArray*) queryAllTableNames {
}

- (BOOL) ensureTableExistsWithSQLTableInfo:(CapexSQLTableInfo*)table {
	if(table == nil) {
		return(FALSE);
	}
	NSString* name = [table getName];
	if([CapeString isEmpty:name]) {
		return(FALSE);
	}
	if([self tableExistsWithString:name]) {
		return(TRUE);
	}
	if([self executeSQLStatement:[self prepareCreateTableStatement:name columns:[table getColumns]]] == FALSE) {
		return(FALSE);
	}
	NSMutableArray* array = [table getIndexes];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			CapexSQLTableColumnIndexInfo* cii = ((CapexSQLTableColumnIndexInfo*)[array objectAtIndex:n]);
			if(cii != nil) {
				if([self executeSQLStatement:[self prepareCreateIndexStatement:name column:[cii getColumn] unique:[cii getUnique]]] == FALSE) {
					[self executeSQLStatement:[self prepareDeleteTableStatement:name]];
				}
			}
		}
	}
	return(TRUE);
}

- (void) ensureTableExistsWithSQLTableInfoAndFunction:(CapexSQLTableInfo*)table callback:(void(^)(BOOL))callback {
	BOOL v = [self ensureTableExistsWithSQLTableInfo:table];
	if(callback != nil) {
		callback(v);
	}
}

- (NSString*) createColumnSelectionString:(NSMutableArray*)columns {
	if(columns == nil || [columns count] < 1) {
		return(@"*");
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	BOOL first = TRUE;
	if(columns != nil) {
		int n = 0;
		int m = [columns count];
		for(n = 0 ; n < m ; n++) {
			NSString* column = ((NSString*)[columns objectAtIndex:n]);
			if(column != nil) {
				if(first == FALSE) {
					[sb appendString:@", "];
				}
				[sb appendString:column];
				first = FALSE;
			}
		}
	}
	return([sb toString]);
}

- (NSString*) createOrderByString:(NSMutableArray*)order {
	if(order == nil || [order count] < 1) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@" ORDER BY "];
	BOOL first = TRUE;
	if(order != nil) {
		int n = 0;
		int m = [order count];
		for(n = 0 ; n < m ; n++) {
			CapexSQLOrderingRule* rule = ((CapexSQLOrderingRule*)[order objectAtIndex:n]);
			if(rule != nil) {
				if(first == FALSE) {
					[sb appendString:@", "];
				}
				[sb appendString:[rule getColumn]];
				[sb appendCharacter:' '];
				if([rule getDescending]) {
					[sb appendString:@"DESC"];
				}
				else {
					[sb appendString:@"ASC"];
				}
				first = FALSE;
			}
		}
	}
	return([sb toString]);
}

- (id<CapexSQLStatement>) prepareQueryAllStatementWithString:(NSString*)table {
	return([self prepareQueryAllStatementWithStringAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table columns:nil order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryAllStatementWithStringAndArrayOfString:(NSString*)table columns:(NSMutableArray*)columns {
	return([self prepareQueryAllStatementWithStringAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table columns:columns order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryAllStatementWithStringAndArrayOfStringAndArrayOfCapexSQLOrderingRule:(NSString*)table columns:(NSMutableArray*)columns order:(NSMutableArray*)order {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"SELECT "];
	[sb appendString:[self createColumnSelectionString:columns]];
	[sb appendString:@" FROM "];
	[sb appendString:table];
	[sb appendString:[self createOrderByString:order]];
	[sb appendString:@";"];
	return([self prepare:[sb toString]]);
}

- (id<CapexSQLStatement>) prepareCountRecordsStatement:(NSString*)table criteria:(NSMutableDictionary*)criteria {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"SELECT COUNT(*) AS count FROM "];
	[sb appendString:table];
	BOOL first = TRUE;
	NSMutableArray* keys = nil;
	if(criteria != nil) {
		keys = ((NSMutableArray*)({ id _v = [CapeMap getKeys:criteria]; [_v isKindOfClass:[NSMutableArray class]] ? _v : nil; }));
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					if(first) {
						[sb appendString:@" WHERE "];
						first = FALSE;
					}
					else {
						[sb appendString:@" AND "];
					}
					[sb appendString:((NSString*)({ id _v = key; [_v isKindOfClass:[NSString class]] ? _v : nil; }))];
					[sb appendString:@" = ?"];
				}
			}
		}
	}
	[sb appendCharacter:';'];
	NSString* sql = [sb toString];
	id<CapexSQLStatement> stmt = [self prepare:sql];
	if(stmt == nil) {
		return(nil);
	}
	if(keys != nil) {
		if(keys != nil) {
			int n2 = 0;
			int m2 = [keys count];
			for(n2 = 0 ; n2 < m2 ; n2++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n2]);
				if(key != nil) {
					NSString* val = [CapeMap getMapAndDynamic:criteria key:((id)key)];
					if(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						val = nil;
					}
					[stmt addParamString:((NSString*)({ id _v = val; [_v isKindOfClass:[NSString class]] ? _v : nil; }))];
				}
			}
		}
	}
	return(stmt);
}

- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMap:(NSString*)table criteria:(NSMutableDictionary*)criteria {
	return([self prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table criteria:criteria limit:0 offset:0 columns:nil order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedInteger:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit {
	return([self prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table criteria:criteria limit:limit offset:0 columns:nil order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedInteger:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset {
	return([self prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table criteria:criteria limit:limit offset:offset columns:nil order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfString:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset columns:(NSMutableArray*)columns {
	return([self prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:table criteria:criteria limit:limit offset:offset columns:columns order:nil]);
}

- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset columns:(NSMutableArray*)columns order:(NSMutableArray*)order {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"SELECT "];
	[sb appendString:[self createColumnSelectionString:columns]];
	[sb appendString:@" FROM "];
	[sb appendString:table];
	BOOL first = TRUE;
	NSMutableArray* keys = nil;
	if(criteria != nil) {
		keys = ((NSMutableArray*)({ id _v = [CapeMap getKeys:criteria]; [_v isKindOfClass:[NSMutableArray class]] ? _v : nil; }));
		if(keys != nil) {
			int n = 0;
			int m = [keys count];
			for(n = 0 ; n < m ; n++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n]);
				if(key != nil) {
					if(first) {
						[sb appendString:@" WHERE "];
						first = FALSE;
					}
					else {
						[sb appendString:@" AND "];
					}
					[sb appendString:((NSString*)({ id _v = key; [_v isKindOfClass:[NSString class]] ? _v : nil; }))];
					[sb appendString:@" = ?"];
				}
			}
		}
	}
	[sb appendString:[self createOrderByString:order]];
	if(limit > 0) {
		[sb appendString:@" LIMIT "];
		[sb appendString:[CapeString forInteger:limit]];
	}
	if(offset > 0) {
		[sb appendString:@" OFFSET "];
		[sb appendString:[CapeString forInteger:offset]];
	}
	[sb appendCharacter:';'];
	NSString* sql = [sb toString];
	id<CapexSQLStatement> stmt = [self prepare:sql];
	if(stmt == nil) {
		return(nil);
	}
	if(keys != nil) {
		if(keys != nil) {
			int n2 = 0;
			int m2 = [keys count];
			for(n2 = 0 ; n2 < m2 ; n2++) {
				NSString* key = ((NSString*)[keys objectAtIndex:n2]);
				if(key != nil) {
					NSString* val = [CapeMap getMapAndDynamic:criteria key:((id)key)];
					if(({ NSString* _s1 = val; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						val = nil;
					}
					[stmt addParamString:((NSString*)({ id _v = val; [_v isKindOfClass:[NSString class]] ? _v : nil; }))];
				}
			}
		}
	}
	return(stmt);
}

- (id<CapexSQLStatement>) prepareQueryDistinctValuesStatement:(NSString*)table column:(NSString*)column {
	if([CapeString isEmpty:table] || [CapeString isEmpty:column]) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"SELECT DISTINCT "];
	[sb appendString:column];
	[sb appendString:@" FROM "];
	[sb appendString:table];
	[sb appendString:@";"];
	return([self prepare:[sb toString]]);
}

- (id<CapexSQLStatement>) prepareInsertStatement:(NSString*)table data:(CapeDynamicMap*)data {
	if([CapeString isEmpty:table] || data == nil || [data getCount] < 1) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"INSERT INTO "];
	[sb appendString:table];
	[sb appendString:@" ( "];
	BOOL first = TRUE;
	NSMutableArray* keys = [data getKeys];
	if(keys != nil) {
		int n = 0;
		int m = [keys count];
		for(n = 0 ; n < m ; n++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n]);
			if(key != nil) {
				if(first == FALSE) {
					[sb appendCharacter:','];
				}
				[sb appendString:((NSString*)({ id _v = key; [_v isKindOfClass:[NSString class]] ? _v : nil; }))];
				first = FALSE;
			}
		}
	}
	[sb appendString:@" ) VALUES ( "];
	first = TRUE;
	if(keys != nil) {
		int n2 = 0;
		int m2 = [keys count];
		for(n2 = 0 ; n2 < m2 ; n2++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n2]);
			if(key != nil) {
				if(first == FALSE) {
					[sb appendCharacter:','];
				}
				[sb appendCharacter:'?'];
				first = FALSE;
			}
		}
	}
	[sb appendString:@" );"];
	id<CapexSQLStatement> stmt = [self prepare:[sb toString]];
	if(stmt == nil) {
		return(nil);
	}
	if(keys != nil) {
		int n3 = 0;
		int m3 = [keys count];
		for(n3 = 0 ; n3 < m3 ; n3++) {
			NSString* key = ((NSString*)[keys objectAtIndex:n3]);
			if(key != nil) {
				id o = [data get:key];
				if([o isKindOfClass:[NSString class]] || [((NSObject*)o) conformsToProtocol:@protocol(CapeStringObject)]) {
					[stmt addParamString:[CapeString asStringWithObject:o]];
				}
				else {
					if([((NSObject*)o) conformsToProtocol:@protocol(CapeIntegerObject)]) {
						[stmt addParamInteger:[CapeInteger asIntegerWithObject:o]];
					}
					else {
						if([((NSObject*)o) conformsToProtocol:@protocol(CapeDoubleObject)]) {
							[stmt addParamDouble:[CapeDouble asDouble:o]];
						}
						else {
							if([((NSObject*)o) conformsToProtocol:@protocol(CapeBufferObject)]) {
								[stmt addParamBlob:[((id<CapeBufferObject>)o) toBuffer]];
							}
							else {
								if([o isKindOfClass:[NSMutableData class]]) {
									[stmt addParamBlob:((NSMutableData*)({ id _v = o; [_v isKindOfClass:[NSMutableData class]] ? _v : nil; }))];
								}
								else {
									NSString* s = ((NSString*)({ id _v = o; [_v isKindOfClass:[NSString class]] ? _v : nil; }));
									if(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
										s = @"";
									}
									[stmt addParamString:s];
								}
							}
						}
					}
				}
			}
		}
	}
	return(stmt);
}

- (id<CapexSQLStatement>) prepareUpdateStatement:(NSString*)table criteria:(CapeDynamicMap*)criteria data:(CapeDynamicMap*)data {
	if([CapeString isEmpty:table] || data == nil || [data getCount] < 1) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"UPDATE "];
	[sb appendString:table];
	[sb appendString:@" SET "];
	NSMutableArray* params = [[NSMutableArray alloc] init];
	BOOL first = TRUE;
	id<CapeIterator> keys = [data iterateKeys];
	while(keys != nil) {
		NSString* key = [keys next];
		if(({ NSString* _s1 = key; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
			break;
		}
		if(first == FALSE) {
			[sb appendString:@", "];
		}
		[sb appendString:key];
		[sb appendString:@" = ?"];
		first = FALSE;
		[params addObject:[data get:key]];
	}
	if(criteria != nil && [criteria getCount] > 0) {
		[sb appendString:@" WHERE "];
		first = TRUE;
		id<CapeIterator> criterias = [criteria iterateKeys];
		while(criterias != nil) {
			NSString* criterium = [criterias next];
			if(({ NSString* _s1 = criterium; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				break;
			}
			if(first == FALSE) {
				[sb appendString:@" AND "];
			}
			[sb appendString:criterium];
			[sb appendString:@" = ?"];
			first = FALSE;
			[params addObject:[criteria get:criterium]];
		}
	}
	[sb appendCharacter:';'];
	id<CapexSQLStatement> stmt = [self prepare:[sb toString]];
	if(stmt == nil) {
		return(nil);
	}
	if(params != nil) {
		int n = 0;
		int m = [params count];
		for(n = 0 ; n < m ; n++) {
			id o = ((id)[params objectAtIndex:n]);
			if(o != nil) {
				if([o isKindOfClass:[NSMutableData class]]) {
					[stmt addParamBlob:[CapeBuffer asBuffer:o]];
				}
				else {
					NSString* s = [CapeString asStringWithObject:o];
					if(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						s = @"";
					}
					[stmt addParamString:s];
				}
			}
		}
	}
	return(stmt);
}

- (id<CapexSQLStatement>) prepareDeleteStatement:(NSString*)table criteria:(CapeDynamicMap*)criteria {
	if([CapeString isEmpty:table]) {
		return(nil);
	}
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	[sb appendString:@"DELETE FROM "];
	[sb appendString:table];
	NSMutableArray* params = [[NSMutableArray alloc] init];
	if(criteria != nil && [criteria getCount] > 0) {
		[sb appendString:@" WHERE "];
		BOOL first = TRUE;
		id<CapeIterator> criterias = [criteria iterateKeys];
		while(criterias != nil) {
			NSString* criterium = [criterias next];
			if(({ NSString* _s1 = criterium; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				break;
			}
			if(first == FALSE) {
				[sb appendString:@" AND "];
			}
			[sb appendString:criterium];
			[sb appendString:@" = ?"];
			first = FALSE;
			[params addObject:[criteria get:criterium]];
		}
	}
	[sb appendCharacter:';'];
	id<CapexSQLStatement> stmt = [self prepare:[sb toString]];
	if(stmt == nil) {
		return(nil);
	}
	if(params != nil) {
		int n = 0;
		int m = [params count];
		for(n = 0 ; n < m ; n++) {
			id o = ((id)[params objectAtIndex:n]);
			if(o != nil) {
				if([o isKindOfClass:[NSMutableData class]]) {
					[stmt addParamBlob:[CapeBuffer asBuffer:o]];
				}
				else {
					NSString* s = [CapeString asStringWithObject:o];
					if(({ NSString* _s1 = s; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
						s = @"";
					}
					[stmt addParamString:s];
				}
			}
		}
	}
	return(stmt);
}

- (id<CapeLoggingContext>) getLogger {
	return(self->logger);
}

- (CapexSQLDatabase*) setLogger:(id<CapeLoggingContext>)v {
	self->logger = v;
	return(self);
}

@end
