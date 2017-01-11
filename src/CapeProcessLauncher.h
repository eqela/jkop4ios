
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

@protocol CapeBufferDataReceiver;
@class CapeStringBuilder;
@class CapeProcessLauncherMyStringPipeHandler;
@class CapeProcessLauncherMyBufferPipeHandler;
@class CapeProcessLauncherQuietPipeHandler;
@protocol CapeFile;
@protocol CapeProcess;
@protocol CapeProcessWithIO;

/*
 * The ProcessLauncher class provides a mechanism for starting and controlling
 * additional processes.
 */

@interface CapeProcessLauncher : NSObject
+ (CapeProcessLauncher*) forSelf;

/*
 * Creates a launcher for the given executable file. If the file does not exist,
 * this method returns a null object instead.
 */

+ (CapeProcessLauncher*) forFile:(id<CapeFile>)file params:(NSMutableArray*)params;

/*
 * Creates a process launcher for the given command. The command can either be a
 * full or relative path to an executable file or, if not, a matching executable
 * file will be searched for in the PATH environment variable (or through other
 * applicable standard means on the given platform), and an appropriately
 * configured ProcessLauncher object will be returned. However, if the given
 * command is not found, this method returns null.
 */

+ (CapeProcessLauncher*) forCommand:(NSString*)command params:(NSMutableArray*)params;

/*
 * Creates a new process launcher object for the given string, which includes a
 * complete command line for executing the process, including the command itself
 * and all the parameters, delimited with spaces. If parameters will need to
 * contain space as part of their value, those parameters can be enclosed in double
 * quotes. This method will return null if the command does not exist and/or is not
 * found.
 */

+ (CapeProcessLauncher*) forString:(NSString*)str;
- (CapeProcessLauncher*) init;

/*
 * Produces a string representation of this command with the command itself,
 * parameters and environment variables included.
 */

- (NSString*) toString:(BOOL)includeEnv;
- (CapeProcessLauncher*) addToParamsWithString:(NSString*)arg;
- (CapeProcessLauncher*) addToParamsWithFile:(id<CapeFile>)file;
- (CapeProcessLauncher*) addToParamsWithVector:(NSMutableArray*)params;
- (void) setEnvVariable:(NSString*)key val:(NSString*)val;
- (id<CapeProcess>) start;
- (id<CapeProcessWithIO>) startWithIO;
- (int) execute;
- (int) executeSilent;
- (int) executeToStringBuilder:(CapeStringBuilder*)output;
- (NSString*) executeToString;
- (NSMutableData*) executeToBuffer;
- (int) executeToPipe:(id<CapeBufferDataReceiver>)pipeHandler;
- (id<CapeFile>) getFile;
- (CapeProcessLauncher*) setFile:(id<CapeFile>)v;
- (NSMutableArray*) getParams;
- (CapeProcessLauncher*) setParams:(NSMutableArray*)v;
- (NSMutableDictionary*) getEnv;
- (CapeProcessLauncher*) setEnv:(NSMutableDictionary*)v;
- (id<CapeFile>) getCwd;
- (CapeProcessLauncher*) setCwd:(id<CapeFile>)v;
- (int) getUid;
- (CapeProcessLauncher*) setUid:(int)v;
- (int) getGid;
- (CapeProcessLauncher*) setGid:(int)v;
- (BOOL) getTrapSigint;
- (CapeProcessLauncher*) setTrapSigint:(BOOL)v;
- (BOOL) getReplaceSelf;
- (CapeProcessLauncher*) setReplaceSelf:(BOOL)v;
- (BOOL) getPipePty;
- (CapeProcessLauncher*) setPipePty:(BOOL)v;
- (BOOL) getStartGroup;
- (CapeProcessLauncher*) setStartGroup:(BOOL)v;
- (BOOL) getNoCmdWindow;
- (CapeProcessLauncher*) setNoCmdWindow:(BOOL)v;
- (CapeStringBuilder*) getErrorBuffer;
- (CapeProcessLauncher*) setErrorBuffer:(CapeStringBuilder*)v;
@end
