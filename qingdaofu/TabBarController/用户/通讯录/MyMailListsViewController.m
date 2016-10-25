//
//  MyMailListsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyMailListsViewController.h"

#import "MineUserCell.h"

#import "MailResponse.h"
#import "MailResponseModel.h"
#import "MailModel.h"

@interface MyMailListsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myMailListsTableView;
@property (nonatomic,strong) UIView *chooseOperatorView;

@property (nonatomic,strong) UIAlertController *alertContro;

//json
@property (nonatomic,strong) NSMutableArray *myMailDataArray;
@property (nonatomic,strong) NSString *textFieldTextString;
@property (nonatomic,assign) NSInteger pageMail;

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
    }
    return _myMailListsTableView;
}

- (UIView *)chooseOperatorView
{
    if (!_chooseOperatorView) {
        _chooseOperatorView = [UIView newAutoLayoutView];
        _chooseOperatorView.backgroundColor = kRedColor;
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
        cell.userNameButton.userInteractionEnabled = YES;
        [cell.userNameButton setImage:[UIImage imageNamed:@"select"] forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//        [cell.userNameButton setTitle:@"    张三" forState:0];
        NSString *name = [NSString stringWithFormat:@"    %@",mailResponseModel.username];
        [cell.userNameButton setTitle:name forState:0];
        
        [cell.userNameButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
    }else{
        [cell.userNameButton setTitle:mailResponseModel.username forState:0];
    }
    
    return cell;
}

#pragma mark - method
- (void)rightItemAction
{
    self.alertContro = [UIAlertController alertControllerWithTitle:@"添加联系人" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    
    QDFWeakSelf;
    [self.alertContro addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"请输入手机号码";
        textField.delegate = weakself;
//        textField.background = [UIImage imageNamed:@"list_more"];
    }];
    
    UIAlertAction *alertAct0 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确认  " style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself searchUserWithPhone:@""];
    }];
    
    [self.alertContro addAction:alertAct0];
    [self.alertContro addAction:alertAct1];
    
    [self presentViewController:self.alertContro animated:YES completion:nil];
}

#pragma mark - search users//contacts/search
- (void)getListsOfMyMailWithPage:(NSString *)page
{
    NSString *listsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyMailListString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"limit" : @"10"
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:listsString params:params successBlock:^(id responseObject) {
        NSDictionary *sosos = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSString *koko;
        
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
    [self presentViewController:self.alertContro animated:YES completion:nil];
    
    [self.view endEditing:YES];
    NSString *searchUserString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyMailOfSearchUserString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"mobile" : self.textFieldTextString
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:searchUserString params:params successBlock:^(id responseObject) {
        
        MailModel *mailModel = [MailModel objectWithKeyValues:responseObject];
        
        NSString *name = mailModel.realname;
        NSString *phone = mailModel.mobile;
                
        [weakself.alertContro addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            NSString *sososo = [NSString stringWithFormat:@"%@\n%@",name,phone];
            textField.text = sososo;
            textField.userInteractionEnabled = NO;
            
            [weakself confirmToAddContactWithUserId:mailModel.userid];
        }];
        
        
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
