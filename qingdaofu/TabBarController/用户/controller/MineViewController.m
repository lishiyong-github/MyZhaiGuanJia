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
#import "AuthentyWaitingViewController.h"  //正在等待认证

#import "MyReleaseViewController.h" //我的发布
#import "MyOrderViewController.h"  //我的接单

#import "MySaveViewController.h"  //我的保存
#import "MyStoreViewController.h"  //我的收藏

#import "PowerProtectListViewController.h" //保全
#import "ApplicationListViewController.h"  //保函
#import "HousePropertyListViewController.h" //产调
#import "HouseAssessListViewController.h"  //评估

#import "MyAgentListViewController.h"  //我的代理

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
            
            [weakself tokenIsValid];
            if (buttonTag == 0|| buttonTag == 101 || buttonTag == 3 || buttonTag == 6 || buttonTag == 7 || buttonTag == 8 || buttonTag == 9 || buttonTag == 12) {//我的认证，发布，保存，保全，保函，产调，评估，设置，
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
                                    
                                    
//                                    AuthentyWaitingViewController *authentyWaitingVC = [[AuthentyWaitingViewController alloc] init];
//                                    authentyWaitingVC.hidesBottomBarWhenPushed = YES;
//                                    authentyWaitingVC.categoryString = @"1";
//                                    [weakself.navigationController pushViewController:authentyWaitingVC animated:YES];
                                }
                            }
                                break;
                            case 101:{//我的发布
                                MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                                myReleaseVC.hidesBottomBarWhenPushed = YES;
                                myReleaseVC.progreStatus = @"0";
                                [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                            }
                                break;
                            case 3:{//我的保存
                                MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                                mySaveVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:mySaveVC animated:YES];
                            }
                                break;
                            case 6:{//我的保全
                                PowerProtectListViewController *powerProtectListVC = [[PowerProtectListViewController alloc] init];
                                powerProtectListVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:powerProtectListVC animated:YES];
                            }
                                break;
                            case 7:{//我的保函
                                ApplicationListViewController *applicationListVC = [[ApplicationListViewController alloc] init];
                                applicationListVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:applicationListVC animated:YES];
                            }
                                break;
                            case 8:{//我的产调
                                HousePropertyListViewController *housePropertyListVC = [[HousePropertyListViewController alloc] init];
                                housePropertyListVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:housePropertyListVC animated:YES];
                            }
                                break;
                            case 9:{//我的房产评估结果
                                HouseAssessListViewController *houseAssessListVC = [[HouseAssessListViewController alloc] init];
                                houseAssessListVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:houseAssessListVC animated:YES];
                            }
                                break;
                            case 12:{//我的设置
                                MySettingsViewController *mySettingVC = [[MySettingsViewController alloc] init];
                                mySettingVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:mySettingVC animated:YES];
                            }
                                break;
                            default:
                                break;
                        }
                    }else{//去登录
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.hidesBottomBarWhenPushed = YES;
                        
                        UINavigationController *msss = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        [weakself presentViewController:msss animated:YES completion:nil];
                        
                        
//                        UINavigationController *loginNavs = [[UINavigationController alloc] initWithRootViewController:loginNavs];
                        
                        
//                        [weakself.navigationController pushViewController:loginVC animated:YES];
                    }
                }];
            }else{
                [weakself setDidTokenValid:^(TokenModel *tokenModel) {
                    if ([tokenModel.code integerValue] == 0000) {
                        switch (buttonTag) {
                            case 102:{//我的接单
                                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                                myOrderVC.hidesBottomBarWhenPushed = YES;
                                myOrderVC.status = @"-1";
                                myOrderVC.progresStatus = @"0";
                                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                            }
                                break;
                            case 4:{//我的收藏
                                MyStoreViewController *myStoreVC = [[MyStoreViewController alloc] init];
                                myStoreVC.hidesBottomBarWhenPushed = YES;
                                [weakself.navigationController pushViewController:myStoreVC animated:YES];
                            }
                                break;
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
                        UINavigationController *uiui = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        [weakself presentViewController:uiui animated:YES completion:nil];
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
