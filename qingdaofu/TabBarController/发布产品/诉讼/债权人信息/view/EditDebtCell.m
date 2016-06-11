//
//  EditDebtCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EditDebtCell.h"

@implementation EditDebtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.editImageButton1];
        [self.contentView addSubview:self.editImageButton2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.editImageButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.editImageButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.editImageButton1 autoSetDimensionsToSize:CGSizeMake(70, 85+18)];
        
        
        [self.editImageButton2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.editImageButton1];
        [self.editImageButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.editImageButton1];
        [self.editImageButton2 autoSetDimensionsToSize:CGSizeMake(85, 85+18)];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (SingleButton *)editImageButton1
{
    if (!_editImageButton1) {
        _editImageButton1 = [SingleButton newAutoLayoutView];
        _editImageButton1.label.text = @"上传图片";
        _editImageButton1.label.textColor = kLightGrayColor;
        _editImageButton1.label.font = kSecondFont;
        _editImageButton1.userInteractionEnabled = YES;
    }
    return _editImageButton1;
}

- (SingleButton *)editImageButton2
{
    if (!_editImageButton2) {
        _editImageButton2 = [SingleButton newAutoLayoutView];
        _editImageButton2.label.text = @"上传图片";
        _editImageButton2.label.textColor = kLightGrayColor;
        _editImageButton2.label.font = kSecondFont;
    }
    return _editImageButton2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
