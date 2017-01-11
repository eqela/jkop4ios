
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
#import "CapeRandom.h"

@implementation CapeRandom

{
	int64_t seed;
}

- (CapeRandom*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->seed = ((int64_t)0);
	return(self);
}

- (CapeRandom*) initWithSigned64bitInteger:(int64_t)seed {
	if([super init] == nil) {
		return(nil);
	}
	self->seed = ((int64_t)0);
	[self setSeed:seed];
	return(self);
}

- (void) setSeed:(int64_t)seed {
	self->seed = seed;
}

- (BOOL) nextBoolean {
	if([self nextInt] % 2 == 0) {
		return(FALSE);
	}
	return(TRUE);
}

- (int32_t) nextInt {
	NSLog(@"%@", @"[cape.Random.nextInt] (Random.sling:92:2): Not implemented");
	return(((int32_t)0));
}

- (int32_t) nextIntWithSigned32bitInteger:(int32_t)n {
	NSLog(@"%@", @"[cape.Random.nextInt] (Random.sling:109:2): Not implemented");
	return(((int32_t)0));
}

- (int32_t) nextIntWithSigned32bitIntegerAndSigned32bitInteger:(int32_t)s e:(int32_t)e {
	NSLog(@"%@", @"[cape.Random.nextInt] (Random.sling:130:2): Not implemented");
	return(((int32_t)0));
}

- (void) nextBytes:(NSMutableArray*)buf {
	NSLog(@"%@", @"[cape.Random.nextBytes] (Random.sling:146:2): Not implemented");
}

- (double) nextDouble {
	NSLog(@"%@", @"[cape.Random.nextDouble] (Random.sling:162:2): Not implemented");
	return(0.0);
}

- (float) nextFloat {
	NSLog(@"%@", @"[cape.Random.nextFloat] (Random.sling:179:2): Not implemented");
	return(0.0f);
}

- (double) nextGaussian {
	NSLog(@"%@", @"--- stub --- cape.Random :: nextGaussian");
	return(0.0);
}

@end
