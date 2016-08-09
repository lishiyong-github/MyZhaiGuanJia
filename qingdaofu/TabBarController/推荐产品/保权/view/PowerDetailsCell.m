//
//  PowerDetailsCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerDetailsCell.h"

@implementation PowerDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.backButton];
        [self.contentView addSubview:self.button1];
        [self.contentView addSubview:self.button2];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, kBigPadding)];
        
        [self.button1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.backButton];
        [self.button1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.backButton];
        [self.button1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.backButton];
        [self.button1 autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.button2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button1];
        [self.button2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.button1];
        [self.button2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.button1];
        [self.button2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.backButton];

        
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}


-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton newAutoLayoutView];
        _backButton.layer.cornerRadius = 5;
        _backButton.backgroundColor = kNavColor;
    }
    return _backButton;
}

-(UIButton *)button1
{
    if (!_button1) {
        _button1 = [UIButton newAutoLayoutView];
        _button1.layer.masksToBounds = YES;
        _button1.titleLabel.numberOfLines = 0;
        [_button1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_button1 setContentEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        [_button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        
        [_button1 setImage:[UIImage imageNamed:@"right"] forState:0];
        NSString *str1 = @"保全进度";
        NSString *str2 = @"本平台承诺对您的案件资料和隐私严格保密！";
        NSString *str = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kBigFont} range:NSMakeRange(0, str1.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kLightGrayColor,NSFontAttributeName:kSmallFont} range:NSMakeRange(str1.length+1, str2.length)];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
       
        [_button1 setAttributedTitle:attributeStr forState:0];
    }
    return _button1;
}

- (UIButton *)button2
{
    if (!_button2) {
        _button2 = [UIButton newAutoLayoutView];
        _button2.layer.masksToBounds = YES;
//        [_button2 setBackgroundImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _button2;
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
