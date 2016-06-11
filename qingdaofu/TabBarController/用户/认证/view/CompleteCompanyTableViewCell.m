//
//  CompleteCompanyTableViewCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompleteCompanyTableViewCell.h"

@implementation CompleteCompanyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.comNameLabel];
        [self.contentView addSubview:self.comImageButton];
        [self.contentView addSubview:self.comIDLabel];

        [self.contentView addSubview:self.comPicLabel];
        [self.contentView addSubview:self.comPicButton];
        
        [self.contentView addSubview:self.comPersonNameLabel];
        [self.contentView addSubview:self.comPersonTelLabel];
        [self.contentView addSubview:self.comMailLabel];
        [self.contentView addSubview:self.comAddressLabel];
        [self.contentView addSubview:self.comWebsiteLabel];
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
        
        [self.comPicLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comPicLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comIDLabel withOffset:kBigPadding];
        
        [self.comPicButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:122];
        [self.comPicButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.comPicLabel];
        [self.comPicButton autoSetDimensionsToSize:CGSizeMake(55, 55)];
        
        [self.comPersonNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comPicButton withOffset:kBigPadding];
        [self.comPersonNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.comPersonTelLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comPersonNameLabel withOffset:kBigPadding];
        [self.comPersonTelLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.comMailLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comMailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comPersonTelLabel withOffset:kBigPadding];
        
        [self.comAddressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comMailLabel withOffset:kBigPadding];
        
        [self.comWebsiteLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comWebsiteLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comAddressLabel withOffset:kBigPadding];
        
        [self.comExampleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.comWebsiteLabel withOffset:kBigPadding];
        [self.comExampleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.comExampleLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:122];
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
        _comNameLabel.text = @"bcdsbvl";
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

- (UILabel *)comPicLabel
{
    if (!_comPicLabel) {
        _comPicLabel = [UILabel newAutoLayoutView];
        _comPicLabel.text = @"照片：";
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

- (UILabel *)comPersonNameLabel
{
    if (!_comPersonNameLabel) {
        _comPersonNameLabel = [UILabel newAutoLayoutView];
        _comPersonNameLabel.font = kBigFont;
    }
    return _comPersonNameLabel;
}

- (UILabel *)comPersonTelLabel
{
    if (!_comPersonTelLabel) {
        _comPersonTelLabel = [UILabel newAutoLayoutView];
        _comPersonTelLabel.font = kBigFont;
    }
    return _comPersonTelLabel;
}

- (UILabel *)comMailLabel
{
    if (!_comMailLabel) {
        _comMailLabel = [UILabel newAutoLayoutView];
        _comMailLabel.font = kBigFont;
    }
    return _comMailLabel;
}

- (UILabel *)comAddressLabel
{
    if (!_comAddressLabel) {
        _comAddressLabel = [UILabel newAutoLayoutView];
        _comAddressLabel.font = kBigFont;
    }
    return _comAddressLabel;
}

- (UILabel *)comWebsiteLabel
{
    if (!_comWebsiteLabel) {
        _comWebsiteLabel = [UILabel newAutoLayoutView];
        _comWebsiteLabel.font = kBigFont;
    }
    return _comWebsiteLabel;
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
