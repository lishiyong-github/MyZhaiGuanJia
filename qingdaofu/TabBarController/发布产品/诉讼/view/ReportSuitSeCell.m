//
//  ReportSuitSeCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportSuitSeCell.h"

@implementation ReportSuitSeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.ssCell0];
        [self.contentView addSubview:self.ssLine0];
        [self.contentView addSubview:self.ssCell1];
        [self.contentView addSubview:self.ssLine1];
        [self.contentView addSubview:self.ssCell2];
        [self.contentView addSubview:self.ssLine2];
        [self.contentView addSubview:self.ssCell3];
        [self.contentView addSubview:self.ssLine3];
        [self.contentView addSubview:self.ssCell4];
        [self.contentView addSubview:self.ssLine4];
        [self.contentView addSubview:self.ssCell5];
        [self.contentView addSubview:self.ssLine5];
        [self.contentView addSubview:self.ssCell6];
        [self.contentView addSubview:self.ssLine6];
        [self.contentView addSubview:self.ssCell7];
        [self.contentView addSubview:self.ssLine7];
        [self.contentView addSubview:self.ssCell8];
        [self.contentView addSubview:self.ssLine8];
        [self.contentView addSubview:self.ssCell9];
        [self.contentView addSubview:self.ssLine9];
        [self.contentView addSubview:self.ssCell10];
        [self.contentView addSubview:self.ssLine10];
        [self.contentView addSubview:self.ssCell11];
        [self.contentView addSubview:self.ssLine11];
        [self.contentView addSubview:self.ssCell12];
        [self.contentView addSubview:self.ssLine12];
        [self.contentView addSubview:self.ssCell13];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstarints) {
        
        NSArray *views = @[self.ssCell0,self.ssCell1,self.ssCell2,self.ssCell3,self.ssCell4,self.ssCell5,self.ssCell6,self.ssCell7,self.ssCell8,self.ssCell10,self.ssCell11,self.ssCell12,self.ssCell13];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth, kCellHeight)];
        [views autoAlignViewsToAxis:ALAxisVertical];
        
        [self.ssCell9 autoSetDimensionsToSize:CGSizeMake(kScreenWidth, 62)];
        
        NSArray *views2 = @[self.ssLine0,self.ssLine1,self.ssLine2,self.ssLine3,self.ssLine4,self.ssLine5,self.ssLine6,self.ssLine7,self.ssLine8,self.ssLine9,self.ssLine10,self.ssLine11,self.ssLine12];
        [views2 autoSetViewsDimension:ALDimensionHeight toSize:kLineWidth];
        
        NSArray *views3 = @[self.ssLine1,self.ssLine2,self.ssLine3,self.ssLine4,self.ssLine5,self.ssLine6,self.ssLine7,self.ssLine8,self.ssLine9,self.ssLine10,self.ssLine11,self.ssLine12];
        [views3 autoAlignViewsToAxis:ALAxisVertical];
        
        [self.ssCell0 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.ssCell0 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine0 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell0];
        [self.ssLine0 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.ssLine0 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine0];
        [self.ssCell1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell1];
        [self.ssLine1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine1];
        [self.ssCell2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell2];
        [self.ssLine2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine2];
        [self.ssCell3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell3];
        [self.ssLine3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine3];
        [self.ssCell4 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell4];
        [self.ssLine4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine4];
        [self.ssCell5 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell5];
        [self.ssLine5 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine5 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell6 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine5];
        [self.ssCell6 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine6 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell6];
        [self.ssLine6 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine6 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell7 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine6];
        [self.ssCell7 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine7 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell7];
        [self.ssLine7 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine7 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell8 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine7];
        [self.ssCell8 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine8 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell8];
        [self.ssLine8 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine8 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell9 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine8];
        [self.ssCell9 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine9 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell9];
        [self.ssLine9 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine9 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell10 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine9];
        [self.ssCell10 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine10 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell10];
        [self.ssLine10 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine10 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell11 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine10];
        [self.ssCell11 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine11 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell11];
        [self.ssLine11 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine11 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell12 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine11];
        [self.ssCell12 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ssLine12 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssCell12];
        [self.ssLine12 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ssLine12 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.ssCell13 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ssLine12];
        [self.ssCell13 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        self.didSetupConstarints = YES;
    }
    [super updateConstraints];
}


- (AuthenBaseView *)ssCell0
{
    if (!_ssCell0) {
        _ssCell0 = [AuthenBaseView newAutoLayoutView];
        
        NSString *str1 = @"|  补充信息";
        NSString *str2 = @"(选填)";
        NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} range:NSMakeRange(0, str1.length)];
        [attributeStr addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(str1.length, str2.length)];
        [_ssCell0.label setAttributedText:attributeStr];
        
        _ssCell0.textField.userInteractionEnabled = NO;
    }
    return _ssCell0;
}

- (LineLabel *)ssLine0
{
    if (!_ssLine0) {
        _ssLine0 = [LineLabel newAutoLayoutView];
    }
    return _ssLine0;
}

- (AuthenBaseView *)ssCell1
{
    if (!_ssCell1) {
        _ssCell1 = [AuthenBaseView newAutoLayoutView];
        _ssCell1.label.text = @"借款利率(%)";
        
        _ssCell1.textField.placeholder = @"能够给到融资方的利息";
        _ssCell1.textField.font = kSecondFont;
        
        [_ssCell1.button setTitle:@"月" forState:0];
        [_ssCell1.button setTitleColor:kBlueColor forState:0];
        [_ssCell1.button setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _ssCell1;
}

- (LineLabel *)ssLine1
{
    if (!_ssLine1) {
        _ssLine1 = [LineLabel newAutoLayoutView];
    }
    return _ssLine1;
}
- (AuthenBaseView *)ssCell2
{
    if (!_ssCell2) {
        _ssCell2 = [AuthenBaseView newAutoLayoutView];
        _ssCell2.label.text = @"借款期限";
        
        _ssCell2.textField.placeholder = @"借款期限";
        _ssCell2.textField.font = kSecondFont;
        _ssCell2.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [_ssCell2.button setTitle:@"月" forState:0];
        [_ssCell2.button setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [_ssCell2.button setTitleColor:kBlueColor forState:0];
    }
    return _ssCell2;
}

- (LineLabel *)ssLine2
{
    if (!_ssLine2) {
        _ssLine2 = [LineLabel newAutoLayoutView];
    }
    return _ssLine2;
}
- (BaseLabel *)ssCell3
{
    if (!_ssCell3) {
        _ssCell3 = [BaseLabel newAutoLayoutView];
        _ssCell3.nameLabel.text = @"选择还款方式";
        [_ssCell3.goButton setTitle:@"按月付息，到期还本" forState:0];
        [_ssCell3.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell3.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _ssCell3;
}
- (LineLabel *)ssLine3
{
    if (!_ssLine3) {
        _ssLine3 = [LineLabel newAutoLayoutView];
    }
    return _ssLine3;
}

- (BaseLabel *)ssCell4
{
    if (!_ssCell4) {
        _ssCell4 = [BaseLabel newAutoLayoutView];
        _ssCell4.nameLabel.text = @"债务人主体";
        [_ssCell4.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell4.goButton setTitle:@"自然人" forState:0];
        [_ssCell4.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

    }
    return _ssCell4;
}

- (LineLabel *)ssLine4
{
    if (!_ssLine4) {
        _ssLine4 = [LineLabel newAutoLayoutView];
    }
    return _ssLine4;
}

- (BaseLabel *)ssCell5
{
    if (!_ssCell5) {
        _ssCell5 = [BaseLabel newAutoLayoutView];
        _ssCell5.nameLabel.text = @"委托事项";
        
        [_ssCell5.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell5.goButton setTitle:@"代理诉讼" forState:0];
        [_ssCell5.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _ssCell5;
}

- (LineLabel *)ssLine5
{
    if (!_ssLine5) {
        _ssLine5 = [LineLabel newAutoLayoutView];
    }
    return _ssLine5;
}

- (BaseLabel *)ssCell6
{
    if (!_ssCell6) {
        _ssCell6 = [BaseLabel newAutoLayoutView];
        _ssCell6.nameLabel.text = @"委托代理期限(月)";
        [_ssCell6.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell6.goButton setTitle:@"1" forState:0];
        [_ssCell6.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _ssCell6;
}

- (LineLabel *)ssLine6
{
    if (!_ssLine6) {
        _ssLine6 = [LineLabel newAutoLayoutView];
    }
    return _ssLine6;
}

- (AuthenBaseView *)ssCell7
{
    if (!_ssCell7) {
        _ssCell7 = [AuthenBaseView newAutoLayoutView];
        _ssCell7.label.text = @"已付本金";
        _ssCell7.textField.placeholder = @"请填写已付本金";
        [_ssCell7.button setTitle:@"元" forState:0];
        _ssCell7.button.titleLabel.font = kSecondFont;
        [_ssCell7.button setTitleColor:kBlueColor forState:0];
    }
    return _ssCell7;
}

- (LineLabel *)ssLine7
{
    if (!_ssLine7) {
        _ssLine7 = [LineLabel newAutoLayoutView];
    }
    return _ssLine7;
}

- (AuthenBaseView *)ssCell8
{
    if (!_ssCell8) {
        _ssCell8 = [AuthenBaseView newAutoLayoutView];
        _ssCell8.label.text = @"已付利息";
        _ssCell8.textField.placeholder = @"请填写已付利息";
        [_ssCell8.button setTitle:@"元" forState:0];
        _ssCell8.button.titleLabel.font = kSecondFont;
        [_ssCell8.button setTitleColor:kBlueColor forState:0];
    }
    return _ssCell8;
}

- (LineLabel *)ssLine8
{
    if (!_ssLine8) {
        _ssLine8 = [LineLabel newAutoLayoutView];
    }
    return _ssLine8;
}

- (AuthenBaseView *)ssCell9
{
    if (!_ssCell9) {
        _ssCell9 = [AuthenBaseView newAutoLayoutView];
        _ssCell9.label.text = @"合同履行地";
        _ssCell9.textField.placeholder = @"合同履行地";
    }
    return _ssCell9;
}

- (LineLabel *)ssLine9
{
    if (!_ssLine9) {
        _ssLine9 = [LineLabel newAutoLayoutView];
    }
    return _ssLine9;
}

- (BaseLabel *)ssCell10
{
    if (!_ssCell10) {
        _ssCell10 = [BaseLabel newAutoLayoutView];
        _ssCell10.nameLabel.text = @"付款方式";
        [_ssCell10.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell10.goButton setTitle:@"分期" forState:0];
        _ssCell10.goButton.titleLabel.font = kSecondFont;
        [_ssCell10.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _ssCell10;
}

- (LineLabel *)ssLine10
{
    if (!_ssLine10) {
        _ssLine10 = [LineLabel newAutoLayoutView];
    }
    return _ssLine10;
}

- (BaseLabel *)ssCell11
{
    if (!_ssCell11) {
        _ssCell11 = [BaseLabel newAutoLayoutView];
        _ssCell11.nameLabel.text = @"债权文件";
        [_ssCell11.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell11.goButton setTitle:@"上传" forState:0];
        _ssCell11.goButton.titleLabel.font = kSecondFont;
        [_ssCell11.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

        QDFWeakSelf;
        [_ssCell11.goButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedIndex) {
                weakself.didSelectedIndex(80);
            }
        }];
    }
    return _ssCell11;
}

- (LineLabel *)ssLine11
{
    if (!_ssLine11) {
        _ssLine11 = [LineLabel newAutoLayoutView];
    }
    return _ssLine11;
}

- (BaseLabel *)ssCell12
{
    if (!_ssCell12) {
        _ssCell12 = [BaseLabel newAutoLayoutView];
        _ssCell12.nameLabel.text = @"债权人信息";
        [_ssCell12.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell12.goButton setTitle:@"完善" forState:0];
        _ssCell12.goButton.titleLabel.font = kSecondFont;
        [_ssCell12.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

        QDFWeakSelf;
        [_ssCell12.goButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedIndex) {
                weakself.didSelectedIndex(81);
            }
        }];

    }
    return _ssCell12;
}

- (LineLabel *)ssLine12
{
    if (!_ssLine12) {
        _ssLine12 = [LineLabel newAutoLayoutView];
    }
    return _ssLine12;
}

- (BaseLabel *)ssCell13
{
    if (!_ssCell13) {
        _ssCell13 = [BaseLabel newAutoLayoutView];
        _ssCell13.nameLabel.text = @"债务人信息";
        [_ssCell13.goButton setTitleColor:kBlueColor forState:0];
        [_ssCell13.goButton setTitle:@"完善" forState:0];
        _ssCell13.goButton.titleLabel.font = kSecondFont;
        [_ssCell13.goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

        QDFWeakSelf;
        [_ssCell13.goButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedIndex) {
                weakself.didSelectedIndex(82);
            }
        }];

    }
    return _ssCell13;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
