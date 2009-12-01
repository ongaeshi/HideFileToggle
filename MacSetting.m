//
//  MacSetting.m
//  MacSetting
//
//  Created by ongaeshi on 09/12/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MacSetting.h"


@implementation MacSetting

// Nibファイル読み込み後
- (void) awakeFromNib 
{
	NSLog(@"showHideFile = %d", [showHideFile state]);
	NSLog(@"alwaysHalfSizeSpace = %d", [alwaysHalfSizeSpace state]);
}


@end
