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
        
        [self.contentView addSubview:self.progress1];
        [self.contentView addSubview:self.progress2];
        [self.contentView addSubview:self.progress3];
        [self.contentView addSubview:self.progress4];
        
        [self.contentView addSubview:self.point1];
        [self.contentView addSubview:self.point2];
        [self.contentView addSubview:self.point3];
        [self.contentView addSubview:self.point4];
        
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];

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

        NSArray *views = @[self.progress1,self.progress2,self.progress3,self.progress4];
        [views autoSetViewsDimension:ALDimensionWidth toSize:(kScreenWidth-kBigPadding*2)/4];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        [self.progress1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button2 withOffset:kBigPadding];
        [self.progress1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.button2];
        [self.progress2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.progress1];
        [self.progress3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.progress2];
        [self.progress4 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.button2];
        
        NSArray *views2 = @[self.point1,self.point2,self.point3,self.point4];
        [views2 autoAlignViewsToAxis:ALAxisHorizontal];
        [self.point1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress1];
        [self.point1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.progress1];
        [self.point2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress2];
        [self.point3 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress3];
        [self.point4 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.progress4];
    
        NSArray *views3 = @[self.line1,self.line2,self.line3];
        [views3 autoSetViewsDimension:ALDimensionHeight toSize:kLineWidth];
        [views3 autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.line1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.point1];
        [self.line1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point1 withOffset:5];
        [self.line1 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point2 withOffset:-5];
        
        [self.line2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point2 withOffset:5];
        [self.line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point3 withOffset:-5];

        [self.line3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.point3 withOffset:5];
        [self.line3 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.point4 withOffset:-5];
        
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
        _button1.userInteractionEnabled = NO;

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
        [_button2 setBackgroundImage:[UIImage imageNamed:@"bg"] forState:0];
        _button2.layer.masksToBounds = YES;
        _button2.userInteractionEnabled = NO;
    }
    return _button2;
}

- (UILabel *)progress1
{
    if (!_progress1) {
        _progress1 = [UILabel newAutoLayoutView];
        _progress1.text = @"审核通过";
        _progress1.textColor = kLightGrayColor;
        _progress1.font = kSecondFont;
        _progress1.textAlignment = NSTextAlignmentCenter;
//        _progress1.backgroundColor = kRedColor;
    }
    return _progress1;
}

- (UILabel *)progress2
{
    if (!_progress2) {
        _progress2 = [UILabel newAutoLayoutView];
        _progress2.text = @"协议已签订";
        _progress2.textColor = kLightGrayColor;
        _progress2.font = kSecondFont;
        _progress2.textAlignment = NSTextAlignmentCenter;
//        _progress2.backgroundColor = kYellowColor;
    }
    return _progress2;
}


- (UILabel *)progress3
{
    if (!_progress3) {
        _progress3 = [UILabel newAutoLayoutView];
        _progress3.text = @"保函已出";
        _progress3.textColor = kLightGrayColor;
        _progress3.font = kSecondFont;
        _progress3.textAlignment = NSTextAlignmentCenter;
//        _progress3.backgroundColor = kBlueColor;
    }
    return _progress3;
}


- (UILabel *)progress4
{
    if (!_progress4) {
        _progress4 = [UILabel newAutoLayoutView];
        _progress4.text = @"完成/退保";
        _progress4.textColor = kLightGrayColor;
        _progress4.font = kSecondFont;
        _progress4.textAlignment = NSTextAlignmentCenter;
//        _progress4.backgroundColor = kGrayColor;
    }
    return _progress4;
}

- (UIButton *)point1
{
    if (!_point1) {
        _point1 = [UIButton newAutoLayoutView];
        [_point1 setImage:[UIImage imageNamed:@"progress_point"] forState:0];
    }
    return _point1;
}

- (UIButton *)point2
{
    if (!_point2) {
        _point2 = [UIButton newAutoLayoutView];
        [_point2 setImage:[UIImage imageNamed:@"progress_point"] forState:0];
    }
    return _point2;
}


- (UIButton *)point3
{
    if (!_point3) {
        _point3 = [UIButton newAutoLayoutView];
        [_point3 setImage:[UIImage imageNamed:@"progress_point"] forState:0];
    }
    return _point3;
}

- (UIButton *)point4
{
    if (!_point4) {
        _point4 = [UIButton newAutoLayoutView];
        [_point4 setImage:[UIImage imageNamed:@"progress_point"] forState:0];
    }
    return _point4;
}

- (UILabel *)line1
{
    if (!_line1) {
        _line1 = [UILabel newAutoLayoutView];
        _line1.backgroundColor = kLightGrayColor;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
