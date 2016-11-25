//
//  NewPublishCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewPublishCell.h"

@implementation NewPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.functionButton1];
        [self.contentView addSubview:self.functionButton2];
        [self.contentView addSubview:self.functionButton3];
        [self.contentView addSubview:self.functionButton4];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.functionButton1,self.functionButton2,self.functionButton3,self.functionButton4];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/4,80)];
        
        [views autoMatchViewsDimension:ALDimensionWidth];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.functionButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.functionButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];

        [self.functionButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton1];

        [self.functionButton3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton2];

        [self.functionButton4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton3];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (SingleButton *)functionButton1
{
    if (!_functionButton1) {
        _functionButton1 = [SingleButton newAutoLayoutView];
        _functionButton1.label.text = @"诉讼保全";
        [_functionButton1.button setImage:[UIImage imageNamed:@"btn_financing"] forState:0];
        _functionButton1.button.userInteractionEnabled = NO;

        QDFWeakSelf;
        [_functionButton1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(11);
            }
        }];
    }
    return _functionButton1;
}

- (SingleButton *)functionButton2
{
    if (!_functionButton2) {
        _functionButton2 = [SingleButton newAutoLayoutView];
        _functionButton2.label.text = @"申请保函";
        [_functionButton2.button setImage:[UIImage imageNamed:@"btn_collection"] forState:0];
        _functionButton2.button.userInteractionEnabled = NO;
        QDFWeakSelf;
        [_functionButton2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(12);
            }
        }];
    }
    return _functionButton2;
}

- (SingleButton *)functionButton3
{
    if (!_functionButton3) {
        _functionButton3 = [SingleButton newAutoLayoutView];
        _functionButton3.label.text = @"房产评估";
        [_functionButton3.button setImage:[UIImage imageNamed:@"btn_litigation"] forState:0];
        _functionButton3.button.userInteractionEnabled = NO;
        
        QDFWeakSelf;
        [_functionButton3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(13);
            }
        }];
    }
    return _functionButton3;
}

- (SingleButton *)functionButton4
{
    if (!_functionButton4) {
        _functionButton4 = [SingleButton newAutoLayoutView];
        _functionButton4.label.text = @"产调查询";
        [_functionButton4.button setImage:[UIImage imageNamed:@"btn_financing"] forState:0];
        _functionButton4.button.userInteractionEnabled = NO;
        
        QDFWeakSelf;
        [_functionButton4 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(14);
            }
        }];
    }
    return _functionButton4;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
