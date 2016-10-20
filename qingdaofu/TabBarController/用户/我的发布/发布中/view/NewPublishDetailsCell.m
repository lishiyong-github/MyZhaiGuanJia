//
//  NewPublishDetailsCell.m
//  qingdaofu
//
//  Created by zhixiang on SPACE/10/13.
//  Copyright © 20SPACE年 zhixiang. All rights reserved.
//

#import "NewPublishDetailsCell.h"
#define SPACE 16  //间隔
@implementation NewPublishDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.point1];
        [self.contentView addSubview:self.point2];
        [self.contentView addSubview:self.point3];
        [self.contentView addSubview:self.point4];
        
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];

        [self.contentView addSubview:self.progress1];
        [self.contentView addSubview:self.progress2];
        [self.contentView addSubview:self.progress3];
        [self.contentView addSubview:self.progress4];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views1 = @[self.point1,self.point2,self.point3,self.point4];
        [views1 autoAlignViewsToAxis:ALAxisHorizontal];
        [views1 autoSetViewsDimensionsToSize:CGSizeMake(20, 20)];
        [views1 autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSize:kScreenWidth/4 insetSpacing:YES];
        [self.point1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:SPACE];
        
        NSArray *view2 = @[self.line1,self.line2,self.line3];
        [view2 autoAlignViewsToAxis:ALAxisHorizontal];
        [view2 autoMatchViewsDimension:ALDimensionWidth];
        [view2 autoMatchViewsDimension:ALDimensionHeight];
        [view2 autoSetViewsDimension:ALDimensionHeight toSize:kLineWidth];
        
        [[view2 firstObject] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point1 withOffset:SPACE];
        [[view2 firstObject] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point2 withOffset:-SPACE];
        [[view2 firstObject]  autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.point1];
        
        [self.line2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point2 withOffset:SPACE];
        [self.line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point3 withOffset:-SPACE];
        
        [[view2 lastObject] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point3 withOffset:SPACE];
        [[view2 lastObject] autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point4 withOffset:-SPACE];
        
         NSArray *views3 = @[self.progress1,self.progress2,self.progress3,self.progress4];
        [views3 autoAlignViewsToAxis:ALAxisHorizontal];
        [self.progress1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.point1];
        [self.progress1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.point1 withOffset:kSpacePadding];
        [self.progress2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.point2];
        [self.progress3 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.point3];
        [self.progress4 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.point4];
        
        
        
        
        
//        [self.point2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress2];
//        [self.point3 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress3];
//        [self.point4 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress4];
        
//        NSArray *views3 = @[self.line1,self.line2,self.line3];
//        [views3 autoSetViewsDimension:ALDimensionHeight toSize:kLineWidth];
//        [views3 autoAlignViewsToAxis:ALAxisHorizontal];
        
//        [self.line1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.point1];
//        [self.line1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point1 withOffset:5];
//        [self.line1 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point2 withOffset:-5];
//        [self.line1 autoSetDimension:ALDimensionHeight toSize:kLineWidth];
//        
//        [self.line2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point2 withOffset:5];
//        [self.line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point3 withOffset:-5];
//        
//        [self.line3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point3 withOffset:5];
//        [self.line3 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point4 withOffset:-5];
        
//        NSArray *views = @[self.progress1,self.progress2,self.progress3,self.progress4];
//        [views autoSetViewsDimension:ALDimensionWidth toSize:(kScreenWidth-kBigPadding*2)/4];
//        [views autoAlignViewsToAxis:ALAxisHorizontal];
//        [self.progress1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button2 withOffset:kBigPadding];
//        [self.progress1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.button2];
//        [self.progress2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.progress1];
//        [self.progress3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.progress2];
//        [self.progress4 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.button2];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)point1
{
    if (!_point1) {
        _point1 = [UIButton newAutoLayoutView];
        [_point1 setImage:[UIImage imageNamed:@"succee"] forState:0];
    }
    return _point1;
}

- (UIButton *)point2
{
    if (!_point2) {//normal,succee,fail,normal2,normal3,normal4
        _point2 = [UIButton newAutoLayoutView];
        [_point2 setImage:[UIImage imageNamed:@"normal2"] forState:0];
    }
    return _point2;
}


- (UIButton *)point3
{
    if (!_point3) {
        _point3 = [UIButton newAutoLayoutView];
        [_point3 setImage:[UIImage imageNamed:@"normal3"] forState:0];
    }
    return _point3;
}

- (UIButton *)point4
{
    if (!_point4) {
        _point4 = [UIButton newAutoLayoutView];
        [_point4 setImage:[UIImage imageNamed:@"normal4"] forState:0];
    }
    return _point4;
}

- (UILabel *)line1
{
    if (!_line1) {
        _line1 = [UILabel newAutoLayoutView];
        _line1.backgroundColor = kButtonColor;
    }
    return _line1;
}

- (UILabel *)line2
{
    if (!_line2) {
        _line2 = [UILabel newAutoLayoutView];
        _line2.backgroundColor = kLightGrayColor;
    }
    return _line2;
}

- (UILabel *)line3
{
    if (!_line3) {
        _line3 = [UILabel newAutoLayoutView];
        _line3.backgroundColor = kLightGrayColor;
    }
    return _line3;
}

- (UILabel *)progress1
{
    if (!_progress1) {
        _progress1 = [UILabel newAutoLayoutView];
        _progress1.text = @"发布成功";
        _progress1.textColor = kTextColor;
        _progress1.font = kSecondFont;
        _progress1.textAlignment = NSTextAlignmentCenter;
    }
    return _progress1;
}

- (UILabel *)progress2
{
    if (!_progress2) {
        _progress2 = [UILabel newAutoLayoutView];
        _progress2.text = @"面谈中";
        _progress2.textColor = kLightGrayColor;
        _progress2.font = kSecondFont;
        _progress2.textAlignment = NSTextAlignmentCenter;
    }
    return _progress2;
}


- (UILabel *)progress3
{
    if (!_progress3) {
        _progress3 = [UILabel newAutoLayoutView];
        _progress3.text = @"处理订单";
        _progress3.textColor = kLightGrayColor;
        _progress3.font = kSecondFont;
        _progress3.textAlignment = NSTextAlignmentCenter;
    }
    return _progress3;
}


- (UILabel *)progress4
{
    if (!_progress4) {
        _progress4 = [UILabel newAutoLayoutView];
        _progress4.text = @"结案";
        _progress4.textColor = kLightGrayColor;
        _progress4.font = kSecondFont;
        _progress4.textAlignment = NSTextAlignmentCenter;
    }
    return _progress4;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
