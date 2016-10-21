//
//  DealingCloseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DealingCloseViewController.h"
#import "PublishCombineView.h"  //同意结案／拒绝结案

@interface DealingCloseViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
//@property (nonatomic,strong) UIButton *dealCloseRightButton;
@property (nonatomic,strong) UIView *backWhiteView;
@property (nonatomic,strong) PublishCombineView *dealCloseFootView;

@end

@implementation DealingCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.backWhiteView];
    
    if ([self.perTypeString integerValue] == 1) {
        self.title = @"处理结案申请";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        [self.rightButton setTitle:@"平台介入" forState:0];
        
        [self.view addSubview:self.dealCloseFootView];
        
    }else if ([self.perTypeString integerValue] == 2){
        self.title = @"示例证明";
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.perTypeString integerValue] == 1) {
            [self.backWhiteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, 0, 0, 0) excludingEdge:ALEdgeBottom];
            [self.backWhiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.dealCloseFootView];
            
            [self.dealCloseFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.dealCloseFootView autoSetDimension:ALDimensionHeight toSize:116];
        }else if ([self.perTypeString integerValue] == 2){
            [self.backWhiteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, 0, 0, 0)];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

//- (UIButton *)dealCloseRightButton
//{
//    if (!_dealCloseRightButton) {
//        _dealCloseRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//        [_dealCloseRightButton setTitleColor:kWhiteColor forState:0];
//        [_dealCloseRightButton setTitle:@"平台介入" forState:0];
//        _dealCloseRightButton.titleLabel.font = kFirstFont;
//        
//        [_dealCloseRightButton addAction:^(UIButton *btn) {
//            NSMutableString *tel = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
//        }];
//    }
//    return _dealCloseRightButton;
//}

- (UIView *)backWhiteView
{
    if (!_backWhiteView) {
        _backWhiteView = [UIView newAutoLayoutView];
        _backWhiteView.backgroundColor = kBackColor;
        
        UIButton *titleButton = [UIButton newAutoLayoutView];
        titleButton.backgroundColor = kWhiteColor;
        [titleButton setTitle:@"结清证明" forState:0];
        [titleButton setTitleColor:kBlackColor forState:0];
        titleButton.titleLabel.font = kBoldFont(16);
        [_backWhiteView addSubview:titleButton];
        
        UILabel *contentLabel = [UILabel newAutoLayoutView];
        contentLabel.backgroundColor = kWhiteColor;
        contentLabel.numberOfLines = 0;
        [_backWhiteView addSubview:contentLabel];
        
        NSString *aaaa1 = @"合同编号：";
        NSString *aaaa2 = @"20160908005\n";
        NSString *aaaa3 = @"兹委托人【委托金额】：";
        NSString *aaaa4 = @"2000";
        NSString *aaaa5 = @"万元整【委托费用】";
        NSString *aaaa6 = @"1000";
        NSString *aaaa7 = @"万元整委托事项经友好协商已结清。\n";
        NSString *aaaa8 = @"实际【结案金额】";
        NSString *aaaa9 = @"1500";
        NSString *aaaa10 = @"万元整，【实收佣金】";
        NSString *aaaa11 = @"10";
        NSString *aaaa12 = @"万元整已支付。\n";
        NSString *aaaa13 = @"因本协议履行而产生的任何纠纷，甲乙双方应友好协商解决如协商不成，任何一方均有权向乙方注册地人民法院提起诉讼。";
        NSString *aaa = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",aaaa1,aaaa2,aaaa3,aaaa4,aaaa5,aaaa6,aaaa7,aaaa8,aaaa9,aaaa10,aaaa11,aaaa12,aaaa13];
        NSMutableAttributedString *attributeAA = [[NSMutableAttributedString alloc] initWithString:aaa];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, aaaa1.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length, aaaa2.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length, aaaa3.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length, aaaa4.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length, aaaa5.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length, aaaa6.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length, aaaa7.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length, aaaa8.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length, aaaa9.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length, aaaa10.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length+aaaa10.length, aaaa11.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length+aaaa10.length+aaaa11.length, aaaa12.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length+aaaa10.length+aaaa11.length+aaaa12.length, aaaa13.length)];
        
        NSMutableParagraphStyle *sisis1 = [[NSMutableParagraphStyle alloc] init];
        [sisis1 setParagraphSpacing:kSmallPadding];
        [sisis1 setLineSpacing:kSpacePadding];
        [sisis1 setFirstLineHeadIndent:kBigPadding];
        [sisis1 setHeadIndent:kBigPadding];
        [attributeAA addAttribute:NSParagraphStyleAttributeName value:sisis1 range:NSMakeRange(0, aaa.length)];
        [contentLabel setAttributedText:attributeAA];
        
        UIView *endView = [UIView newAutoLayoutView];
        endView.backgroundColor = kWhiteColor;
        [_backWhiteView addSubview:endView];
        UIButton *endButton = [UIButton newAutoLayoutView];
        endButton.titleLabel.font = kSecondFont;
        endButton.titleLabel.numberOfLines = 0;
        [endButton setBackgroundImage:[UIImage imageNamed:@"chapter"] forState:0];
        [endView addSubview:endButton];
        
        NSString *eee1 = @"2016-09-28\n";
        NSString *eee2 = @"特此证明";
        NSString *eee = [NSString stringWithFormat:@"%@%@",eee1,eee2];
        NSMutableAttributedString *attributeEE = [[NSMutableAttributedString alloc] initWithString:eee];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, eee1.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(eee1.length, eee2.length)];
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        [style1 setLineSpacing:kSpacePadding];
        style1.alignment = NSTextAlignmentCenter;
        [attributeEE addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(0, eee.length)];
        
        [endButton setAttributedTitle:attributeEE forState:0];
        [_backWhiteView addSubview:endButton];
        
        [titleButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backWhiteView];
        [titleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [titleButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [titleButton autoSetDimension:ALDimensionHeight toSize:40];
        
        [contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [contentLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleButton];
        
        [endView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentLabel];
        [endView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [endView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [endView autoSetDimension:ALDimensionHeight toSize:100];
        
        [endButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:endView withOffset:-kBigPadding];
        [endButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:endView withOffset:kBigPadding];
    }
    return _backWhiteView;
}

- (PublishCombineView *)dealCloseFootView
{
    if (!_dealCloseFootView) {
        _dealCloseFootView = [PublishCombineView newAutoLayoutView];
        [_dealCloseFootView.comButton1 setTitle:@"同意结案" forState:0];
        [_dealCloseFootView.comButton1 setBackgroundColor:kButtonColor];
        
        [_dealCloseFootView.comButton2 setTitle:@"拒绝结案" forState:0];
        [_dealCloseFootView.comButton2 setTitleColor:kLightGrayColor forState:0];
        _dealCloseFootView.comButton2.layer.borderColor = kBorderColor.CGColor;
        _dealCloseFootView.comButton2.layer.borderWidth = kLineWidth;
        
        QDFWeakSelf;
        [_dealCloseFootView.comButton1 addAction:^(UIButton *btn) {
            [weakself showHint:@"同意结案"];
        }];
        [_dealCloseFootView.comButton2 addAction:^(UIButton *btn) {
            [weakself back];
        }];
    }
    return _dealCloseFootView;
}

#pragma mark - menthod
- (void)rightItemAction
{
    [self showHint:@"平台介入"];
    NSMutableString *tel = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sCloseer:(id)sCloseer {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
