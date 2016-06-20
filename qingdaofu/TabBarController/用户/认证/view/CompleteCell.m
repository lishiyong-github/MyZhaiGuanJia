//
//  CompleteCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompleteCell.h"

@implementation CompleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.comNameLabel];
        [self.contentView addSubview:self.comImageButton];
        [self.contentView addSubview:self.comIDLabel];
        [self.contentView addSubview:self.mobileLabel];
        [self.contentView addSubview:self.comPicLabel];
        [self.contentView addSubview:self.comPicButton];
        [self.contentView addSubview:self.comMailLabel];
        [self.contentView addSubview:self.comExampleLabel];
        [self.contentView addSubview:self.comExampleLabel2];

        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.comNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.comNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.comImageButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.comImageButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.comIDLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comIDLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comNameLabel withOffset:kBigPadding];
        
        [self.mobileLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.mobileLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comIDLabel withOffset:kBigPadding];

        [self.comPicLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileLabel withOffset:kBigPadding];
        [self.comPicLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.comPicButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:110];
        [self.comPicButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.comPicLabel];
        [self.comPicButton autoSetDimensionsToSize:CGSizeMake(55, 55)];
        
        [self.comMailLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comMailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comPicButton withOffset:kBigPadding];

        [self.comExampleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comMailLabel withOffset:kBigPadding];
        [self.comExampleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];

        [self.comExampleLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:110];
        [self.comExampleLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.comExampleLabel];
        [self.comExampleLabel2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)comNameLabel
{
    if (!_comNameLabel) {
        _comNameLabel = [UILabel newAutoLayoutView];
        _comNameLabel.font = kBigFont;
    }
    return _comNameLabel;
}

- (UIButton *)comImageButton
{
    if (!_comImageButton) {
        _comImageButton = [UIButton newAutoLayoutView];
        [_comImageButton setImage:[UIImage imageNamed:@"identification_label"] forState:0];
    }
    return _comImageButton;
}

- (UILabel *)comIDLabel
{
    if (!_comIDLabel) {
        _comIDLabel = [UILabel newAutoLayoutView];
        _comIDLabel.font = kBigFont;
    }
    return _comIDLabel;
}

- (UILabel *)mobileLabel
{
    if (!_mobileLabel) {
        _mobileLabel = [UILabel newAutoLayoutView];
        _mobileLabel.font = kBigFont;
    }
    return _mobileLabel;
}

- (UILabel *)comPicLabel
{
    if (!_comPicLabel) {
        _comPicLabel = [UILabel newAutoLayoutView];
        _comPicLabel.text = @"身份照片：";
        _comPicLabel.textColor = kBlackColor;
        _comPicLabel.font = kBigFont;
    }
    return _comPicLabel;
}

- (UIButton *)comPicButton
{
    if (!_comPicButton) {
        _comPicButton = [UIButton newAutoLayoutView];
        [_comPicButton setBackgroundColor:kRedColor];
    }
    return _comPicButton;
}

- (UILabel *)comMailLabel
{
    if (!_comMailLabel) {
        _comMailLabel = [UILabel newAutoLayoutView];
        _comMailLabel.font = kBigFont;
    }
    return _comMailLabel;
}

- (UILabel *)comExampleLabel
{
    if (!_comExampleLabel) {
        _comExampleLabel = [UILabel newAutoLayoutView];
        _comExampleLabel.font = kBigFont;
        _comExampleLabel.textColor = kBlackColor;
    }
    return _comExampleLabel;
}

- (UILabel *)comExampleLabel2
{
    if (!_comExampleLabel2) {
        _comExampleLabel2 = [UILabel newAutoLayoutView];
        _comExampleLabel2.font = kFirstFont;
        _comExampleLabel2.numberOfLines = 0;
        _comExampleLabel2.textColor = kLightGrayColor;
    }
    return _comExampleLabel2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
