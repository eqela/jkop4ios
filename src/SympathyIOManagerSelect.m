
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
#import <stdio.h>
#import <stdlib.h>
#import <errno.h>
#import <string.h>
#import <sys/select.h>
#import <unistd.h>
#import "SympathyIOManager.h"
#import "SympathyIOManagerEntry.h"
#import "CapeFileDescriptor.h"
#import "CapeVector.h"
#import "CapeLoggingContext.h"
#import "CapeLog.h"
#import "CapeString.h"
#import "CapeStaticFileDescriptor.h"
#import "SympathyIOManagerSelect.h"

@class SympathyIOManagerSelectMyEntry;
@class SympathyIOManagerSelectListAction;

@interface SympathyIOManagerSelectMyEntry : NSObject <SympathyIOManagerEntry, CapeFileDescriptor>
- (SympathyIOManagerSelectMyEntry*) init;
- (int) getFileDescriptor;
- (void) onReadReady;
- (void) onWriteReady;
- (void) setListeners:(void(^)(void))rrl wrl:(void(^)(void))wrl;
- (void) setReadListener:(void(^)(void))rrl;
- (void) setWriteListener:(void(^)(void))wrl;
- (void) update;
- (void) remove;
- (id<CapeFileDescriptor>) getFdo;
- (SympathyIOManagerSelectMyEntry*) setFdo:(id<CapeFileDescriptor>)v;
- (SympathyIOManagerSelect*) getMaster;
- (SympathyIOManagerSelectMyEntry*) setMaster:(SympathyIOManagerSelect*)v;
@end

@implementation SympathyIOManagerSelectMyEntry

{
	id<CapeFileDescriptor> fdo;
	SympathyIOManagerSelect* master;
	void (^rrl)(void);
	void (^wrl)(void);
	BOOL added;
}

- (SympathyIOManagerSelectMyEntry*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->added = FALSE;
	self->wrl = nil;
	self->rrl = nil;
	self->master = nil;
	self->fdo = nil;
	return(self);
}

- (int) getFileDescriptor {
	if(self->fdo == nil) {
		return(-1);
	}
	return([self->fdo getFileDescriptor]);
}

- (void) onReadReady {
	void (^rrl)(void) = self->rrl;
	if(rrl != nil) {
		rrl();
	}
}

- (void) onWriteReady {
	void (^wrl)(void) = self->wrl;
	if(wrl != nil) {
		wrl();
	}
}

- (void) setListeners:(void(^)(void))rrl wrl:(void(^)(void))wrl {
	self->rrl = rrl;
	self->wrl = wrl;
	[self update];
}

- (void) setReadListener:(void(^)(void))rrl {
	self->rrl = rrl;
	[self update];
}

- (void) setWriteListener:(void(^)(void))wrl {
	self->wrl = wrl;
	[self update];
}

- (void) update {
	[self remove];
	if(self->fdo == nil || self->master == nil) {
		return;
	}
	if(self->rrl == nil && self->wrl == nil) {
		return;
	}
	if(self->rrl != nil) {
		[self->master addToReadList:((id<SympathyIOManagerEntry>)self)];
	}
	if(self->wrl != nil) {
		[self->master addToWriteList:((id<SympathyIOManagerEntry>)self)];
	}
	self->added = TRUE;
}

- (void) remove {
	if(self->added == FALSE || self->master == nil) {
		return;
	}
	[self->master removeFromReadList:((id<SympathyIOManagerEntry>)self)];
	[self->master removeFromWriteList:((id<SympathyIOManagerEntry>)self)];
	self->added = FALSE;
}

- (id<CapeFileDescriptor>) getFdo {
	return(self->fdo);
}

- (SympathyIOManagerSelectMyEntry*) setFdo:(id<CapeFileDescriptor>)v {
	self->fdo = v;
	return(self);
}

- (SympathyIOManagerSelect*) getMaster {
	return(self->master);
}

- (SympathyIOManagerSelectMyEntry*) setMaster:(SympathyIOManagerSelect*)v {
	self->master = v;
	return(self);
}

@end

extern int SympathyIOManagerSelectListActionADD_TO_READ_LIST;
extern int SympathyIOManagerSelectListActionREMOVE_FROM_READ_LIST;
extern int SympathyIOManagerSelectListActionADD_TO_WRITE_LIST;
extern int SympathyIOManagerSelectListActionREMOVE_FROM_WRITE_LIST;

@interface SympathyIOManagerSelectListAction : NSObject
{
	@public id<SympathyIOManagerEntry> entry;
	@public int op;
}
- (SympathyIOManagerSelectListAction*) init;
- (SympathyIOManagerSelectListAction*) initWithIOManagerEntryAndSignedInteger:(id<SympathyIOManagerEntry>)entry op:(int)op;
@end

int SympathyIOManagerSelectListActionADD_TO_READ_LIST = 0;
int SympathyIOManagerSelectListActionREMOVE_FROM_READ_LIST = 1;
int SympathyIOManagerSelectListActionADD_TO_WRITE_LIST = 2;
int SympathyIOManagerSelectListActionREMOVE_FROM_WRITE_LIST = 3;

@implementation SympathyIOManagerSelectListAction

- (SympathyIOManagerSelectListAction*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->op = 0;
	self->entry = nil;
	return(self);
}

- (SympathyIOManagerSelectListAction*) initWithIOManagerEntryAndSignedInteger:(id<SympathyIOManagerEntry>)entry op:(int)op {
	if([super init] == nil) {
		return(nil);
	}
	self->op = 0;
	self->entry = nil;
	self->entry = entry;
	self->op = op;
	return(self);
}

@end

@implementation SympathyIOManagerSelect

{
	BOOL exitflag;
	BOOL running;
	int commpipewritefd;
	NSMutableArray* readlist;
	NSMutableArray* writelist;
	NSMutableArray* listActionQueue;
}

- (SympathyIOManagerSelect*) init {
	if([super init] == nil) {
		return(nil);
	}
	self->listActionQueue = nil;
	self->writelist = nil;
	self->readlist = nil;
	self->commpipewritefd = -1;
	self->running = FALSE;
	self->exitflag = FALSE;
	self->readlist = [[NSMutableArray alloc] init];
	self->writelist = [[NSMutableArray alloc] init];
	return(self);
}

- (void) addToReadList:(id<SympathyIOManagerEntry>)entry {
	if(self->listActionQueue != nil) {
		[self->listActionQueue addObject:[[SympathyIOManagerSelectListAction alloc] initWithIOManagerEntryAndSignedInteger:entry op:SympathyIOManagerSelectListActionADD_TO_READ_LIST]];
		return;
	}
	[self->readlist addObject:entry];
}

- (void) addToWriteList:(id<SympathyIOManagerEntry>)entry {
	if(self->listActionQueue != nil) {
		[self->listActionQueue addObject:[[SympathyIOManagerSelectListAction alloc] initWithIOManagerEntryAndSignedInteger:entry op:SympathyIOManagerSelectListActionADD_TO_WRITE_LIST]];
		return;
	}
	[self->writelist addObject:entry];
}

- (void) removeFromReadList:(id<SympathyIOManagerEntry>)entry {
	if(self->listActionQueue != nil) {
		[self->listActionQueue addObject:[[SympathyIOManagerSelectListAction alloc] initWithIOManagerEntryAndSignedInteger:entry op:SympathyIOManagerSelectListActionREMOVE_FROM_READ_LIST]];
		return;
	}
	[CapeVector removeValue:self->readlist value:entry];
}

- (void) removeFromWriteList:(id<SympathyIOManagerEntry>)entry {
	if(self->listActionQueue != nil) {
		[self->listActionQueue addObject:[[SympathyIOManagerSelectListAction alloc] initWithIOManagerEntryAndSignedInteger:entry op:SympathyIOManagerSelectListActionREMOVE_FROM_WRITE_LIST]];
		return;
	}
	[CapeVector removeValue:self->writelist value:entry];
}

- (id<SympathyIOManagerEntry>) add:(id)o {
	id<CapeFileDescriptor> fdo = ((id<CapeFileDescriptor>)({ id _v = o; [((NSObject*)_v) conformsToProtocol:@protocol(CapeFileDescriptor)] ? _v : nil; }));
	if(fdo == nil) {
		return(nil);
	}
	return(((id<SympathyIOManagerEntry>)[[[[SympathyIOManagerSelectMyEntry alloc] init] setMaster:self] setFdo:fdo]));
}

- (BOOL) executeSelect:(id<CapeLoggingContext>)ctx fdr:(fd_set*)fdr fdw:(fd_set*)fdw timeout:(int)timeout {
	int n = 0;
	int fd = 0;
	FD_ZERO(fdr);
	FD_ZERO(fdw);
	int rc = 0;
	int wc = 0;
	if(self->readlist != nil) {
		int n2 = 0;
		int m = [self->readlist count];
		for(n2 = 0 ; n2 < m ; n2++) {
			id<CapeFileDescriptor> o = ((id<CapeFileDescriptor>)({ id _v = ((id<SympathyIOManagerEntry>)[self->readlist objectAtIndex:n2]); [((NSObject*)_v) conformsToProtocol:@protocol(CapeFileDescriptor)] ? _v : nil; }));
			if(o != nil) {
				fd = [o getFileDescriptor];
				if(fd < 0) {
					FD_ZERO(fdr);
					FD_ZERO(fdw);
					return(TRUE);
				}
				if(fd >= 0) {
					FD_SET(fd, fdr);
				}
				if(fd > n) {
					n = fd;
				}
				rc++;
			}
		}
	}
	if(self->writelist != nil) {
		int n3 = 0;
		int m2 = [self->writelist count];
		for(n3 = 0 ; n3 < m2 ; n3++) {
			id<CapeFileDescriptor> o = ((id<CapeFileDescriptor>)({ id _v = ((id<SympathyIOManagerEntry>)[self->writelist objectAtIndex:n3]); [((NSObject*)_v) conformsToProtocol:@protocol(CapeFileDescriptor)] ? _v : nil; }));
			if(o != nil) {
				fd = [o getFileDescriptor];
				if(fd < 0) {
					FD_ZERO(fdr);
					FD_ZERO(fdw);
					return(TRUE);
				}
				if(fd >= 0) {
					FD_SET(fd, fdw);
				}
				if(fd > n) {
					n = fd;
				}
				wc++;
			}
		}
	}
	int nc = 0;
	if(n > 0) {
		nc = n + 1;
	}
	int r = -1;
	if(timeout < 0) {
		r = select(nc, fdr, fdw, (void*)0, (void*)0);
	}
	else {
		struct timeval tv;
		tv.tv_sec = (long)timeout / 1000000;
		tv.tv_usec = (long)timeout % 1000000;
		r = select(nc, fdr, fdw, (void*)0, &tv);
	}
	BOOL v = FALSE;
	if(r < 0) {
		NSString* err = nil;
		if(errno != EINTR) {
			char* ee = strerror(errno);
			if(ee != NULL) {
				err = [[NSString alloc] initWithUTF8String:ee];
			}
		}
		if(!(({ NSString* _s1 = err; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			[CapeLog error:ctx message:[[[@"Call to select() returned error status " stringByAppendingString:([CapeString forInteger:r])] stringByAppendingString:@": "] stringByAppendingString:err]];
		}
	}
	else {
		if(r > 0) {
			v = TRUE;
		}
	}
	return(v);
}

- (BOOL) execute:(id<CapeLoggingContext>)ctx {
	self->exitflag = FALSE;
	self->running = TRUE;
	int prd = -1;
	int pfd = -1;
	int pipes[2];
	if(pipe(pipes) != 0) {
		[CapeLog error:ctx message:@"SelectEngine: Failed to create controller pipe"];
		return(FALSE);
	}
	prd = pipes[0];
	pfd = pipes[1];
	if(prd < 0 || pfd < 0) {
		[CapeLog error:ctx message:@"SelectEngine: One of the controller pipes was invalid"];
		return(FALSE);
	}
	id<SympathyIOManagerEntry> ee = [self add:((id)[CapeStaticFileDescriptor forFileDescriptor:prd])];
	if(ee != nil) {
		[ee setReadListener:^void() {
			int fd = prd;
			char b[16];
			read(fd, b, 16);
		}];
	}
	fd_set* fdsetr = nil;
	fd_set* fdsetw = nil;
	fd_set fdr;
	fd_set fdw;
	fdsetr = &fdr;
	fdsetw = &fdw;
	self->commpipewritefd = pfd;
	[CapeLog debug:ctx message:@"SelectEngine started"];
	while(self->exitflag == FALSE) {
		if([self executeSelect:ctx fdr:fdsetr fdw:fdsetw timeout:-1] == FALSE) {
			continue;
		}
		self->listActionQueue = [[NSMutableArray alloc] init];
		if(self->readlist != nil) {
			int n = 0;
			int m = [self->readlist count];
			for(n = 0 ; n < m ; n++) {
				SympathyIOManagerSelectMyEntry* ele = ((SympathyIOManagerSelectMyEntry*)({ id _v = ((id<SympathyIOManagerEntry>)[self->readlist objectAtIndex:n]); [_v isKindOfClass:[SympathyIOManagerSelectMyEntry class]] ? _v : nil; }));
				if(ele != nil) {
					int fd = [ele getFileDescriptor];
					if(fd < 0 || FD_ISSET(fd, fdsetr) != 0) {
						if(fd >= 0) {
							FD_CLR(fd, fdsetr);
						}
						[ele onReadReady];
					}
				}
			}
		}
		if(self->writelist != nil) {
			int n2 = 0;
			int m2 = [self->writelist count];
			for(n2 = 0 ; n2 < m2 ; n2++) {
				SympathyIOManagerSelectMyEntry* ele = ((SympathyIOManagerSelectMyEntry*)({ id _v = ((id<SympathyIOManagerEntry>)[self->writelist objectAtIndex:n2]); [_v isKindOfClass:[SympathyIOManagerSelectMyEntry class]] ? _v : nil; }));
				if(ele != nil) {
					int fd = [ele getFileDescriptor];
					if(fd < 0 || FD_ISSET(fd, fdsetw) != 0) {
						if(fd >= 0) {
							FD_CLR(fd, fdsetw);
						}
						[ele onWriteReady];
					}
				}
			}
		}
		NSMutableArray* lq = self->listActionQueue;
		self->listActionQueue = nil;
		if(lq != nil) {
			int n3 = 0;
			int m3 = [lq count];
			for(n3 = 0 ; n3 < m3 ; n3++) {
				SympathyIOManagerSelectListAction* action = ((SympathyIOManagerSelectListAction*)[lq objectAtIndex:n3]);
				if(action != nil) {
					if(action->op == SympathyIOManagerSelectListActionADD_TO_READ_LIST) {
						[self addToReadList:action->entry];
					}
					else {
						if(action->op == SympathyIOManagerSelectListActionREMOVE_FROM_READ_LIST) {
							[self removeFromReadList:action->entry];
						}
						else {
							if(action->op == SympathyIOManagerSelectListActionADD_TO_WRITE_LIST) {
								[self addToWriteList:action->entry];
							}
							else {
								if(action->op == SympathyIOManagerSelectListActionREMOVE_FROM_WRITE_LIST) {
									[self removeFromWriteList:action->entry];
								}
							}
						}
					}
				}
			}
		}
	}
	close(pipes[0]);
	close(pipes[1]);
	self->commpipewritefd = -1;
	self->running = FALSE;
	[CapeLog debug:ctx message:@"SelectEngine ended"];
	return(TRUE);
}

- (void) stop {
	self->exitflag = TRUE;
	if(self->commpipewritefd >= 0) {
		char c = 1;
		write(commpipewritefd, &c, 1);
	}
}

- (BOOL) isRunning {
	return(self->running);
}

@end
