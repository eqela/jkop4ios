
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
#import "CapeString.h"
#import "SympathyDNSResolver.h"
#import "CapeLog.h"
#import "SympathyTCPSocket.h"
#import "CapePrintWriter.h"
#import "CapePrintReader.h"
#import "CapeStringBuilder.h"
#import "CapexBase64Encoder.h"
#import "CapeDynamicVector.h"
#import "SympathyDNSRecordMX.h"
#import "SympathyDNSRecord.h"
#import "SympathySMTPMessage.h"
#import "SympathyURL.h"
#import "SympathySMTPClientResult.h"
#import "SympathySMTPClientTransactionResult.h"
#import "CapeDynamicMap.h"
#import "CapeIterator.h"
#import "SympathyConnectedSocket.h"
#import "SympathySSLSocket.h"
#import "CapePrintWriterWrapper.h"
#import "CapeWriter.h"
#import "CapeReader.h"
#import "SympathySMTPClient.h"

@implementation SympathySMTPClient

- (SympathySMTPClient*) init {
	if([super init] == nil) {
		return(nil);
	}
	return(self);
}

+ (SympathyTCPSocket*) connect:(NSString*)server port:(int)port ctx:(id<CapeLoggingContext>)ctx {
	if([CapeString isEmpty:server] || port < 1) {
		return(nil);
	}
	NSString* address = server;
	SympathyDNSResolver* dns = [SympathyDNSResolver create];
	if(dns != nil) {
		address = [dns getIPAddress:server ctx:ctx];
		if([CapeString isEmpty:address]) {
			[CapeLog error:ctx message:[[@"SMTPClient: Could not resolve SMTP server address: `" stringByAppendingString:server] stringByAppendingString:@"'"]];
			return(nil);
		}
	}
	[CapeLog debug:ctx message:[[[[@"SMTPClient: Connecting to SMTP server `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"' .."]];
	SympathyTCPSocket* v = [SympathyTCPSocket createAndConnect:address port:port];
	if(v != nil) {
		[CapeLog debug:ctx message:[[[[@"SMTPClient: Connected to SMTP server `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"' .."]];
	}
	else {
		[CapeLog error:ctx message:[[[[@"SMTPClient: FAILED connection to SMTP server `" stringByAppendingString:address] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"' .."]];
	}
	return(v);
}

+ (BOOL) writeLine:(id<CapePrintWriter>)ops str:(NSString*)str {
	return([ops print:[str stringByAppendingString:@"\r\n"]]);
}

+ (NSString*) communicate:(CapePrintReader*)ins expectCode:(NSString*)expectCode {
	CapeStringBuilder* sb = [[CapeStringBuilder alloc] init];
	NSString* line = [ins readLine];
	if([CapeString isEmpty:line] == FALSE) {
		[sb appendString:line];
	}
	while([CapeString isEmpty:line] == FALSE && [CapeString getChar:line index:3] == '-') {
		line = [ins readLine];
		if([CapeString isEmpty:line] == FALSE) {
			[sb appendString:line];
		}
	}
	if([CapeString isEmpty:line] == FALSE && [CapeString getChar:line index:3] == ' ') {
		if([CapeString isEmpty:expectCode]) {
			return(nil);
		}
		NSString* rc = [CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:line start:0 length:3];
		NSMutableArray* array = [CapeString split:expectCode delim:'|' max:0];
		if(array != nil) {
			int n = 0;
			int m = [array count];
			for(n = 0 ; n < m ; n++) {
				NSString* cc = ((NSString*)[array objectAtIndex:n]);
				if(cc != nil) {
					if([CapeString equals:cc str2:rc]) {
						return(nil);
					}
				}
			}
		}
	}
	NSString* v = [sb toString];
	if([CapeString isEmpty:v]) {
		v = @"XXX Unknown SMTP server error response";
	}
	return(v);
}

+ (NSString*) encode:(NSString*)enc {
	if([CapeString isEmpty:enc]) {
		return(nil);
	}
	return([CapexBase64Encoder encode:[CapeString toUTF8Buffer:enc]]);
}

+ (NSString*) rcptAsEmailAddress:(NSString*)ss {
	if([CapeString isEmpty:ss]) {
		return(ss);
	}
	int b = [CapeString getIndexOfWithStringAndCharacterAndSignedInteger:ss c:'<' start:0];
	if(b < 0) {
		return(ss);
	}
	int e = [CapeString getIndexOfWithStringAndCharacterAndSignedInteger:ss c:'>' start:0];
	if(e < 0) {
		return(ss);
	}
	return([CapeString getSubStringWithStringAndSignedIntegerAndSignedInteger:ss start:b + 1 length:e - b - 1]);
}

+ (NSString*) resolveMXServerForDomain:(NSString*)domain {
	SympathyDNSResolver* dns = [SympathyDNSResolver instance];
	if(dns == nil) {
		return(nil);
	}
	CapeDynamicVector* rcs = [dns getNSRecords:domain type:@"MX" ctx:nil];
	if(rcs == nil || [rcs getSize] < 1) {
		return(nil);
	}
	NSString* v = nil;
	int pr = 0;
	NSMutableArray* array = [rcs toVector];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			SympathyDNSRecordMX* mx = ((SympathyDNSRecordMX*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[SympathyDNSRecordMX class]] ? _v : nil; }));
			if(mx != nil) {
				int p = [mx getPriority];
				if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || p < pr) {
					pr = p;
					v = [mx getAddress];
				}
			}
		}
	}
	return(v);
}

+ (SympathySMTPClientResult*) sendMessage:(SympathySMTPMessage*)msg server:(SympathyURL*)server serverName:(NSString*)serverName ctx:(id<CapeLoggingContext>)ctx {
	if(msg == nil) {
		return([[SympathySMTPClientResult forMessage:msg] addTransaction:[SympathySMTPClientTransactionResult forError:@"No message"]]);
	}
	CapeDynamicVector* rcpts = [msg getAllRcpts];
	if(server != nil) {
		SympathySMTPClientTransactionResult* t = [SympathySMTPClient executeTransaction:msg server:server rcpts:rcpts serverName:serverName ctx:ctx];
		if(t != nil) {
			[t setServer:[server getHost]];
			[t setRecipients:rcpts];
		}
		return([[SympathySMTPClientResult forMessage:msg] addTransaction:t]);
	}
	SympathySMTPClientResult* r = [SympathySMTPClientResult forMessage:msg];
	CapeDynamicMap* servers = [[CapeDynamicMap alloc] init];
	NSMutableArray* array = [rcpts toVector];
	if(array != nil) {
		int n = 0;
		int m = [array count];
		for(n = 0 ; n < m ; n++) {
			NSString* rcpt = ((NSString*)({ id _v = ((id)[array objectAtIndex:n]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
			if(rcpt != nil) {
				NSString* em = [SympathySMTPClient rcptAsEmailAddress:rcpt];
				if([CapeString isEmpty:em]) {
					[r addTransaction:[SympathySMTPClientTransactionResult forError:[[@"Invalid recipient address: `" stringByAppendingString:rcpt] stringByAppendingString:@"'"]]];
					break;
				}
				int at = [CapeString getIndexOfWithStringAndCharacterAndSignedInteger:em c:'@' start:0];
				if(at < 0) {
					[r addTransaction:[SympathySMTPClientTransactionResult forError:[[@"Invalid recipient address: `" stringByAppendingString:rcpt] stringByAppendingString:@"'"]]];
					break;
				}
				NSString* sa = [CapeString getSubStringWithStringAndSignedInteger:em start:at + 1];
				if([CapeString isEmpty:sa]) {
					[r addTransaction:[SympathySMTPClientTransactionResult forError:[[@"Invalid recipient address: `" stringByAppendingString:rcpt] stringByAppendingString:@"'"]]];
					break;
				}
				CapeDynamicVector* ss = ((CapeDynamicVector*)({ id _v = [servers get:sa]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; }));
				if(ss == nil) {
					ss = [[CapeDynamicVector alloc] init];
					[servers setStringAndObject:sa value:((id)ss)];
				}
				[ss appendObject:((id)rcpt)];
			}
		}
	}
	id<CapeIterator> itr = [servers iterateKeys];
	while(itr != nil) {
		NSString* domain = [itr next];
		if([CapeString isEmpty:domain]) {
			break;
		}
		NSString* ds = [SympathySMTPClient resolveMXServerForDomain:domain];
		if([CapeString isEmpty:ds]) {
			[r addTransaction:[SympathySMTPClientTransactionResult forError:[[@"Unable to determine mail server for `" stringByAppendingString:domain] stringByAppendingString:@"'"]]];
		}
		else {
			[CapeLog debug:ctx message:[[[[@"SMTP server for domain `" stringByAppendingString:domain] stringByAppendingString:@"': `"] stringByAppendingString:ds] stringByAppendingString:@"'"]];
			CapeDynamicVector* trcpts = ((CapeDynamicVector*)({ id _v = [servers get:domain]; [_v isKindOfClass:[CapeDynamicVector class]] ? _v : nil; }));
			SympathySMTPClientTransactionResult* t = [SympathySMTPClient executeTransaction:msg server:[SympathyURL forString:[@"smtp://" stringByAppendingString:ds] normalizePath:FALSE] rcpts:trcpts serverName:serverName ctx:ctx];
			if(t != nil) {
				[t setDomain:domain];
				[t setServer:ds];
				[t setRecipients:trcpts];
			}
			[r addTransaction:t];
		}
	}
	CapeDynamicVector* vt = [r getTransactions];
	if(vt == nil || [vt getSize] < 1) {
		[r addTransaction:[SympathySMTPClientTransactionResult forError:@"Unknown error in SMTPClient"]];
	}
	return(r);
}

+ (SympathySMTPClientTransactionResult*) executeTransaction:(SympathySMTPMessage*)msg server:(SympathyURL*)server rcpts:(CapeDynamicVector*)rcpts serverName:(NSString*)serverName ctx:(id<CapeLoggingContext>)ctx {
	SympathyURL* url = server;
	if(url == nil) {
		return([SympathySMTPClientTransactionResult forError:@"No server URL"]);
	}
	id<SympathyConnectedSocket> socket = nil;
	NSString* scheme = [url getScheme];
	NSString* host = [url getHost];
	int port = [url getPortInt];
	int n = 0;
	for(n = 0 ; n < 3 ; n++) {
		if([CapeString equals:@"smtp" str2:scheme] || [CapeString equals:@"smtp+tls" str2:scheme]) {
			if(port < 1) {
				port = 25;
			}
			socket = ((id<SympathyConnectedSocket>)[SympathySMTPClient connect:host port:port ctx:ctx]);
		}
		else {
			if([CapeString equals:@"smtp+ssl" str2:scheme]) {
				if(port < 1) {
					port = 465;
				}
				SympathyTCPSocket* ts = [SympathySMTPClient connect:host port:port ctx:ctx];
				if(ts != nil) {
					socket = ((id<SympathyConnectedSocket>)[SympathySSLSocket forClient:((id<SympathyConnectedSocket>)ts) hostAddress:host ctx:nil acceptInvalidCertificate:FALSE]);
					if(socket == nil) {
						return([SympathySMTPClientTransactionResult forError:@"Failed to start SSL"]);
					}
				}
			}
			else {
				return([SympathySMTPClientTransactionResult forError:[[@"SMTPClient: Unknown SMTP URI scheme `" stringByAppendingString:scheme] stringByAppendingString:@"'"]]);
			}
		}
		if(socket != nil) {
			break;
		}
		[CapeLog debug:ctx message:[[[[@"Failed to connect to SMTP server `" stringByAppendingString:host] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"'. Waiting to retry .."]];
		[CapeLog error:ctx message:@"FIXME - No sleep implementation yet, quitting instead!"];
		break;
	}
	if(socket == nil) {
		return([SympathySMTPClientTransactionResult forError:[[[[@"Unable to connect to SMTP server `" stringByAppendingString:host] stringByAppendingString:@":"] stringByAppendingString:([CapeString forInteger:port])] stringByAppendingString:@"'"]]);
	}
	id<CapePrintWriter> ops = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)socket)];
	CapePrintReader* ins = [[CapePrintReader alloc] initWithReader:((id<CapeReader>)socket)];
	if(ops == nil || ins == nil) {
		return([SympathySMTPClientTransactionResult forError:@"Unable to establish SMTP I/O streams"]);
	}
	NSString* err = nil;
	if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"220"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([SympathySMTPClientTransactionResult forError:err]);
	}
	NSString* sn = serverName;
	if([CapeString isEmpty:sn]) {
		sn = @"eq.net.smtpclient";
	}
	if([SympathySMTPClient writeLine:ops str:[@"EHLO " stringByAppendingString:sn]] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"250"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([SympathySMTPClientTransactionResult forError:err]);
	}
	if([CapeString equals:@"smtp+tls" str2:scheme]) {
		if([SympathySMTPClient writeLine:ops str:@"STARTTLS"] == FALSE) {
			return([SympathySMTPClientTransactionResult forNetworkError]);
		}
		if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"220"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			return([SympathySMTPClientTransactionResult forError:err]);
		}
		ops = nil;
		ins = nil;
		socket = ((id<SympathyConnectedSocket>)[SympathySSLSocket forClient:socket hostAddress:host ctx:nil acceptInvalidCertificate:FALSE]);
		if(socket == nil) {
			return([SympathySMTPClientTransactionResult forError:@"Failed to start SSL"]);
		}
		ops = [CapePrintWriterWrapper forWriter:((id<CapeWriter>)socket)];
		ins = [[CapePrintReader alloc] initWithReader:((id<CapeReader>)socket)];
	}
	NSString* username = [url getUsername];
	NSString* password = [url getPassword];
	if([CapeString isEmpty:username] == FALSE) {
		if([SympathySMTPClient writeLine:ops str:@"AUTH login"] == FALSE) {
			return([SympathySMTPClientTransactionResult forNetworkError]);
		}
		if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"334"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			return([SympathySMTPClientTransactionResult forError:err]);
		}
		if([SympathySMTPClient writeLine:ops str:[SympathySMTPClient encode:username]] == FALSE) {
			return([SympathySMTPClientTransactionResult forNetworkError]);
		}
		if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"334"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			return([SympathySMTPClientTransactionResult forError:err]);
		}
		if([SympathySMTPClient writeLine:ops str:[SympathySMTPClient encode:password]] == FALSE) {
			return([SympathySMTPClientTransactionResult forNetworkError]);
		}
		if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"235|530"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
			return([SympathySMTPClientTransactionResult forError:err]);
		}
	}
	if([SympathySMTPClient writeLine:ops str:[[@"MAIL FROM:<" stringByAppendingString:([msg getMyAddress])] stringByAppendingString:@">"]] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"250"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([SympathySMTPClientTransactionResult forError:err]);
	}
	if(rcpts != nil) {
		NSMutableArray* array = [rcpts toVector];
		if(array != nil) {
			int n2 = 0;
			int m = [array count];
			for(n2 = 0 ; n2 < m ; n2++) {
				NSString* rcpt = ((NSString*)({ id _v = ((id)[array objectAtIndex:n2]); [_v isKindOfClass:[NSString class]] ? _v : nil; }));
				if(rcpt != nil) {
					if([SympathySMTPClient writeLine:ops str:[[@"RCPT TO:<" stringByAppendingString:([SympathySMTPClient rcptAsEmailAddress:rcpt])] stringByAppendingString:@">"]] == FALSE) {
						return([SympathySMTPClientTransactionResult forNetworkError]);
					}
					if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"250"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
						return([SympathySMTPClientTransactionResult forError:err]);
					}
				}
			}
		}
	}
	if([SympathySMTPClient writeLine:ops str:@"DATA"] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"354"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([SympathySMTPClientTransactionResult forError:err]);
	}
	if([CapeString isEmpty:[msg getMessageID]]) {
		[msg generateMessageID:sn];
	}
	NSString* bod = [msg getMessageBody];
	[CapeLog debug:ctx message:[[@"Sending message body: `" stringByAppendingString:bod] stringByAppendingString:@"'"]];
	if([ops print:bod] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	if([ops print:@"\r\n.\r\n"] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	if(!(({ NSString* _s1 = err = [SympathySMTPClient communicate:ins expectCode:@"250"]; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		return([SympathySMTPClientTransactionResult forError:err]);
	}
	if([SympathySMTPClient writeLine:ops str:@"QUIT"] == FALSE) {
		return([SympathySMTPClientTransactionResult forNetworkError]);
	}
	return([SympathySMTPClientTransactionResult forSuccess]);
}

@end
