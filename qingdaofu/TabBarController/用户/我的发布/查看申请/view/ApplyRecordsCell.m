//
//  ApplyRecordsCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordsCell.h"

@implementation ApplyRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.personLabel];
        [self.contentView addSubview:self.lineLabel11];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.lineLabel12];
        [self.contentView addSubview:self.actButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.personLabel,self.dateLabel,self.actButton];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        NSArray *views2 = @[self.lineLabel11,self.lineLabel12];
        [views2 autoSetViewsDimension:ALDimensionWidth toSize:kLineWidth];
        [views2 autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.personLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.personLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];

        [self.lineLabel11 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        [self.lineLabel11 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSmallPadding];
        [self.lineLabel11 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.personLabel];
        
        [self.dateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.personLabel];
        [self.dateLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        
        [self.lineLabel12 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        [self.lineLabel12 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSmallPadding];
        [self.lineLabel12 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateLabel];
        
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSmallPadding];
        [self.actButton autoSetDimension:ALDimensionWidth toSize:50];
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(kScreenWidth/3-50)/2];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)personLabel
{
    if (!_personLabel) {
        _personLabel = [UILabel newAutoLayoutView];
        _personLabel.textColor = kLightGrayColor;
        _personLabel.font = kSecondFont;
        _personLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _personLabel;
}

- (LineLabel *)lineLabel11
{
    if (!_lineLabel11) {
        _lineLabel11 = [LineLabel newAutoLayoutView];
    }
    return _lineLabel11;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel newAutoLayoutView];
        _dateLabel.textColor = kLightGrayColor;
        _dateLabel.font = kSecondFont;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (LineLabel *)lineLabel12
{
    if (!_lineLabel12) {
        _lineLabel12 = [LineLabel newAutoLayoutView];
    }
    return _lineLabel12;
}

- (UIButton *)actButton
{
    if (!_actButton) {
        _actButton = [UIButton newAutoLayoutView];
        [_actButton setTitleColor:kBlueColor forState:0];
        _actButton.titleLabel.font = kSecondFont;
    }
    return _actButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
