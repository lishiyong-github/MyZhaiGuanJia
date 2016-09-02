//
//  DelayHandleViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DelayHandleViewController.h"

#import "ReceiptActionCell.h"
#import "MineUserCell.h"
#import "ExeCell.h"
#import "EditDebtAddressCell.h"

@interface DelayHandleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *delayHandleTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation DelayHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"延期处理";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.delayHandleTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDelayDetails];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.delayHandleTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)delayHandleTableView
{
    if (!_delayHandleTableView) {
        _delayHandleTableView = [UITableView newAutoLayoutView];
        _delayHandleTableView.backgroundColor = kBackColor;
        _delayHandleTableView.separatorColor = kSeparateColor;
        _delayHandleTableView.delegate = self;
        _delayHandleTableView.dataSource = self;
        _delayHandleTableView.tableFooterView = [[UIView alloc] init];
        _delayHandleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _delayHandleTableView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kCellHeight;
    }else if (indexPath.row == 1){
        return 30;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"handle0";
        ReceiptActionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReceiptActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.reActButton1 setTitleColor:kBlackColor forState:0];
        cell.reActButton1.titleLabel.font = kBigFont;
        [cell.reActButton1 setTitle:@"延期申请" forState:0];
        
        [cell.reActButton2 setTitleColor:kBlackColor forState:0];
        [cell.reActButton2 setTitle:@"      拒绝      " forState:0];
        cell.reActButton2.layer.borderColor = kBorderColor.CGColor;
        cell.reActButton2.layer.borderWidth = kLineWidth;
        cell.reActButton2.layer.cornerRadius = corner1;
        cell.reActButton2.titleLabel.font = kFirstFont;
        
        [cell.reActButton3 setTitleColor:kNavColor forState:0];
        [cell.reActButton3 setBackgroundColor:kBlueColor];
        [cell.reActButton3 setTitle:@"      同意      " forState:0];
        cell.reActButton3.layer.cornerRadius = corner1;
        cell.reActButton3.titleLabel.font = kFirstFont;
        
        QDFWeakSelf;
        [cell setDidSelectedActbutton:^(NSInteger tag, UIButton *btn) {
            if (tag > 77) {
                [weakself delayRequestActionWithType:tag];
            }
        }];
        
        return cell;
        
    }else if (indexPath.row == 1){//ExeCell.h
        identifier = @"handle1";
        ExeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ExeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        
        NSString *delayDay = [NSString stringWithFormat:@"延期天数：%@天",@"3"];
        [cell.ceButton setTitle:delayDay forState:0];
        cell.ceButton.titleLabel.font = kFirstFont;
        
        return cell;
    }
    
    //row==2
    identifier = @"handle2";
    EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftTextViewConstraints.constant = 82;
    
    cell.ediLabel.text = @"延期原因：";
    cell.ediLabel.font = kFirstFont;

    cell.ediTextView.textColor = kGrayColor;
    cell.ediTextView.font = kFirstFont;
    cell.ediTextView.editable = NO;
    cell.ediTextView.text = @"延期原因延期原因延期原因延期原因延期原因延期原因延期原因延期原因延期原因延期原因延期原因延期原因";
    
    return cell;
}

#pragma mark - method
- (void)getDelayDetails
{
    NSString *delayDetaiString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDelayDetailsOfMyReleaseString];
    NSDictionary *params = @{@"id" : self.delayIdStr,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:delayDetaiString params:params successBlock:^(id responseObject) {
        NSDictionary *hiihi = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *hoho;
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)delayRequestActionWithType:(NSInteger )typeInt
{
    NSString *delayActString;
    if (typeInt == 78) {//拒绝
        delayActString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDisAgreeProductOfMyReleaseString];
    }else if(typeInt == 79){//同意
        delayActString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAgreeProductOfMyReleaseString];
    }
    NSDictionary *params = @{@"id" : self.delayIdStr,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:delayActString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];
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
