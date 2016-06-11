//
//  MyStoreCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyStoreCell.h"

#import "UIButton+Addition.h"

@implementation MyStoreCell


//+(instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *identifier = @"mySave";
//    MyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (!cell) {
//        cell = [[MyStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//        [self addSubview:self.imageView1];
//        [self addSubview:self.label1];
//        [self addSubview:self.label2];
        //        [self addSubview:self.label3];
        
        [self.contentView addSubview:self.sButton1];
        [self.contentView addSubview:self.sButton2];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.sButton1,self.sButton2];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.sButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.sButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        
        [self.sButton2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)sButton1
{
    if (!_sButton1) {
        _sButton1 = [UIButton newAutoLayoutView];
        [_sButton1 setTitleColor:kBlackColor forState:0];
        _sButton1.titleLabel.font = kBigFont;
        _sButton1.userInteractionEnabled = NO;
    }
    return _sButton1;
}

- (UIButton *)sButton2
{
    if (!_sButton2) {
        _sButton2 = [UIButton newAutoLayoutView];
        [_sButton2 setTitleColor:kLightGrayColor forState:0];
        _sButton2.titleLabel.font = kSecondFont;
        [_sButton2 swapImage];
        _sButton2.userInteractionEnabled = NO;
    }
    return _sButton2;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
