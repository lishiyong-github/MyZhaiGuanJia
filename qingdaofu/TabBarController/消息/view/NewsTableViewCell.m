//
//  NewsTableViewCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIButton+Addition.h"

@interface NewsTableViewCell ()

@property (nonatomic,assign) BOOL finishSwap;

@end

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.newsNameButton];
        [self.contentView addSubview:self.newsCountButton];
        [self.contentView addSubview:self.newsActionButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.newsNameButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.newsNameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.newsCountButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.newsNameButton];
        [self.newsCountButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.newsActionButton withOffset:-2];
//        [self.newsCountButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        [self.newsActionButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.newsActionButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.newsNameButton];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)newsNameButton
{
    if (!_newsNameButton) {
        _newsNameButton = [UIButton newAutoLayoutView];
        _newsNameButton.titleLabel.font = kBigFont;
        [_newsNameButton setTitleColor:kBlackColor forState:0];
        _newsNameButton.userInteractionEnabled = NO;
    }
    return _newsNameButton;
}

- (UIButton *)newsCountButton
{
    if (!_newsCountButton) {
        _newsCountButton = [UIButton newAutoLayoutView];
        _newsCountButton.backgroundColor = kButtonColor;
        [_newsCountButton setTitleColor:kWhiteColor forState:0];
        _newsCountButton.titleLabel.font = kSmallFont;
        _newsCountButton.userInteractionEnabled = NO;
    }
    return _newsCountButton;
}

- (UIButton *)newsActionButton
{
    if (!_newsActionButton) {
        _newsActionButton = [UIButton newAutoLayoutView];
        [_newsActionButton swapImage];
        [_newsActionButton setTitleColor:kLightGrayColor forState:0];
        _newsActionButton.titleLabel.font = kSecondFont;
        _newsActionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _newsActionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _newsActionButton.userInteractionEnabled = NO;
    }
    return _newsActionButton;
}

- (void)swapUserName
{
    if (!self.finishSwap) {
        self.finishSwap = YES;
        [self.newsNameButton swapImage];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
