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
        
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:105];
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
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
        [_segment insertSegmentWithTitle:@"房产抵押" atIndex:0 animated:YES];
        [_segment insertSegmentWithTitle:@"机动车抵押" atIndex:1 animated:YES];
        [_segment insertSegmentWithTitle:@"应收帐款" atIndex:2 animated:YES];
        [_segment insertSegmentWithTitle:@"无抵押" atIndex:3 animated:YES];
        
        _segment.tintColor = kBlueColor;
        _segment.selectedSegmentIndex = 0;
        [_segment setWidth:60 forSegmentAtIndex:0];
        [_segment setTitleTextAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} forState:0];
        [_segment setTitleTextAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kNavColor} forState:UIControlStateSelected];
        
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
