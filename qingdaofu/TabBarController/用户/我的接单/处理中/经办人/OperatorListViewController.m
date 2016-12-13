//
//  OperatorListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OperatorListViewController.h"

#import "MyMailListsViewController.h"  //通讯录

#import "MineUserCell.h"
#import "OperatorCell.h"  //经办人cell
#import "PowerCell.h"

#import "OperatorResponse.h"
#import "OperatorModel.h"
#import "ImageModel.h"
#import "OrderModel.h"

#import "UIButton+WebCache.h"

@interface OperatorListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *operatorListTableView;

@property (nonatomic,strong) NSMutableArray *operatorListArray;
@property (nonatomic,strong) NSString *userId;

@end

@implementation OperatorListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getOperatoeLists];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"经办人";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.operatorListTableView];
    
    [self.view setNeedsUpdateConstraints];
}

 -(void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.operatorListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)operatorListTableView
{
    if (!_operatorListTableView) {
        _operatorListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _operatorListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _operatorListTableView.backgroundColor = kBackColor;
        _operatorListTableView.separatorColor = kSeparateColor;
        _operatorListTableView.delegate = self;
        _operatorListTableView.dataSource = self;
    }
    return _operatorListTableView;
}

- (NSMutableArray *)operatorListArray
{
    if (!_operatorListArray) {
        _operatorListArray = [NSMutableArray array];
    }
    return _operatorListArray;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.operatorListArray.count > 0) {
        OperatorResponse *response = self.operatorListArray[0];
        if (response.accessOrdersADDOPERATOR && [response.orders.status integerValue] <= 20) {
            //可新增
            if (response.operators.count > 0) {
                return 3;
            }else{
                return 2;
            }
        }else{//只可查看
            if (response.operators.count > 0) {
                return 2;
            }else{
                return 1;
            }
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.operatorListArray.count > 0) {
        OperatorResponse *response = self.operatorListArray[0];
        if (response.accessOrdersADDOPERATOR && [response.orders.status integerValue] <= 20) {
            //可新增
            if (response.operators.count > 0) {
                if (section == 1) {
                    return response.operators.count;
                }
                return 1;
            }else{
                return 1;
            }
        }else{//只可查看
            if (response.operators.count > 0) {
                if (section == 0) {
                    return response.operators.count;
                }
                return 1;
            }else{
                return 1;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.operatorListArray.count > 0) {
        static NSString *identifier;
        OperatorResponse *response = self.operatorListArray[0];
        if (response.accessOrdersADDOPERATOR && [response.orders.status integerValue] <= 20) {//可编辑
            
            if (indexPath.section == 0) {//MineUserCell.h
                identifier = @"operator0";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.userNameButton setTitle:@" 从通讯录选择经办人" forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@"select_p"] forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                return cell;
                
            }else{
                if (response.operators.count > 0) {//已有经办人
                    if (indexPath.section == 2){
                        identifier = @"operator22";
                        PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (!cell) {
                            cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell.statusLabel setHidden:YES];
                        
                        OrderModel *orderModel = response.orders;
                        NSString *naanna = [NSString getValidStringFromString:orderModel.realname toString:orderModel.username];
                        [cell.orderButton setTitle:naanna forState:0];
                        
                        [cell.moreImageView setImage:[UIImage imageNamed:@"contacts_icon_mark"]];
                        return cell;
                    }else if(indexPath.section == 1){
                        identifier = @"operator11";
                        OperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        if (!cell) {
                            cell = [[OperatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
                        OperatorModel *operatorModel = response.operators[indexPath.row];
    
                        //aaButton
                        if ([operatorModel.level integerValue] == 1) {
                            [cell.aabutton setImage:[UIImage imageNamed:@"triangle"] forState:0];
                        }else if ([operatorModel.level integerValue] == 2){
                            [cell.aabutton setImage:[UIImage imageNamed:@"packet"] forState:0];
                        }
                        
                        //ddButton
                        if (![operatorModel.operatorid isEqualToString:response.userid]) {
                            [cell.ddButton setHidden:NO];
                            [cell.ddButton setImage:[UIImage imageNamed:@"phoneqq"] forState:0];
                        }else{
                            [cell.ddButton setHidden:YES];
                        }
    
                        NSString *picture = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,operatorModel.headimg.file];
                        [cell.bbButton sd_setImageWithURL:[NSURL URLWithString:picture] forState:0 placeholderImage:[UIImage imageNamed:@"contacts_icon_head"]];
                        
                        NSString *name = [NSString getValidStringFromString:operatorModel.realname toString:operatorModel.username];
                        [cell.ccButton setTitle:name forState:0];
                        
                        QDFWeakSelf;
                        [cell.ddButton addAction:^(UIButton *btn) {
                            if (weakself.rightButton.selected) {//编辑状态
                                [weakself deleteOperatorWithOperatorModel:operatorModel];
                            }else{
                                NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",operatorModel.mobile];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                            }
                        }];
                        return cell;
                    }
                }else{//没有经办人
                    identifier = @"operator1";
                    PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.statusLabel setHidden:YES];
                    
                    OrderModel *orderModel = response.orders;
                    NSString *naanna = [NSString getValidStringFromString:orderModel.realname toString:orderModel.username];
                    [cell.orderButton setTitle:naanna forState:0];
                    
                    [cell.moreImageView setImage:[UIImage imageNamed:@"contacts_icon_mark"]];
                    return cell;
                }
            }
        }
        
        //只可查看
        if (response.operators.count == 0) {
            //没有经办人
            if (indexPath.section == 0) {//显示接单方
                identifier = @"operator2220";
                PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.statusLabel setHidden:YES];
                
                OrderModel *orderModel = response.orders;
                NSString *naanna = [NSString getValidStringFromString:orderModel.realname toString:orderModel.username];
                [cell.orderButton setTitle:naanna forState:0];
                
                [cell.moreImageView setImage:[UIImage imageNamed:@"contacts_icon_mark"]];
                return cell;
            }
        }else{
            //有经办人
            if (indexPath.section == 1) {
                identifier = @"operator22221";
                PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[PowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.statusLabel setHidden:YES];
                
                OrderModel *orderModel = response.orders;
                NSString *naanna = [NSString getValidStringFromString:orderModel.realname toString:orderModel.username];
                [cell.orderButton setTitle:naanna forState:0];
                
                [cell.moreImageView setImage:[UIImage imageNamed:@"contacts_icon_mark"]];
                return cell;
    
            }else{//显示经办人列表
                identifier = @"operator22222";
                OperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[OperatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
                OperatorModel *operatorModel = response.operators[indexPath.row];
    
                //aaButton
                if ([operatorModel.level integerValue] == 1) {
                    [cell.aabutton setImage:[UIImage imageNamed:@"triangle"] forState:0];
                }else if ([operatorModel.level integerValue] == 2){
                    [cell.aabutton setImage:[UIImage imageNamed:@"packet"] forState:0];
                }
                
                //ddButton
                if (![operatorModel.operatorid isEqualToString:response.userid]) {
                    [cell.ddButton setHidden:NO];
                    [cell.ddButton setImage:[UIImage imageNamed:@"phoneqq"] forState:0];
                }else{
                    [cell.ddButton setHidden:YES];
                }
    
                NSString *picture = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,operatorModel.headimg.file];
                [cell.bbButton sd_setImageWithURL:[NSURL URLWithString:picture] forState:0 placeholderImage:[UIImage imageNamed:@"contacts_icon_head"]];
    
                NSString *name = [NSString getValidStringFromString:operatorModel.realname toString:operatorModel.username];
                [cell.ccButton setTitle:name forState:0];
                
                QDFWeakSelf;
                [cell.ddButton addAction:^(UIButton *btn) {
                    if (weakself.rightButton.selected) {//编辑状态
                        [weakself deleteOperatorWithOperatorModel:operatorModel];
                    }else{
                        NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",operatorModel.mobile];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                    }
                }];
                return cell;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.operatorListArray.count > 0) {
        OperatorResponse *response = self.operatorListArray[0];
        if (response.accessOrdersADDOPERATOR && [response.orders.status integerValue] <= 20) {
            if (indexPath.section == 0) {//从通讯录选择经办人
                MyMailListsViewController *myMailListsVC = [[MyMailListsViewController alloc] init];
                myMailListsVC.mailType = @"2";
                myMailListsVC.ordersid = self.ordersid;
                [self.navigationController pushViewController:myMailListsVC animated:YES];
            }        
        }
    }
}

#pragma mark - method
- (void)getOperatoeLists
{
    
    NSString *operatorString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetaulOfOperatorLists];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"ordersid" : self.ordersid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:operatorString params:params successBlock:^(id responseObject) {
        
        [weakself.operatorListArray removeAllObjects];
        
        OperatorResponse *responff = [OperatorResponse objectWithKeyValues:responseObject];
        
        [weakself.operatorListArray addObject:responff];
        
        if (responff.accessOrdersADDOPERATOR & ([responff.orders.status integerValue] <= 20)) {//编辑状态
            weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.rightButton];
            [weakself.rightButton setTitle:@"编辑" forState:0];
        }
        
        [weakself.operatorListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    self.rightButton.selected = !self.rightButton.selected;
    
    OperatorResponse *response = self.operatorListArray[0];
    
    if (self.rightButton.selected) {
        [self.rightButton setTitle:@"完成" forState:0];

        for (NSInteger i=0; i<response.operators.count; i++) {
            OperatorModel *operatorModel = response.operators[i];
            
            if ([operatorModel.create_by isEqualToString:response.userid]) {
                OperatorCell *cell = [self.operatorListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                [cell.ddButton setImage:[UIImage imageNamed:@"deleteaa"] forState:0];
            }
        }        
    }else{
        [self.rightButton setTitle:@"编辑" forState:0];
        for (NSInteger i=0; i<response.operators.count; i++) {
            OperatorModel *operatorModel = response.operators[i];
            
            if ([operatorModel.create_by isEqualToString:response.userid]) {
                OperatorCell *cell = [self.operatorListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                [cell.ddButton setImage:[UIImage imageNamed:@"phoneqq"] forState:0];
            }
        }
    }
}

- (void)deleteOperatorWithOperatorModel:(OperatorModel *)operatorModel
{
    NSString *deleteOpString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetaulOfDeleteOperator];
    NSDictionary *params = @{@"ordersid" : operatorModel.ordersid,
                             @"ids" : operatorModel.idString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:deleteOpString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getOperatoeLists];
        }
        
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
