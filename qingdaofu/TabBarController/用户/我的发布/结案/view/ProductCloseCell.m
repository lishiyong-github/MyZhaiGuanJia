//
//  ProductCloseCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductCloseCell.h"

@implementation ProductCloseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, kBigPadding, 0, kBigPadding)];
        self.contentView.backgroundColor = kWhiteColor;
        
        [self.contentView addSubview:self.topSpaceImaegView];
        [self.contentView addSubview:self.codeLabel];
        [self.contentView addSubview:self.closeProofButton];
        [self.contentView addSubview:self.productTitleLabel];
        [self.contentView addSubview:self.productTextButton];
        [self.contentView addSubview:self.productCheckbutton];
        [self.contentView addSubview:self.signTitleLabel];
        [self.contentView addSubview:self.signTextButton];
        [self.contentView addSubview:self.sighCheckButton];
        [self.contentView addSubview:self.signDetailScrollView];
        [self.contentView addSubview:self.investLabel];
        [self.contentView addSubview:self.investCheckButton];
        [self.contentView addSubview:self.agreementLabel];
        [self.contentView addSubview:self.agreementCheckButton];
        
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];
        [self.contentView addSubview:self.line4];
        [self.contentView addSubview:self.line5];
        [self.contentView addSubview:self.line6];

        [self setNeedsUpdateConstraints];

    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.topSpaceImaegView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.topSpaceImaegView autoSetDimension:ALDimensionHeight toSize:5];
        
        [self.codeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.codeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topSpaceImaegView withOffset:kSpacePadding];
//
        [self.closeProofButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.closeProofButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.codeLabel];
        [self.closeProofButton autoSetDimensionsToSize:CGSizeMake(75, 30)];

        [self.productTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft ];
        [self.productTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.codeLabel withOffset:kSpacePadding];
        [self.productTitleLabel autoSetDimension:ALDimensionWidth toSize:kCellHeight3];
        [self.productTitleLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.productTextButton];

        [self.productTextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTitleLabel];
        [self.productTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.productTitleLabel];
        [self.productTextButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
//
        [self.productCheckbutton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.productCheckbutton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTextButton];
//
        [self.signTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.productTitleLabel];
        [self.signTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.productTitleLabel];
        [self.signTitleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.productTitleLabel];
        [self.signTitleLabel autoSetDimension:ALDimensionHeight toSize:114];

        [self.signTextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.signTitleLabel];
        [self.signTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.signTitleLabel];

        [self.sighCheckButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.signTextButton];
        [self.sighCheckButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];

        [self.signDetailScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.signTextButton];
        [self.signDetailScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signTextButton withOffset:kBigPadding];
        [self.signDetailScrollView autoSetDimension:ALDimensionHeight toSize:60];
        [self.signDetailScrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.investLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.signTitleLabel];
        [self.investLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signTitleLabel];
        [self.investLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.signTitleLabel];
        [self.investLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.signTitleLabel];
        
        [self.investCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.investLabel];
        [self.investCheckButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.investLabel];
        [self.investCheckButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.investLabel];
        [self.investCheckButton autoSetDimension:ALDimensionWidth toSize:(kScreenWidth-kBigPadding*2-kCellHeight3*2)/2];
        
        [self.agreementLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.investCheckButton];
        [self.agreementLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.investCheckButton];
        [self.agreementLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.investLabel];
        [self.agreementLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.investLabel];
        
        [self.agreementCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.agreementLabel];
        [self.agreementCheckButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreementLabel];
        [self.agreementCheckButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.agreementCheckButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.agreementLabel];
        
        [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTitleLabel];
        [self.line1 autoSetDimension:ALDimensionHeight toSize:kLineWidth];
//
        [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.signTitleLabel];
        [self.line2 autoSetDimension:ALDimensionHeight toSize:kLineWidth];
//
        [self.line3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.line3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.investLabel];
        [self.line3 autoSetDimension:ALDimensionHeight toSize:kLineWidth];

        [self.line4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line1];
        [self.line4 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.investLabel];
        [self.line4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.productTitleLabel];
        [self.line4 autoSetDimension:ALDimensionWidth toSize:kLineWidth];

        [self.line5 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.line3];
        [self.line5 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.investCheckButton];
        [self.line5 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.line4];
        [self.line5 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        [self.line6 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.line5];
        [self.line6 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreementLabel];
        [self.line6 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.line5];
        [self.line6 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)topSpaceImaegView
{
    if (!_topSpaceImaegView) {
        _topSpaceImaegView = [UIImageView newAutoLayoutView];
        _topSpaceImaegView.backgroundColor = kRedColor;
    }
    return _topSpaceImaegView;
}

- (UILabel *)codeLabel
{
    if (!_codeLabel) {
        _codeLabel = [UILabel newAutoLayoutView];
        _codeLabel.numberOfLines = 0;
        
        NSString *code1 = @"BX201609280001\n";
        NSString *code2 = @"订单已结案";
        NSString *codeStr = [NSString stringWithFormat:@"%@%@",code1,code2];
        NSMutableAttributedString *attributeCC = [[NSMutableAttributedString alloc] initWithString:codeStr];
        [attributeCC setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, code1.length)];
        [attributeCC setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(code1.length, code2.length)];
        NSMutableParagraphStyle *stylerr = [[NSMutableParagraphStyle alloc] init];
        [stylerr setLineSpacing:kSpacePadding];
        [attributeCC addAttribute:NSParagraphStyleAttributeName value:stylerr range:NSMakeRange(0, codeStr.length)];

        [_codeLabel setAttributedText:attributeCC];
    }
    return _codeLabel;
}

- (UIButton *)closeProofButton
{
    if (!_closeProofButton) {
        _closeProofButton = [UIButton newAutoLayoutView];
//        _closeProofButton.layer.borderColor = kButtonColor.CGColor;
//        _closeProofButton.layer.borderWidth = kLineWidth;
        _closeProofButton.layer.cornerRadius = corner;
        [_closeProofButton setTitle:@"结清证明" forState:0];
        [_closeProofButton setTitleColor:kTextColor forState:0];
        _closeProofButton.titleLabel.font = kFirstFont;
    }
    return _closeProofButton;
}

- (UILabel *)productTitleLabel
{
    if (!_productTitleLabel) {
        _productTitleLabel = [UILabel newAutoLayoutView];
        _productTitleLabel.text = @"产\n品\n信\n息";
        _productTitleLabel.textColor = kGrayColor;
        _productTitleLabel.font = kBigFont;
        _productTitleLabel.numberOfLines = 0;
        _productTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _productTitleLabel.layer.borderColor = kBorderColor.CGColor;
//        _productTitleLabel.layer.borderWidth = kLineWidth;
    }
    return _productTitleLabel;
}

- (UIButton *)productTextButton
{
    if (!_productTextButton) {
        _productTextButton = [UIButton newAutoLayoutView];
//        _productTextButton.layer.borderWidth = kLineWidth;
//        _productTextButton.layer.borderColor = kBorderColor.CGColor;
        _productTextButton.titleLabel.numberOfLines = 0;
        _productTextButton.contentHorizontalAlignment = 1;
        _productTextButton.contentEdgeInsets = UIEdgeInsetsMake(kSmallPadding, kSpacePadding, kSmallPadding, 0);

        NSString *proText1 = @"产品信息\n";
        NSString *proText2 = @"债权类型：房产抵押、机动车抵押\n";
        NSString *proText3 = @"固定费用：20万\n";
        NSString *proText4 = @"委托金额：1000万";

        NSString *proTextStr = [NSString stringWithFormat:@"%@%@%@%@",proText1,proText2,proText3,proText4];
        NSMutableAttributedString *attributePP = [[NSMutableAttributedString alloc] initWithString:proTextStr];
        [attributePP setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, proText1.length)];
        [attributePP setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(proText1.length, proText2.length+proText3.length+proText4.length)];
        NSMutableParagraphStyle *stylerr = [[NSMutableParagraphStyle alloc] init];
        [stylerr setLineSpacing:8];
        stylerr.alignment = NSTextAlignmentLeft;
        [attributePP addAttribute:NSParagraphStyleAttributeName value:stylerr range:NSMakeRange(0, proTextStr.length)];
        [_productTextButton setAttributedTitle:attributePP forState:0];
    }
    return _productTextButton;
}

- (UIButton *)productCheckbutton
{
    if (!_productCheckbutton) {
        _productCheckbutton = [UIButton newAutoLayoutView];
        [_productCheckbutton setTitleColor:kTextColor forState:0];
        [_productCheckbutton setTitle:@"查看全部" forState:0];
        _productCheckbutton.titleLabel.font = kFirstFont;
        
//        QDFWeakSelf;
//        [_productCheckbutton addAction:^(UIButton *btn) {
//        }];
    }
    return _productCheckbutton;
}

- (UILabel *)signTitleLabel
{
    if (!_signTitleLabel) {
        _signTitleLabel = [UILabel newAutoLayoutView];
        _signTitleLabel.text = @"签\n约\n协\n议";
        _signTitleLabel.textColor = kGrayColor;
        _signTitleLabel.font = kBigFont;
        _signTitleLabel.numberOfLines = 0;
        _signTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _signTitleLabel.layer.borderColor = kBorderColor.CGColor;
//        _signTitleLabel.layer.borderWidth = kLineWidth;
    }
    return _signTitleLabel;
}

- (UIButton *)signTextButton
{
    if (!_signTextButton) {
        _signTextButton = [UIButton newAutoLayoutView];
        [_signTextButton setTitleColor:kGrayColor forState:0];
        [_signTextButton setTitle:@"签约协议详情" forState:0];
        _signTextButton.titleLabel.font = kFirstFont;
        _signTextButton.contentHorizontalAlignment = 1;
        _signTextButton.contentEdgeInsets = UIEdgeInsetsMake(kSmallPadding, kSpacePadding, 0, 0);
    }
    return _signTextButton;
}

- (UIScrollView *)signDetailScrollView
{
    if (!_signDetailScrollView) {
        _signDetailScrollView = [UIScrollView newAutoLayoutView];
        _signDetailScrollView.backgroundColor = kYellowColor;
        _signDetailScrollView.contentSize = CGSizeMake(80, 60);
        _signDetailScrollView.delegate = self;
    }
    return _signDetailScrollView;
}

- (UIButton *)sighCheckButton
{
    if (!_sighCheckButton) {
        _sighCheckButton = [UIButton newAutoLayoutView];
        [_sighCheckButton setTitleColor:kTextColor forState:0];
        [_sighCheckButton setTitle:@"查看全部" forState:0];
        _sighCheckButton.titleLabel.font = kFirstFont;
    }
    return _sighCheckButton;
}

- (UILabel *)investLabel
{
    if (!_investLabel) {
        _investLabel = [UILabel newAutoLayoutView];
        _investLabel.text = @"尽\n职\n调\n查";
        _investLabel.textColor = kGrayColor;
        _investLabel.font = kBigFont;
        _investLabel.numberOfLines = 0;
        _investLabel.textAlignment = NSTextAlignmentCenter;
//        _investLabel.layer.borderColor = kBorderColor.CGColor;
//        _investLabel.layer.borderWidth = kLineWidth;
    }
    return _investLabel;
}

- (UIButton *)investCheckButton
{
    if (!_investCheckButton) {
        _investCheckButton = [UIButton newAutoLayoutView];
        [_investCheckButton setTitleColor:kTextColor forState:0];
        [_investCheckButton setTitle:@"查看详情" forState:0];
        _investCheckButton.titleLabel.font = kFirstFont;
//        _investCheckButton.layer.borderColor = kBorderColor.CGColor;
//        _investCheckButton.layer.borderWidth = kLineWidth;
    }
    return _investCheckButton;
}

- (UILabel *)agreementLabel
{
    if (!_agreementLabel) {
        _agreementLabel = [UILabel newAutoLayoutView];
        _agreementLabel.text = @"居\n间\n协\n议";
        _agreementLabel.textColor = kGrayColor;
        _agreementLabel.font = kBigFont;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.textAlignment = NSTextAlignmentCenter;
//        _agreementLabel.layer.borderColor = kBorderColor.CGColor;
//        _agreementLabel.layer.borderWidth = kLineWidth;
    }
    return _agreementLabel;
}

- (UIButton *)agreementCheckButton
{
    if (!_agreementCheckButton) {
        _agreementCheckButton = [UIButton newAutoLayoutView];
        [_agreementCheckButton setTitleColor:kTextColor forState:0];
        [_agreementCheckButton setTitle:@"查看详情" forState:0];
        _agreementCheckButton.titleLabel.font = kFirstFont;
//        _agreementCheckButton.layer.borderColor = kBorderColor.CGColor;
//        _agreementCheckButton.layer.borderWidth = kLineWidth;
    }
    return _agreementCheckButton;
}

- (UILabel *)line1
{
    if (!_line1) {
        _line1 = [UILabel newAutoLayoutView];
        _line1.backgroundColor = kBorderColor;
    }
    return _line1;
}
- (UILabel *)line2
{
    if (!_line2) {
        _line2 = [UILabel newAutoLayoutView];
        _line2.backgroundColor = kBorderColor;
    }
    return _line2;
}
- (UILabel *)line3
{
    if (!_line3) {
        _line3 = [UILabel newAutoLayoutView];
        _line3.backgroundColor = kBorderColor;
    }
    return _line3;
}
- (UILabel *)line4
{
    if (!_line4) {
        _line4 = [UILabel newAutoLayoutView];
        _line4.backgroundColor = kBorderColor;
    }
    return _line4;
}
- (UILabel *)line5
{
    if (!_line5) {
        _line5 = [UILabel newAutoLayoutView];
        _line5.backgroundColor = kBorderColor;
    }
    return _line5;
}
- (UILabel *)line6
{
    if (!_line6) {
        _line6 = [UILabel newAutoLayoutView];
        _line6.backgroundColor = kBorderColor;
    }
    return _line6;
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
