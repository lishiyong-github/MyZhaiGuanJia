//
//  MyOrderDetailCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyOrderDetailCell.h"

@implementation MyOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.detail1];
        [self.contentView addSubview:self.lineLabel1];
        [self.contentView addSubview:self.detail2];
        [self.contentView addSubview:self.lineLabel2];
        [self.contentView addSubview:self.detail3];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraits) {
        
        NSArray *views = @[self.lineLabel1,self.lineLabel2];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth, 0.5)];
        
        [self.detail1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
        
        [self.lineLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHeight];
        [self.lineLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.detail2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel1];
        [self.detail2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.detail2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.detail2 autoSetDimension:ALDimensionHeight toSize:120];
        
        [self.lineLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.detail2];
        [self.lineLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.detail3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel2];
        [self.detail3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.detail3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.detail3 autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        
        self.didSetupConstraits = YES;
    }
    [super updateConstraints];
}

- (AuthenBaseView *)detail1
{
    if (!_detail1) {
        _detail1 = [AuthenBaseView newAutoLayoutView];
        _detail1.label.text = @"| 进度详情";
        _detail1.label.textColor = kBlueColor;
        _detail1.textField.placeholder = @"";
        _detail1.textField.userInteractionEnabled = NO;
    }
    return _detail1;
}

- (LineLabel *)lineLabel1
{
    if (!_lineLabel1) {
        _lineLabel1 = [LineLabel newAutoLayoutView];
    }
    return _lineLabel1;
}

- (UIView *)detail2
{
    if (!_detail2) {
        _detail2 = [UIView newAutoLayoutView];
    }
    return _detail2;
}

- (LineLabel *)lineLabel2
{
    if (!_lineLabel2) {
        _lineLabel2 = [LineLabel newAutoLayoutView];
    }
    return _lineLabel2;
}

- (UIButton *)detail3
{
    if (!_detail3) {
        _detail3 = [UIButton newAutoLayoutView];
        [_detail3 setTitle:@"填写进度 >" forState:0];
        [_detail3 setTitleColor:kLightGrayColor forState:0];
        _detail3.titleLabel.font = kFirstFont;
    }
    return _detail3;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
