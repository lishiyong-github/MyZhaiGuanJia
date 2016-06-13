//
//  CaseNoCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CaseNoCell.h"

@implementation CaseNoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.caseNoButton];
        [self.contentView addSubview:self.caseNoTextField];
        [self.contentView addSubview:self.caseGoButton];
        
        self.leftFieldConstraints = [self.caseNoTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.caseNoButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.caseNoButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.caseNoTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.caseNoButton];
        [self.caseNoTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.caseGoButton withOffset:-kBigPadding];
        
        [self.caseGoButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.caseGoButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.caseNoTextField];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)caseNoButton
{
    if (!_caseNoButton) {
        _caseNoButton = [UIButton newAutoLayoutView];
        _caseNoButton.titleLabel.font = kBigFont;
        [_caseNoButton setTitleColor:kBlackColor forState:0];
    }
    return _caseNoButton;
}

- (UITextField *)caseNoTextField
{
    if (!_caseNoTextField) {
        _caseNoTextField = [UITextField newAutoLayoutView];
        _caseNoTextField.textColor = kLightGrayColor;
        _caseNoTextField.font = kFirstFont;
    }
    return _caseNoTextField;
}

- (UIButton *)caseGoButton
{
    if (!_caseGoButton) {
        _caseGoButton = [UIButton newAutoLayoutView];
        [_caseGoButton setTitleColor:kBlueColor forState:0];
        [_caseGoButton swapImage];
        _caseGoButton.titleLabel.font = kSecondFont;
    }
    return _caseGoButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
