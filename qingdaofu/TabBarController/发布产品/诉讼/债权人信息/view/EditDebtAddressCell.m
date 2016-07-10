//
//  EditDebtAddressCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EditDebtAddressCell.h"

@implementation EditDebtAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.ediLabel];
        [self.contentView addSubview:self.ediTextView];
        
        self.leftTextViewConstraints = [self.ediTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:90];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ediLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ediLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        
        [self.ediTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [self.ediTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.ediTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)ediLabel
{
    if (!_ediLabel) {
        _ediLabel = [UILabel newAutoLayoutView];
        _ediLabel.textColor = kBlackColor;
        _ediLabel.font = kBigFont;
    }
    return _ediLabel;
}

- (PlaceHolderTextView *)ediTextView
{
    if (!_ediTextView) {
        _ediTextView = [PlaceHolderTextView newAutoLayoutView];
        _ediTextView.textColor = kBlackColor;
        _ediTextView.font = kFirstFont;
        _ediTextView.placeholder = @"请输入地址";
        _ediTextView.placeholderColor = kLightGrayColor;
        _ediTextView.returnKeyType = UIReturnKeyDone;
        _ediTextView.delegate = self;
    }
    return _ediTextView;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.touchBeginPoint) {
        self.touchBeginPoint(CGPointMake(self.center.x, self.bottom + 10));
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSString *title = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (self.didEndEditing) {
            self.didEndEditing(title);
        }
        return NO;
    }
    
    NSString *title = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.didEndEditing) {
        self.didEndEditing(title);
    }
    
    return YES;
}



//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]){
//        [textView resignFirstResponder];
//        return NO;
//    }else if(range.location >= 500){//如果输入超过规定的字数20，就不再让输入
//        return NO;
//    }
//    NSString *content = text;
//    return YES;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
