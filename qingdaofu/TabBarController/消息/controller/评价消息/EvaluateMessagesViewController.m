//
//  EvaluateMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateMessagesViewController.h"
#import "MyClosingViewController.h"   //产品详情
#import "AdditionalEvaluateViewController.h"

#import "EvaTopSwitchView.h"
#import "EvaluatePhotoCell.h"

#import "EvaluateSendCell.h"  //发出评价

@interface EvaluateMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) EvaTopSwitchView *evaTopSwitchView;
@property (nonatomic,strong) UITableView *evaluateTableView;

@property (nonatomic,strong) NSString *tagString;
@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation EvaluateMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价消息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.evaTopSwitchView];
    [self.view addSubview:self.evaluateTableView];
    
    _tagString = @"get";
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaTopSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.evaTopSwitchView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.evaluateTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.evaluateTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaTopSwitchView];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)evaTopSwitchView
{
    if (!_evaTopSwitchView) {
        _evaTopSwitchView = [EvaTopSwitchView newAutoLayoutView];
        _evaTopSwitchView.backgroundColor = kNavColor;
        [_evaTopSwitchView.getbutton setTitle:@"收到的评价" forState:0];
        [_evaTopSwitchView.sendButton setTitle:@"发出的评价" forState:0];
        
        QDFWeakSelf;
        [_evaTopSwitchView setDidSelectedButton:^(NSInteger buttonTag) {
            if (buttonTag == 33) {//收到的
                _tagString = @"get";
                [weakself.evaTopSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakself.evaTopSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                
                [weakself.evaluateTableView reloadData];
                
            }else{//发出的
                _tagString = @"send";
                [weakself.evaTopSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakself.evaTopSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                
                [weakself.evaluateTableView reloadData];
            }
        }];
    }
    return _evaTopSwitchView;
}

- (UITableView *)evaluateTableView
{
    if (!_evaluateTableView) {
//        _evaluateTableView = [UITableView newAutoLayoutView];
        _evaluateTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _evaluateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _evaluateTableView.delegate = self;
        _evaluateTableView.dataSource = self;
        _evaluateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _evaluateTableView.backgroundColor = kBackColor;
    }
    return _evaluateTableView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"1111",@"2222",@"3333",@"4444",@"5555",@"6666",@"7777",@"8888",@"9999",@"00000", nil];
    }
    return _dataList;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_tagString isEqualToString:@"get"]) {
        return 10;
    }
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tagString isEqualToString:@"send"]) {
        return 265;
    }
    
    return 225;
    
    //（收到）
//    return 165;//无image
//    return 225;//有image
    
    //（ 发出）
//    return 205;   //无image
//    return 265;   //有image
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    EvaluateSendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluateSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.evaNameLabel.text = self.dataList[indexPath.section];
    //@"12345678900";
    cell.evaTimeLabel.text = @"2016-10-10";
    [cell.evaStarImageView setBackgroundColor:kBlueColor];
    cell.evaTextLabel.text = @"还行，还行，还行";
    [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
    [cell.evaInnnerButton setTitle:@"RZ201605200001" forState:0];
    
    QDFWeakSelf;
    [cell.evaProductButton addAction:^(UIButton *btn) {
        MyClosingViewController *myCloseVC = [[MyClosingViewController alloc] init];
        [weakself.navigationController pushViewController:myCloseVC animated:YES];
    }];
    
    if ([_tagString isEqualToString:@"get"]) {
        [cell.evaDeleteButton setHidden:YES];
        [cell.evaAdditionButton setHidden:YES];
    }else if ([_tagString isEqualToString:@"send"]) {
        [cell.evaDeleteButton setHidden:NO];
        [cell.evaAdditionButton setHidden:NO];
        [cell.evaDeleteButton setTitle:@"删除" forState:0];
        [cell.evaAdditionButton setTitle:@"追加评论" forState:0];
        
        [cell setDidSelectedIndex:^(NSInteger btnTag) {
            if (btnTag == 444) {
                NSIndexSet *deleteIndexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                [weakself.dataList removeObjectAtIndex:indexPath.section];
                [weakself deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationLeft];
            }else{
                AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
                [weakself.navigationController pushViewController:additionalEvaluateVC animated:YES];
            }
        }];
    }
    
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

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.evaluateTableView reloadData];
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
