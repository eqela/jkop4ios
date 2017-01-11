
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

@class CapexSQLTableColumnInfo;
@class CapexSQLTableColumnIndexInfo;

@interface CapexSQLTableInfo : NSObject
- (CapexSQLTableInfo*) init;
+ (CapexSQLTableInfo*) forName:(NSString*)name;
+ (CapexSQLTableInfo*) forDetails:(NSString*)name columns:(NSMutableArray*)columns indexes:(NSMutableArray*)indexes uniqueIndexes:(NSMutableArray*)uniqueIndexes;
- (CapexSQLTableInfo*) addColumn:(CapexSQLTableColumnInfo*)info;
- (CapexSQLTableInfo*) addIntegerColumn:(NSString*)name;
- (CapexSQLTableInfo*) addStringColumn:(NSString*)name;
- (CapexSQLTableInfo*) addStringKeyColumn:(NSString*)name;
- (CapexSQLTableInfo*) addTextColumn:(NSString*)name;
- (CapexSQLTableInfo*) addIntegerKeyColumn:(NSString*)name;
- (CapexSQLTableInfo*) addDoubleColumn:(NSString*)name;
- (CapexSQLTableInfo*) addBlobColumn:(NSString*)name;
- (CapexSQLTableInfo*) addIndex:(NSString*)column;
- (CapexSQLTableInfo*) addUniqueIndex:(NSString*)column;
- (NSString*) getName;
- (CapexSQLTableInfo*) setName:(NSString*)v;
- (NSMutableArray*) getColumns;
- (CapexSQLTableInfo*) setColumns:(NSMutableArray*)v;
- (NSMutableArray*) getIndexes;
- (CapexSQLTableInfo*) setIndexes:(NSMutableArray*)v;
@end
