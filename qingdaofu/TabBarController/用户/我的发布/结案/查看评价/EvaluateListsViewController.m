//
//  EvaluateListsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateListsViewController.h"

#import "AdditionalEvaluateViewController.h" //追加评价

#import "BaseCommitView.h"
#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"

#import "EvaluateResponse.h"
#import "EvaluateModel.h"  //收到的评价
#import "LaunchEvaluateModel.h"  //给出的评价

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface EvaluateListsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *evaluateListTableView;
@property (nonatomic,strong) BaseCommitView *evaluateCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableArray *evaluateArray;
@property (nonatomic,strong) NSMutableArray *launchEvaluateArray;

@end

@implementation EvaluateListsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getAllEvaluetasContainGetingAndSending];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.evaluateListTableView];
    [self.view addSubview:self.evaluateCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaluateListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.evaluateListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.evaluateCommitView];
        
        [self.evaluateCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.evaluateCommitView autoSetDimension:ALDimensionHeight toSize:kCellHeight4];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)evaluateListTableView
{
    if (!_evaluateListTableView) {
        _evaluateListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _evaluateListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _evaluateListTableView.backgroundColor = kBackColor;
        _evaluateListTableView.separatorColor = kSeparateColor;
        _evaluateListTableView.delegate = self;
        _evaluateListTableView.dataSource = self;
        _evaluateListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _evaluateListTableView;
}

- (BaseCommitView *)evaluateCommitView
{
    if (!_evaluateCommitView) {
        _evaluateCommitView = [BaseCommitView newAutoLayoutView];
        [_evaluateCommitView.button setTitle:@"追加评价" forState:0];
       
        QDFWeakSelf;
        [_evaluateCommitView addAction:^(UIButton *btn) {
            AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
            additionalEvaluateVC.typeString = weakself.typeString;
            additionalEvaluateVC.idString = weakself.idString;
            additionalEvaluateVC.categoryString = weakself.categoryString;
            additionalEvaluateVC.evaString = @"1";
            
            UINavigationController *nasi = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
            [weakself presentViewController:nasi animated:YES completion:nil];
        }];
        
    }
    return _evaluateCommitView;
}

- (NSMutableArray *)evaluateArray
{
    if (!_evaluateArray) {
        _evaluateArray = [NSMutableArray array];
    }
    return _evaluateArray;
}

- (NSMutableArray *)launchEvaluateArray
{
    if (!_launchEvaluateArray) {
        _launchEvaluateArray = [NSMutableArray array];
    }
    return _launchEvaluateArray;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1+self.evaluateArray.count;
    }
    
    return 1+self.launchEvaluateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row > 0) {
        EvaluateModel *evaModel = self.evaluateArray[indexPath.row-1];
        if (evaModel.pictures.count > 0) {
            return 145;
        }else{
            return 80;
        }
        
    }else if (indexPath.section == 1 && indexPath.row > 0){
        LaunchEvaluateModel *launchEvaModel = self.launchEvaluateArray[indexPath.row-1];
        if (launchEvaModel.pictures.count > 0) {
            return 145;
        }else{
            return 80;
        }
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"evaGet0";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userActionButton setHidden:YES];
            
            NSString *evaGetString = [NSString stringWithFormat:@"收到的评价（ %lu ）",(unsigned long)self.evaluateArray.count];
            [cell.userNameButton setTitle:evaGetString forState:0];
            
            return cell;
        }
        
        //收到的评价
        identifier = @"evaGet1";
        EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.evaProductButton setHidden:YES];
        
        EvaluateModel *evaluateModel;
        if (self.evaluateArray.count > 0) {
            evaluateModel = self.evaluateArray[indexPath.row-1];
        }
        
//        cell.evaNameLabel.text = evaluateModel.mobile;
        [cell.evaNameButton setTitle:evaluateModel.mobile forState:0];
        
        cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:evaluateModel.action_at];
//        cell.evaStarImage.currentIndex = [evaluateModel.creditor integerValue];
        cell.evaTextLabel.text = evaluateModel.memo;
        
        if (evaluateModel.pictures.count == 0) {
            [cell.evaProImageView1 setHidden:YES];
            [cell.evaProImageView2 setHidden:YES];
        }else if (evaluateModel.pictures.count == 1){
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:YES];
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.pictures[0]];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            QDFWeakSelf;
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[imgUrl1]];
            }];
            
        }else{
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:NO];
            
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.pictures[0]];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];

            NSString *imgString2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.pictures[0]];
            NSURL *imgUrl2 = [NSURL URLWithString:imgString2];
            [cell.evaProImageView2 sd_setImageWithURL:imgUrl2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            QDFWeakSelf;
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[imgUrl1,imgUrl2]];
            }];
            [cell.evaProImageView2 addAction:^(UIButton *btn) {
                [weakself showImages:@[imgUrl1,imgUrl2]];
            }];
        }
        
        return cell;
    }
    
    //section=1
    if (indexPath.row == 0) {
        identifier = @"evaSend0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setHidden:YES];
        
        NSString *evaGetString = [NSString stringWithFormat:@"发出的评价（ %lu ）",(unsigned long)self.launchEvaluateArray.count];
        [cell.userNameButton setTitle:evaGetString forState:0];
        
        return cell;
    }
    
    //发出的评价
    identifier = @"evaSend1";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.evaProductButton setHidden:YES];
    
    LaunchEvaluateModel *launchEvaluateModel;
    if (self.launchEvaluateArray.count > 0) {
        launchEvaluateModel = self.launchEvaluateArray[indexPath.row-1];
    }
    
//    cell.evaNameLabel.textColor = kBlueColor;
//    cell.evaNameLabel.text = @"自己";
    [cell.evaNameButton setTitleColor:kBlueColor forState:0];
    [cell.evaNameButton setTitleColor:@"自己" forState:0];
    cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:launchEvaluateModel.create_time];
    cell.evaStarImage.currentIndex = [launchEvaluateModel.creditor integerValue];
    cell.evaTextLabel.text = launchEvaluateModel.content;
    
    if (launchEvaluateModel.pictures.count == 0) {
        [cell.evaProImageView1 setHidden:YES];
        [cell.evaProImageView2 setHidden:YES];
    }else if (launchEvaluateModel.pictures.count == 1){
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:YES];
        NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,launchEvaluateModel.pictures[0]];
        NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
        [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        QDFWeakSelf;
        [cell.evaProImageView1 addAction:^(UIButton *btn) {
            [weakself showImages:@[imgUrl1]];
        }];
        
    }else{
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:NO];
        
        NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,launchEvaluateModel.pictures[0]];
        NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
        [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        NSString *imgString2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,launchEvaluateModel.pictures[0]];
        NSURL *imgUrl2 = [NSURL URLWithString:imgString2];
        [cell.evaProImageView2 sd_setImageWithURL:imgUrl2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        QDFWeakSelf;
        [cell.evaProImageView1 addAction:^(UIButton *btn) {
            [weakself showImages:@[imgUrl1,imgUrl2]];
        }];
        [cell.evaProImageView2 addAction:^(UIButton *btn) {
            [weakself showImages:@[imgUrl1,imgUrl2]];
        }];
        
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kBigPadding;
    }
    return 0.1;
}

#pragma mark - method
- (void)getAllEvaluetasContainGetingAndSending
{
    NSString *allEvaContainString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyEvaluateString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categoryString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:allEvaContainString params:params successBlock:^(id responseObject) {
                
        [weakself.evaluateArray removeAllObjects];
        [weakself.launchEvaluateArray removeAllObjects];
        
        EvaluateResponse *evaResponse = [EvaluateResponse objectWithKeyValues:responseObject];
        
        for (EvaluateModel *evaluateModel in evaResponse.evaluate) {
            [weakself.evaluateArray addObject:evaluateModel];
        }
        
        for (LaunchEvaluateModel *launchEvaluateModel in evaResponse.launchevaluation) {
            [weakself.launchEvaluateArray addObject:launchEvaluateModel];
        }
        
        [weakself.evaluateListTableView reloadData];
        
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
