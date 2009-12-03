//
//  MacSetting.m
//  MacSetting
//
//  Created by ongaeshi on 09/12/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MacSetting.h"

int execCommand(NSString* command)
{ 
  NSTask* task = [ [ NSTask alloc ] init ]; 
  NSPipe* pipe = [ NSPipe pipe ];
  NSArray* array = [command componentsSeparatedByString:@" "];
  //  NSLog([array description]);
  
  // 出力先の指定
  [task setStandardOutput: pipe];
  [task setStandardError : pipe]; 
  
  // 実行 
  [ task setLaunchPath           : [array objectAtIndex:0] ];
  [ task setArguments            : [array subarrayWithRange: NSMakeRange(1, ([array count] - 1))] ];
  [ task launch ];
  [ task waitUntilExit ];
    
  // 出力の読み出し
  { 
    NSData* data = [ [ pipe fileHandleForReading ] availableData ];
    NSString* str  = [ NSString stringWithFormat : @"%s", [ data bytes ] ];
    NSLog(str);
  }

  return( [ task terminationStatus ] );
} 

@implementation MacSetting

- (void) execCommand: (NSArray*) args
{
  NSTask* task = [[NSTask alloc] init];
  //[task setStandardOutput: [NSPipe pipe]];
  //[task setStandardError: [task standardOutput]];
  [task setLaunchPath: [args objectAtIndex:0]];
  [task setArguments: [args subarrayWithRange: NSMakeRange (1, ([args count] - 1))]];
#if 0
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                        selector:@selector(getData:) 
                                        name: NSFileHandleReadCompletionNotification 
                                        object: [[task standardOutput] fileHandleForReading]];
#endif
  // [[[task standardOutput] fileHandleForReading] readInBackgroundAndNotify];
  [task launch];    
}

- (NSInteger) str2int: (NSString*) str
{
  if (str == @"TRUE")
    return TRUE;
  else
    return FALSE;
}

// Nibファイル読み込み後
- (void) awakeFromNib 
{
  // 隠しファイル
  // defaults write com.apple.finder AppleShowAllFiles TRUE
  // defaults write com.apple.finder AppleShowAllFiles FALSE
  
  // 半角スペース
  // defaults write com.apple.inputmethod.Kotoeri zhsy -dict-add " " -bool no
  // killall Kotoeri
  
  NSLog(@"showHideFile = %d", [showHideFile state]);
  NSLog(@"alwaysHalfSizeSpace = %d", [alwaysHalfSizeSpace state]);
  
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  
  NSDictionary* dict = [defaults persistentDomainForName:@"com.apple.finder"];
  
  
  NSLog(@"value = %@", [dict valueForKey:@"AppleShowAllFiles"]);
//  NSLog([dict description]);
  
  [showHideFile setState: [self str2int: [dict valueForKey:@"AppleShowAllFiles"]]];
}

- (IBAction) updateHideFile:(id)sender
{
  NSLog(@"hoge");
  execCommand(@"/usr/bin/defaults read com.apple.finder AppleShowAllFiles");
  
  [self execCommand: [NSArray arrayWithObjects: 
                      @"/usr/bin/defaults",
                      @"write",
                      @"com.apple.finder",
                      @"AppleShowAllFiles",
                      @"TRUE",
                      nil]];
                      
//  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//  NSDictionary* dict = [defaults persistentDomainForName:@"com.apple.finder"];
  
//  [defaults setPersistentDomain:dict forName:@"com.apple.finder"];

}

@end
