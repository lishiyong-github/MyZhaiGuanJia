//
//  NewMobileViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewMobileViewController.h"
#import "ChangeMobileViewController.h"
#import "BaseCommitButton.h"

@interface NewMobileViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *neMobileLabel;
@property (nonatomic,strong) UITextField *neTextField1;
@property (nonatomic,strong) UITextField *neTextField2;
@property (nonatomic,strong) UITextField *neTextField3;
@property (nonatomic,strong) UITextField *neTextField4;
@property (nonatomic,strong) BaseCommitButton *neCommitButton;
@property (nonatomic,strong) UIButton *neCodeButton;

@property (nonatomic,strong) NSString *code1;
@property (nonatomic,strong) NSString *code2;
@property (nonatomic,strong) NSString *code3;
@property (nonatomic,strong) NSString *code4;

@end

@implementation NewMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改手机号码";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.neMobileLabel];
    [self.view addSubview:self.neTextField1];
    [self.view addSubview:self.neTextField2];
    [self.view addSubview:self.neTextField3];
    [self.view addSubview:self.neTextField4];
    [self.view addSubview:self.neCommitButton];
    [self.view addSubview:self.neCodeButton];
    
    [self.view setNeedsUpdateConstraints];
    
    [self sendMobileCode];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.neMobileLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.neMobileLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        
        NSArray *views = @[self.neTextField1,self.neTextField2,self.neTextField3,self.neTextField4];
        [views autoSetViewsDimensionsToSize:CGSizeMake(40, 40)];
        [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:kBigPadding*2 insetSpacing:YES matchedSizes:YES];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        [[views firstObject] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.neMobileLabel withOffset:30];
        
        [self.neCommitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.neCommitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.neCommitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.neTextField1 withOffset:20];
        [self.neCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        
        [self.neCodeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.neCodeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.neCommitButton withOffset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UILabel *)neMobileLabel
{
    if (!_neMobileLabel) {
        _neMobileLabel = [UILabel newAutoLayoutView];
        _neMobileLabel.numberOfLines = 0;
        _neMobileLabel.textAlignment = 2;
        NSString *sss1 = @"发送验证码到当前手机号码";
        NSString *sss2 = self.mobile;
        NSString *sss = [NSString stringWithFormat:@"%@\n%@",sss1,sss2];
        NSMutableAttributedString *attributeSS = [[NSMutableAttributedString alloc] initWithString:sss];
        [attributeSS addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, sss1.length)];
        [attributeSS addAttributes:@{NSFontAttributeName:kBoldFont(32),NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(sss1.length+1, sss2.length)];
        NSMutableParagraphStyle *syyu = [[NSMutableParagraphStyle alloc] init];
        [syyu setLineSpacing:kSpacePadding];
        [attributeSS addAttribute:NSParagraphStyleAttributeName value:syyu range:NSMakeRange(0, sss.length)];
        [_neMobileLabel setAttributedText:attributeSS];
    }
    return _neMobileLabel;
}

- (UITextField *)neTextField1
{
    if (!_neTextField1) {
        _neTextField1 = [UITextField newAutoLayoutView];
        _neTextField1.layer.borderColor = kBorderColor.CGColor;
        _neTextField1.layer.borderWidth = kLineWidth;
        _neTextField1.delegate = self;
        _neTextField1.textAlignment = NSTextAlignmentCenter;
        _neTextField1.tag = 51;
        _neTextField1.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _neTextField1;
}
- (UITextField *)neTextField2
{
    if (!_neTextField2) {
        _neTextField2 = [UITextField newAutoLayoutView];
        _neTextField2.layer.borderColor = kBorderColor.CGColor;
        _neTextField2.layer.borderWidth = kLineWidth;
        _neTextField2.delegate = self;
        _neTextField2.textAlignment = NSTextAlignmentCenter;
        _neTextField2.tag = 52;
        _neTextField2.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _neTextField2;
}
- (UITextField *)neTextField3
{
    if (!_neTextField3) {
        _neTextField3 = [UITextField newAutoLayoutView];
        _neTextField3.layer.borderColor = kBorderColor.CGColor;
        _neTextField3.layer.borderWidth = kLineWidth;
        _neTextField3.delegate = self;
        _neTextField3.textAlignment = NSTextAlignmentCenter;
        _neTextField3.tag = 53;
        _neTextField3.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _neTextField3;
}
- (UITextField *)neTextField4
{
    if (!_neTextField4) {
        _neTextField4 = [UITextField newAutoLayoutView];
        _neTextField4.layer.borderColor = kBorderColor.CGColor;
        _neTextField4.layer.borderWidth = kLineWidth;
        _neTextField4.delegate = self;
        _neTextField4.textAlignment = NSTextAlignmentCenter;
        _neTextField4.tag = 54;
        _neTextField4.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _neTextField4;
}

- (BaseCommitButton *)neCommitButton
{
    if (!_neCommitButton) {
        _neCommitButton = [BaseCommitButton newAutoLayoutView];
        [_neCommitButton setTitle:@"下一步" forState:0];
        [_neCommitButton setTitleColor:kWhiteColor forState:0];
        
        QDFWeakSelf;
        [_neCommitButton addAction:^(UIButton *btn) {
            [weakself VerifyThePldMobile];
        }];
    }
    return _neCommitButton;
}

- (UIButton *)neCodeButton
{
    if (!_neCodeButton) {
        _neCodeButton = [UIButton newAutoLayoutView];
        NSString *ccc1 = @"没收到验证码？";
        NSString *ccc2 = @"重新发送";
        NSString *ccc = [NSString stringWithFormat:@"%@%@",ccc1,ccc2];
        NSMutableAttributedString *attributeCC = [[NSMutableAttributedString alloc] initWithString:ccc];
        [attributeCC addAttributes:@{NSFontAttributeName : kFourFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, ccc1.length)];
        [attributeCC addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(ccc1.length, ccc2.length)];
        [_neCodeButton setAttributedTitle:attributeCC forState:0];
        
        QDFWeakSelf;
        [_neCodeButton addAction:^(UIButton *btn) {
            [weakself sendMobileCode];
        }];
    }
    return _neCodeButton;
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 51) {
        self.code1 = textField.text;
    }else if (textField.tag == 52){
        self.code2 = textField.text;
    }else if (textField.tag == 53){
        self.code3 = textField.text;
    }else if (textField.tag == 54){
        self.code4 = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 0) {
        switch (textField.tag) {
            case 51:{
                [textField resignFirstResponder];
                [self.neTextField2 becomeFirstResponder];
            }
                break;
            case 52:{
                [textField resignFirstResponder];
                [self.neTextField3 becomeFirstResponder];
            }
                break;
            case 53:{
                [textField resignFirstResponder];
                [self.neTextField4 becomeFirstResponder];
            }
                break;
            case 54:{
                [textField resignFirstResponder];
            }
                break;
            default:
                break;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - method
- (void)sendMobileCode//发送手机验证码
{
    [self.view endEditing:YES];
    
    NSString *oldMobileString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySettingOfModifyOldMobile];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"mobile" : self.mobile,
                             @"type" : @"4"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:oldMobileString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself.neTextField1 becomeFirstResponder];
        }

    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)VerifyThePldMobile
{
    [self.view endEditing:YES];
    
    NSString *verifyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySettingOfVerifyOldPhone];
    
    NSString *ccc = [NSString stringWithFormat:@"%@%@%@%@",self.code1,self.code2,self.code3,self.code4];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"mobile" : self.mobile,
                             @"code" : ccc,
                             @"type" : @"4"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:verifyString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            ChangeMobileViewController *changeMobileVC = [[ChangeMobileViewController alloc] init];
            changeMobileVC.oldMobile = self.mobile;
            changeMobileVC.oldCode = ccc;
            [weakself.navigationController pushViewController:changeMobileVC animated:YES];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
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
