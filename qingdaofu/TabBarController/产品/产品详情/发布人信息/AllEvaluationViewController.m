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

#import "UIImageView+WebCache.h"

@interface AllEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *allEvaTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *responseArray;
@property (nonatomic,strong) NSMutableArray *allEvaluateArray;
@property (nonatomic,assign) NSInteger pageEva;

@end

@implementation AllEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有评价";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.allEvaTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self refreshHeaderOfAllEvaluation];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.allEvaTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
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
        [_allEvaTableView addHeaderWithTarget:self action:@selector(refreshHeaderOfAllEvaluation)];
        [_allEvaTableView addFooterWithTarget:self action:@selector(refreshFooterOfAllEvaluation)];
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
    if (self.allEvaluateArray.count > 0) {
        
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {
            EvaluateModel *model = self.allEvaluateArray[indexPath.section];
            if ([model.picture isEqualToString:@""] || model.picture == nil) {
                return 110;
            }else{
                return 170;
            }
        }else if ([self.evaTypeString isEqualToString:@"launchevaluation"]){
            LaunchEvaluateModel *model = self.allEvaluateArray[indexPath.section];
            if ([model.picture isEqualToString:@""] || model.picture == nil) {
                return 110;
            }else{
                return 170;
            }
        }
    }
    return 0;
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
        
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {//收到的
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
            
            if ([model.picture isEqualToString:@""] || model.picture == nil) {
                [cell.evaProImageView1 setHidden:YES];
                [cell.evaProImageView2 setHidden:YES];
            }else{
                [cell.evaProImageView1 setHidden:NO];
                [cell.evaProImageView2 setHidden:NO];
                NSString *baseString = [model.picture substringWithRange:NSMakeRange(1, model.picture.length-2)];
                NSString *string = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,baseString];
                NSURL *URL = [NSURL URLWithString:string];
                [cell.evaProImageView1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
            }
            
         }else if([self.evaTypeString isEqualToString:@"launchevaluation"]){//给出的
            LaunchEvaluateModel *model = self.allEvaluateArray[indexPath.section];
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
             
             if ([model.picture isEqualToString:@""] || model.picture == nil) {
                 [cell.evaProImageView1 setHidden:YES];
                 [cell.evaProImageView2 setHidden:YES];
             }else{
                 [cell.evaProImageView1 setHidden:NO];
                 [cell.evaProImageView2 setHidden:NO];
                 
                 NSString *baseString = [model.picture substringWithRange:NSMakeRange(1, model.picture.length-2)];
                 NSString *string = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,baseString];
                 NSURL *URL = [NSURL URLWithString:string];
                 [cell.evaProImageView1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
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
    NSString *evaluateString;
    NSDictionary *params;
    
    if ([self.evaTypeString isEqualToString:@"launchevaluation"]) {//结案给出的评价
        evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyEvaluateString];
        params = @{@"token" : [self getValidateToken],
                   @"id" : self.idString,
                   @"category" : self.categoryString,
                   @"page" : page
                   };

    }else if ([self.evaTypeString isEqualToString:@"evaluate"]){///发布接单里面的结案详情中给出的评价
        evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToEvaluationString];
        params = @{@"token" : [self getValidateToken],
                   @"id" : self.idString,
                   @"category" : self.categoryString,
                   @"page" : page,
                   @"pid" : self.pidString,
                   };
    }
    
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {        
        if ([page integerValue] == 0) {
            [self.allEvaluateArray removeAllObjects];
        }
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [self.responseArray addObject:response];
        
        if (response.evaluate.count == 0) {
            [self showHint:@"没有更多了"];
            _pageEva--;
        }
        
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {//收到的评价
            for (EvaluateModel *model in response.evaluate) {
                [self.allEvaluateArray addObject:model];
            }
        }else if([self.evaTypeString isEqualToString:@"launchevaluation"]){//给出的评价
            for (LaunchEvaluateModel *model in response.launchevaluation) {
                [self.allEvaluateArray addObject:model];
            }
        }
        
        if (self.allEvaluateArray.count > 0) {
            [self .baseRemindImageView setHidden:YES];
        }else{
            [self .baseRemindImageView setHidden:NO];
        }
        
        [self.allEvaTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)refreshHeaderOfAllEvaluation
{
    _pageEva = 0;
    [self getEvaluateDetailListsWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.allEvaTableView headerEndRefreshing];
    });
}

- (void)refreshFooterOfAllEvaluation
{
    _pageEva++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageEva];
    [self getEvaluateDetailListsWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.allEvaTableView footerEndRefreshing];
    });
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
