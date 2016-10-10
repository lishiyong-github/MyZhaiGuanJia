//
//  ChangeMobileViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ChangeMobileViewController.h"
#import "JKCountDownButton.h"

@interface ChangeMobileViewController ()

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UILabel *changeLabel;
@property (nonatomic,strong) UITextField *changeMobileTextField;
@property (nonatomic,strong) UITextField *changeCodeTextField;
@property (nonatomic,strong) JKCountDownButton *changeGetButton;
@property (nonatomic,strong) UIButton *changeCommitButton;

@end

@implementation ChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改手机号码";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.changeLabel];
    [self.view addSubview:self.changeMobileTextField];
    [self.view addSubview:self.changeCodeTextField];
    [self.view addSubview:self.changeGetButton];
    [self.view addSubview:self.changeCommitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.changeLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.changeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.changeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.changeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.changeMobileTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.changeMobileTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.changeMobileTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.changeLabel withOffset:30];
        [self.changeMobileTextField autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.changeCodeTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.changeCodeTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.changeMobileTextField withOffset:kBigPadding];
        [self.changeCodeTextField autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.changeMobileTextField];
        [self.changeCodeTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.changeGetButton withOffset:-kBigPadding];
        
        [self.changeGetButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.changeGetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.changeCodeTextField];
        [self.changeGetButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.changeCodeTextField];
        
        [self.changeCommitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.changeCommitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.changeCommitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.changeCodeTextField withOffset:kBigPadding*2];
        [self.changeCommitButton autoSetDimension:ALDimensionHeight toSize:40];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UILabel *)changeLabel
{
    if (!_changeLabel) {
        _changeLabel = [UILabel newAutoLayoutView];
        _changeLabel.textColor = kLightGrayColor;
        _changeLabel.font = kFourFont;
        _changeLabel.numberOfLines = 0;
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.text = @"绑定新的手机号码，可使用新手机号码和验证码登录";
    }
    return _changeLabel;
}

- (UITextField *)changeMobileTextField
{
    if (!_changeMobileTextField) {
        _changeMobileTextField = [UITextField newAutoLayoutView];
        _changeMobileTextField.layer.borderColor = kBorderColor.CGColor;
        _changeMobileTextField.layer.borderWidth = kLineWidth;
        _changeMobileTextField.placeholder = @"输入新的手机号码";
        _changeMobileTextField.textColor = kBlackColor;
        _changeMobileTextField.font = kFourFont;
        _changeMobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBigPadding, 0)];
        _changeMobileTextField.leftViewMode = UITextFieldViewModeAlways;
        _changeMobileTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _changeMobileTextField;
}

- (UITextField *)changeCodeTextField
{
    if (!_changeCodeTextField) {
        _changeCodeTextField = [UITextField newAutoLayoutView];
        _changeCodeTextField.layer.borderColor = kBorderColor.CGColor;
        _changeCodeTextField.layer.borderWidth = kLineWidth;
        _changeCodeTextField.placeholder = @"输入验证码";
        _changeCodeTextField.textColor = kBlackColor;
        _changeCodeTextField.font = kFourFont;
        _changeCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBigPadding, 0)];
        _changeCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _changeCodeTextField;
}

- (JKCountDownButton *)changeGetButton
{
    if (!_changeGetButton) {
        _changeGetButton = [JKCountDownButton newAutoLayoutView];
        _changeGetButton.backgroundColor = kButtonColor;
        _changeGetButton.layer.cornerRadius = corner;
        [_changeGetButton setTitle:@"      点击获取      " forState:0];
        [_changeGetButton setTitleColor:kWhiteColor forState:0];
        _changeGetButton.titleLabel.font = kFourFont;
        
        [_changeGetButton addTarget:self action:@selector(getChangeCodeWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeGetButton;
}

- (UIButton *)changeCommitButton
{
    if (!_changeCommitButton) {
        _changeCommitButton = [UIButton newAutoLayoutView];
        _changeCommitButton.backgroundColor = kBorderColor;
        _changeCommitButton.layer.cornerRadius = corner;
        [_changeCommitButton setTitle:@"确定" forState:0];
        [_changeCommitButton setTitleColor:kGrayColor forState:0];
        _changeCommitButton.titleLabel.font = kFourFont;
    }
    return _changeCommitButton;
}

#pragma mark - method
- (void)getChangeCodeWithButton:(JKCountDownButton *)sender
{
    [sender startWithSecond:5];
//    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
//        [sender setTitle:@"点击获取" forState:0];
//    }];
    
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
