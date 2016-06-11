//
//  MineCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topNameButton];
        [self.contentView addSubview:self.topGoButton];
        [self.contentView addSubview:self.linelabel];
        [self.contentView addSubview:self.button1];
        [self.contentView addSubview:self.button2];
        [self.contentView addSubview:self.button3];
        [self.contentView addSubview:self.button4];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
       // [self.topLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        //[self.topLabel autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        
        [self.topNameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.topNameButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        
        [self.topGoButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.topGoButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.topNameButton];
        
        [self.linelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topNameButton withOffset:5];
        [self.linelabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.linelabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.linelabel autoSetDimension:ALDimensionHeight toSize:kLineWidth];
        
        NSArray *views = @[self.button1,self.button2,self.button3,self.button4];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/4, 80)];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.button1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.linelabel];
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.button2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button1];
        [self.button3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button2];
        [self.button4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button3];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)topNameButton
{
    if (!_topNameButton) {
        _topNameButton = [UIButton newAutoLayoutView];
        [_topNameButton setTitleColor:kBlackColor forState:0];
        _topNameButton.titleLabel.font = kBigFont;
    }
    return _topNameButton;
}

- (UIButton *)topGoButton
{
    if (!_topGoButton) {
        _topGoButton = [UIButton newAutoLayoutView];
        [_topGoButton setTitleColor:kLightGrayColor forState:0];
        _topGoButton.titleLabel.font = kSecondFont;
        [_topGoButton swapImage];
        [_topGoButton setTitle:@"查看全部" forState:0];
        [_topGoButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

    }
    return _topGoButton;
}

- (UILabel *)linelabel
{
    if (!_linelabel) {
        _linelabel = [UILabel newAutoLayoutView];
        _linelabel.backgroundColor = kSeparateColor;
    }
    return _linelabel;
}

- (UserButton *)button1
{
    if (!_button1) {
        _button1 = [UserButton newAutoLayoutView];
    }
    return _button1;
}

- (UserButton *)button2
{
    if (!_button2) {
        _button2 = [UserButton newAutoLayoutView];
        _button2.label1.text = @"处理中";
        _button2.imageView1.image = [UIImage imageNamed:@"list_icon_treatment"];
    }
    return _button2;
}

- (UserButton *)button3
{
    if (!_button3) {
        _button3 = [UserButton newAutoLayoutView];
        _button3.label1.text = @"终止";
        _button3.imageView1.image = [UIImage imageNamed:@"list_icon_cutout"];
    }
    return _button3;
}

- (UserButton *)button4
{
    if (!_button4) {
        _button4 = [UserButton newAutoLayoutView];
        _button4.label1.text = @"结案";
        _button4.imageView1.image = [UIImage imageNamed:@"list_icon_end"];
    }
    return _button4;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
