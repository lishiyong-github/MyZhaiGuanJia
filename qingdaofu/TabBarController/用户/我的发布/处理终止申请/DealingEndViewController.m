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

@interface DealingEndViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIView *dealEndWhiteView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) PublishCombineView *dealEndFootView;

@property (nonatomic,strong) NSMutableArray *dealEndDataArray;
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
    
    [self.view addSubview:self.dealEndWhiteView];
    [self.view addSubview:self.dealEndFootView];
    [self.dealEndFootView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.dealEndWhiteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, 0, 0, 0) excludingEdge:ALEdgeBottom];
        [self.dealEndWhiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.dealEndFootView];
        
        [self.dealEndFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dealEndFootView autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIView *)dealEndWhiteView
{
    if (!_dealEndWhiteView) {
        _dealEndWhiteView = [UIView newAutoLayoutView];
        _dealEndWhiteView.backgroundColor = kBackColor;
        
        [_dealEndWhiteView addSubview:self.textLabel];
        
        UIView *imageView = [UIView newAutoLayoutView];
        imageView.backgroundColor = kWhiteColor;
        [_dealEndWhiteView addSubview:imageView];
        
        UIButton *imageButton1 = [UIButton newAutoLayoutView];
        imageButton1.backgroundColor = kGrayColor;
        [imageView addSubview:imageButton1];
        
        [self.textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_dealEndWhiteView];
        [self.textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_dealEndWhiteView];
        [self.textLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dealEndWhiteView];
        
        [imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_dealEndWhiteView];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dealEndWhiteView];
        [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textLabel];
        [imageView autoSetDimension:ALDimensionHeight toSize:80];
        
        [imageButton1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView withOffset:kBigPadding];
        [imageButton1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView withOffset:kBigPadding];
        [imageButton1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
    }
    return _dealEndWhiteView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel newAutoLayoutView];
        _textLabel.backgroundColor = kWhiteColor;
        _textLabel.numberOfLines = 0;
//        NSString *lll1 = [NSString stringWithFormat:@"申请事项：接单方申请终止\n"];
//        NSString *lll2 = [NSString stringWithFormat:@"申请时间：2016-09-28 17:09\n"];
//        NSString *lll3 = [NSString stringWithFormat:@"终止原因：%@",@"不看不好不"];
//        NSString *lll = [NSString stringWithFormat:@"%@%@%@",lll1,lll2,lll3];
//        NSMutableAttributedString *attributeLL = [[NSMutableAttributedString alloc] initWithString:lll];
//        [attributeLL setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, lll.length)];
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineSpacing:kSpacePadding];
//        [style setParagraphSpacing:kSpacePadding];
//        [style setFirstLineHeadIndent:kBigPadding];
//        [style setHeadIndent:kBigPadding];
//        [attributeLL addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lll.length)];
//        [_textLabel setAttributedText:attributeLL];
    }
    return _textLabel;
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

- (NSMutableArray *)dealEndDataArray
{
    if (!_dealEndDataArray) {
        _dealEndDataArray = [NSMutableArray array];
    }
    return _dealEndDataArray;
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
        
        NSDictionary *sososo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        DealEndDeatiResponse *respinde = [DealEndDeatiResponse objectWithKeyValues:responseObject];
        
//        [weakself.dealEndDataArray addObject:respinde];
        
        NSString *lll1 = [NSString stringWithFormat:@"申请事项：%@\n",respinde.dataLabel];
        NSString *lll2 = [NSString stringWithFormat:@"申请时间：%@\n",[NSDate getYMDhmFormatterTime:respinde.data.create_at]];
        NSString *lll3 = [NSString stringWithFormat:@"终止原因：%@",respinde.data.applymemo];
        NSString *lll = [NSString stringWithFormat:@"%@%@%@",lll1,lll2,lll3];
        NSMutableAttributedString *attributeLL = [[NSMutableAttributedString alloc] initWithString:lll];
        [attributeLL setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, lll.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:kSpacePadding];
        [style setParagraphSpacing:kSpacePadding];
        [style setFirstLineHeadIndent:kBigPadding];
        [style setHeadIndent:kBigPadding];
        [attributeLL addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lll.length)];
        [weakself.textLabel setAttributedText:attributeLL];
        
        //权限
        if ([respinde.accessTerminationAUTH integerValue] == 0) {//能操作
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
