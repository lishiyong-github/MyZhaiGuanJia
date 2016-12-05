//
//  ProductCloseCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductCloseCell.h"
#import "UIButton+WebCache.h"
#import "ImageModel.h"

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
        
        //分割图片
        [self.topSpaceImaegView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.topSpaceImaegView autoSetDimension:ALDimensionHeight toSize:5];
        
        //number
        [self.codeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.codeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topSpaceImaegView withOffset:kSpacePadding];

        //结清证明
        [self.closeProofButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.closeProofButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.codeLabel];
        [self.closeProofButton autoSetDimensionsToSize:CGSizeMake(75, 30)];

        //产品信息
        [self.productTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft ];
        [self.productTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.codeLabel withOffset:kSpacePadding];
        [self.productTitleLabel autoSetDimension:ALDimensionWidth toSize:kCellHeight3];
        [self.productTitleLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.productTextButton];

        //详细产品信息
        [self.productTextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTitleLabel];
        [self.productTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.productTitleLabel];
        [self.productTextButton autoPinEdgeToSuperviewEdge:ALEdgeRight];

        //查看全部产品信息
        [self.productCheckbutton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.productCheckbutton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTextButton];

        //签约协议
        [self.signTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.productTitleLabel];
        [self.signTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.productTitleLabel];
        [self.signTitleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.productTitleLabel];
        [self.signTitleLabel autoSetDimension:ALDimensionHeight toSize:114];

        //签约协议详情
        [self.signTextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.signTitleLabel];
        [self.signTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.signTitleLabel];

        //查看全部签约协议
        [self.sighCheckButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.signTextButton];
        [self.sighCheckButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];

        //scrollview
        [self.signDetailScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.signTextButton];
        [self.signDetailScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signTextButton withOffset:kBigPadding];
        [self.signDetailScrollView autoSetDimension:ALDimensionHeight toSize:60];
        [self.signDetailScrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        //尽职调查
        [self.investLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.signTitleLabel];
        [self.investLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.signTitleLabel];
        [self.investLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.signTitleLabel];
        [self.investLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.signTitleLabel];
        
        //查看尽职调查
        [self.investCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.investLabel];
        [self.investCheckButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.investLabel];
        [self.investCheckButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.investLabel];
        [self.investCheckButton autoSetDimension:ALDimensionWidth toSize:(kScreenWidth-kBigPadding*2-kCellHeight3*2)/2];
        
        //居间协议
        [self.agreementLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.investCheckButton];
        [self.agreementLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.investCheckButton];
        [self.agreementLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.investLabel];
        [self.agreementLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.investLabel];
        
        //查看居间协议
        [self.agreementCheckButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.agreementLabel];
        [self.agreementCheckButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreementLabel];
        [self.agreementCheckButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.agreementCheckButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.agreementLabel];
        
        [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.productTitleLabel];
        [self.line1 autoSetDimension:ALDimensionHeight toSize:kLineWidth];

        [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.signTitleLabel];
        [self.line2 autoSetDimension:ALDimensionHeight toSize:kLineWidth];

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
    }
    return _codeLabel;
}

- (UIButton *)closeProofButton
{
    if (!_closeProofButton) {
        _closeProofButton = [UIButton newAutoLayoutView];
        _closeProofButton.layer.borderColor = kButtonColor.CGColor;
        _closeProofButton.layer.borderWidth = kLineWidth;
        _closeProofButton.layer.cornerRadius = corner;
        [_closeProofButton setTitle:@"结清证明" forState:0];
        [_closeProofButton setTitleColor:kTextColor forState:0];
        _closeProofButton.titleLabel.font = kFirstFont;
        _closeProofButton.tag = 330;
        
        QDFWeakSelf;
        [_closeProofButton addAction:^(UIButton *btn) {
            if (weakself.didselectedBtn) {
                weakself.didselectedBtn(btn.tag);
            }
        }];
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
    }
    return _productTitleLabel;
}

- (UIButton *)productTextButton
{
    if (!_productTextButton) {
        _productTextButton = [UIButton newAutoLayoutView];
        _productTextButton.titleLabel.numberOfLines = 0;
        _productTextButton.contentHorizontalAlignment = 1;
        _productTextButton.contentEdgeInsets = UIEdgeInsetsMake(kSmallPadding, kSpacePadding, kSmallPadding, 0);
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
        
        _productCheckbutton.tag = 331;
        
        QDFWeakSelf;
        [_productCheckbutton addAction:^(UIButton *btn) {
            if (weakself.didselectedBtn) {
                weakself.didselectedBtn(btn.tag);
            }
        }];
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
        _signDetailScrollView.contentSize = CGSizeMake(80, 60);
        _signDetailScrollView.delegate = self;
        
        for (NSInteger i=0; i<self.signImageArray.count ; i++) {
            UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(70*i, 0, 60, 60)];
            [_signDetailScrollView addSubview:imgButton];
            
            ImageModel *imgModel = self.signImageArray[i];
            NSString *imgString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel.file];
            [imgButton sd_setImageWithURL:[NSURL URLWithString:imgString] forState:0 placeholderImage:nil];
            
            
        }
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
        _sighCheckButton.contentHorizontalAlignment = 1;
        _sighCheckButton.contentEdgeInsets = UIEdgeInsetsMake(kSmallPadding, kSpacePadding, 0, 0);
        
        _sighCheckButton.tag = 332;
        
        QDFWeakSelf;
        [_sighCheckButton addAction:^(UIButton *btn) {
            if (weakself.didselectedBtn) {
                weakself.didselectedBtn(btn.tag);
            }
        }];
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
        
        _investCheckButton.tag = 333;
        
        QDFWeakSelf;
        [_investCheckButton addAction:^(UIButton *btn) {
            if (weakself.didselectedBtn) {
                weakself.didselectedBtn(btn.tag);
            }
        }];
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
        
        _agreementCheckButton.tag = 334;
        
        QDFWeakSelf;
        [_agreementCheckButton addAction:^(UIButton *btn) {
            if (weakself.didselectedBtn) {
                weakself.didselectedBtn(btn.tag);
            }
        }];

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

- (NSMutableArray *)signImageArray
{
    if (!_signImageArray) {
        _signImageArray = [NSMutableArray new];
    }
    return _signImageArray;
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
