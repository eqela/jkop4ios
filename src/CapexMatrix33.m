
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
#import "CapexVector2.h"
#import "CapexMatrix33.h"

@implementation CapexMatrix33

- (CapexMatrix33*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->v = [[NSMutableArray alloc] initWithCapacity:9];
	return(self);
}

+ (CapexMatrix33*) forZero {
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), @(0.0), nil]]);
}

+ (CapexMatrix33*) forIdentity {
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix33*) invertMatrix:(CapexMatrix33*)m {
	double d = (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; });
	CapexMatrix33* v = [[CapexMatrix33 alloc] init];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:0];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:3];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:6];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:1];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:4];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:7];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:2];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:5];
	[v->v insertObject:@(((double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) - (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[m->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; })) / d) atIndex:8];
	return(v);
}

+ (CapexMatrix33*) forTranslate:(double)translateX translateY:(double)translateY {
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(translateX), @(0.0), @(1.0), @(translateY), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix33*) forRotation:(double)angle {
	double c = [CapeMath cos:angle];
	double s = [CapeMath sin:angle];
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(c), @(s), @(0.0), @(-s), @(c), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix33*) forRotationWithCenter:(double)angle centerX:(double)centerX centerY:(double)centerY {
	CapexMatrix33* translate = [CapexMatrix33 forTranslate:centerX translateY:centerY];
	CapexMatrix33* rotate = [CapexMatrix33 forRotation:angle];
	CapexMatrix33* translateBack = [CapexMatrix33 forTranslate:-centerX translateY:-centerY];
	CapexMatrix33* translatedRotated = [CapexMatrix33 multiplyMatrix:translate b:rotate];
	return([CapexMatrix33 multiplyMatrix:translatedRotated b:translateBack]);
}

+ (CapexMatrix33*) forSkew:(double)skewX skewY:(double)skewY {
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(skewX), @(0.0), @(skewY), @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix33*) forScale:(double)scaleX scaleY:(double)scaleY {
	return([CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(scaleX), @(0.0), @(0.0), @(0.0), @(scaleY), @(0.0), @(0.0), @(0.0), @(1.0), nil]]);
}

+ (CapexMatrix33*) forFlip:(BOOL)flipX flipY:(BOOL)flipY {
	CapexMatrix33* xmat33 = [CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(1.0), @(0.0), @(0.0), @(0.0), @(-1.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]];
	CapexMatrix33* ymat33 = [CapexMatrix33 forValues:[NSMutableArray arrayWithObjects: @(-1.0), @(0.0), @(0.0), @(0.0), @(1.0), @(0.0), @(0.0), @(0.0), @(1.0), nil]];
	if(flipX && flipY) {
		return([CapexMatrix33 multiplyMatrix:xmat33 b:ymat33]);
	}
	else {
		if(flipX) {
			return(xmat33);
		}
		else {
			if(flipY) {
				return(ymat33);
			}
		}
	}
	return([CapexMatrix33 forIdentity]);
}

+ (CapexMatrix33*) forValues:(NSMutableArray*)mv {
	CapexMatrix33* v = [[CapexMatrix33 alloc] init];
	int i = 0;
	for(i = 0 ; i < 9 ; i++) {
		if(i >= [mv count]) {
			[v->v insertObject:@(0.0) atIndex:i];
		}
		else {
			[v->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mv objectAtIndex:i]; _v == nil ? 0 : _v.doubleValue; })) atIndex:i];
		}
	}
	return(v);
}

+ (CapexMatrix33*) multiplyScalar:(double)v mm:(CapexMatrix33*)mm {
	CapexMatrix33* mat33 = [CapexMatrix33 forZero];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:0];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:1];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:2];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:3];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:4];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:5];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:6];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:7];
	[mat33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[mm->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * v) atIndex:8];
	return(mat33);
}

+ (CapexMatrix33*) multiplyMatrix:(CapexMatrix33*)a b:(CapexMatrix33*)b {
	CapexMatrix33* matrix33 = [[CapexMatrix33 alloc] init];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:0];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:1];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:2];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:3];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:4];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:5];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; })) atIndex:6];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; })) atIndex:7];
	[matrix33->v insertObject:@((double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:6]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:7]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; }) * (double)({ NSNumber* _v = (NSNumber*)[b->v objectAtIndex:8]; _v == nil ? 0 : _v.doubleValue; })) atIndex:8];
	return(matrix33);
}

+ (CapexVector2*) multiplyVector:(CapexMatrix33*)a b:(CapexVector2*)b {
	double x = (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:0]; _v == nil ? 0 : _v.doubleValue; }) * b->x + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:1]; _v == nil ? 0 : _v.doubleValue; }) * b->y + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:2]; _v == nil ? 0 : _v.doubleValue; }) * 1.0;
	double y = (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:3]; _v == nil ? 0 : _v.doubleValue; }) * b->x + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:4]; _v == nil ? 0 : _v.doubleValue; }) * b->y + (double)({ NSNumber* _v = (NSNumber*)[a->v objectAtIndex:5]; _v == nil ? 0 : _v.doubleValue; }) * 1.0;
	return([CapexVector2 create:x y:y]);
}

@end
