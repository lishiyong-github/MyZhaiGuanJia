//
//  TextFieldCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textDeailButton];
        [self.contentView addSubview:self.countLabel];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
        [self.textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kSmallPadding];
        [self.textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        [self.textDeailButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.textDeailButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.textField];
        
//        [self.countLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.textField];
        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (PlaceHolderTextView *)textField
{
    if (!_textField) {
        _textField = [PlaceHolderTextView newAutoLayoutView];
        _textField.textColor = kBlackColor;
        [_textField setPlaceholderColor:kLightGrayColor];
        _textField.font = kBigFont;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)textDeailButton
{
    if (!_textDeailButton) {
        _textDeailButton = [UIButton newAutoLayoutView];
        [_textDeailButton setTitleColor:kBlackColor forState:0];
        _textDeailButton.titleLabel.font = kBigFont;
    }
    return _textDeailButton;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel newAutoLayoutView];
        _countLabel.textColor = kLightGrayColor;
        _countLabel.font = kSecondFont;
    }
    return _countLabel;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.didEndEditing) {
        self.didEndEditing(textView.text);
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (self.didEndEditing) {
        self.didEndEditing(textView.text);
    }
    
    return YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
