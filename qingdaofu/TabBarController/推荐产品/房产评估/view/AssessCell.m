//
//  AssessCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AssessCell.h"

@implementation AssessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.label1];
        [self.contentView addSubview:self.textField1];
        [self.contentView addSubview:self.label2];
        [self.contentView addSubview:self.textField2];
        [self.contentView addSubview:self.label3];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.label1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.textField1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.label1 withOffset:kBigPadding];
        [self.textField1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label1];
        
        [self.label2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.textField1 withOffset:kSmallPadding];
        [self.label2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label1];
        
        [self.textField2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.label2 withOffset:kSmallPadding/2];
        [self.textField2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label1];
        
        [self.label3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.label3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label1];
        
        self.didSetupConstraints = YES;
        
    }
    [super updateConstraints];
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [UILabel newAutoLayoutView];
        _label1.font = kBigFont;
        _label1.textColor = kBlackColor;
    }
    return _label1;
}
- (UITextField *)textField1
{
    if (!_textField1) {
        _textField1 = [UITextField newAutoLayoutView];
        _textField1.textColor = kBlackColor;
        _textField1.font = kFirstFont;
        _textField1.keyboardType = UIKeyboardTypeNumberPad;
        _textField1.delegate = self;
        _textField1.tag = 11;
    }
    return _textField1;
}
- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [UILabel newAutoLayoutView];
        _label2.font = kBigFont;
        _label2.textColor = kBlueColor;
    }
    return _label2;
}
- (UITextField *)textField2
{
    if (!_textField2) {
        _textField2 = [UITextField newAutoLayoutView];
        _textField2.textColor = kBlackColor;
        _textField2.font = kFirstFont;
        _textField2.keyboardType = UIKeyboardTypeNumberPad;
        _textField2.delegate = self;
        _textField2.tag = 12;
    }
    return _textField2;
}
- (UILabel *)label3
{
    if (!_label3) {
        _label3 = [UILabel newAutoLayoutView];
        _label3.font = kBigFont;
        _label3.textColor = kBlueColor;
    }
    return _label3;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.didEndEditing) {
        self.didEndEditing(textField.text,textField.tag);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
