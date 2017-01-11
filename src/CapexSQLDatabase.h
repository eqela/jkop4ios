
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

@protocol CapeLoggingContext;
@protocol CapexSQLStatement;
@class CapexSQLTableColumnInfo;
@class CapexSQLResultSetIterator;
@class CapeDynamicMap;
@class CapexSQLTableInfo;
@class CapexSQLOrderingRule;

@interface CapexSQLDatabase : NSObject
- (CapexSQLDatabase*) init;
- (id<CapexSQLStatement>) prepare:(NSString*)sql;
- (NSString*) getDatabaseTypeId;
- (id<CapexSQLStatement>) prepareCreateTableStatement:(NSString*)table columns:(NSMutableArray*)columns;
- (id<CapexSQLStatement>) prepareDeleteTableStatement:(NSString*)table;
- (id<CapexSQLStatement>) prepareCreateIndexStatement:(NSString*)table column:(NSString*)column unique:(BOOL)unique;
- (void) closeFunction:(void(^)(void))callback;
- (void) executeSQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(BOOL))callback;
- (void) querySQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(CapexSQLResultSetIterator*))callback;
- (void) querySingleRowWithSQLStatementAndFunction:(id<CapexSQLStatement>)stmt callback:(void(^)(CapeDynamicMap*))callback;
- (void) tableExistsWithStringAndFunction:(NSString*)table callback:(void(^)(BOOL))callback;
- (void) queryAllTableNamesWithFunction:(void(^)(NSMutableArray*))callback;
- (void) close;
- (BOOL) executeSQLStatement:(id<CapexSQLStatement>)stmt;
- (CapexSQLResultSetIterator*) querySQLStatement:(id<CapexSQLStatement>)stmt;
- (CapeDynamicMap*) querySingleRowWithSQLStatement:(id<CapexSQLStatement>)stmt;
- (BOOL) tableExistsWithString:(NSString*)table;
- (NSMutableArray*) queryAllTableNames;
- (BOOL) ensureTableExistsWithSQLTableInfo:(CapexSQLTableInfo*)table;
- (void) ensureTableExistsWithSQLTableInfoAndFunction:(CapexSQLTableInfo*)table callback:(void(^)(BOOL))callback;
- (id<CapexSQLStatement>) prepareQueryAllStatementWithString:(NSString*)table;
- (id<CapexSQLStatement>) prepareQueryAllStatementWithStringAndArrayOfString:(NSString*)table columns:(NSMutableArray*)columns;
- (id<CapexSQLStatement>) prepareQueryAllStatementWithStringAndArrayOfStringAndArrayOfCapexSQLOrderingRule:(NSString*)table columns:(NSMutableArray*)columns order:(NSMutableArray*)order;
- (id<CapexSQLStatement>) prepareCountRecordsStatement:(NSString*)table criteria:(NSMutableDictionary*)criteria;
- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMap:(NSString*)table criteria:(NSMutableDictionary*)criteria;
- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedInteger:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit;
- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedInteger:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset;
- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfString:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset columns:(NSMutableArray*)columns;
- (id<CapexSQLStatement>) prepareQueryWithCriteriaStatementWithStringAndMapAndSignedIntegerAndSignedIntegerAndArrayOfStringAndArrayOfCapexSQLOrderingRule:(NSString*)table criteria:(NSMutableDictionary*)criteria limit:(int)limit offset:(int)offset columns:(NSMutableArray*)columns order:(NSMutableArray*)order;
- (id<CapexSQLStatement>) prepareQueryDistinctValuesStatement:(NSString*)table column:(NSString*)column;
- (id<CapexSQLStatement>) prepareInsertStatement:(NSString*)table data:(CapeDynamicMap*)data;
- (id<CapexSQLStatement>) prepareUpdateStatement:(NSString*)table criteria:(CapeDynamicMap*)criteria data:(CapeDynamicMap*)data;
- (id<CapexSQLStatement>) prepareDeleteStatement:(NSString*)table criteria:(CapeDynamicMap*)criteria;
- (id<CapeLoggingContext>) getLogger;
- (CapexSQLDatabase*) setLogger:(id<CapeLoggingContext>)v;
@end
