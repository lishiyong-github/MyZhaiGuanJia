//
//  ReportSuitCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuitCell.h"

@implementation ReportSuitCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.suCell0];
        [self.contentView addSubview:self.suLine0];
        [self.contentView addSubview:self.suCell1];
        [self.contentView addSubview:self.suLine1];
        [self.contentView addSubview:self.suCell2];
        [self.contentView addSubview:self.suLine2];
        [self.contentView addSubview:self.suCell3];
        [self.contentView addSubview:self.suLine3];
        [self.contentView addSubview:self.suCell4];
        [self.contentView addSubview:self.suLine4];
        [self.contentView addSubview:self.suCell5];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstarints) {
        
        NSArray *views = @[self.suCell0,self.suCell1,self.suCell2,self.suCell3,self.suCell4];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth, kCellHeight)];
        [views autoAlignViewsToAxis:ALAxisVertical];
        
        NSArray *views2 = @[self.suLine0,self.suLine1,self.suLine2,self.suLine3,self.suLine4];
        [views2 autoSetViewsDimension:ALDimensionHeight toSize:kLineWidth];
        
        NSArray *views3 = @[self.suLine1,self.suLine2,self.suLine3,self.suLine4];
        [views3 autoAlignViewsToAxis:ALAxisVertical];
        
        
        [self.suCell0 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.suCell0 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.suLine0 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suCell0];
        [self.suLine0 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.suLine0 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.suCell1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suLine0];
        [self.suCell1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.suLine1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suCell1];
        [self.suLine1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suLine1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.suCell2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suLine1];
        [self.suCell2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.suLine2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suCell2];
        [self.suLine2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suLine2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.suCell3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suLine2];
        [self.suCell3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.suLine3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suCell3];
        [self.suLine3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suLine3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.suCell4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suLine3];
        [self.suCell4 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.suLine4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suCell4];
        [self.suLine4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suLine4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.suCell5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suLine4];
        [self.suCell5 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
        [self.suCell5 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.suCell5 autoSetDimension:ALDimensionHeight toSize:62];
        
        self.didSetupConstarints = YES;
    }
    [super updateConstraints];
}


- (AuthenBaseView *)suCell0
{
    if (!_suCell0) {
        _suCell0 = [AuthenBaseView newAutoLayoutView];
        _suCell0.label.text = @"|  基本信息";
        _suCell0.label.textColor = kBlueColor;
        _suCell0.textField.userInteractionEnabled = NO;
    }
    return _suCell0;
}

- (LineLabel *)suLine0
{
    if (!_suLine0) {
        _suLine0 = [LineLabel newAutoLayoutView];
    }
    return _suLine0;
}

- (AuthenBaseView *)suCell1
{
    if (!_suCell1) {
        _suCell1 = [AuthenBaseView newAutoLayoutView];
        _suCell1.label.text = @"借款本金";
        
        NSMutableAttributedString *sttString = [[NSMutableAttributedString alloc] initWithString:@"填写您希望融资的金额"];
        [sttString setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, sttString.length)];
        [_suCell1.textField setAttributedPlaceholder:sttString];
        
        [_suCell1.button setTitle:@"万元" forState:0];
        _suCell1.button.titleLabel.font = kSecondFont;
        [_suCell1.button setTitleColor:kBlueColor forState:0];
    }
    return _suCell1;
}

- (LineLabel *)suLine1
{
    if (!_suLine1) {
        _suLine1 = [LineLabel newAutoLayoutView];
    }
    return _suLine1;
}

- (AuthenBaseView *)suCell2
{
    if (!_suCell2) {
        _suCell2 = [AuthenBaseView newAutoLayoutView];
        _suCell2.label.text = @"代理费用";
        
        NSMutableAttributedString *sttString = [[NSMutableAttributedString alloc] initWithString:@"请输入费用"];
        [sttString setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, sttString.length)];
        [_suCell2.textField setAttributedPlaceholder:sttString];
        
        [_suCell2.button setTitle:@"风险代理(%)" forState:0];
        [_suCell2.button setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [_suCell2.button setTitleColor:kBlueColor forState:0];
    }
    return _suCell2;
}

- (LineLabel *)suLine2
{
    if (!_suLine2) {
        _suLine2 = [LineLabel newAutoLayoutView];
    }
    return _suLine2;
}

- (SuitBaseView *)suCell3
{
    if (!_suCell3) {
        _suCell3 = [SuitBaseView newAutoLayoutView];
        _suCell3.label.text = @"债权类型";
    }
    return _suCell3;
}

- (LineLabel *)suLine3
{
    if (!_suLine3) {
        _suLine3 = [LineLabel newAutoLayoutView];
    }
    return _suLine3;
}

- (AuthenBaseView *)suCell4
{
    if (!_suCell4) {
        _suCell4 = [AuthenBaseView newAutoLayoutView];
        _suCell4.label.text = @"抵押物地址";
        NSMutableAttributedString *sttString = [[NSMutableAttributedString alloc] initWithString:@"小区/写字楼/商铺等"];
        [sttString setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, sttString.length)];
        [_suCell4.textField setAttributedPlaceholder:sttString];
    }
    return _suCell4;
}

- (LineLabel *)suLine4
{
    if (!_suLine4) {
        _suLine4 = [LineLabel newAutoLayoutView];
    }
    return _suLine4;
}

- (PlaceHolderTextView *)suCell5
{
    if (!_suCell5) {
        _suCell5 = [PlaceHolderTextView newAutoLayoutView];
        _suCell5.placeholder = @"详细地址";
        _suCell5.placeholderColor = kLightGrayColor;
        _suCell5.font = kSecondFont;
    }
    return _suCell5;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
