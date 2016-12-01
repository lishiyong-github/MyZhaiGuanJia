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

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface EvaluateListsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *evaluateListTableView;
@property (nonatomic,strong) BaseCommitView *evaluateCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableArray *evaluateArray;
@property (nonatomic,strong) NSMutableArray *twiceEvaluateArray;

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
            additionalEvaluateVC.evaString = @"1";
            additionalEvaluateVC.typeString = weakself.typeString;
            additionalEvaluateVC.ordersid = weakself.ordersid;
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

- (NSMutableArray *)twiceEvaluateArray
{
    if (!_twiceEvaluateArray) {
        _twiceEvaluateArray = [NSMutableArray array];
    }
    return _twiceEvaluateArray;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.twiceEvaluateArray.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1+self.evaluateArray.count;
    }
    
    return 1+self.twiceEvaluateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row > 0) {
        EvaluateModel *evaModel = self.evaluateArray[indexPath.row-1];
        if (evaModel.filesImg.count > 0) {
            return 150;
        }else{
            return 85;
        }
    }else if (indexPath.section == 1 && indexPath.row > 0){
        EvaluateModel *evaModel = self.twiceEvaluateArray[indexPath.row-1];
        if (evaModel.filesImg.count > 0) {
            return 130;
        }else{
            return 65;
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
            
            [cell.userNameButton setTitle:@"评价" forState:0];
            
            return cell;
        }
        
        //评价
        identifier = @"evaGet1";
        EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        EvaluateModel *evaluateModel = self.evaluateArray[indexPath.row-1];
        
        //user image
        NSString *sosos = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.headimg.file];
        [cell.evaNameButton sd_setImageWithURL:[NSURL URLWithString:sosos] forState:0 placeholderImage:nil];
        
        //user name
        NSString *nanan = [NSString getValidStringFromString:evaluateModel.realname toString:evaluateModel.username];
        [cell.evaNameLabel setText:nanan];
        
        //time
        cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:evaluateModel.action_at];
        
        //star
        NSInteger starr = [evaluateModel.truth_score integerValue] + [evaluateModel.assort_score integerValue] + [evaluateModel.response_score integerValue];
        cell.evaStarImage.currentIndex = starr/3;
        
        //text
        cell.evaTextLabel.text = evaluateModel.memo;
        
        if (evaluateModel.filesImg.count == 0) {
            [cell.evaProImageView1 setHidden:YES];
            [cell.evaProImageView2 setHidden:YES];
        }else if (evaluateModel.filesImg.count == 1){
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:YES];
            
            ImageModel *imgModel1 = evaluateModel.filesImg[0];
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel1.file];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            QDFWeakSelf;
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[imgUrl1]];
            }];
            
        }else{
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:NO];
            
            ImageModel *imgModel1 =evaluateModel.filesImg[0];
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel1.file];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];

            ImageModel *imgModel2 = evaluateModel.filesImg[1];
            NSString *imgString2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel2.file];
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
    
    //section=1(追评)
    if (indexPath.row == 0) {
        identifier = @"evaTwice0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setHidden:YES];
        
        [cell.userNameButton setTitle:@"追加" forState:0];
        
        return cell;
    }else{//追评
        identifier = @"evaTwice2";
        EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.evaStarImage setHidden:YES];
        cell.topTextConstraints.constant = -kBigPadding;
        
        EvaluateModel *evaluateModel = self.twiceEvaluateArray[indexPath.row-1];
        
        //user image
        NSString *sosos = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.headimg.file];
        [cell.evaNameButton sd_setImageWithURL:[NSURL URLWithString:sosos] forState:0 placeholderImage:nil];
        
        //user name
        NSString *nanan = [NSString getValidStringFromString:evaluateModel.realname toString:evaluateModel.username];
        [cell.evaNameLabel setText:nanan];
        
        //time
        cell.evaTimeLabel.text = [NSDate getYMDhmFormatterTime:evaluateModel.action_at];
        
        //star
        NSInteger starr = [evaluateModel.truth_score integerValue] + [evaluateModel.assort_score integerValue] + [evaluateModel.response_score integerValue];
        cell.evaStarImage.currentIndex = starr/3;

        
        //text
        cell.evaTextLabel.text = evaluateModel.memo;
        
        if (evaluateModel.filesImg.count == 0) {
            [cell.evaProImageView1 setHidden:YES];
            [cell.evaProImageView2 setHidden:YES];
        }else if (evaluateModel.filesImg.count == 1){
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:YES];
            
            ImageModel *imgModel1 = evaluateModel.filesImg[0];
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel1.file];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            QDFWeakSelf;
            [cell.evaProImageView1 addAction:^(UIButton *btn) {
                [weakself showImages:@[imgUrl1]];
            }];
            
        }else{
            [cell.evaProImageView1 setHidden:NO];
            [cell.evaProImageView2 setHidden:NO];
            
            ImageModel *imgModel1 = evaluateModel.filesImg[0];
            NSString *imgString1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel1.file];
            NSURL *imgUrl1 = [NSURL URLWithString:imgString1];
            [cell.evaProImageView1 sd_setImageWithURL:imgUrl1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            
            ImageModel *imgModel2 = evaluateModel.filesImg[1];
            NSString *imgString2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel2.file];
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - method
- (void)getAllEvaluetasContainGetingAndSending
{
    NSString *allEvaContainString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kEvalueteListString];
    NSDictionary *params = @{@"ordersid" : self.ordersid,
                             @"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:allEvaContainString params:params successBlock:^(id responseObject) {
                
        [weakself.evaluateArray removeAllObjects];
        [weakself.twiceEvaluateArray removeAllObjects];
        
        EvaluateResponse *evaResponse = [EvaluateResponse objectWithKeyValues:responseObject];
        
        for (EvaluateModel *evaluateModel in evaResponse.Comments1) {//评价
            [weakself.evaluateArray addObject:evaluateModel];
        }
        
        for (EvaluateModel *twiceEvaluateModel in evaResponse.Comments2) {//追评
            [weakself.twiceEvaluateArray addObject:twiceEvaluateModel];
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
