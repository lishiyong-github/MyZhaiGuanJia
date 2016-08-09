//
//  SuitBaseCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SuitBaseCell.h"

@implementation SuitBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.segment];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.label,self.segment];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:95];
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.segment autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}


- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel newAutoLayoutView];
        _label.textColor = kBlackColor;
        _label.font = kBigFont;
    }
    return _label;
}

- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [UISegmentedControl newAutoLayoutView];
        [_segment insertSegmentWithTitle:@"快递" atIndex:0 animated:YES];
        [_segment insertSegmentWithTitle:@"自取" atIndex:1 animated:YES];
        
        _segment.tintColor = kBlueColor;
        _segment.selectedSegmentIndex = 0;
        [_segment setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kLightGrayColor} forState:0];
        [_segment setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kNavColor} forState:UIControlStateSelected];
        
        [_segment addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segment;
}

- (void)changeSegment:(UISegmentedControl *)segment
{
    if (self.didSelectedSeg) {
        self.didSelectedSeg(segment.selectedSegmentIndex);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
