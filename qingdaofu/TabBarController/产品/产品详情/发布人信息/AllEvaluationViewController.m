//
//  AllEvaluationViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllEvaluationViewController.h"

#import "EvaluatePhotoCell.h"

#import "EvaluateResponse.h"
#import "LaunchEvaluateModel.h"
#import "EvaluateModel.h"

@interface AllEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *allEvaTableView;

@property (nonatomic,strong) NSMutableArray *responseArray;
@property (nonatomic,strong) NSMutableArray *allEvaluateArray;

@end

@implementation AllEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有评价";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.allEvaTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self.allEvaTableView addFooterWithTarget:self action:@selector(getEvaluateDetailListsWithPage:)];
    [self getEvaluateDetailListsWithPage:@"0"];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.allEvaTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)allEvaTableView
{
    if (!_allEvaTableView) {
        _allEvaTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _allEvaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _allEvaTableView.delegate = self;
        _allEvaTableView.dataSource = self;
        _allEvaTableView.separatorColor = kSeparateColor;
        _allEvaTableView.backgroundColor = kBackColor;
        _allEvaTableView.tableFooterView = [[UIView alloc] init];
    }
    return _allEvaTableView;
}
- (NSMutableArray *)responseArray
{
    if (!_responseArray) {
        _responseArray = [NSMutableArray array];
    }
    return _responseArray;
}

- (NSMutableArray *)allEvaluateArray
{
    if (!_allEvaluateArray) {
        _allEvaluateArray = [NSMutableArray array];
    }
    return _allEvaluateArray;
}


#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allEvaluateArray.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allEvaluateArray.count > 0) {
        return self.allEvaluateArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"allEva";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EvaluateResponse *response = self.responseArray[0];
    
    if (self.allEvaluateArray.count > 0 ) {
        [cell.remindImageButton setHidden:YES];
        [cell.evaProductButton setHidden:YES];
        [cell.evaNameLabel setHidden:NO];
        [cell.evaTimeLabel setHidden:NO];
        [cell.evaTextLabel setHidden:NO];
        [cell.evaStarImage setHidden:NO];
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:NO];
        
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {
            EvaluateModel *model = self.allEvaluateArray[indexPath.section];
            NSString *isHideStr = model.isHide?@"匿名":model.mobile;
            cell.evaNameLabel.text = isHideStr;
            cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:model.create_time];
            cell.evaStarImage.currentIndex = [response.creditor intValue];
            cell.evaProImageView1.backgroundColor = kLightGrayColor;
            cell.evaProImageView2.backgroundColor = kLightGrayColor;
            if (model.content == nil || [model.content isEqualToString:@""]) {
                cell.evaTextLabel.text = @"未填写评价内容";
            }else{
                cell.evaTextLabel.text = model.content;
            }
         }else{
            LaunchEvaluateModel *model = self.allEvaluateArray[indexPath.section];
            NSString *isHideStr = model.isHide?@"匿名":model.mobile;
            cell.evaNameLabel.text = isHideStr;
            cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:model.create_time];
            cell.evaStarImage.currentIndex = [response.creditor intValue];
//            cell.evaTextLabel.text = model.content;
            //model.content?@"未填写评价内容":model.content;
            cell.evaProImageView1.backgroundColor = kLightGrayColor;
            cell.evaProImageView2.backgroundColor = kLightGrayColor;
             if (model.content == nil || [model.content isEqualToString:@""]) {
                 cell.evaTextLabel.text = @"未填写评价内容";
             }else{
                 cell.evaTextLabel.text = model.content;
             }
         }
    }else{
        [cell.remindImageButton setHidden:NO];
        [cell.evaProductButton setHidden:YES];
        [cell.evaNameLabel setHidden:YES];
        [cell.evaTimeLabel setHidden:YES];
        [cell.evaTextLabel setHidden:YES];
        [cell.evaStarImage setHidden:YES];
        [cell.evaProImageView1 setHidden:YES];
        [cell.evaProImageView2 setHidden:YES];
        [cell.evaProductButton setHidden:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - method
-  (void)getEvaluateDetailListsWithPage:(NSString *)page
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToEvaluationString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString,
                             @"pid" : self.pidString,
                             @"page" : page
                             };
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [self.responseArray addObject:response];
        
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {
            for (EvaluateModel *model in response.evaluate) {
                [self.allEvaluateArray addObject:model];
            }
        }else if([self.evaTypeString isEqualToString:@"launchevaluation"]){
            for (LaunchEvaluateModel *model in response.launchevaluation) {
                [self.allEvaluateArray addObject:model];
            }
        }
        
        [self.allEvaTableView reloadData];
        
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
