//
//  MineViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MineViewController.h"
#import "PersonCerterViewController.h" //个人中心

#import "MyReleaseViewController.h" //我的发布
#import "MyOrderViewController.h"  //我的接单，经办事项

#import "PowerProtectListViewController.h" //保全
#import "ApplicationListViewController.h"  //保函
#import "HousePropertyListViewController.h" //产调
#import "HouseAssessListViewController.h"  //评估

#import "MySaveViewController.h"  //我的保存
#import "MyStoreViewController.h"  //我的收藏

#import "MyMailListsViewController.h"  //我的通讯录

#import "MySettingsViewController.h"  //设置
#import "HelpCenterViewController.h" //帮助中心

#import "LoginTableView.h"

#import "ProductDetailResponse.h"
#import "CompleteResponse.h"
#import "CertificationModel.h"
#import "UIViewController+SelectedIndex.h"

@interface MineViewController ()

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,strong) LoginTableView *loginView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getMessageOfUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"list_icon_setting"] forState:0];
    
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
            switch (buttonTag) {
                case 0:{//用户
                    PersonCerterViewController *personCerterVC = [[PersonCerterViewController alloc] init];
                    personCerterVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:personCerterVC animated:YES];
                }
                    break;
                case 101:{//我的发布
                    MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
                    myReleaseVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:myReleaseVC animated:YES];
                }
                    break;
                case 102:{//我的接单
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.hidesBottomBarWhenPushed = YES;
                    myOrderVC.navType = @"2";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 103:{//经办事项
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.hidesBottomBarWhenPushed = YES;
                    myOrderVC.navType = @"3";
                    [weakself.navigationController pushViewController:myOrderVC animated:YES];
                }
                    break;
                case 4:{//保全
                    PowerProtectListViewController *powerProtectListVC = [[PowerProtectListViewController alloc] init];
                    powerProtectListVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:powerProtectListVC animated:YES];
                }
                    break;
                case 5:{//我的保函
                    ApplicationListViewController *applicationListVC = [[ApplicationListViewController alloc] init];
                    applicationListVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:applicationListVC animated:YES];
                }
                    break;
                case 6:{//我的产调
                    [weakself showHint:@"暂不支持产调"];
//                    HousePropertyListViewController *housePropertyListVC = [[HousePropertyListViewController alloc] init];
//                    housePropertyListVC.hidesBottomBarWhenPushed = YES;
//                    [weakself.navigationController pushViewController:housePropertyListVC animated:YES];
                }
                    break;
                case 7:{//我的房产评估结果
                    HouseAssessListViewController *houseAssessListVC = [[HouseAssessListViewController alloc] init];
                    houseAssessListVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:houseAssessListVC animated:YES];
                }
                    break;
                case 8:{//我的草稿
                    MySaveViewController *mySaveVC = [[MySaveViewController alloc] init];
                    mySaveVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:mySaveVC animated:YES];
                }
                    break;
                case 9:{//收藏
                    MyStoreViewController *myStoreVC = [[MyStoreViewController alloc] init];
                    myStoreVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:myStoreVC animated:YES];
                }
                    break;
                case 12:{//通讯录
                    MyMailListsViewController *myMailListsVC = [[MyMailListsViewController alloc] init];
                    myMailListsVC.mailType = @"1";
                    myMailListsVC.hidesBottomBarWhenPushed = YES;
                    //                                myMailListsVC.ordersid =
                    [weakself.navigationController pushViewController:myMailListsVC animated:YES];
                }
                    break;
                case 16:{//帮助中心
                    HelpCenterViewController *helpCenterVC = [[HelpCenterViewController alloc] init];
                    helpCenterVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:helpCenterVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _loginView;
}

#pragma mark - method
- (void)getMessageOfUser
{
    NSString *aoaoa = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessagesString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    QDFWeakSelf;
    [session POST:aoaoa parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"3001"]){//未登录
            [weakself setSelectedIndex:0 andType:@"1"];
        }else{
            weakself.loginView.completeResponse = response;
            [weakself.loginView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)rightItemAction
{
    MySettingsViewController *mySettingVC = [[MySettingsViewController alloc] init];
    mySettingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySettingVC animated:YES];
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
