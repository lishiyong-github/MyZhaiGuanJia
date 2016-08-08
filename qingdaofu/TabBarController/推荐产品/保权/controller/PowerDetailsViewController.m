//
//  PowerDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerDetailsViewController.h"

#import "PowerProtectViewController.h"  //申请保全

#import "MessageCell.h"
#import "MineUserCell.h"

@interface PowerDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerDetailsTableView;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BX201609280005";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMeesages)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.powerDetailsTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)editMeesages
{
    PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
    [self.navigationController pushViewController:powerProtectVC animated:YES];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerDetailsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)powerDetailsTableView
{
    if (!_powerDetailsTableView) {
        _powerDetailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerDetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerDetailsTableView.delegate = self;
        _powerDetailsTableView.dataSource = self;
        _powerDetailsTableView.separatorColor = kSeparateColor;
    }
    return _powerDetailsTableView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//基本信息
        identifier = @"power00";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.countLabel setHidden:YES];
        [cell.actButton setHidden:YES];
        cell.userLabel.font = kBoldFont(16);
        
        cell.userLabel.text = @"审核中";
        cell.timeLabel.text = @"2016-09-28 11:11";
        cell.newsLabel.text = @"审核中，耐心等待";
        
        return cell;
    }else if (indexPath.section == 1){
        //补充材料
        if (indexPath.row == 0) {
            identifier = @"application10";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"保全信息" forState:0];
            cell.userNameButton.titleLabel.font = kBoldFont(16);
            return cell;
        }
        
        identifier = @"application11234";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];

        NSArray *additionArray = @[@"姓名",@"身份证",@"联系方式",@"债权金额"];
        [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
        
        if (indexPath.row == 1) {
            [cell.userActionButton setTitle:@"顾笙" forState:0];
        }else if (indexPath.row == 2){
            [cell.userActionButton setTitle:@"123321231212345678" forState:0];
        }else if (indexPath.row == 3){
            [cell.userActionButton setTitle:@"12345678987" forState:0];
        }else if (indexPath.row == 4){
            [cell.userActionButton setTitle:@"600万" forState:0];
        }
        
        /*
        [cell.userActionButton setHidden:YES];
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kSecondFont;
        
        NSString *textStr1 = [NSString stringWithFormat:@"姓名：        %@",@"顾笙"];
        NSString *textStr2 = [NSString stringWithFormat:@"身份证：    %@",@"123321231212345678"];
        NSString *textStr3 = [NSString stringWithFormat:@"联系方式：%@",@"12345678987"];
        NSString *textStr4 = [NSString stringWithFormat:@"债券金额：%@",@"600万"];
        NSArray *additionArray = @[textStr1,textStr2,textStr3,textStr4];
        [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
        
        
        [cell.userActionButton setTitle:@"添加图片" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        */
        return cell;
    }
    
    //证据材料
    identifier = @"application2";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;

    [cell.userNameButton setTitle:@"证据材料" forState:0];
    [cell.userActionButton setTitle:@"查看图片  " forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {//证据材料
        
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
