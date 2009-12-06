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
  //  NSLog(command);
  
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
  return [ NSString stringWithFormat : @"%s", [ data bytes ] ];
} 

// --------------------------------------------------------------------------
/**
 * 外部コマンドを実行(コマンドはフルパスで渡すこと)
 *
 * @param array コマンドの配列
 * @return 実行結果を文字列で返す
 */
NSString* execCommand2(NSArray* array)
{ 
  // NSLog(command);
  
  NSTask* task = [ [ NSTask alloc ] init ]; 
  NSPipe* pipe = [ NSPipe pipe ];
  
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

// --------------------------------------------------------------------------
/**
 * 末尾の1文字を削る
 */
NSString* chop(NSString* str)
{
  return [str substringToIndex:[str length]-1];
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
  
  NSString* str = chop(execCommand(@"/usr/bin/defaults read com.apple.finder AppleShowAllFiles"));
  [showHideFile setState: str2Int(str)];
  
  NSString* s = execCommand(@"/usr/bin/defaults read com.apple.inputmethod.Kotoeri zhsy");
//  [s propertyList];
  [s writeToFile:[@"~/hoge.txt" stringByExpandingTildeInPath] atomically:YES];
//  NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[@"~/hoge.txt" stringByExpandingTildeInPath]];
//  NSLog([dict description]);

  //  NSLog(@"%@", s);
//  NSLog(s);
//  NSString* s2 = [s stringByReplacingOccurrencesOfString:@"{" withString:@""];
//  NSString* s3 = [s2 stringByReplacingOccurrencesOfString:@"}" withString:@""];
//  NSLog(s3);
//  [s3 propertyList];
  
//  NSLog(s2);
//  [s2 propertyList];  
  
  //  NSDictionary* dic = [execCommand(@"/usr/bin/defaults read com.apple.inputmethod.Kotoeri zhsy") propertyList];
  //  NSLog([dic description]);
}

- (IBAction) updateHideFile:(id)sender
{
  execCommand([@"/usr/bin/defaults write com.apple.finder AppleShowAllFiles " stringByAppendingString:int2Str([showHideFile state])]);
  execCommand(@"/usr/bin/killall Finder");
  //  NSLog(execCommand(@"/usr/bin/defaults read com.apple.finder AppleShowAllFiles"));
}

- (IBAction) updateHalfSizeSpace:(id)sender
{
#if 1
  execCommand2([NSArray arrayWithObjects: @"/usr/bin/defaults ",
                                          @"write com.apple.inputmethod.Kotoeri zhsy -dist-add \" \" -bool yes",
                                          nil]);
#else
//  execCommand(@"/usr/bin/defaults write com.apple.inputmethod.Kotoeri zhsy -dict-add ' ' -bool yes");
#endif  
  execCommand(@"/usr/bin/killall Kotoeri");
  NSLog(@"hoge");
}

@end
