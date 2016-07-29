//
//  FourCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/22.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "FourCell.h"

@implementation FourCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.button1];
        [self.contentView addSubview:self.button2];
        [self.contentView addSubview:self.button3];
        [self.contentView addSubview:self.button4];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.button1,self.button2,self.button3,self.button4];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/2, 70)];
        
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.button2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.button2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.button3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button1];
        [self.button3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.button4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.button4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button2];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)button1
{
    if (!_button1) {
        _button1 = [UIButton newAutoLayoutView];
        [_button1 setImage:[UIImage imageNamed:@"img_assessment"] forState:0];
        _button1.layer.borderColor = kSeparateColor.CGColor;
        _button1.layer.borderWidth = kLineWidth;
        _button1.tag = 11;
        [_button1 addTarget:self action:@selector(clickSingleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
- (UIButton *)button2
{
    if (!_button2) {
        _button2 = [UIButton newAutoLayoutView];
        [_button2 setImage:[UIImage imageNamed:@"img_transfer"] forState:0];
        _button2.layer.borderColor = kSeparateColor.CGColor;
        _button2.layer.borderWidth = kLineWidth;
        _button2.tag = 22;
        [_button2 addTarget:self action:@selector(clickSingleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}
- (UIButton *)button3
{
    if (!_button3) {
        _button3 = [UIButton newAutoLayoutView];
        [_button3 setImage:[UIImage imageNamed:@"img_litigation"] forState:0];
        _button3.layer.borderColor = kSeparateColor.CGColor;
        _button3.layer.borderWidth = kLineWidth;
        _button3.tag = 33;
        [_button3 addTarget:self action:@selector(clickSingleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}
- (UIButton *)button4
{
    if (!_button4) {
        _button4 = [UIButton newAutoLayoutView];
        [_button4 setImage:[UIImage imageNamed:@"img_guarantee"] forState:0];
        _button4.layer.borderColor = kSeparateColor.CGColor;
        _button4.layer.borderWidth = kLineWidth;
        _button4.tag = 44;
        [_button4 addTarget:self action:@selector(clickSingleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button4;
}

- (void)clickSingleButton:(UIButton *)sender
{
    if (self.didClickButton) {
        self.didClickButton(sender.tag);
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
