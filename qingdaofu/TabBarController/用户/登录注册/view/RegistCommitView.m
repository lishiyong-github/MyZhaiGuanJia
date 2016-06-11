//
//  RegistCommitView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RegistCommitView.h"

@implementation RegistCommitView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.commitButton];
        [self addSubview:self.tagButton];
        [self addSubview:self.contentLabel];
        [self addSubview:self.contentButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.commitButton autoSetDimension:ALDimensionHeight toSize:40];
        
        
        NSArray *views = @[self.tagButton,self.contentLabel,self.contentButton];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.tagButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.commitButton withOffset:20];
        [self.tagButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.tagButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        [self.contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tagButton withOffset:5];
        
        [self.contentButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.contentLabel withOffset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (BaseCommitButton *)commitButton
{
    if (!_commitButton) {
        _commitButton = [BaseCommitButton newAutoLayoutView];
        [_commitButton setTitle:@"注册" forState:0];
        QDFWeakSelf;
        [_commitButton addAction:^(UIButton *btn) {
            if (weakself.didSetectedButton) {
                weakself.didSetectedButton(11);
            }
        }];
    }
    return _commitButton;
}

- (UIButton *)tagButton
{
    if (!_tagButton) {
        _tagButton = [UIButton newAutoLayoutView];
        [_tagButton setBackgroundColor:kRedColor];
        [_tagButton setImage:[UIImage imageNamed:@""] forState:0
         ];
        [_tagButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        QDFWeakSelf;
        [_tagButton addAction:^(UIButton *btn) {
            if (weakself.didSetectedButton) {
                btn.selected = !btn.selected;
                weakself.didSetectedButton(12);
            }
        }];
    }
    return _tagButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.text = @"我已阅读并同意";
        _contentLabel.textColor = kLightGrayColor;
        _contentLabel.font = kBigFont;
    }
    return _contentLabel;
}

- (UIButton *)contentButton
{
    if (!_contentButton) {
        _contentButton = [UIButton newAutoLayoutView];
        [_contentButton setTitle:@"注册协议" forState:0];
        [_contentButton setTitleColor:kBlueColor forState:0];
        _contentButton.titleLabel.font = kBigFont;
        
        QDFWeakSelf;
        [_contentButton addAction:^(UIButton *btn) {
            if (weakself.didSetectedButton) {
                weakself.didSetectedButton(13);
            }
        }];
    }
    return _contentButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
