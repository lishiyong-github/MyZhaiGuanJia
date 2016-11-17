//
//  MoreMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MoreMessagesViewController.h"
#import "ReportSuitViewController.h"  //编辑

#import "MineUserCell.h"

#import "PublishingResponse.h"
#import "RowsModel.h"

@interface MoreMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *moreMessageTableView;

//json
@property (nonatomic,strong) NSMutableArray *moreMessageArray;

@end

@implementation MoreMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getMoreMessagesOfProduct];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.moreMessageTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.moreMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)moreMessageTableView
{
    if (!_moreMessageTableView) {
        _moreMessageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _moreMessageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _moreMessageTableView.backgroundColor = kBackColor;
        _moreMessageTableView.separatorColor = kSeparateColor;
        _moreMessageTableView.delegate = self;
        _moreMessageTableView.dataSource = self;
    }
    return _moreMessageTableView;
}

- (NSMutableArray *)moreMessageArray
{
    if (!_moreMessageArray) {
        _moreMessageArray = [NSMutableArray array];
    }
    return _moreMessageArray;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.moreMessageArray.count > 0) {
        return 1;
    }
    return 0;
//    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else{
        
        if (self.moreMessageArray.count > 0) {
            PublishingResponse *response = self.moreMessageArray[0];
            RowsModel *rowModel = response.data;
            
            //房产抵押，机动车抵押，合同纠纷
            if ([rowModel.statusLabel containsString:@"发布"] || [rowModel.statusLabel containsString:@"面谈"]) {
                if (section == 1){
                    return 1+rowModel.productMortgages1.count;
                }else if (section == 2){
                    return 1+rowModel.productMortgages2.count;
                }else{
                    return 1+rowModel.productMortgages3.count;
                }
            }else{
                if (section == 1){
                    return rowModel.productMortgages1.count;
                }else if (section == 2){
                    return rowModel.productMortgages2.count;
                }else{
                    return rowModel.productMortgages3.count;
                }
            }
        }
        return 0;
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
    if (indexPath.section == 0) {
        identifier = @"moreMes0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PublishingResponse *response = self.moreMessageArray[0];
        RowsModel *dataModel = response.data;
        
        NSArray *www;
        if ([dataModel.typeLabel isEqualToString:@"万"]) {
            www = @[@"基本信息",@"债权类型",@"委托事项",@"委托金额",@"固定费用",@"违约期限",@"合同履行地"];
        }else if([dataModel.typeLabel isEqualToString:@"%"]){
            www = @[@"基本信息",@"债权类型",@"委托事项",@"委托金额",@"风险费率",@"违约期限",@"合同履行地"];
        }
        [cell.userNameButton setTitle:www[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlackColor forState:0];
            cell.userNameButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitleColor:kTextColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            if ([dataModel.statusLabel containsString:@"发布"] || [dataModel.statusLabel containsString:@"面谈"]) {
                [cell.userActionButton setTitle:@"编辑" forState:0];
                cell.userActionButton.userInteractionEnabled = YES;
                
                QDFWeakSelf;
                [cell.userActionButton addAction:^(UIButton *btn) {
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.tagString = @"3";
                    reportSuitVC.productid = dataModel.productid;
                    UINavigationController *nabb = [[UINavigationController alloc] initWithRootViewController:reportSuitVC];
                    [weakself presentViewController:nabb animated:YES completion:nil];
                }];
            }else{
                [cell.userActionButton setTitle:@"" forState:0];
            }
        }else {
            
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            if (indexPath.row == 1){
                [cell.userActionButton setTitle:dataModel.categoryLabel forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:dataModel.entrustLabel forState:0];
            }else if (indexPath.row == 3){
                [cell.userActionButton setTitle:dataModel.accountLabel forState:0];
            }else if (indexPath.row == 4){
                NSString *tytenum = [NSString stringWithFormat:@"%@%@",dataModel.typenumLabel,dataModel.typeLabel];
                [cell.userActionButton setTitle:tytenum forState:0];
            }else if (indexPath.row == 5){
                NSString *overdue = [NSString stringWithFormat:@"%@个月",dataModel.overdue];
                [cell.userActionButton setTitle:overdue forState:0];
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:dataModel.addressLabel forState:0];
            }
        }
        return cell;
    }else{
        
        if (self.moreMessageArray.count > 0) {
            PublishingResponse *response = self.moreMessageArray[0];
            RowsModel *rowModel = response.data;
            if ([rowModel.statusLabel containsString:@"发布"] || [rowModel.statusLabel containsString:@"面谈"]) {//可以添加
                
            }else{//无添加功能
                
                if (rowModel.productMortgages1.count > 0) {

                    if (indexPath.section == 1) {
                        identifier = @"moreMes1";
                        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (!cell) {
                            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        [cell.userNameButton setTitle:@"房产抵押" forState:0];
                        
                        return cell;
                    }
                    
                }else{
                   
                }
                
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - method
- (void)getMoreMessagesOfProduct
{
    NSString *moreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfMoreMessages];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:moreString params:params successBlock:^(id responseObject) {
        
        [weakself.moreMessageArray removeAllObjects];
                
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        weakself.title = response.data.number;
        
        [weakself.moreMessageArray addObject:response];
        
        [weakself.moreMessageTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
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
