//
//  HelpCenterViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HelpCenterViewController.h"

#import "MessageRemindViewController.h"   //消息提醒
#import "SuggestionViewController.h"  //意见反馈
#import "ContactUsViewController.h"  //联系我们
#import "AboutViewController.h"  //关于清道夫
#import "RegisterAgreementViewController.h" //常见问答

#import "MineUserCell.h"
#import "BidOneCell.h"

@interface HelpCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myhelpingTableView;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助中心";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myhelpingTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myhelpingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myhelpingTableView
{
    if (!_myhelpingTableView) {
        _myhelpingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myhelpingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myhelpingTableView.delegate = self;
        _myhelpingTableView.dataSource = self;
        _myhelpingTableView.tableFooterView = [[UIView alloc] init];
        _myhelpingTableView.separatorColor = kSeparateColor;
        _myhelpingTableView.backgroundColor = kBackColor;
    }
    return _myhelpingTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section < 2) {
        identifier = @"helping0";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
        
        NSArray *textArray = @[@[@"消息提醒"],@[@"意见反馈",@"常见问答",@"联系我们",@"关于清道夫"]];
        
        [cell.userNameButton setTitle:textArray[indexPath.section][indexPath.row] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }
    identifier = @"helping1";
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
    
    if(indexPath.section == 0){//消息提醒
        MessageRemindViewController *messageRemindVC = [[MessageRemindViewController alloc] init];
        [self.navigationController pushViewController:messageRemindVC animated:YES];
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{//意见反馈
                SuggestionViewController *suggestionVC = [[SuggestionViewController alloc] init];
                [self.navigationController pushViewController:suggestionVC animated:YES];
            }
                break;
            case 1:{//常见问答
                RegisterAgreementViewController *registerAgreementVC = [[RegisterAgreementViewController alloc] init];
                registerAgreementVC.agreeString = kSettingProblems;
                [self.navigationController pushViewController:registerAgreementVC animated:YES];
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
        NSString *exitString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kExitString];
        NSDictionary *params = @{@"token" : [self getValidateToken]};
        
        QDFWeakSelf;
        [self requestDataPostWithString:exitString params:params successBlock:^(id responseObject){
            BaseModel *exitModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:exitModel.msg];
            
            if ([exitModel.code isEqualToString:@"0000"]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            
        } andFailBlock:^(NSError *error){
            
        }];
    }
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
