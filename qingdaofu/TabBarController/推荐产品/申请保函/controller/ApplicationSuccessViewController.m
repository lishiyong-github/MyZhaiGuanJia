//
//  ApplicationSuccessViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationSuccessViewController.h"

#import "ApplicationListViewController.h"//我的保函
#import "PowerProtectListViewController.h" //我的保全
#import "HousePropertyListViewController.h" //我的产调

#import "PowerProtectViewController.h"
#import "ApplicationGuaranteeViewController.h"
#import "HousePropertyViewController.h"

#import "ApplicationSuccessCell.h"

@interface ApplicationSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *appSuccessTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ApplicationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.successType integerValue] < 3) {
        self.title = @"申请成功";
    }else{
        self.title = @"支付成功";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor} forState:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishsd)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.appSuccessTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)finishsd
{
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    if ([self.successType integerValue] == 1) {//保函
        ApplicationListViewController *applicationListVC = [[ApplicationListViewController alloc] init];
        applicationListVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:applicationListVC animated:NO];
    }else if ([self.successType integerValue] == 2) {//保全
        PowerProtectListViewController *powerListVC = [[PowerProtectListViewController alloc] init];
        powerListVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:powerListVC animated:NO];
    }else if ([self.successType integerValue] == 3) {//产调
        HousePropertyListViewController *housePropertyListVC = [[HousePropertyListViewController alloc] init];
        housePropertyListVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:housePropertyListVC animated:NO];
    }else if ([self.successType integerValue] == 4) {// 快递
        PowerProtectListViewController *powerListVC = [[PowerProtectListViewController alloc] init];
        powerListVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:powerListVC animated:NO];
    }
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.appSuccessTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)appSuccessTableView
{
    if (!_appSuccessTableView) {
        _appSuccessTableView = [UITableView newAutoLayoutView];
        _appSuccessTableView.delegate = self;
        _appSuccessTableView.dataSource = self;
        _appSuccessTableView.separatorColor = kSeparateColor;
        _appSuccessTableView.backgroundColor = kBackColor;
    }
    return _appSuccessTableView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"apps";
    ApplicationSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ApplicationSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.successType integerValue] < 3) {
        cell.appLabel1.text = @"申请成功";
    }else{
        cell.appLabel1.text = @"支付成功";
    }
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
    if ([self.successType integerValue] < 4) {
        if ([self.successType integerValue] == 1) {
            str3 = @"保函";
        }else if ([self.successType integerValue] == 2) {
            str3 = @"保全";
        }else if ([self.successType integerValue] == 3) {
            str3 = @"产调";
        }
        str2 = [NSString stringWithFormat:@"您可以在我的%@里查看%@的处理状态",str3,str3];
    }else{
        
        str3 = @"快递";
        str2 = [NSString stringWithFormat:@"我们将尽快把产调原件邮递给您"];
    }
    
    str1 = [NSString stringWithFormat:@"%@信息",str3];
    NSString *str = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, str1.length)];
    [attributeStr addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(str1.length+1, str2.length)];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [cell.appLabel2 setAttributedText:attributeStr];
    
    NSString *appTitle;
    if ([self.successType integerValue] < 4) {
        appTitle = @"再次申请";
    }else{
        appTitle = @"申请产调";
    }
    [cell.appButton2 setTitle:appTitle forState:0];
    
    QDFWeakSelf;
    [cell.appButton1 addAction:^(UIButton *btn) {
        NSLog(@"回首页");
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
    }];
    
    [cell.appButton2 addAction:^(UIButton *btn) {
        NSLog(@"我的保函");
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        if ([weakself.successType integerValue] == 1) {//保函
            ApplicationGuaranteeViewController *applicationGuaranteeVC = [[ApplicationGuaranteeViewController alloc] init];
            applicationGuaranteeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:applicationGuaranteeVC animated:NO];
        }else if ([weakself.successType integerValue] == 2){//保全
            PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
            powerProtectVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:powerProtectVC animated:NO];
        }else if ([weakself.successType integerValue] == 3){//产调
            HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
            housePropertyVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:housePropertyVC animated:NO];
        }else if ([weakself.successType integerValue] == 4){//快递
            PowerProtectListViewController *powerListVC = [[PowerProtectListViewController alloc] init];
            powerListVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:powerListVC animated:NO];
        }

    }];
    
    return cell;
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
