
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
#import "CapeMath.h"
#import "CapexVector3.h"
#import "CapexMatrix44.h"

@implementation CapexMatrix44

- (CapexMatrix44*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->v = [[NSMutableArray alloc] initWithCapacity:16];
	return(self);
}

+ (CapexMatrix44*) forZero {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), nil]]);
}

+ (CapexMatrix44*) forIdentity {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forTranslate:(double)translateX translateY:(double)translateY translateZ:(double)translateZ {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(translateX), @(0.0), @(1.0), @(0.0), @(translateY), @(0.0), @(0.0), @(1.0), @(translateZ), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forXRotation:(double)angle {
	double c = [CapeMath cos:angle];
	double s = [CapeMath sin:angle];
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(c), @(-s), @(0.0), @(0.0), @(s), @(c), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forYRotation:(double)angle {
	double c = [CapeMath cos:angle];
	double s = [CapeMath sin:angle];
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(c), @(0.0), @(s), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(-s), @(0.0), @(c), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forZRotation:(double)angle {
	double c = [CapeMath cos:angle];
	double s = [CapeMath sin:angle];
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(c), @(-s), @(0.0), @(0.0), @(s), @(c), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forSkew:(double)vx vy:(double)vy vz:(double)vz {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(vx), @(vx), @(0.0), @(vy), @(1.0), @(vy), @(0.0), @(vz), @(vz), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forXRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ {
	CapexMatrix44* translate = [CapexMatrix44 forTranslate:centerX translateY:centerY translateZ:centerZ];
	CapexMatrix44* rotate = [CapexMatrix44 forXRotation:angle];
	CapexMatrix44* translateBack = [CapexMatrix44 forTranslate:-centerX translateY:-centerY translateZ:-centerZ];
	CapexMatrix44* translatedRotated = [CapexMatrix44 multiplyMatrix:translate b:rotate];
	return([CapexMatrix44 multiplyMatrix:translatedRotated b:translateBack]);
}

+ (CapexMatrix44*) forYRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ {
	CapexMatrix44* translate = [CapexMatrix44 forTranslate:centerX translateY:centerY translateZ:centerZ];
	CapexMatrix44* rotate = [CapexMatrix44 forYRotation:angle];
	CapexMatrix44* translateBack = [CapexMatrix44 forTranslate:-centerX translateY:-centerY translateZ:-centerZ];
	CapexMatrix44* translatedRotated = [CapexMatrix44 multiplyMatrix:translate b:rotate];
	return([CapexMatrix44 multiplyMatrix:translatedRotated b:translateBack]);
}

+ (CapexMatrix44*) forZRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY centerZ:(double)centerZ {
	CapexMatrix44* translate = [CapexMatrix44 forTranslate:centerX translateY:centerY translateZ:centerZ];
	CapexMatrix44* rotate = [CapexMatrix44 forZRotation:angle];
	CapexMatrix44* translateBack = [CapexMatrix44 forTranslate:-centerX translateY:-centerY translateZ:-centerZ];
	CapexMatrix44* translatedRotated = [CapexMatrix44 multiplyMatrix:translate b:rotate];
	return([CapexMatrix44 multiplyMatrix:translatedRotated b:translateBack]);
}

+ (CapexMatrix44*) forScale:(double)scaleX scaleY:(double)scaleY scaleZ:(double)scaleZ {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(scaleX), @(0.0), @(0.0), @(0.0), @(0.0), @(scaleY), @(0.0), @(0.0), @(0.0), @(0.0), @(scaleZ), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix44*) forFlipXY:(BOOL)flipXY {
	if(flipXY) {
		return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(-1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
	}
	return([CapexMatrix44 forIdentity]);
}

+ (CapexMatrix44*) forFlipXZ:(BOOL)flipXZ {
	if(flipXZ) {
		return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(-1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
	}
	return([CapexMatrix44 forIdentity]);
}

+ (CapexMatrix44*) forFlipYZ:(BOOL)flipYZ {
	if(flipYZ) {
		return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @(-1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
	}
	return([CapexMatrix44 forIdentity]);
}

+ (CapexMatrix44*) forValues:(NSMutableArray*)mv {
	CapexMatrix44* v = [[CapexMatrix44 alloc] init];
	int i = 0;
	for(i = 0 ; i < 16 ; i++) {
		if(i >= [mv count]) {
			[v->v insertObject:@(0.0) atIndex:i];
		}
		else {
			[v->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mv objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; })) atIndex:i];
		}
	}
	return(v);
}

+ (CapexMatrix44*) multiplyScalar:(double)v mm:(CapexMatrix44*)mm {
	return([CapexMatrix44 forValues:[NSMutableArray arrayWithObjects: @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; }) * v), @((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; }) * v), nil]]);
}

+ (CapexMatrix44*) multiplyMatrix:(CapexMatrix44*)a b:(CapexMatrix44*)b {
	CapexMatrix44* matrix44 = [[CapexMatrix44 alloc] init];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; })) atIndex:0];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; })) atIndex:1];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; })) atIndex:2];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; })) atIndex:3];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; })) atIndex:4];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; })) atIndex:5];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; })) atIndex:6];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; })) atIndex:7];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; })) atIndex:8];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; })) atIndex:9];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; })) atIndex:10];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; })) atIndex:11];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; })) atIndex:12];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; })) atIndex:13];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; })) atIndex:14];
	[matrix44->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:12]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:13]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:14]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:15]; _v == nil ? 0 : _v.doubleValue; })) atIndex:15];
	return(matrix44);
}

+ (CapexVector3*) multiplyVector:(CapexMatrix44*)a b:(CapexVector3*)b {
	double x = (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * b->x + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * b->y + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * b->z + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * 1.0;
	double y = (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * b->x + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * b->y + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * b->z + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * 1.0;
	double z = (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * b->x + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:9]; _v == nil ? 0 : _v.doubleValue; }) * b->y + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:10]; _v == nil ? 0 : _v.doubleValue; }) * b->z + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:11]; _v == nil ? 0 : _v.doubleValue; }) * 1.0;
	return([CapexVector3 create:x y:y z:z]);
}

@end
