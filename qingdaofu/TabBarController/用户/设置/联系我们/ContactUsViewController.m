//
//  ContactUsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MyLocationViewController.h"  //地图

#import "MineUserCell.h"

@interface ContactUsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *contactTableView;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.contactTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.contactTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [UITableView newAutoLayoutView];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _contactTableView.separatorColor = kSeparateColor;
        _contactTableView.backgroundColor = kBackColor;
    }
    return _contactTableView;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"contact";
    
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *textArray = @[@"客服热线  ",@"总机          ",@"传真          ",@"邮箱           ",@"公司地址  "];
    NSArray *detailArray = @[@"400-855-7022",@"021-8012-0900",@"021-8012-0901",@"zx@direct-invest.com.cn",@"上海市浦东南路855号世界广场34楼A座"];
    NSMutableAttributedString *attributeString = [cell.userNameButton setAttributeString:textArray[indexPath.row] withColor:kBlackColor andSecond:detailArray[indexPath.row] withColor:kLightGrayColor withFont:14];
    [cell.userNameButton setAttributedTitle:attributeString forState:0];
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    if ((indexPath.row == 0) || (indexPath.row == 4)) {
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSmallPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//客服热线
        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }else if (indexPath.row == 4){//地图
//        ViewController *VC = [[ViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
        MyLocationViewController *myLocationVC = [[MyLocationViewController alloc] init];
        [self.navigationController pushViewController:myLocationVC animated:YES];
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
