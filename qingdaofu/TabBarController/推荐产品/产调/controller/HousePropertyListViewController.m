//
//  HousePropertyListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePropertyListViewController.h"
#import "HouseCopyViewController.h"  //快递信息
#import "HousePropertyViewController.h" //查询产调
#import "HousePayingViewController.h" //支付
#import "HousePayingEditViewController.h"  //编辑
#import "HousePropertyResultViewController.h" //查看结果

#import "BaseCommitView.h"

#import "MineUserCell.h"
#import "MessageCell.h"
#import "PropertyListCell.h"

#import "PropertyListResponse.h"
#import "PropertyListModel.h"

@interface HousePropertyListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *propertyListTableView;
@property (nonatomic,strong) BaseCommitView *propertyListCommitView;

//json
@property (nonatomic,assign) NSInteger pageProperty;
@property (nonatomic,strong) NSMutableArray *propertyListArray;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation HousePropertyListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfPropertyList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的产调";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.propertyListTableView];
    [self.view addSubview:self.propertyListCommitView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.propertyListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.propertyListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.propertyListCommitView];
        
        [self.propertyListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.propertyListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)propertyListTableView
{
    if (!_propertyListTableView) {
        _propertyListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _propertyListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _propertyListTableView.delegate = self;
        _propertyListTableView.dataSource = self;
        _propertyListTableView.backgroundColor = kBackColor;
        _propertyListTableView.separatorColor = kSeparateColor;
        _propertyListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        [_propertyListTableView addHeaderWithTarget:self action:@selector(headerRefreshOfPropertyList)];
        [_propertyListTableView addFooterWithTarget:self action:@selector(footerRefreshOfPropertyList)];
    }
    return _propertyListTableView;
}

- (BaseCommitView *)propertyListCommitView
{
    if (!_propertyListCommitView) {
        _propertyListCommitView = [BaseCommitView newAutoLayoutView];
        [_propertyListCommitView.button setTitle:@"查询产调" forState:0];
        
        QDFWeakSelf;
        [_propertyListCommitView addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
//            [nav popViewControllerAnimated:NO];

            HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
            housePropertyVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:housePropertyVC animated:NO];
        }];
    }
    return _propertyListCommitView;
}

- (NSMutableArray *)propertyListArray
{
    if (!_propertyListArray) {
        _propertyListArray = [NSMutableArray array];
    }
    return _propertyListArray;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.propertyListArray.count > 0) {
        PropertyListModel *pModel = self.propertyListArray[section];
        if ([pModel.status integerValue] == -1 || [pModel.status  integerValue] == 1) {
            return 2;
        }
        return 3;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.propertyListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 62;
    }else if (indexPath.row == 2){
        return 40;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    PropertyListModel *pModel;
    if (self.propertyListArray.count > 0) {
        pModel = self.propertyListArray[indexPath.section];
    }
    
    if (indexPath.row == 0) {
        identifier = @"listas0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setImage:[UIImage imageNamed:@"property_transfer"] forState:0];
        
        NSString *phoneStr = [NSString stringWithFormat:@"  %@",pModel.phone];
        [cell.userNameButton setTitle:phoneStr forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        
        if ([pModel.status integerValue] == 0) {//未付款
            [cell.userActionButton setTitleColor:kBlueColor forState:0];
        }else if ([pModel.status integerValue] == 1 || [pModel.status integerValue] == -1){//付款成功，处理中
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
        }else if([pModel.status integerValue] == 2){//产调成功
            [cell.userActionButton setTitleColor:UIColorFromRGB(0x18ad37) forState:0];
        }else{
            [cell.userActionButton setTitleColor:kRedColor forState:0];
        }
        
        [cell.userActionButton setTitle:pModel.statusLabel forState:0];
        
        return cell;
        
    }else if(indexPath.row == 1){
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeLabel.textColor = kGrayColor;
        cell.timeLabel.font = kBigFont;  //money
        [cell.countLabel setHidden:YES];
        [cell.actButton setBackgroundColor:[UIColor clearColor]];
        [cell.actButton setTitleColor:kLightGrayColor forState:0];
        
        cell.userLabel.text = [NSString stringWithFormat:@"%@%@",pModel.city,pModel.address];
        cell.timeLabel.text = [NSString stringWithFormat:@"¥%@",pModel.money];
        cell.newsLabel.text = [NSDate getYMDhmFormatterTime:pModel.time];
        
        NSString *tytty;
        if ([pModel.status integerValue] == -1 || [pModel.status integerValue] == 1) {
            tytty = [NSString stringWithFormat:@"已用时%@分钟",pModel.yongshi];
        }else if ([pModel.status integerValue] > 1){
             tytty = [NSString stringWithFormat:@"用时%@分钟",pModel.yongshi];
        }else{
            tytty = @"";
        }
        
        [cell.actButton setTitle:tytty forState:0];
        
        return cell;
    }else{//row==2
        
        identifier = @"listas2";
        PropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PropertyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QDFWeakSelf;
        if ([pModel.status integerValue] == 0) {//未付款
            [cell.leftButton setTitleColor:kBlackColor forState:0];
            [cell.leftButton setTitle:@"编辑" forState:0];
            [cell.rightButton setTitle:@"立即支付" forState:0];
            
            [cell.leftButton addAction:^(UIButton *btn) {
                HousePayingEditViewController *housePayingEditVC = [[HousePayingEditViewController alloc] init];
                housePayingEditVC.areaString = pModel.city;
                housePayingEditVC.addressString = pModel.address;
                housePayingEditVC.phoneString = pModel.phone;
                housePayingEditVC.idString = pModel.idString;
                housePayingEditVC.moneyString = pModel.money;
                housePayingEditVC.actString = @"2";
                [weakself.navigationController pushViewController:housePayingEditVC animated:YES];
            }];
            
            [cell.rightButton addAction:^(UIButton *btn) {
                HousePayingViewController *housePayingVC = [[HousePayingViewController alloc] init];
                housePayingVC.areaString = pModel.city;
                housePayingVC.addressString = pModel.address;
                housePayingVC.phoneString = pModel.phone;
                housePayingVC.genarateId = pModel.idString;
                housePayingVC.genarateMoney = pModel.money;
                [weakself.navigationController pushViewController:housePayingVC animated:YES];
            }];
        }else{//2已处理，3退款中，4已退款
            
            if ([pModel.canExpress integerValue] == 1) {//可快递
                NSString *str1 = @"快递原件";
                NSString *str2 = @"(24小时有效)";
                NSString *str = [NSMutableString stringWithFormat:@"%@%@",str1,str2];
                NSMutableAttributedString *kdTitle = [[NSMutableAttributedString alloc] initWithString:str];
                [kdTitle setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, str1.length)];
                [kdTitle setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(str1.length, str2.length)];
                [cell.leftButton setAttributedTitle:kdTitle forState:0];
            }else{//不可快递
                [cell.leftButton setTitleColor:kLightGrayColor forState:0];
                [cell.leftButton setTitle:@"快递原件" forState:0];
            }
            
            [cell.rightButton setTitle:@"查看结果" forState:0];
            
            QDFWeakSelf;
            [cell.leftButton addAction:^(UIButton *btn) {//快递原件
                if ([pModel.canExpress integerValue] == 1) {
                    HouseCopyViewController *houseCopyVC = [[HouseCopyViewController alloc] init];
                    houseCopyVC.jid = pModel.idString;
                    [weakself.navigationController pushViewController:houseCopyVC animated:YES];
                }else{
                    [weakself showHint:pModel.canExpressmsg];
                }
            }];
            
            [cell.rightButton addAction:^(UIButton *btn) {
                if ([pModel.type isEqualToString:@"tips"]) {
                    [weakself showHint:pModel.attr];
                }else if ([pModel.type isEqualToString:@"view"]){
                    HousePropertyResultViewController *housePropertyResultVC = [[HousePropertyResultViewController alloc] init];
                    housePropertyResultVC.attrString = pModel.attr;
                    [weakself.navigationController pushViewController:housePropertyResultVC animated:YES];
                }
            }];
            
        }
        
        return cell;
    }
    return nil;
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
    if (indexPath.row == 0) {
//        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
//        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }
}

#pragma mark - method
- (void)getListOfHousePropertyWithPage:(NSString *)page
{
    NSString *listHouseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHousePropertyListString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:listHouseString params:params successBlock:^(id responseObject) {
                
        if ([page integerValue] == 1) {
            [weakself.propertyListArray removeAllObjects];
        }
        
        PropertyListResponse *response = [PropertyListResponse objectWithKeyValues:responseObject];
        
        if (response.data.count == 0) {
            [weakself showHint:@"没有更多了"];
        }
        
        for (PropertyListModel *pModel in response.data) {
            [weakself.propertyListArray addObject:pModel];
        }
        
//        if (weakself.propertyListArray.count == 0) {
//            [weakself.baseRemindImageView setHidden:YES];
//        }else{
//            [weakself.baseRemindImageView setHidden:NO];
//        }
        
        [weakself.propertyListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfPropertyList
{
    _pageProperty = 1;
    [self getListOfHousePropertyWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.propertyListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfPropertyList
{
    _pageProperty++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageProperty];
    [self getListOfHousePropertyWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.propertyListTableView footerEndRefreshing];
    });
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
