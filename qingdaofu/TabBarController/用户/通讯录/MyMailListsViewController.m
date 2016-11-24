//
//  MyMailListsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyMailListsViewController.h"

#import "ChooseOperatorView.h"
#import "MineUserCell.h"

#import "MailResponse.h"
#import "MailResponseModel.h"
#import "MailModel.h"

@interface MyMailListsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myMailListsTableView;
@property (nonatomic,strong) ChooseOperatorView *chooseOperatorView;

//@property (nonatomic,strong) UIAlertController *alertContro;

//json
@property (nonatomic,strong) NSMutableArray *myMailDataArray;
@property (nonatomic,strong) NSString *textFieldTextString;
@property (nonatomic,assign) NSInteger pageMail;
@property (nonatomic,strong) NSMutableArray *operatorArray;  //选择的经办人

@end

@implementation MyMailListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"添加" forState:0];
    
    [self.view addSubview:self.myMailListsTableView];
    
    if ([self.mailType integerValue] == 2) {
        [self.view addSubview:self.chooseOperatorView];
    }
    [self.view setNeedsUpdateConstraints];
    
    [self headerRefreshOfMyMail];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.mailType integerValue] == 2) {
            [self.myMailListsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.myMailListsTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chooseOperatorView];
            
            [self.chooseOperatorView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.chooseOperatorView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        }else{
            [self.myMailListsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myMailListsTableView
{
    if (!_myMailListsTableView) {
        _myMailListsTableView = [UITableView newAutoLayoutView];
        _myMailListsTableView.backgroundColor = kBackColor;
        _myMailListsTableView.separatorColor = kSeparateColor;
        _myMailListsTableView.delegate = self;
        _myMailListsTableView.dataSource = self;
        _myMailListsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myMailListsTableView.tableFooterView = [[UIView alloc] init];
        [_myMailListsTableView addHeaderWithTarget:self action:@selector(headerRefreshOfMyMail)];
        [_myMailListsTableView addHeaderWithTarget:self action:@selector(footerRefreshOfMyMail)];
    }
    return _myMailListsTableView;
}

- (UIView *)chooseOperatorView
{
    if (!_chooseOperatorView) {
        _chooseOperatorView = [ChooseOperatorView newAutoLayoutView];
        [_chooseOperatorView.aButton setTitle:@"已选择0个联系人" forState:0];
        
        QDFWeakSelf;
        [_chooseOperatorView.bButton addAction:^(UIButton *btn) {
            [weakself addOperators];
//            if (weakself.operatorArray.count > 0) {
//            }else{
//                [weakself showHint:@"请选择联系人"];
//            }
        }];
    }
    return _chooseOperatorView;
}

- (NSMutableArray *)myMailDataArray
{
    if (!_myMailDataArray) {
        _myMailDataArray = [NSMutableArray array];
    }
    return _myMailDataArray;
}

- (NSMutableArray *)operatorArray
{
    if (!_operatorArray) {
        _operatorArray = [NSMutableArray array];
    }
    return _operatorArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myMailDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myMail";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//蓝色选中， 未选择selected@2x ,select ,灰色已选中selected_dis@2x
    
    MailResponseModel *mailResponseModel = self.myMailDataArray[indexPath.row];
    
    [cell.userActionButton setTitle:mailResponseModel.mobile forState:0];
    
    if ([self.mailType integerValue] == 2) {
        
        if (!mailResponseModel.level) {
            cell.userNameButton.userInteractionEnabled = YES;
            [cell.userNameButton setImage:[UIImage imageNamed:@"select"] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        }else{
            cell.userNameButton.userInteractionEnabled = NO;
            [cell.userNameButton setImage:[UIImage imageNamed:@"selected_dis"] forState:0];
        }
        
        NSString *name = [NSString stringWithFormat:@"  %@",mailResponseModel.username];
        [cell.userNameButton setTitle:name forState:0];
        
        QDFWeakSelf;
        [cell.userNameButton addAction:^(UIButton *btn) {
            
            btn.selected = !btn.selected;
            
            if (btn.selected) {
                [weakself.operatorArray addObject:mailResponseModel.userid];
            }else{
                [weakself.operatorArray removeObject:mailResponseModel.userid];
            }
            
            NSString *allString = [NSString stringWithFormat:@"已选择%lu个联系人",(unsigned long)weakself.operatorArray.count];
            [weakself.chooseOperatorView.aButton setTitle:allString forState:0];
            
        }];
        
    }else{
        [cell.userNameButton setTitle:mailResponseModel.username forState:0];
    }
    
    return cell;
}

#pragma mark - search users//contacts/search
- (void)getListsOfMyMailWithPage:(NSString *)page
{
    NSString *listsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyMailListString];
    NSDictionary *params;
    if (!self.ordersid) {
        params = @{@"token" : [self getValidateToken],
                    @"page" : page,
                    @"limit" : @"10"
                   };
    }else{
        params = @{@"token" : [self getValidateToken],
                   @"page" : page,
                   @"limit" : @"10",
                   @"ordersid" : self.ordersid
                   };
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:listsString params:params successBlock:^(id responseObject) {
        NSDictionary *sosos = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([page integerValue] == 1) {
            [weakself.myMailDataArray removeAllObjects];
        }
        
        MailResponse *resoibf = [MailResponse objectWithKeyValues:responseObject];
        
        for (MailResponseModel *mailResponseModel in resoibf.data) {
            [weakself.myMailDataArray addObject:mailResponseModel];
        }
        
        if (resoibf.data.count <= 0) {
            _pageMail--;
            [weakself showSuitHint:@"没有更多了"];
        }
        
        [weakself.myMailListsTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfMyMail
{
    _pageMail = 1;
    [self getListsOfMyMailWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.myMailListsTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfMyMail
{
    _pageMail++;
    NSString *page  = [NSString stringWithFormat:@"%ld",(long)_pageMail];
    [self getListsOfMyMailWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.myMailListsTableView footerEndRefreshing];
    });
}

- (void)searchUserWithPhone:(NSString *)phoneString
{
    [self.view endEditing:YES];
    NSString *searchUserString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyMailOfSearchUserString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"mobile" : self.textFieldTextString
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:searchUserString params:params successBlock:^(id responseObject) {
        
        NSDictionary *aoaoa = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        MailModel *mailModel = [MailModel objectWithKeyValues:responseObject];
        
        NSString *ssss;
        if ([mailModel.code isEqualToString:@"0000"]) {
            NSString *name = [NSString getValidStringFromString:mailModel.username toString:mailModel.realname];
            ssss = [NSString stringWithFormat:@"%@\n%@",name,mailModel.mobile];
        }else{
            ssss = mailModel.msg;
        }
        UIAlertController *resultAlert = [UIAlertController alertControllerWithTitle:@"添加联系人" message:ssss preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAct0 = [UIAlertAction actionWithTitle:@"重新输入" style:0 handler:^(UIAlertAction * _Nonnull action) {
            [weakself rightItemAction];
        }];
        
        UIAlertAction *alertAct1;
        if ([mailModel.code isEqualToString:@"0000"]) {
            alertAct1 = [UIAlertAction actionWithTitle:@"确认添加" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [weakself confirmToAddContactWithUserId:mailModel.ID];
            }];
        }else{
            alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
        }
        
        [resultAlert addAction:alertAct0];
        [resultAlert addAction:alertAct1];
        
        [weakself presentViewController:resultAlert animated:YES completion:nil];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)confirmToAddContactWithUserId:(NSString *)userId
{
    NSString *confirmAddString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyMailOfAddUserString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"userid" : userId
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:confirmAddString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself headerRefreshOfMyMail];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - textField delegate 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldTextString = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - method
- (void)addOperators//分配经办人
{
    NSString *addOperatorString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetaulOfAddOperator];
    
    NSString *ppp = @"";
    NSDictionary *params;
    
    if (self.operatorArray.count > 0) {
        for (int i=0; i<self.operatorArray.count; i++) {
            ppp = [NSString stringWithFormat:@"%@,%@",self.operatorArray[i],ppp];
        }
        ppp = [ppp substringWithRange:NSMakeRange(0, ppp.length-1)];
        params = @{@"token" : [self getValidateToken],
                   @"ordersid" : self.ordersid,
                   @"operatorIds" : ppp
                   };
    }else{
        params = @{@"token" : [self getValidateToken],
                   @"ordersid" : self.ordersid
                   };
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:addOperatorString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"添加联系人" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入手机号码";
        textField.delegate = weakself;
        //        textField.background = [UIImage imageNamed:@"list_more"];
    }];
    
    UIAlertAction *alertAct0 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确认  " style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself searchUserWithPhone:@""];
    }];
    
    [alertControl addAction:alertAct0];
    [alertControl addAction:alertAct1];
    
    [self presentViewController:alertControl animated:YES completion:nil];
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
