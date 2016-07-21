//
//  EvaluateMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateMessagesViewController.h"
#import "MyClosingViewController.h"   //我的接单－结案
#import "ReleaseCloseViewController.h"  //我的发布－结案
#import "AdditionalEvaluateViewController.h"

#import "EvaTopSwitchView.h"
#import "EvaluatePhotoCell.h"

#import "EvaluateSendCell.h"  //发出评价

#import "EvaluateResponse.h"
#import "EvaluateModel.h"
#import "LaunchEvaluateModel.h"

#import "MessageModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface EvaluateMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) EvaTopSwitchView *evaTopSwitchView;
@property (nonatomic,strong) UITableView *evaluateTableView;

@property (nonatomic,strong) NSString *tagString;

//json
@property (nonatomic,assign) NSInteger pageList;
@property (nonatomic,strong) NSMutableArray *evaluateListArray;  //收到的评价
@property (nonatomic,strong) NSMutableArray *launchEvaListArray;  //发出的评价

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
    
    [self headerRefreshOfList];
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
        [_evaTopSwitchView.sendButton setTitle:@"给出的评价" forState:0];
        
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
        _evaluateTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _evaluateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _evaluateTableView.delegate = self;
        _evaluateTableView.dataSource = self;
        _evaluateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _evaluateTableView.backgroundColor = kBackColor;
        [_evaluateTableView addFooterWithTarget:self action:@selector(footerRefreshOfList)];
        [_evaluateTableView addHeaderWithTarget:self action:@selector(headerRefreshOfList)];
    }
    return _evaluateTableView;
}

- (NSMutableArray *)evaluateListArray
{
    if (!_evaluateListArray) {
        _evaluateListArray = [NSMutableArray array];
    }
    return _evaluateListArray;
}

- (NSMutableArray *)launchEvaListArray
{
    if (!_launchEvaListArray) {
        _launchEvaListArray = [NSMutableArray array];
    }
    return _launchEvaListArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_tagString isEqualToString:@"get"]) {
        return self.evaluateListArray.count;
    }
    return self.launchEvaListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tagString isEqualToString:@"send"]) {
        
        LaunchEvaluateModel *model = self.launchEvaListArray[indexPath.section];
        if ([model.pictures isEqualToArray:@[]] || [model.pictures[0] isEqualToString:@""]) {
            return 185;
        }else{
            return 245;
        }
    }
    
    EvaluateModel *model = self.evaluateListArray[indexPath.section];
    if ([model.pictures isEqualToArray:@[]] || [model.pictures[0] isEqualToString:@""]) {
        return 145;
    }else{
        return 205;
    }
    
    return 0;
//    return 225;
    
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
    
    QDFWeakSelf;
    if ([_tagString isEqualToString:@"get"]) {//收到的评价
        EvaluateModel *evaModel = self.evaluateListArray[indexPath.section];
        cell.evaNameLabel.text = evaModel.mobile;
        cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:evaModel.create_time];
        cell.evaStarImageView.currentIndex = [evaModel.creditor integerValue];
        cell.evaTextLabel.text = evaModel.content;
        [cell.evaInnnerButton setTitle:evaModel.code forState:0];
        [cell.evaDeleteButton setHidden:YES];
        [cell.evaAdditionButton setHidden:YES];
        
        //图片
        if (evaModel.pictures.count == 1) {
            if ([evaModel.pictures[0] isEqualToString:@""]) {//没有图片
                cell.topProConstraints.constant = 90;
                [cell.evaProImageViews1 setHidden:YES];
                [cell.evaProImageViews2 setHidden:YES];
            }else{//有图片
                cell.topProConstraints.constant = 150;
                [cell.evaProImageViews1 setHidden:NO];
                [cell.evaProImageViews2 setHidden:YES];
                NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
                NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                NSURL *url1 = [NSURL URLWithString:imageStr1];
                
                [cell.evaProImageViews1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageViews1 addAction:^(UIButton *btn) {
                    [weakself showImages:@[url1]];
                }];
            }
        }else if (evaModel.pictures.count >= 2){
            cell.topProConstraints.constant = 150;
            [cell.evaProImageViews1 setHidden:NO];
            [cell.evaProImageViews2 setHidden:NO];
            NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
            NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
            NSURL *url1 = [NSURL URLWithString:imageStr1];
            NSString *str2 = [evaModel.pictures[1] substringWithRange:NSMakeRange(1, [evaModel.pictures[1] length]-2)];
            NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
            NSURL *url2 = [NSURL URLWithString:imageStr2];
            
            [cell.evaProImageViews1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageViews2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageViews1 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
            [cell.evaProImageViews2 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
        }
        
        //产品分类图片
        if ([evaModel.category integerValue] == 1) {//list_financing
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
        }else if ([evaModel.category integerValue] == 2){//list_collection
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
        }else{//list_litigation
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
        }
        
        [cell.evaProductButton addAction:^(UIButton *btn) {
            [weakself messageIsReadWithId:evaModel.product_id andUid:evaModel.buid andCuid:evaModel.cuid andCategory:evaModel.category andFrequency:evaModel.frequency];
        }];
        
    }else{//给出的评价
        LaunchEvaluateModel *launchEvaModel = self.launchEvaListArray[indexPath.section];
        cell.evaNameLabel.text = launchEvaModel.mobile;
        cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:launchEvaModel.create_time];
        cell.evaStarImageView.currentIndex = [launchEvaModel.creditor integerValue];
        cell.evaTextLabel.text = launchEvaModel.content;
        [cell.evaInnnerButton setTitle:launchEvaModel.code forState:0];
        [cell.evaDeleteButton setHidden:NO];
        [cell.evaDeleteButton setTitle:@"删除" forState:0];
        [cell.evaDeleteButton addAction:^(UIButton *btn) {
            NSString *sid = [NSString getValidStringFromString:launchEvaModel.sid toString:@"0"];
            [weakself deleteEvaluateWithSection:indexPath.section andId:launchEvaModel.idString andSid:sid];
        }];
        
        if ([launchEvaModel.frequency integerValue] >= 2) {
            [cell.evaAdditionButton setHidden:YES];
        }else{
            [cell.evaAdditionButton setHidden:NO];
            [cell.evaAdditionButton setTitle:@"追加评论" forState:0];
            [cell.evaAdditionButton addAction:^(UIButton *btn) {
                AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
                additionalEvaluateVC.idString = launchEvaModel.idString;
                additionalEvaluateVC.categoryString = launchEvaModel.category;
                additionalEvaluateVC.codeString = launchEvaModel.code;
                additionalEvaluateVC.evaString = launchEvaModel.frequency;
                if ([launchEvaModel.uidInner isEqualToString:launchEvaModel.cuid]) {
                    additionalEvaluateVC.typeString = @"发布方";
                }
                [weakself.navigationController pushViewController:additionalEvaluateVC animated:YES];
            }];
        }
        
        //图片
        if (launchEvaModel.pictures.count == 1) {
            if ([launchEvaModel.pictures[0] isEqualToString:@""]) {//没有图片
                cell.topProConstraints.constant = 90;
                [cell.evaProImageViews1 setHidden:YES];
                [cell.evaProImageViews2 setHidden:YES];
            }else{//有图片
                cell.topProConstraints.constant = 150;
                [cell.evaProImageViews1 setHidden:NO];
                [cell.evaProImageViews2 setHidden:YES];
                NSString *str1 = [launchEvaModel.pictures[0] substringWithRange:NSMakeRange(1, [launchEvaModel.pictures[0] length]-2)];
                NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                NSURL *url1 = [NSURL URLWithString:imageStr1];
                
                [cell.evaProImageViews1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageViews1 addAction:^(UIButton *btn) {
                    [weakself showImages:@[url1]];
                }];
            }
        }else if (launchEvaModel.pictures.count >= 2){
            cell.topProConstraints.constant = 150;
            [cell.evaProImageViews1 setHidden:NO];
            [cell.evaProImageViews2 setHidden:NO];
            NSString *str1 = [launchEvaModel.pictures[0] substringWithRange:NSMakeRange(1, [launchEvaModel.pictures[0] length]-2)];
            NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
            NSURL *url1 = [NSURL URLWithString:imageStr1];
            NSString *str2 = [launchEvaModel.pictures[1] substringWithRange:NSMakeRange(1, [launchEvaModel.pictures[1] length]-2)];
            NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
            NSURL *url2 = [NSURL URLWithString:imageStr2];
            
            [cell.evaProImageViews1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageViews2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            [cell.evaProImageViews1 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
            [cell.evaProImageViews2 addAction:^(UIButton *btn) {
                [weakself showImages:@[url1,url2]];
            }];
        }

        //产品分类图片
        if ([launchEvaModel.category integerValue] == 1) {
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
        }else if ([launchEvaModel.category integerValue] == 2){//list_collection
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_collection"] forState:0];
        }else{//list_litigation
            [cell.evaInnnerButton setImage:[UIImage imageNamed:@"list_litigation"] forState:0];
        }
        
        [cell.evaProductButton addAction:^(UIButton *btn) {
            [weakself messageIsReadWithId:launchEvaModel.product_id andUid:launchEvaModel.uidInner andCuid:launchEvaModel.cuid andCategory:launchEvaModel.category andFrequency:launchEvaModel.frequency];
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

#pragma mark - refresh
- (void)getListOfEvaluateListWithPage:(NSString *)page
{
    NSString *listString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfEvaluateString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    [self requestDataPostWithString:listString params:params successBlock:^(id responseObject) {
        
        NSDictionary *jojoj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self.evaluateListArray removeAllObjects];
        [self.launchEvaListArray removeAllObjects];
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        
        for (EvaluateModel *evaModel in response.evaluate) {
            [self.evaluateListArray addObject:evaModel];
        }
        
        for (LaunchEvaluateModel *launchEvaModel in response.launchevaluation) {
            [self.launchEvaListArray addObject:launchEvaModel];
        }
        
        if ([_tagString isEqualToString:@"get"]) {
            if (self.evaluateListArray.count > 0) {
            }else{
//                [self.baseRemindImageView setHidden:NO];
                _pageList--;
            }
        }else{
            if (self.launchEvaListArray.count > 0) {
            }else{
//                [self.baseRemindImageView setHidden:NO];
                _pageList--;
            }
        }
        
        [self.evaluateTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfList
{
    _pageList = 1;
    [self getListOfEvaluateListWithPage:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.evaluateTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfList
{
    _pageList++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageList];
    [self getListOfEvaluateListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.evaluateTableView footerEndRefreshing];
    });
}

#pragma mark - read
- (void)messageIsReadWithId:(NSString *)idStr andUid:(NSString *)uidStr andCuid:(NSString *)cuidStr andCategory:(NSString *)categoryStr andFrequency:(NSString *)frequency
{
    NSString *isReadString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageIsReadString];
    NSDictionary *params = @{@"id" : idStr,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:isReadString params:params successBlock:^(id responseObject) {
        
        BaseModel *aModel = [BaseModel objectWithKeyValues:responseObject];
        if ([aModel.code isEqualToString:@"0000"]) {
            if ([uidStr isEqualToString:cuidStr]) {//发布
                ReleaseCloseViewController *releaseCloseVC = [[ReleaseCloseViewController alloc] init];
                releaseCloseVC.evaString = frequency;
                releaseCloseVC.idString = idStr;
                releaseCloseVC.categaryString = categoryStr;
                releaseCloseVC.pidString = uidStr;
                [weakself.navigationController pushViewController:releaseCloseVC animated:YES];
            }else{//接单
                MyClosingViewController *myClosingVC = [[MyClosingViewController alloc] init];
                myClosingVC.evaString = frequency;
                myClosingVC.idString = idStr;
                myClosingVC.categaryString = categoryStr;
                myClosingVC.pidString = uidStr;
                [weakself.navigationController pushViewController:myClosingVC animated:YES];
            }
        }else{
            [weakself showHint:aModel.msg];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - delete
- (void)deleteEvaluateWithSection:(NSInteger)section andId:(NSString *)idStr andSid:(NSString *)sidStr
{
    NSString *deleteString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMessageOfDeleteString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : idStr,
                             @"sid" : sidStr
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:deleteString params:params successBlock:^(id responseObject) {
        
        BaseModel *yModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:yModel.msg];
        if ([yModel.code isEqualToString:@"0000"]) {
            NSIndexSet *deleteIndexSet = [NSIndexSet indexSetWithIndex:section];
            [weakself.launchEvaListArray removeObjectAtIndex:section];
            [weakself deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationMiddle];
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
