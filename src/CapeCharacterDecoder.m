
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
#import "CapeCharacterIterator.h"
#import "CapeString.h"
#import "CapeCharacterDecoder.h"

int CapeCharacterDecoderUTF8 = 0;
int CapeCharacterDecoderASCII = 1;
int CapeCharacterDecoderUCS2 = 2;

@implementation CapeCharacterDecoder

{
	int encoding;
	int current;
	int currentSize;
	BOOL ended;
}

- (CapeCharacterDecoder*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->ended = FALSE;
	self->currentSize = 0;
	self->current = ((int)0);
	self->encoding = 0;
	return(self);
}

- (void) copyTo:(CapeCharacterDecoder*)o {
	o->encoding = self->encoding;
	o->current = self->current;
	o->currentSize = self->currentSize;
	o->ended = self->ended;
}

- (BOOL) moveToPreviousByte {
	return(FALSE);
}

- (BOOL) moveToNextByte {
	return(FALSE);
}

- (int) getCurrentByte {
	return(0);
}

- (CapeCharacterDecoder*) setEncoding:(NSString*)ee {
	if([CapeString equalsIgnoreCase:ee str2:@"UTF8"] || [CapeString equalsIgnoreCase:ee str2:@"UTF-8"]) {
		self->encoding = CapeCharacterDecoderUTF8;
		self->currentSize = 1;
		return(self);
	}
	if([CapeString equalsIgnoreCase:ee str2:@"ASCII"]) {
		self->encoding = CapeCharacterDecoderASCII;
		self->currentSize = 1;
		return(self);
	}
	if([CapeString equalsIgnoreCase:ee str2:@"UCS2"] || [CapeString equalsIgnoreCase:ee str2:@"UCS-2"]) {
		self->encoding = CapeCharacterDecoderUCS2;
		self->currentSize = 2;
		return(self);
	}
	return(nil);
}

- (BOOL) moveToPreviousChar {
	int cs = self->currentSize;
	if(cs > 1) {
		int n = 0;
		for(n = 0 ; n < cs - 1 ; n++) {
			if([self moveToPreviousByte] == FALSE) {
				return(FALSE);
			}
		}
	}
	BOOL v = [self doMoveToPreviousChar];
	if(v == FALSE && cs > 1) {
		int n = 0;
		for(n = 0 ; n < cs - 1 ; n++) {
			[self moveToNextByte];
		}
	}
	if(v && self->ended) {
		self->ended = FALSE;
	}
	return(v);
}

- (BOOL) doMoveToPreviousChar {
	if(self->encoding == CapeCharacterDecoderUTF8) {
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int c2 = ((int)([self getCurrentByte]));
		if(c2 <= 127) {
			self->current = ((int)c2);
			self->currentSize = 1;
			return(TRUE);
		}
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int c1 = ((int)([self getCurrentByte]));
		if((c1 & 192) == 192) {
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int v = ((int)((c1 & 31) << 6));
			v += ((int)(c2 & 63));
			self->current = ((int)v);
			self->currentSize = 2;
			return(TRUE);
		}
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int c0 = ((int)([self getCurrentByte]));
		if((c0 & 224) == 224) {
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int v = ((int)((c0 & 15) << 12));
			v += ((int)((c1 & 63) << 6));
			v += ((int)(c2 & 63));
			self->current = ((int)v);
			self->currentSize = 3;
			return(TRUE);
		}
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int cm1 = ((int)([self getCurrentByte]));
		if((cm1 & 240) == 240) {
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int v = ((int)((cm1 & 7) << 18));
			v += ((int)((c0 & 63) << 12));
			v += ((int)((c1 & 63) << 6));
			v += ((int)(c2 & 63));
			self->current = ((int)v);
			self->currentSize = 4;
			return(TRUE);
		}
		[self moveToNextByte];
		[self moveToNextByte];
		[self moveToNextByte];
		[self moveToNextByte];
		return(FALSE);
	}
	if(self->encoding == CapeCharacterDecoderASCII) {
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		self->current = ((int)([self getCurrentByte]));
		return(TRUE);
	}
	if(self->encoding == CapeCharacterDecoderUCS2) {
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int c1 = ((int)([self getCurrentByte]));
		if([self moveToPreviousByte] == FALSE) {
			return(FALSE);
		}
		int c0 = ((int)([self getCurrentByte]));
		if([self moveToNextByte] == FALSE) {
			return(FALSE);
		}
		self->current = ((int)(c0 << 8 & c1));
		return(TRUE);
	}
	return(FALSE);
}

- (BOOL) moveToNextChar {
	BOOL v = [self doMoveToNextChar];
	if(v == FALSE) {
		self->current = ((int)0);
		self->ended = TRUE;
	}
	return(v);
}

- (BOOL) doMoveToNextChar {
	if(self->encoding == CapeCharacterDecoderUTF8) {
		if([self moveToNextByte] == FALSE) {
			return(FALSE);
		}
		int b1 = [self getCurrentByte];
		int v = -1;
		if((b1 & 240) == 240) {
			v = ((int)((b1 & 7) << 18));
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int b2 = [self getCurrentByte];
			v += ((int)((b2 & 63) << 12));
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int b3 = [self getCurrentByte];
			v += ((int)((b3 & 63) << 6));
			if([self moveToNextByte] == FALSE) {
				return(FALSE);
			}
			int b4 = [self getCurrentByte];
			v += ((int)(b4 & 63));
			self->currentSize = 4;
		}
		else {
			if((b1 & 224) == 224) {
				v = ((int)((b1 & 15) << 12));
				if([self moveToNextByte] == FALSE) {
					return(FALSE);
				}
				int b2 = [self getCurrentByte];
				v += ((int)((b2 & 63) << 6));
				if([self moveToNextByte] == FALSE) {
					return(FALSE);
				}
				int b3 = [self getCurrentByte];
				v += ((int)(b3 & 63));
				self->currentSize = 3;
			}
			else {
				if((b1 & 192) == 192) {
					v = ((int)((b1 & 31) << 6));
					if([self moveToNextByte] == FALSE) {
						return(FALSE);
					}
					int b2 = [self getCurrentByte];
					v += ((int)(b2 & 63));
					self->currentSize = 2;
				}
				else {
					if(b1 <= 127) {
						v = ((int)b1);
						self->currentSize = 1;
					}
					else {
						return(FALSE);
					}
				}
			}
		}
		self->current = ((int)v);
		return(TRUE);
	}
	if(self->encoding == CapeCharacterDecoderASCII) {
		if([self moveToNextByte] == FALSE) {
			return(FALSE);
		}
		self->current = ((int)([self getCurrentByte]));
		return(TRUE);
	}
	if(self->encoding == CapeCharacterDecoderUCS2) {
		if([self moveToNextByte] == FALSE) {
			return(FALSE);
		}
		int c0 = ((int)([self getCurrentByte]));
		if([self moveToNextByte] == FALSE) {
			return(FALSE);
		}
		int c1 = ((int)([self getCurrentByte]));
		self->current = ((int)(c0 << 8 & c1));
		return(TRUE);
	}
	return(FALSE);
}

- (int) getCurrentChar {
	return(self->current);
}

- (int) getNextChar {
	if([self moveToNextChar] == FALSE) {
		return(((int)0));
	}
	return(self->current);
}

- (BOOL) hasEnded {
	return(self->ended);
}

@end
