//
//  AuthentyWaitingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthentyWaitingViewController.h"

@interface AuthentyWaitingViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImageView *waitingImageView;
@property (nonatomic,strong) UILabel *waitingLabel;
@property (nonatomic,strong) UIButton *waitingButton;

@end

@implementation AuthentyWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if ([self.categoryString integerValue] == 1) {
        self.navigationItem.title = @"个人认证";
    }else if ([self.categoryString integerValue] == 2){
        self.navigationItem.title = @"律所认证";
    }else if ([self.categoryString integerValue] == 3){
        self.navigationItem.title = @"公司认证";
    }
    
    [self.view addSubview:self.waitingImageView];
    [self.view addSubview:self.waitingLabel];
    [self.view addSubview:self.waitingButton];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.waitingImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.waitingImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:36];
        
        [self.waitingLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.waitingImageView withOffset:24];
        [self.waitingLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.waitingImageView];

        [self.waitingButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.waitingLabel withOffset:40];
        [self.waitingButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.waitingImageView];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIImageView *)waitingImageView
{
    if (!_waitingImageView) {
        _waitingImageView = [UIImageView newAutoLayoutView];
        _waitingImageView.image = [UIImage imageNamed:@"image_success"];
    }
    return _waitingImageView;
}

- (UILabel *)waitingLabel
{
    if (!_waitingLabel) {
        _waitingLabel = [UILabel newAutoLayoutView];
        _waitingLabel.numberOfLines = 0;
        _waitingLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString *str1 = @"        提交成功，等待审核中       ";
        NSString *str2 = @"预计审核将在半小时内完成，请耐心等待。";
        NSString *sreing = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:sreing];
        
        [attString addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, str1.length)];
        [attString addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(str1.length+1, str2.length)];

        NSMutableParagraphStyle *strle = [[NSMutableParagraphStyle alloc] init];
        [strle setLineSpacing:kBigPadding/2];
        [attString addAttribute:NSParagraphStyleAttributeName value:strle range:NSMakeRange(0, sreing.length)];
        
        [_waitingLabel setAttributedText:attString];
    }
    return _waitingLabel;
}

- (UIButton *)waitingButton
{
    if (!_waitingButton) {
        _waitingButton = [UIButton newAutoLayoutView];
        [_waitingButton setTitle:@"  返回首页  " forState:0];
        _waitingButton.titleLabel.font = kFirstFont;
        [_waitingButton setTitleColor:kLightGrayColor forState:0];
        _waitingButton.layer.borderColor = kBorderColor.CGColor;
        _waitingButton.layer.borderWidth = kLineWidth;
        _waitingButton.layer.cornerRadius = corner;
        _waitingButton.backgroundColor = kBackColor;
        
        QDFWeakSelf;
        [_waitingButton addAction:^(UIButton *btn) {
            [weakself back];
        }];
    }
    return _waitingButton;
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
