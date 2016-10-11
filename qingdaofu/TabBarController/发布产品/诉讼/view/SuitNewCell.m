//
//  SuitNewCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SuitNewCell.h"

@implementation SuitNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cateLabel];
        [self.contentView addSubview:self.optionButton1];
        [self.contentView addSubview:self.optionButton2];
        [self.contentView addSubview:self.optionButton3];
        [self.contentView addSubview:self.optionButton4];
        [self.contentView addSubview:self.optionTextField];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.cateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.cateLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.cateLabel autoSetDimension:ALDimensionWidth toSize:65];
        
        NSArray *views = @[self.optionButton1,self.optionButton2,self.optionButton3];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        [views autoSetViewsDimension:ALDimensionHeight toSize:30];
        
        [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20 insetSpacing:YES matchedSizes:YES];
        
        [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2*kBigPadding+65];
        [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        
        [self.optionButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.optionButton1 withOffset:kBigPadding];
        [self.optionButton2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.optionButton1];
        
        [[views lastObject] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.optionButton2 withOffset:kBigPadding];
        [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [[views lastObject] autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.optionButton2];
        
        [self.optionButton4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.optionButton1];
        [self.optionButton4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.optionButton1 withOffset:kBigPadding];
        [self.optionButton4 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.optionButton1];
        [self.optionButton4 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.optionButton1];
        
        [self.optionTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.optionButton4 withOffset:kBigPadding];
        [self.optionTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.optionButton4];
        [self.optionTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.optionTextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.optionButton4];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

-(UILabel *)cateLabel
{
    if (!_cateLabel) {
        _cateLabel = [UILabel newAutoLayoutView];
        _cateLabel.numberOfLines = 0;
    }
    return _cateLabel;
}

- (UIButton *)optionButton1
{
    if (!_optionButton1) {
        _optionButton1 = [UIButton newAutoLayoutView];
        [_optionButton1 setTitleColor:kGrayColor forState:0];
        [_optionButton1 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _optionButton1.titleLabel.font = kSecondFont;
        _optionButton1.layer.cornerRadius = corner;
        [_optionButton1 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_optionButton1 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_optionButton1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton){
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _optionButton1;
}

- (UIButton *)optionButton2
{
    if (!_optionButton2) {
        _optionButton2 = [UIButton newAutoLayoutView];
        [_optionButton2 setTitleColor:kGrayColor forState:0];
        [_optionButton2 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _optionButton2.titleLabel.font = kSecondFont;
        [_optionButton2 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_optionButton2 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_optionButton2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton){
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _optionButton2;
}

- (UIButton *)optionButton3
{
    if (!_optionButton3) {
        _optionButton3 = [UIButton newAutoLayoutView];
        [_optionButton3 setTitleColor:kGrayColor forState:0];
        [_optionButton3 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _optionButton3.titleLabel.font = kSecondFont;
        [_optionButton3 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_optionButton3 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_optionButton3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton){
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _optionButton3;
}

- (UIButton *)optionButton4
{
    if (!_optionButton4) {
        _optionButton4 = [UIButton newAutoLayoutView];
        [_optionButton4 setTitleColor:kGrayColor forState:0];
        [_optionButton4 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _optionButton4.titleLabel.font = kSecondFont;
        [_optionButton4 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_optionButton4 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_optionButton4 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton){
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _optionButton4;
}

- (UITextField *)optionTextField
{
    if (!_optionTextField) {
        _optionTextField = [UITextField newAutoLayoutView];
        _optionTextField.layer.cornerRadius = corner;
        _optionTextField.layer.borderColor = kBorderColor.CGColor;
        _optionTextField.layer.borderWidth = kLineWidth;
        _optionTextField.placeholder = @"不超过5个字";
        _optionTextField.font = kSecondFont;
        _optionTextField.textColor = kBlackColor;
        _optionTextField.delegate = self;
    }
    return _optionTextField;
}

#pragma mark - delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   if (self.didEndEditting) {
        self.didEndEditting(textField.text);
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
