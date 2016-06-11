//
//  ReportSuccessCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuccessCell.h"

@implementation ReportSuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.suTimeLabel];
        [self.contentView addSubview:self.suTypeLabel];
        [self.contentView addSubview:self.suStateLabel];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.suTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        
        [self.suTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suTimeLabel withOffset:kSmallPadding];
        
        [self.suStateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.suStateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.suTypeLabel withOffset:kSmallPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)suTimeLabel
{
    if (!_suTimeLabel) {
        _suTimeLabel = [UILabel newAutoLayoutView];
        _suTimeLabel.textColor = kLightGrayColor;
        _suTimeLabel.font = kFirstFont;
    }
    return _suTimeLabel;
}

- (UILabel *)suTypeLabel
{
    if (!_suTypeLabel) {
        _suTypeLabel = [UILabel newAutoLayoutView];
        _suTypeLabel.textColor = kLightGrayColor;
        _suTypeLabel.font = kFirstFont;
    }
    return _suTypeLabel;
}

- (UILabel *)suStateLabel
{
    if (!_suStateLabel) {
        _suStateLabel = [UILabel newAutoLayoutView];
        _suStateLabel.textColor = kLightGrayColor;
        _suStateLabel.font = kFirstFont;
    }
    return _suStateLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
