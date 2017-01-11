
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

@protocol CapeFile;
@protocol CapeLoggingContext;
@protocol CapexSQLStatement;
@class CapeDynamicMap;
@class CapexSQLTableColumnInfo;

@interface CapexSQLiteDatabase : CapexSQLDatabase
- (CapexSQLiteDatabase*) init;
+ (CapexSQLiteDatabase*) forFile:(id<CapeFile>)file allowCreate:(BOOL)allowCreate logger:(id<CapeLoggingContext>)logger;
- (NSString*) getDatabaseTypeId;
- (BOOL) initialize:(id<CapeFile>)file create:(BOOL)create;
- (CapeDynamicMap*) querySingleRow:(id<CapexSQLStatement>)stmt;
- (BOOL) tableExists:(NSString*)table;
- (void) queryAllTableNamesWithFunction:(void(^)(NSMutableArray*))callback;
- (NSMutableArray*) queryAllTableNames;
- (NSString*) columnToCreateString:(CapexSQLTableColumnInfo*)cc;
- (id<CapexSQLStatement>) prepareCreateTableStatement:(NSString*)table columns:(NSMutableArray*)columns;
- (id<CapexSQLStatement>) prepareDeleteTableStatement:(NSString*)table;
- (id<CapexSQLStatement>) prepareCreateIndexStatement:(NSString*)table column:(NSString*)column unique:(BOOL)unique;
@end
