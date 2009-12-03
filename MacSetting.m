//
//  MacSetting.m
//  MacSetting
//
//  Created by ongaeshi on 09/12/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MacSetting.h"

@implementation MacSetting

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


@end
