//
//  REAppListCell.m
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppListCell.h"

@interface REAppListCell () {
    id _target;
    SEL _sel;
    BOOL _bIsTapGestureAdded;
}

@end

@implementation REAppListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)render:(id)data {
    id app = [data invoke:@"containingBundle"] ?: data;
    self.imageView.image = [REHelper iconImageForApplication:app];
    self.textLabel.text = [REHelper displayNameForApplication:app];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rectIcon = (CGRect){
        .origin.x = 0,
        .origin.y = 0,
        .size.width = CGRectGetWidth(self.imageView.frame) + 2 * CGRectGetMinX(self.imageView.frame),
        .size.height = CGRectGetHeight(self.imageView.frame) + 2 * CGRectGetMinY(self.imageView.frame)
    };
    
    if (CGRectContainsPoint(rectIcon, point)) {
        return self.imageView;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)addIconGestureTarget:(id)target selector:(SEL)sel {
    if (target && sel && !_bIsTapGestureAdded) {
        _target = target;
        _sel = sel;
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIconTapped:)];
        [self.imageView addGestureRecognizer:tagGesture];
        
        _bIsTapGestureAdded = YES;
    }
}

- (void)onIconTapped:(UITapGestureRecognizer *)tap {
    if (_target && _sel) {
        [_target invoke:NSStringFromSelector(_sel) args:self, nil];
    }
}

@end
