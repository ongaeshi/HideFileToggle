//
//  MacSetting.h
//  MacSetting
//
//  Created by ongaeshi on 09/12/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MacSetting : NSObject {
  IBOutlet NSButton* showHideFile; // 隠しファイルを表示する
}

- (IBAction) updateHideFile:(id)sender;

@end
