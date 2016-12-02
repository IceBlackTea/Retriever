//
//  REAppListCell.m
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppListCell.h"

@interface REAppListCell () {
    id _iconTarget;
    SEL _iconSel;
    BOOL _bIsIconTapGestureAdded;
    id _signTarget;
    SEL _signSel;
    BOOL _bIsSignTapGestureAdded;
}
@property (weak, nonatomic) UILabel *codeSignLabel;

@end

@implementation REAppListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat fW = CGRectGetHeight(self.contentView.bounds);
    self.codeSignLabel.frame = (CGRect){
        .origin.x = CGRectGetMaxX(self.contentView.bounds) - fW,
        .origin.y = 0,
        .size.width = fW,
        .size.height = fW
    };
}

- (void)render:(id)data {
    id app = [data invoke:@"containingBundle"] ?: data;
    self.imageView.image = [REHelper iconImageForApplication:app];
    self.textLabel.text = [REHelper displayNameForApplication:app];
    
    NSString *codeSignIdcator = nil;
    UIColor *codeSignColor = [UIColor blackColor];
    
    if ([[data invoke:@"isBetaApp"] boolValue]) {
        codeSignIdcator = @"B";
    }
    else {
        NSString *codeSign = [data invoke:@"signerIdentity"];
        if (!codeSign &&
            [[data invoke:@"applicationType"] isEqualToString:@"System"])
        {
            codeSignIdcator = @"S";
        }
        else if ([codeSign isEqualToString:@"Apple iPhone OS Application Signing"]) {
            codeSignIdcator = @"";
        }
        else if ([codeSignIdcator isEqualToString:@"TestFlight Beta Distribution"]) {
            codeSignIdcator = @"B";
        }
        else if ([codeSign hasPrefix:@"iPhone Developer:"]) {
            codeSignIdcator = @"⌘";
            codeSignColor = [UIColor yellowColor];
        }
        else if ([codeSign hasPrefix:@"iPhone Distribution:"]) {
            NSString *locaseStr = [codeSign lowercaseString];
            if ([locaseStr containsString:@"co."] ||
                [locaseStr containsString:@"ltd."] ||
                [locaseStr containsString:@"inc."] ||
                [locaseStr containsString:@"llc."])
            {
                codeSignIdcator = @"E";
                codeSignColor = [UIColor redColor];
            }
            else {
                codeSignIdcator = @"D";
                codeSignColor = [UIColor yellowColor];
            }
        }
        else if ([codeSign isEqualToString:@"Simulator"]) {
            codeSignIdcator = @"📱";
        }
        else {
            codeSignIdcator = @"?";
            codeSignColor = [UIColor orangeColor];
        }
    }
    
    
    
    self.codeSignLabel.text = codeSignIdcator;
    self.codeSignLabel.textColor = codeSignColor;
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

#pragma mark - Public Method

- (void)addIconGestureTarget:(id)target selector:(SEL)sel {
    if (target && sel && !_bIsIconTapGestureAdded) {
        _iconTarget = target;
        _iconSel = sel;
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIconTapped:)];
        [self.imageView addGestureRecognizer:tagGesture];
        
        _bIsIconTapGestureAdded = YES;
    }
}

- (void)addCodeSignGestureTarget:(id)target selector:(SEL)sel {
    if (target && sel && !_bIsSignTapGestureAdded) {
        _signTarget = target;
        _signSel = sel;
        self.codeSignLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSignTapped:)];
        [self.codeSignLabel addGestureRecognizer:tagGesture];
        
        _bIsSignTapGestureAdded = YES;
    }
}

- (void)onIconTapped:(UITapGestureRecognizer *)tap {
    if (_iconTarget && _iconSel) {
        [_iconTarget invoke:NSStringFromSelector(_iconSel) args:self, nil];
    }
}

- (void)onSignTapped:(UITapGestureRecognizer *)tap {
    if (_signTarget && _signSel) {
        [_signTarget invoke:NSStringFromSelector(_signSel) args:self, nil];
    }
}

#pragma mark - Getter

- (UILabel *)codeSignLabel {
    if (!_codeSignLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _codeSignLabel = label;
    }
    return _codeSignLabel;
}

@end
