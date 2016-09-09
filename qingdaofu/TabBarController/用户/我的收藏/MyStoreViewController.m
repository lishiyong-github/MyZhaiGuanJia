//
//  MyStoreViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyStoreViewController.h"
//#import "MyDetailStoreViewController.h"    //收藏详细
#import "MyOrderViewController.h" //我的接单
#import "ProductsDetailsViewController.h" //详细

#import "MineUserCell.h"
#import "HomeCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"

#import "UIImage+Color.h"

@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myStoreTableView;
@property (nonatomic,strong) UIButton *rightNavButton;

//json
@property (nonatomic,assign) BOOL editState;
@property (nonatomic,strong) NSMutableArray *storeDataList;
@property (nonatomic,assign) NSInteger pageStore;

@end

@implementation MyStoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self refreshHeaderOfMySave];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
    
    [self.view addSubview:self.myStoreTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myStoreTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myStoreTableView
{
    if (!_myStoreTableView) {
        _myStoreTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myStoreTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myStoreTableView.delegate = self;
        _myStoreTableView.dataSource = self;
        _myStoreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myStoreTableView.separatorColor = kSeparateColor;
        _myStoreTableView.backgroundColor = kBackColor;
        
        [_myStoreTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMySave)];
        [_myStoreTableView addFooterWithTarget:self action:@selector(refreshFooterOfMySave)];
    }
    return _myStoreTableView;
}

- (UIButton *)rightNavButton
{
    if (!_rightNavButton) {
        _rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        _rightNavButton.titleLabel.font = kFirstFont;
        [_rightNavButton setTitle:@"编辑" forState:0];
        [_rightNavButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_rightNavButton addAction:^(UIButton *btn) {
            
            [weakself.myStoreTableView setEditing:!weakself.myStoreTableView.editing animated:YES];
            
            if (weakself.myStoreTableView.editing){
                [btn setTitle:@"完成" forState:0];
            }else{
                [btn setTitle:@"编辑" forState:0];
            }
        }];
    }
    return _rightNavButton;
}

- (NSMutableArray *)storeDataList
{
    if (!_storeDataList) {
        _storeDataList = [NSMutableArray array];
    }
    return _storeDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.storeDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"store";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.recommendimageView setHidden:YES];
    [cell.typeButton setHidden:YES];
    
    RowsModel *storeModel = self.storeDataList[indexPath.section];

    //image
    if ([storeModel.category isEqualToString:@"2"]){//清收
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_collection"]];
    }else if ([storeModel.category isEqualToString:@"3"]){
        [cell.typeImageView setImage:[UIImage imageNamed:@"list_litigation"]];
    }
    
    //code
    cell.nameLabel.text = storeModel.codeString;
    
    //借款本金
    NSString *moneySa1 = [NSString getValidStringFromString:storeModel.money toString:@"0"];
    NSString *moneyQ = [NSString stringWithFormat:@"%@万",moneySa1];
    NSMutableAttributedString *attrMoney = [[NSMutableAttributedString alloc] initWithString:moneyQ];
    [attrMoney addAttributes:@{NSFontAttributeName:kBoldFont(24),NSForegroundColorAttributeName:kYellowColor} range:NSMakeRange(0, moneySa1.length)];
    [attrMoney addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kYellowColor} range:NSMakeRange(moneySa1.length,1)];
    [cell.moneyView.label1 setAttributedText:attrMoney];
    cell.moneyView.label2.text = @"借款本金";
    
    //代理费用类型
    if ([storeModel.category isEqualToString:@"2"]){//清收
        
        if ([storeModel.agencycommissiontype isEqualToString:@"1"]) {
            
            cell.pointView.label2.text = @"服务佣金";
            
            NSString *agencyType1 = [NSString getValidStringFromString:storeModel.agencycommission toString:@"0"];
            NSString *agencyQ = [NSString stringWithFormat:@"%@%@",agencyType1,@"%"];
            NSMutableAttributedString *attrAgency = [[NSMutableAttributedString alloc] initWithString:agencyQ];
            [attrAgency addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, agencyType1.length)];
            [attrAgency addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(agencyType1.length,1)];
            [cell.pointView.label1 setAttributedText:attrAgency];
            
        }else{
            cell.pointView.label2.text = @"固定费用";
            
            NSString *agencyType1 = [NSString getValidStringFromString:storeModel.agencycommission toString:@"0"];
            NSString *agencyQ = [NSString stringWithFormat:@"%@万",agencyType1];
            NSMutableAttributedString *attrAgency = [[NSMutableAttributedString alloc] initWithString:agencyQ];
            [attrAgency addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, agencyType1.length)];
            [attrAgency addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(agencyType1.length,1)];
            [cell.pointView.label1 setAttributedText:attrAgency];
        }
    }else if ([storeModel.category isEqualToString:@"3"]){//诉讼
        
        if ([storeModel.agencycommissiontype isEqualToString:@"1"]) {
            
            cell.pointView.label2.text = @"固定费用";
            
            NSString *agencyType1 = [NSString getValidStringFromString:storeModel.agencycommission toString:@"0"];
            NSString *agencyQ = [NSString stringWithFormat:@"%@万",agencyType1];
            NSMutableAttributedString *attrAgency = [[NSMutableAttributedString alloc] initWithString:agencyQ];
            [attrAgency addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, agencyType1.length)];
            [attrAgency addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(agencyType1.length,1)];
            [cell.pointView.label1 setAttributedText:attrAgency];
            
        }else{
            
            cell.pointView.label2.text = @"风险费率";
            
            NSString *agencyType1 = [NSString getValidStringFromString:storeModel.agencycommission toString:@"0"];
            NSString *agencyQ = [NSString stringWithFormat:@"%@%@",agencyType1,@"%"];
            NSMutableAttributedString *attrAgency = [[NSMutableAttributedString alloc] initWithString:agencyQ];
            [attrAgency addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, agencyType1.length)];
            [attrAgency addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(agencyType1.length,1)];
            [cell.pointView.label1 setAttributedText:attrAgency];
        }
    }
    
    //债权类型
    if ([storeModel.loan_type isEqualToString:@"1"]) {
        cell.rateView.label1.text = @"房产抵押";
        cell.addressLabel.text = [NSString getValidStringFromString:storeModel.seatmortgage toString:@"无抵押物地址"];
    }else if ([storeModel.loan_type isEqualToString:@"2"]){
        cell.rateView.label1.text = @"应收账款";
        cell.addressLabel.text = [NSString stringWithFormat:@"应收账款：%@万",storeModel.agencycommission];
    }else if ([storeModel.loan_type isEqualToString:@"3"]){
        cell.rateView.label1.text = @"机动车抵押";
        NSArray *lisence = @[@"沪牌",@"非沪牌"];
//        NSString *license = lisence[[storeModel.licenseplate integerValue] - 1];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",storeModel.carbrand,storeModel.audi,lisence];
    }else{
        cell.rateView.label1.text = @"无抵押";
        cell.addressLabel.text = @"无抵押";
    }
    cell.rateView.label2.text = @"债权类型";

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


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.editing) {//是否处于编辑状态
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

//删除cell方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section]; //获取当前jie
    [self deleteOneStoreOfRow:section];
//    [self.storeDataList removeObjectAtIndex:section]; //在数据中删除当前对象
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; //数组执行删除 操作
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RowsModel *rowModel = self.storeDataList[indexPath.section];
    
    ProductsDetailsViewController *myDetailStoreVC = [[ProductsDetailsViewController alloc] init];
    myDetailStoreVC.idString = rowModel.idString;
    myDetailStoreVC.categoryString = rowModel.category;
    [self.navigationController pushViewController:myDetailStoreVC animated:YES];
}

#pragma mark - refresh method
- (void)getMyStoreListWithPage:(NSString *)page
{
    NSString *storeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyStoreString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:storeString params:params successBlock:^(id responseObject){
        
        NSDictionary *qpqp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        
        if ([page integerValue] == 1) {
            [weakself.storeDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.rows.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageStore--;
        }
        
        for (RowsModel *storeModel in responseModel.rows) {
            [weakself.storeDataList addObject:storeModel];
        }
        
        if (weakself.storeDataList.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.myStoreTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)refreshHeaderOfMySave
{
    _pageStore = 1;
    [self getMyStoreListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myStoreTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMySave
{
    _pageStore ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageStore];
    [self getMyStoreListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myStoreTableView footerEndRefreshing];
    });
}

#pragma mark - method
- (void)goToApplyWithRow:(NSInteger)row
{
    RowsModel *appModel = self.storeDataList[row];
    NSString *appString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductHouseString];
    NSDictionary *params = @{@"id" : appModel.idString,
                             @"category" : appModel.category,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:appString params:params successBlock:^(id responseObject) {
        BaseModel *appModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:appModel.msg];
        if ([appModel.code isEqualToString:@"0000"]) {
            [weakself.storeDataList removeObjectAtIndex:row];
            [weakself.myStoreTableView reloadData];
            
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.status = @"0";
            myOrderVC.progresStatus = @"1";
            [nav pushViewController:myOrderVC animated:NO];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//删除
- (void)deleteOneStoreOfRow:(NSInteger)indexRow
{
    RowsModel *deleteModel = self.storeDataList[indexRow];
    NSString *deleteString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteStoreString];
    NSDictionary *params = @{@"product_id" : deleteModel.idString,
                             @"category" : deleteModel.category,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deleteString params:params successBlock:^(id responseObject){
        BaseModel *deleteModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:deleteModel.msg];
        if ([deleteModel.code isEqualToString:@"0000"]) {
            [weakself.storeDataList removeObjectAtIndex:indexRow];
            [weakself.myStoreTableView reloadData];
            if (weakself.storeDataList.count > 0) {
                [weakself.baseRemindImageView setHidden:YES];
            }else{
                [weakself.baseRemindImageView setHidden:NO];
            }
        }
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
