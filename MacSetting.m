//
//  MacSetting.m
//  MacSetting
//
//  Created by ongaeshi on 09/12/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MacSetting.h"

// --------------------------------------------------------------------------
/**
 * 外部コマンドを実行(コマンドはフルパスで渡すこと)
 *
 * @param command コマンド文字列(引数はスペースで区切って渡せる)
 * @return 実行結果を文字列で返す
 */
NSString* execCommand(NSString* command)
{ 
  NSLog(command);
  
  NSTask* task = [ [ NSTask alloc ] init ]; 
  NSPipe* pipe = [ NSPipe pipe ];
  NSArray* array = [command componentsSeparatedByString:@" "];
  
  // 出力先の指定
  [task setStandardOutput: pipe];
  // [task setStandardError : pipe]; 
  
  // 実行 
  [ task setLaunchPath           : [array objectAtIndex:0] ];
  [ task setArguments            : [array subarrayWithRange: NSMakeRange(1, ([array count] - 1))] ];
  [ task launch ];
  [ task waitUntilExit ];
    
  // 出力の読み出し
  NSData* data = [ [ pipe fileHandleForReading ] availableData ];
  NSLog([ NSString stringWithFormat : @"%s", [ data bytes ] ]);
  return [ NSString stringWithFormat : @"%s", [ data bytes ] ];
} 

// --------------------------------------------------------------------------
/**
 * TRUE -> 1, FALSE -> 0
 */
NSInteger str2Int(NSString* str)
{
  NSLog(@"%d", [str length]);
  if ([str compare: @"TRUE"] == NSOrderedSame)
    return NSOnState;
  else
    return NSOffState;
}

// --------------------------------------------------------------------------
/**
 * 1 -> "TRUE", 0 -> "FALSE"
 */
NSString* int2Str(NSInteger val)
{
  if (val == 1)
    return @"TRUE";
  else
    return @"FALSE";
}

@implementation MacSetting

// Nibファイル読み込み後
- (void) awakeFromNib 
{
  // 隠しファイル
  // defaults write com.apple.finder AppleShowAllFiles TRUE
  // defaults write com.apple.finder AppleShowAllFiles FALSE
  // killall Finder
  
  // 半角スペース
  // defaults write com.apple.inputmethod.Kotoeri zhsy -dict-add " " -bool no
  // killall Kotoeri
  
  NSString* str = execCommand(@"/usr/bin/defaults read com.apple.finder AppleShowAllFiles");
  NSString* str2 = [str substringToIndex:[str length]-1];
  NSLog(str2);
  [showHideFile setState: str2Int(str2)];
}

- (IBAction) updateHideFile:(id)sender
{
  execCommand([@"/usr/bin/defaults write com.apple.finder AppleShowAllFiles " stringByAppendingString:int2Str([showHideFile state])]);
  NSLog(execCommand(@"/usr/bin/defaults read com.apple.finder AppleShowAllFiles"));
}

@end
