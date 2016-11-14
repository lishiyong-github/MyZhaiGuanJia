//
//  StarCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "StarCell.h"

@implementation StarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.starLabel1];
        [self.contentView addSubview:self.starView1];
        [self.contentView addSubview:self.starLabel2];
        [self.contentView addSubview:self.starView2];
        [self.contentView addSubview:self.starLabel3];
        [self.contentView addSubview:self.starView3];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstarints) {
        
        NSArray *views = @[self.starView1,self.starView2,self.starView3];
        [views autoSetViewsDimensionsToSize:CGSizeMake(100, 20)];
        
        [self.starLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.starLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kNewPadding];
        
        [self.starView1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.starView1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.starLabel1];
        
        [self.starLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.starLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.starLabel1 withOffset:kNewPadding];
        
        [self.starView2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.starView2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.starLabel2];
        
        [self.starLabel3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.starLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.starLabel2 withOffset:kNewPadding];
        
        [self.starView3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.starView3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.starLabel3];
        
        self.didSetupConstarints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)starLabel1
{
    if (!_starLabel1) {
        _starLabel1 = [UILabel newAutoLayoutView];
        _starLabel1.textColor = kBlackColor;
        _starLabel1.font = kBigFont;
        _starLabel1.text = @"真实性";
    }
    return _starLabel1;
}

- (LEOStarView *)starView1
{
    if (!_starView1) {
        _starView1 = [LEOStarView newAutoLayoutView];
        [_starView1 setStarImage:[UIImage imageNamed:@"evaluate_star"]];
        _starView1.markType = EMarkTypeInteger;
        [_starView1 setStarFrontColor:kYellowColor];
        _starView1.starBackgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _starView1;
}

- (UILabel *)starLabel2
{
    if (!_starLabel2) {
        _starLabel2 = [UILabel newAutoLayoutView];
        _starLabel2.textColor = kBlackColor;
        _starLabel2.font = kBigFont;
        _starLabel2.text = @"配合度";
    }
    return _starLabel2;
}

- (LEOStarView *)starView2
{
    if (!_starView2) {
        _starView2 = [LEOStarView newAutoLayoutView];
        [_starView2 setStarImage:[UIImage imageNamed:@"evaluate_star"]];
        _starView2.markType = EMarkTypeInteger;
        [_starView2 setStarFrontColor:kYellowColor];
        _starView2.starBackgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _starView2;
}

- (UILabel *)starLabel3
{
    if (!_starLabel3) {
        _starLabel3 = [UILabel newAutoLayoutView];
        _starLabel3.textColor = kBlackColor;
        _starLabel3.font = kBigFont;
        _starLabel3.text = @"响应度";
    }
    return _starLabel3;
}

- (LEOStarView *)starView3
{
    if (!_starView3) {
        _starView3 = [LEOStarView newAutoLayoutView];
        [_starView3 setStarImage:[UIImage imageNamed:@"evaluate_star"]];
        _starView3.markType = EMarkTypeInteger;
        [_starView3 setStarFrontColor:kYellowColor];
        _starView3.starBackgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _starView3;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
