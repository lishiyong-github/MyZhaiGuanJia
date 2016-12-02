//
//  DealingEndViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DealingEndViewController.h"

#import "PublishCombineView.h"  //同意终止／拒绝终止

#import "DealEndDeatiResponse.h"
#import "ProductOrdersClosedOrEndApplyModel.h"  //终止原因
#import "ImageModel.h"

#import "UIButton+WebCache.h"

@interface DealingEndViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIView *dealEndWhiteView;
@property (nonatomic,strong) UILabel *textLabel;  //申请原因
@property (nonatomic,strong) UIView *reasonView;  //图片背景
@property (nonatomic,strong) UIButton *reasonImageButton1;
@property (nonatomic,strong) UIButton *reasonImageButton2;



@property (nonatomic,strong) UIButton *reasonTextButton;  //申请原因

@property (nonatomic,strong) PublishCombineView *dealEndFootView;

@property (nonatomic,strong) NSString *reason;

@end

@implementation DealingEndViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailsOfDealEnding];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理终止";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.reasonTextButton];
    [self.view addSubview:self.reasonImageButton1];
    [self.reasonImageButton1 setHidden:YES];
    [self.view addSubview:self.reasonImageButton2];
    [self.reasonImageButton2 setHidden:YES];
    [self.view addSubview:self.dealEndFootView];
    [self.dealEndFootView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reasonTextButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.reasonTextButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.reasonTextButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        NSArray *views = @[self.reasonImageButton1,self.reasonImageButton2];
        [views autoSetViewsDimensionsToSize:CGSizeMake(50+kBigPadding, 50+kBigPadding)];
        
        [self.reasonImageButton1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.reasonTextButton];
        [self.reasonImageButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.reasonImageButton2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.reasonImageButton1];
        [self.reasonImageButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.reasonImageButton1];
        
        [self.dealEndFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dealEndFootView autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)reasonTextButton
{
    if (!_reasonTextButton) {
        _reasonTextButton = [UIButton newAutoLayoutView];
        _reasonTextButton.backgroundColor = kWhiteColor;
        _reasonTextButton.titleLabel.numberOfLines = 0;
        _reasonTextButton.contentHorizontalAlignment = 1;
        [_reasonTextButton setContentEdgeInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, kBigPadding)];
    }
    return _reasonTextButton;
}

- (UIButton *)reasonImageButton1
{
    if (!_reasonImageButton1) {
        _reasonImageButton1 = [UIButton newAutoLayoutView];
        _reasonImageButton1.backgroundColor = kWhiteColor;
        [_reasonImageButton1 setImageEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, kBigPadding, 0)];
    }
    return _reasonImageButton1;
}

- (UIButton *)reasonImageButton2
{
    if (!_reasonImageButton2) {
        _reasonImageButton2 = [UIButton newAutoLayoutView];
        _reasonImageButton2.backgroundColor = kWhiteColor;
        [_reasonImageButton2 setImageEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, kBigPadding, 0)];
    }
    return _reasonImageButton2;
}

- (PublishCombineView *)dealEndFootView
{
    if (!_dealEndFootView) {
        _dealEndFootView = [PublishCombineView newAutoLayoutView];
        [_dealEndFootView.comButton1 setTitle:@"同意终止" forState:0];
        [_dealEndFootView.comButton1 setBackgroundColor:kButtonColor];
        
        [_dealEndFootView.comButton2 setTitle:@"拒绝终止" forState:0];
        [_dealEndFootView.comButton2 setTitleColor:kLightGrayColor forState:0];
        _dealEndFootView.comButton2.layer.borderColor = kBorderColor.CGColor;
        _dealEndFootView.comButton2.layer.borderWidth = kLineWidth;
        
        QDFWeakSelf;
        [_dealEndFootView setDidSelectedBtn:^(NSInteger tag) {
            if (tag == 111) {
                [weakself showAlertWithActType:@"1"];
            }else{
                [weakself showAlertWithActType:@"2"];
            }
        }];
    }
    return _dealEndFootView;
}

#pragma mark - method
- (void)getDetailsOfDealEnding
{
    NSString *endndDetailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfDealEndDetails];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"terminationid" : self.terminationid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:endndDetailString params:params successBlock:^(id responseObject) {
                
        DealEndDeatiResponse *respinde = [DealEndDeatiResponse objectWithKeyValues:responseObject];
        
        NSString *lll1 = [NSString stringWithFormat:@"申请事项：%@\n",respinde.dataLabel];
        NSString *lll2 = [NSString stringWithFormat:@"申请时间：%@\n",[NSDate getYMDhmFormatterTime:respinde.data.create_at]];
        NSString *lll3 = [NSString stringWithFormat:@"申请终止原因：%@",respinde.data.applymemo];
        NSString *lll4 = [NSString stringWithFormat:@"\n拒绝终止原因：%@",respinde.data.resultmemo];
        NSString *lll;
        if ([respinde.data.status integerValue] == 0) {
            lll = [NSString stringWithFormat:@"%@%@%@",lll1,lll2,lll3];
        }else{
            lll = [NSString stringWithFormat:@"%@%@%@%@",lll1,lll2,lll3,lll4];
        }
        NSMutableAttributedString *attributeLL = [[NSMutableAttributedString alloc] initWithString:lll];
        [attributeLL setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, lll.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setParagraphSpacing:kSpacePadding];
        [attributeLL addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lll.length)];
        [weakself.reasonTextButton setAttributedTitle:attributeLL forState:0];
        
        //图片
        if (respinde.data.filesImg.count > 0) {
            [weakself.reasonImageButton1 setHidden:NO];
            if (respinde.data.filesImg.count == 1) {
                
                ImageModel *imgModel1 = respinde.data.filesImg[0];
                [weakself.reasonImageButton1 sd_setImageWithURL:[NSURL URLWithString:imgModel1.file] forState:0 placeholderImage:nil];
            }else{
                [weakself.reasonImageButton2 setHidden:NO];
                
                ImageModel *imgModel1 = respinde.data.filesImg[0];
                [weakself.reasonImageButton1 sd_setImageWithURL:[NSURL URLWithString:imgModel1.file] forState:0 placeholderImage:nil];
                
                ImageModel *imgModel2 = respinde.data.filesImg[1];
                [weakself.reasonImageButton2 sd_setImageWithURL:[NSURL URLWithString:imgModel2.file] forState:0 placeholderImage:nil];
            }
            
        }
        
        //权限
        if ([respinde.accessTerminationAUTH integerValue] == 1 && [respinde.data.status integerValue] == 0 && ![respinde.data.create_by isEqualToString:respinde.userid]) {//能操作
            [weakself.dealEndFootView setHidden:NO];
            weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
            [weakself.rightButton setTitle:@"平台介入" forState:0];
        }else{
            [weakself.dealEndFootView setHidden:YES];
            [weakself.rightButton removeFromSuperview];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)showAlertWithActType:(NSString *)actType //1-同意，2-拒绝
{
    NSString *endTitle;
    NSString *endPlaceholder;
    if ([actType integerValue] == 1) {//同意
        endTitle = @"是否同意终止";
        endPlaceholder = @"请说明同意终止的原因";
    }else{
        endTitle = @"是否拒绝终止";
        endPlaceholder = @"请说明拒绝终止的原因";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:endTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = endPlaceholder;
        textField.delegate = weakself;
    }];
    
    UIAlertAction *endAct1 = [UIAlertAction actionWithTitle:@"否" style:0 handler:nil];
    
    UIAlertAction *endAct2 = [UIAlertAction actionWithTitle:@"是" style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself actionOfDealEndingWithActType:actType];
    }];
    
    [alertController addAction:endAct1];
    [alertController addAction:endAct2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)actionOfDealEndingWithActType:(NSString *)actType
{
    [self.view endEditing:YES];
    NSString *dealEndingString;
    if ([actType integerValue] == 1) {//同意
        dealEndingString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfDealEndDetailsAgree];
    }else{//拒绝
        dealEndingString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfDealEndDetailsVote];
    }

    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"resultmemo" : self.reason,
                             @"terminationid" : self.terminationid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:dealEndingString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];

        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"80120900"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.reason = textField.text;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
