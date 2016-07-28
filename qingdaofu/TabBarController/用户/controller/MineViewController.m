//
//  MineViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MineViewController.h"

#import "MineUserCell.h"

#import "LoginViewController.h"     //登录
#import "AuthentyViewController.h"  //未认证
#import "CompleteViewController.h"  //已认证

#import "MyReleaseViewController.h" //我的发布
#import "MyOrderViewController.h"  //我的接单

#import "MyAgentListViewController.h"  //我的代理
#import "MySaveViewController.h"  //我的保存
#import "MyStoreViewController.h"  //我的收藏

#import "MySettingsViewController.h"  //设置

#import "LoginTableView.h"

#import "CompleteResponse.h"
#import "CertificationModel.h"

@interface MineViewController ()

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,strong) LoginTableView *loginView;

@property (nonatomic,strong) NSString *authenString;
@property (nonatomic,strong) NSMutableArray *authenArray;

@property (nonatomic,strong) NSMutableArray *tokenArray;


@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self tokenIsValid];
    QDFWeakSelf;
    [self setDidTokenValid:^(TokenModel *tModel) {
        weakself.loginView.model = tModel;
        [weakself.loginView reloadData];
    }];
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
        
        [self.loginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.loginView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        self.didSetupConstraits = YES;
    }
    [super updateViewConstraints];
}

- (LoginTableView *)loginView
{
    if (!_loginView) {
        _loginView.translatesAutoresizingMaskIntoConstraints = NO;
        _loginView = [[LoginTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        QDFWeakSelf;
        [_loginView setDidSelectedButton:^(NSInteger buttonTag) {
            if (buttonTag == 0|| buttonTag == 10 || buttonTag == 12 || buttonTag == 20 || buttonTag == 21 || buttonTag == 22 || buttonTag == 23 || buttonTag == 24) {//我的保存，我的设置，我的发布
                [weakself tokenIsValid];
                [weakself setDidTokenValid:^(TokenModel *tokenModel) {
                    if ([tokenModel.code integerValue] == 0000 || [tokenModel.code integerValue] == 3006) {
                        switch (buttonTag) {
                            case 0:{//认证
                                if ([tokenModel.code integerValue] == 0000) {//已认证
                                    NSString *categoryStr;
                                    if ([tokenModel.state intValue] == 1 && [tokenModel.category intValue] == 1) {//个人
                                        categoryStr = @"1";
                                    }else if ([tokenModel.state intValue] == 1 && [tokenModel.category intValue] == 2){//律所
                                        categoryStr = @"2";
                                    }else if ([tokenModel.state intValue] == 1 && [tokenModel.category intValue] == 3){//公司
                                        categoryStr = @"3";
                                    }
                                    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                                    completeVC.hidesBottomBarWhenPushed = YES;
                                    completeVC.categoryString = tokenModel.category;
                                    [weakself.navigationController pushViewController:completeVC animated:YES];
                                }else{//未认证
                                    [weakself showHint:tokenModel.msg];
                                    AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                                    authentyVC.hidesBottomBarWhenPushed = YES;
                                    authentyVC.typeAuthty = @"0";
                                    [weakself.navigationController pushViewController:authentyVC animated:YES];
                                }
                            }
                                break;
                            case 10:{//我的保存
                                MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                                mySaveVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:mySaveVC animated:YES];
                            }
                                break;
                            case 12:{//我的设置
                                MySettingsViewController *mySettingVC = [[MySettingsViewController alloc] init];
                                mySettingVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:mySettingVC animated:YES];
                            }
                                break;
                            case 20:{//我的发布－全部
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"0";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            case 21:{
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"1";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            case 22:{
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"2";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            case 23:{
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"3";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            case 24:{
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"4";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            default:
                                break;
                        }
                    }else{//去登录
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:loginVC animated:YES];
                    }
                }];
            }else{
                 [weakself tokenIsValid];
                [weakself setDidTokenValid:^(TokenModel *tokenModel) {
                    if ([tokenModel.code integerValue] == 0000) {
                        switch (buttonTag) {
                            case 9:{//我的代理
                                MyAgentListViewController *myAgentListVC = [[MyAgentListViewController alloc] init];
                                myAgentListVC.hidesBottomBarWhenPushed = YES;
                                
                                if (tokenModel.pid == nil) {
                                    myAgentListVC.typePid = @"本人";
                                }else{
                                    myAgentListVC.typePid = @"非本人";
                                }
                                
                                [weakself.navigationController pushViewController:myAgentListVC animated:YES];
                            }
                                break;
                            case 11:{//我的收藏
                                MyStoreViewController *myStoreVC = [[MyStoreViewController alloc] init];
                                myStoreVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:myStoreVC animated:YES];
                            }
                                break;
                            case 30:{//我的接单－全部
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"-1";
                                myOrderVC.progresStatus = @"0";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            case 31:{//我的接单－申请中
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"0";
                                myOrderVC.progresStatus = @"1";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            case 32:{//我的接单－处理中
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"1";
                                myOrderVC.progresStatus = @"2";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            case 33:{//我的接单－终止
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"1";
                                myOrderVC.progresStatus = @"3";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            case 34:{//我的接单－结案
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"1";
                                myOrderVC.progresStatus = @"4";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            default:
                                break;
                        }
                    }else if ([tokenModel.code integerValue] == 3006){
                        [weakself showHint:tokenModel.msg];
                        AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                        authentyVC.hidesBottomBarWhenPushed = YES;
                        authentyVC.typeAuthty = @"0";
                        [weakself.navigationController pushViewController:authentyVC animated:YES];
                    }else if ([tokenModel.code integerValue] == 3001 || [weakself getValidateToken] == nil){
                        [weakself showHint:tokenModel.msg];
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:loginVC animated:YES];
                    }
                }];
            }
        }];
    }
    return _loginView;
}

- (NSMutableArray *)authenArray
{
    if (!_authenArray) {
        _authenArray = [NSMutableArray array];
    }
    return _authenArray;
}

- (NSMutableArray *)tokenArray
{
    if (!_tokenArray) {
        _tokenArray = [NSMutableArray array];
    }
    return _tokenArray;
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
