//
//  MineViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MineViewController.h"

#import "LoginViewController.h"     //登录
#import "AuthentyViewController.h"  //未认证
#import "CompleteViewController.h"  //已认证

#import "MyReleaseViewController.h" //我的发布
#import "MyOrderViewController.h"  //我的接单

#import "MyAgentListViewController.h"  //我的代理
#import "MySaveViewController.h"  //我的保存
#import "MyStoreViewController.h"  //我的收藏

#import "MySettingsViewController.h"  //设置

#import "LoginView.h"
@interface MineViewController ()

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,strong) LoginView *loginView;

@property (nonatomic,strong) NSString *authenString;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    if ([self getValidateToken] == nil) {
        
    }else{
        [self showAuthentyOrComplete];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户中心";
    
    [self.view addSubview:self.loginView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraits) {
        
        [self.loginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraits = YES;
    }
    [super updateViewConstraints];
}


- (LoginView *)loginView
{
    if (!_loginView) {
        _loginView = [LoginView newAutoLayoutView];
        
        QDFWeakSelf;
        [_loginView setDidSelectedButton:^(NSInteger buttonTag) {
            MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
            myReleaseVC.hidesBottomBarWhenPushed = YES;
            
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.hidesBottomBarWhenPushed = YES;
            
            switch (buttonTag) {
                
                case 10:{//我的发布
                    NSLog(@"全部");
                    myReleaseVC.rFlagString = @"all";
                    myReleaseVC.progreStatus = @"0";
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 11:{
                    myReleaseVC.rFlagString = @"ing";
                    myReleaseVC.progreStatus = @"1";
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 12:{
                    myReleaseVC.rFlagString = @"deal";
                    myReleaseVC.progreStatus = @"2";
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 13:{
                    myReleaseVC.rFlagString = @"end";
                    myReleaseVC.progreStatus = @"3";
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 14:{
                    myReleaseVC.rFlagString = @"close";
                    myReleaseVC.progreStatus = @"4";
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 20:{//我的接单
                    myOrderVC.status = @"01";
                    myOrderVC.progresStatus = @"1234";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 21:{
                    myOrderVC.status = @"0";
                    myOrderVC.progresStatus = @"1";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 22:{
                    myOrderVC.status = @"1";
                    myOrderVC.progresStatus = @"2";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 23:{
                    myOrderVC.status = @"1";
                    myOrderVC.progresStatus = @"3";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 24:{
                    myOrderVC.status = @"1";
                    myOrderVC.progresStatus = @"4";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
        
        [_loginView setDidSelectedIndex:^(NSIndexPath *indexPath) {
            if (indexPath.section == 0) {//认证
                NSLog(@"认证");
                if ([weakself getValidateToken] == nil) {
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:loginVC animated:YES];
                }else{
                    if ([weakself.authenString isEqualToString:@"4001"]) {
                        AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                        authentyVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:authentyVC animated:YES];
                    }else{
        
                        CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                        completeVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:completeVC animated:YES];
                    }
                }
            }else if (indexPath.section == 3){
                if (indexPath.row == 0) {//我的代理
                    
                    MyAgentListViewController *myAgentListVC = [[MyAgentListViewController alloc] init];
                    myAgentListVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:myAgentListVC animated:YES];
                    
                }else if (indexPath.row == 1){//我的保存
                    MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                    mySaveVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:mySaveVC animated:YES];
                    
                }else {//我的收藏
                    MyStoreViewController *myStoreVC = [[MyStoreViewController alloc] init];
                    myStoreVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:myStoreVC animated:YES];
                }
                
            }else if(indexPath.section == 4){//设置
                
                MySettingsViewController *mySettingsVC = [[MySettingsViewController alloc] init];
                mySettingsVC.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:mySettingsVC animated:YES];
            }
        }];
    }
    return _loginView;
}

#pragma mark - method
- (void)showAuthentyOrComplete
{
    NSString *completeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsCompleteString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    [self requestDataPostWithString:completeString params:params successBlock:^(id responseObject){
        BaseModel *completeModel = [BaseModel objectWithKeyValues:responseObject];
        
        self.loginView.authenDic = responseObject;
        [self.loginView.loginTableView reloadData];
        
        self.authenString = completeModel.code;
        
    } andFailBlock:^(NSError *error){
        
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
