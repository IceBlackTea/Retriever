//
//  REAppDelegate+Shortcut.m
//  Retriever
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppDelegate+Shortcut.h"

@implementation REAppDelegate (Shortcut)

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    if ([shortcutItem.type isEqualToString:@"Share"]) {
        [REHelper shareRetriever];
    }
}

@end
