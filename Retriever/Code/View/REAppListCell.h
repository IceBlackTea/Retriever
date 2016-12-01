//
//  REAppListCell.h
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RETableViewCell.h"

@interface REAppListCell : RETableViewCell

- (void)addIconGestureTarget:(id)target selector:(SEL)sel;

- (void)addCodeSignGestureTarget:(id)target selector:(SEL)sel;

@end
