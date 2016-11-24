//
//  DealingCloseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DealingCloseViewController.h"

#import "PublishCombineView.h"  //同意结案／拒绝结案

#import "DealEndDeatiResponse.h"
#import "ProductOrdersClosedOrEndApplyModel.h"

@interface DealingCloseViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIView *backWhiteView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *endView;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) PublishCombineView *dealCloseFootView;

//json
@property (nonatomic,strong) NSString *dealReason;

@end

@implementation DealingCloseViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (self.closedid) {
        [self getDetailsOfClosed];
    }else{
        //content
        NSString *aaaa1 = @"合同编号：";
        NSString *aaaa2 = [NSString stringWithFormat:@"%@\n",self.orderModell.product.number];
        NSString *aaaa3 = @"兹委托人【委托金额】：";
        NSString *aaaa4 = self.orderModell.product.accountLabel;
        NSString *aaaa5 = @"万元整【委托费用】";
        NSString *aaaa6 = [NSString stringWithFormat:@"%@",self.orderModell.product.typenumLabel];
        NSString *aaaa7 = [NSString stringWithFormat:@"%@委托事项经友好协商已结清。\n",self.orderModell.product.typeLabel];
        NSString *aaaa8 = @"实际【结案金额】";
        NSString *aaaa9 = @"_____";
        NSString *aaaa10 = @"万元整，【实收佣金】";
        NSString *aaaa11 = @"_____";
        NSString *aaaa12 = @"万元整已支付。\n因本协议履行而产生的任何纠纷，甲乙双方应友好协商解决如协商不成，任何一方均有权向乙方注册地人民法院提起诉讼。";
        
        NSString *aaa = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",aaaa1,aaaa2,aaaa3,aaaa4,aaaa5,aaaa6,aaaa7,aaaa8,aaaa9,aaaa10,aaaa11,aaaa12];
        NSMutableAttributedString *attributeAA = [[NSMutableAttributedString alloc] initWithString:aaa];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, aaaa1.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length, aaaa2.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length, aaaa3.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length, aaaa4.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length, aaaa5.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length, aaaa6.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length, aaaa7.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length, aaaa8.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length, aaaa9.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length, aaaa10.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length+aaaa10.length, aaaa11.length)];
        [attributeAA setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(aaaa1.length+aaaa2.length+aaaa3.length+aaaa4.length+aaaa5.length+aaaa6.length+aaaa7.length+aaaa8.length+aaaa9.length+aaaa10.length+aaaa11.length, aaaa12.length)];
        
        NSMutableParagraphStyle *sisis1 = [[NSMutableParagraphStyle alloc] init];
        [sisis1 setParagraphSpacing:kSmallPadding];
        [sisis1 setLineSpacing:kSpacePadding];
        [sisis1 setFirstLineHeadIndent:kBigPadding];
        [sisis1 setHeadIndent:kBigPadding];
        [attributeAA addAttribute:NSParagraphStyleAttributeName value:sisis1 range:NSMakeRange(0, aaa.length)];
        [self.contentLabel setAttributedText:attributeAA];
        
        //日期
        NSString *eee1 = @"特此证明\n";
        NSString *eee2 = [NSString stringWithFormat:@"%@",[NSDate getYMDFormatterTime:self.orderModell.product.create_at]];
        NSString *eee = [NSString stringWithFormat:@"%@%@",eee1,eee2];
        NSMutableAttributedString *attributeEE = [[NSMutableAttributedString alloc] initWithString:eee];
        [attributeEE setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, eee1.length)];
        [attributeEE setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(eee1.length, eee2.length)];
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        [style1 setLineSpacing:kSpacePadding];
        style1.alignment = NSTextAlignmentCenter;
        [attributeEE addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(0, eee.length)];
        [self.endButton setAttributedTitle:attributeEE forState:0];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.backWhiteView];
    [self.view addSubview:self.dealCloseFootView];
    [self.dealCloseFootView setHidden:YES];
    
//    if ([self.perTypeString integerValue] == 1) {
//        
//    }else if ([self.perTypeString integerValue] == 2){
//        self.title = @"结清证明";
//    }
    
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
        [_backWhiteView addSubview:self.contentLabel];
        [_backWhiteView addSubview:self.endView];
        [_backWhiteView addSubview:self.endButton];
        
        [titleButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backWhiteView];
        [titleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [titleButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [titleButton autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [self.contentLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleButton];
        
        [self.endView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel];
        [self.endView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backWhiteView];
        [self.endView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_backWhiteView];
        [self.endView autoSetDimension:ALDimensionHeight toSize:100];
        
        [self.endButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.endView withOffset:-kBigPadding];
        [self.endButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.endView withOffset:kBigPadding];
    }
    return _backWhiteView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.backgroundColor = kWhiteColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)endView
{
    if (!_endView) {
        _endView = [UIView newAutoLayoutView];
        _endView.backgroundColor = kWhiteColor;
    }
    return _endView;
}

- (UIButton *)endButton
{
    if (!_endButton) {
        _endButton = [UIButton newAutoLayoutView];
        _endButton.titleLabel.font = kSecondFont;
        _endButton.titleLabel.numberOfLines = 0;
        [_endButton setBackgroundImage:[UIImage imageNamed:@"chapter"] forState:0];
    }
    return _endButton;
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
            [weakself showAlertOfProductDealWithType:@"1"];
        }];
        [_dealCloseFootView.comButton2 addAction:^(UIButton *btn) {
            [weakself showAlertOfProductDealWithType:@"2"];
        }];
    }
    return _dealCloseFootView;
}

#pragma mark - menthod
- (void)getDetailsOfClosed
{
    NSString *closeDetailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfDealClosedDetails];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"closedid" : self.closedid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:closeDetailString params:params successBlock:^(id responseObject) {
        
        NSDictionary *apaap = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        DealEndDeatiResponse *response = [DealEndDeatiResponse objectWithKeyValues:responseObject];
        
        if ([response.code isEqualToString:@"0000"]) {
            
            [weakself.view addSubview:weakself.backWhiteView];
            
            ProductOrdersClosedOrEndApplyModel *closeModel = response.data;
            
            //content
            NSString *aaaa1 = @"合同编号：";
            NSString *aaaa2 = [NSString stringWithFormat:@"%@\n",closeModel.number];
            NSString *aaaa3 = @"兹委托人【委托金额】：";
            NSString *aaaa4 = closeModel.accountLabel;
            NSString *aaaa5 = @"万元整【委托费用】";
            NSString *aaaa6 = [NSString stringWithFormat:@"%@",closeModel.typenumLabel];
            NSString *aaaa7 = [NSString stringWithFormat:@"%@委托事项经友好协商已结清。\n",closeModel.typeLabel];
            NSString *aaaa8 = @"实际【结案金额】";
            NSString *aaaa9 = closeModel.priceLabel;
            NSString *aaaa10 = @"万元整，【实收佣金】";
            NSString *aaaa11 = closeModel.price2Label;
            NSString *aaaa12 = @"万元整已支付。\n因本协议履行而产生的任何纠纷，甲乙双方应友好协商解决如协商不成，任何一方均有权向乙方注册地人民法院提起诉讼。";

            NSString *aaa = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",aaaa1,aaaa2,aaaa3,aaaa4,aaaa5,aaaa6,aaaa7,aaaa8,aaaa9,aaaa10,aaaa11,aaaa12];
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
            
            NSMutableParagraphStyle *sisis1 = [[NSMutableParagraphStyle alloc] init];
            [sisis1 setParagraphSpacing:kSmallPadding];
            [sisis1 setLineSpacing:kSpacePadding];
            [sisis1 setFirstLineHeadIndent:kBigPadding];
            [sisis1 setHeadIndent:kBigPadding];
            [attributeAA addAttribute:NSParagraphStyleAttributeName value:sisis1 range:NSMakeRange(0, aaa.length)];
            [weakself.contentLabel setAttributedText:attributeAA];
            
            //日期
            NSString *eee1 = @"特此证明\n";
            NSString *eee2 = [NSString stringWithFormat:@"%@",[NSDate getYMDFormatterTime:closeModel.create_at]];
            NSString *eee = [NSString stringWithFormat:@"%@%@",eee1,eee2];
            NSMutableAttributedString *attributeEE = [[NSMutableAttributedString alloc] initWithString:eee];
            [attributeEE setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, eee1.length)];
            [attributeEE setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(eee1.length, eee2.length)];
            NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
            [style1 setLineSpacing:kSpacePadding];
            style1.alignment = NSTextAlignmentCenter;
            [attributeEE addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(0, eee.length)];
            [weakself.endButton setAttributedTitle:attributeEE forState:0];
            
            if ([response.accessTerminationAUTH integerValue] == 0) {
                self.title = @"处理结案申请";
                weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
                [weakself.rightButton setTitle:@"平台介入" forState:0];
                
                [weakself.dealCloseFootView setHidden:NO];
                
            }else{
                self.title = @"结清证明";
                [weakself.rightButton removeFromSuperview];
                [weakself.dealCloseFootView setHidden:YES];
            }
            
        }else{
            [weakself showHint:response.msg];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
- (void)rightItemAction
{
    [self showHint:@"平台介入"];
    NSMutableString *tel = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

- (void)showAlertOfProductDealWithType:(NSString *)type
{
    NSString *message;
    if ([type integerValue] == 1) {
        message = @"同意结案？";
    }else{
        message = @"拒绝结案？";
    }
    
    UIAlertController *dealAlert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [dealAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入原因";
    }];
    
    UIAlertAction *dealAct0 = [UIAlertAction actionWithTitle:@"放弃" style:0 handler:nil];
    
    QDFWeakSelf;
    UIAlertAction *dealAct1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself actionOfProductDealWithType:type];
    }];
    [dealAlert addAction:dealAct0];
    [dealAlert addAction:dealAct1];
    
    [self presentViewController:dealAlert animated:YES completion:nil];
}

- (void)actionOfProductDealWithType:(NSString *)type
{
    [self.view endEditing:YES];
    
    NSString *dealString;
    if ([type integerValue] == 1) {
        dealString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfDealCloseDetailsAgree];
    }else{
        dealString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfDealCloseDetailsVote];
    }
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"resultmemo" : self.dealReason,
                             @"closedid" : self.closedid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:dealString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.dealReason = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
