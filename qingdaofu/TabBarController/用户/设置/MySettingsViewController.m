//
//  MySettingsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MySettingsViewController.h"

#import "SuggestionViewController.h"  //意见反馈
#import "ContactUsViewController.h"  //联系我们
#import "AboutViewController.h"  //关于清道夫
#import "ModifyPassWordViewController.h"  //修改密码
#import "MessageRemindViewController.h"   //消息提醒

#import "MineUserCell.h"
#import "BidOneCell.h"

@interface MySettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *mySettingTableView;

@end

@implementation MySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.mySettingTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.mySettingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)mySettingTableView
{
    if (!_mySettingTableView) {
//        _mySettingTableView = [UITableView newAutoLayoutView];
        _mySettingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _mySettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mySettingTableView.delegate = self;
        _mySettingTableView.dataSource = self;
        _mySettingTableView.tableFooterView = [[UIView alloc] init];
        _mySettingTableView.separatorColor = kSeparateColor;
    }
    return _mySettingTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
//    = @"setting";
    if (indexPath.section < 3) {
        identifier = @"setting0";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        
        NSArray *textArray = @[@[@"修改密码"],@[@"消息提醒"],@[@"意见反馈",@"常见问答",@"联系我们",@"关于清道夫"]];
        
        [cell.userNameButton setTitle:textArray[indexPath.section][indexPath.row] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }
    identifier = @"setting1";
    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    
    [cell.oneButton setTitle:@"退出登录" forState:0];
    [cell.oneButton setTitleColor:kRedColor forState:0];
    cell.oneButton.userInteractionEnabled = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//修改密码
        ModifyPassWordViewController *modifyPassWordVC = [[ModifyPassWordViewController alloc] init];
        [self.navigationController pushViewController:modifyPassWordVC animated:YES];
        
    }else if(indexPath.section == 1){//消息提醒
        MessageRemindViewController *messageRemindVC = [[MessageRemindViewController alloc] init];
        [self.navigationController pushViewController:messageRemindVC animated:YES];
        
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:{//意见反馈
                SuggestionViewController *suggestionVC = [[SuggestionViewController alloc] init];
                [self.navigationController pushViewController:suggestionVC animated:YES];
            }
                break;
            case 1:{//常见问答
                
            }
                break;
            case 2:{//联系我们
                ContactUsViewController *contactUsVC = [[ContactUsViewController alloc] init];
                [self.navigationController pushViewController:contactUsVC animated:YES];
            }
                break;
            case 3:{//关于清道夫
                AboutViewController *aboutVC = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        NSLog(@"退出");
        NSString *exitString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kExitString];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSDictionary *params = @{@"token" : token};
        [self requestDataPostWithString:exitString params:params successBlock:^(id responseObject){
            
            NSDictionary *duu = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"duu is %@",duu);
            
            BaseModel *exitModel = [BaseModel objectWithKeyValues:responseObject];
            [self showHint:exitModel.msg];
            
            if ([exitModel.code isEqualToString:@"0000"]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } andFailBlock:^(NSError *error){
            
        }];
    }
}


#pragma mark - method


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
