//
//  MessageSystemView.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageSystemView.h"

@implementation MessageSystemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        self.layer.borderColor = kSeparateColor.CGColor;
        self.layer.borderWidth = kLineWidth;
        
        [self addSubview:self.imageButton];
        [self addSubview:self.countLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.timeButton];
        
        [self setNeedsUpdateConstraints];

    }
    return self;
}


- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.imageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.imageButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.imageButton autoSetDimensionsToSize:CGSizeMake(50, 50)];

        
        [self.countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.imageButton];
        [self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.imageButton];
        
        [self.contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageButton withOffset:kBigPadding];
        [self.contentLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.imageButton];
        
        [self.timeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.timeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentLabel];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [UIButton newAutoLayoutView];
        _imageButton.userInteractionEnabled = NO;
        [_imageButton setImage:[UIImage imageNamed:@"news_system"] forState:0];
    }
    return _imageButton;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel newAutoLayoutView];
        _countLabel.backgroundColor = kYellowColor;
        _countLabel.font = kSmallFont;
//        _countLabel.text = @"12";
        _countLabel.textColor = kWhiteColor;
    }
    return _countLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.numberOfLines = 0;
        
        NSString *ccc1 = @"系统消息\n";
        NSString *ccc2 = @"系统消息通知";
        NSString *ccc = [NSString stringWithFormat:@"%@%@",ccc1,ccc2];
        NSMutableAttributedString *attributeCCC = [[NSMutableAttributedString alloc] initWithString:ccc];
        [attributeCCC setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ccc1.length)];
        [attributeCCC setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(ccc1.length, ccc2.length)];
        NSMutableParagraphStyle *styorr = [[NSMutableParagraphStyle alloc] init];
        [styorr setParagraphSpacing:kSpacePadding];
        [attributeCCC addAttribute:NSParagraphStyleAttributeName value:styorr range:NSMakeRange(0, ccc.length)];
        [_contentLabel setAttributedText:attributeCCC];
        
    }
    return _contentLabel;
}

- (UIButton *)timeButton
{
    if (!_timeButton) {
        _timeButton = [UIButton newAutoLayoutView];
        [_timeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        _timeButton.userInteractionEnabled = NO;
    }
    return _timeButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
