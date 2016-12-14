//
//  MyStoreViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyStoreViewController.h"
#import "ProductsDetailsViewController.h" //详细

#import "ExtendHomeCell.h"

#import "ReleaseResponse.h"
#import "RowsModel.h"
#import "ProductDetailModel.h"

#import "UIImage+Color.h"

@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myStoreTableView;

//json
@property (nonatomic,strong) NSMutableArray *storeDataList;
@property (nonatomic,assign) NSInteger pageStore;

@end

@implementation MyStoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor] forBarMetrics:UIBarMetricsDefault];
    
    [self refreshHeaderOfMyStore];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = self.leftItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
//    [self.rightButton setTitle:@"编辑" forState:0];
    
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
        
        [_myStoreTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfMyStore)];
        [_myStoreTableView addFooterWithTarget:self action:@selector(refreshFooterOfMySave)];
    }
    return _myStoreTableView;
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
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myRelease0";
    ExtendHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ExtendHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.actButton2 setHidden:YES];
    cell.bottomContentConstraints.constant = 0;
    
    RowsModel *rowModel = self.storeDataList[indexPath.section];
    ProductDetailModel *storeModel = rowModel.product;
    
    //code
    [cell.nameButton setTitle:storeModel.number forState:0];
    
    //details
    //委托本金
    NSString *orString0 = [NSString stringWithFormat:@"委托本金：%@万",storeModel.accountLabel];
    //债权类型
    NSString *orString1 = [NSString stringWithFormat:@"债权类型：%@",storeModel.categoryLabel];
    //委托事项
    NSString *orString2 = [NSString stringWithFormat:@"委托事项：%@",storeModel.entrustLabel];
    //委托费用
    NSString *orString3;
    if ([storeModel.typeLabel isEqualToString:@"万"]) {
        orString3 = [NSString stringWithFormat:@"固定费用：%@%@",storeModel.typenumLabel,storeModel.typeLabel];
    }else if ([storeModel.typeLabel isEqualToString:@"%"]){
        orString3 = [NSString stringWithFormat:@"风险费率：%@%@",storeModel.typenumLabel,storeModel.typeLabel];
    }
    
    //违约期限
    NSString *orString4 = [NSString stringWithFormat:@"违约期限：%@个月",storeModel.overdue];
    //合同履行地
    NSString *orString5 = [NSString stringWithFormat:@"合同履行地：%@",storeModel.addressLabel];
    
    NSString *orString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",orString0,orString1,orString2,orString3,orString4,orString5];
    NSMutableAttributedString *orAttributeStr = [[NSMutableAttributedString alloc] initWithString:orString];
    [orAttributeStr setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, orString.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [orAttributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, orString.length)];
    [cell.contentButton setAttributedTitle:orAttributeStr forState:0];
    
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
    
    RowsModel *storeModel = self.storeDataList[indexPath.section];
    
    ProductsDetailsViewController *myDetailStoreVC = [[ProductsDetailsViewController alloc] init];
    myDetailStoreVC.productid = storeModel.productid;
    [self.navigationController pushViewController:myDetailStoreVC animated:YES];
}

#pragma mark - refresh method
- (void)getMyStoreListWithPage:(NSString *)page
{
    NSString *storeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySaveListsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:storeString params:params successBlock:^(id responseObject){
        
        NSDictionary *aoaoao = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    
        if ([page integerValue] == 1) {
            [weakself.storeDataList removeAllObjects];
        }
        
        ReleaseResponse *responseModel = [ReleaseResponse objectWithKeyValues:responseObject];
        
        if (responseModel.data.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageStore--;
        }
        
        for (RowsModel *storeModel in responseModel.data) {
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

- (void)refreshHeaderOfMyStore
{
    _pageStore = 1;
    [self getMyStoreListWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.myStoreTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfMySave
{
    _pageStore ++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageStore];
    [self getMyStoreListWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.myStoreTableView footerEndRefreshing];
    });
}

- (void)rightItemAction
{
    [self.myStoreTableView setEditing:!self.myStoreTableView.editing animated:YES];
    
    if (self.myStoreTableView.editing){
        [self.rightButton setTitle:@"完成" forState:0];
    }else{
        [self.rightButton setTitle:@"编辑" forState:0];
    }
}

////删除
- (void)deleteOneStoreOfRow:(NSInteger)indexRow
{
    RowsModel *deleteModel = self.storeDataList[indexRow];
    
    NSString *deleteString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailOfCancelSave];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : deleteModel.productid};
    
    QDFWeakSelf;
    [self requestDataPostWithString:deleteString params:params successBlock:^(id responseObject){
        BaseModel *deleteModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:deleteModel.msg];
        if ([deleteModel.code isEqualToString:@"0000"]) {
            [weakself refreshHeaderOfMyStore];
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
