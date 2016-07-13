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

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

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
            if ([model.pictures[0] isEqualToString:@""]) {
                return 105;
            }else{
                return 170;
            }
        }else if ([self.evaTypeString isEqualToString:@"launchevaluation"]){
            LaunchEvaluateModel *model = self.allEvaluateArray[indexPath.section];
            if ([model.pictures[0] isEqualToString:@""]) {
                return 105;
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
        
        QDFWeakSelf;
        if ([self.evaTypeString isEqualToString:@"evaluate"]) {//收到的评价
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
            
            //图片
            if (model.pictures.count == 1) {
                if ([model.pictures[0] isEqualToString:@""]) {//没有图片
                    [cell.evaProImageView1 setHidden:YES];
                    [cell.evaProImageView2 setHidden:YES];
                }else{//有图片
                    [cell.evaProImageView1 setHidden:NO];
                    [cell.evaProImageView2 setHidden:YES];
                    NSString *str1 = [model.pictures[0] substringWithRange:NSMakeRange(1, [model.pictures[0] length]-2)];
                    NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                    NSURL *url1 = [NSURL URLWithString:imageStr1];
                    
                    [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                    [cell.evaProImageView1 addAction:^(UIButton *btn) {
                        [weakself showImages:@[url1]];
                    }];
                }
            }else if (model.pictures.count >= 2){
                [cell.evaProImageView1 setHidden:NO];
                [cell.evaProImageView2 setHidden:NO];
                NSString *str1 = [model.pictures[0] substringWithRange:NSMakeRange(1, [model.pictures[0] length]-2)];
                NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                NSURL *url1 = [NSURL URLWithString:imageStr1];
                NSString *str2 = [model.pictures[1] substringWithRange:NSMakeRange(1, [model.pictures[1] length]-2)];
                NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
                NSURL *url2 = [NSURL URLWithString:imageStr2];
                
                [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageView2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageView1 addAction:^(UIButton *btn) {
                    [weakself showImages:@[url1,url2]];
                }];
                [cell.evaProImageView2 addAction:^(UIButton *btn) {
                    [weakself showImages:@[url1,url2]];
                }];
            }
            
        }else if([self.evaTypeString isEqualToString:@"launchevaluation"]){//给出的评价
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
            
            //图片
            if (model.pictures.count == 1) {
                if ([model.pictures[0] isEqualToString:@""]) {//没有图片
                    [cell.evaProImageView1 setHidden:YES];
                    [cell.evaProImageView2 setHidden:YES];
                }else{//有图片
                    [cell.evaProImageView1 setHidden:NO];
                    [cell.evaProImageView2 setHidden:YES];
                    NSString *str1 = [model.pictures[0] substringWithRange:NSMakeRange(1, [model.pictures[0] length]-2)];
                    NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                    NSURL *url1 = [NSURL URLWithString:imageStr1];
                    [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                    [cell.evaProImageView1 addAction:^(UIButton *btn) {
                        [weakself showImages:@[url1]];
                    }];
                }
            }else if (model.pictures.count >= 2){
                [cell.evaProImageView1 setHidden:NO];
                [cell.evaProImageView2 setHidden:NO];
                NSString *str1 = [model.pictures[0] substringWithRange:NSMakeRange(1, [model.pictures[0] length]-2)];
                NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                NSURL *url1 = [NSURL URLWithString:imageStr1];
                NSString *str2 = [model.pictures[1] substringWithRange:NSMakeRange(1, [model.pictures[1] length]-2)];
                NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
                NSURL *url2 = [NSURL URLWithString:imageStr2];
                
                [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageView2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                [cell.evaProImageView1 addAction:^(UIButton *btn) {
                    [weakself showImages:@[url1,url2]];
                }];
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
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        NSDictionary *gtfdeyw = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        
        if ([page integerValue] == 1) {
            [weakself.allEvaluateArray removeAllObjects];
        }
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        [weakself.responseArray addObject:response];
        
        if (response.evaluate.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageEva--;
        }
        
        if ([weakself.evaTypeString isEqualToString:@"evaluate"]) {//收到的评价
            for (EvaluateModel *model in response.evaluate) {
                [weakself.allEvaluateArray addObject:model];
            }
        }else if([weakself.evaTypeString isEqualToString:@"launchevaluation"]){//给出的评价
            for (LaunchEvaluateModel *model in response.launchevaluation) {
                [weakself.allEvaluateArray addObject:model];
            }
        }
        
        if (weakself.allEvaluateArray.count > 0) {
            [weakself .baseRemindImageView setHidden:YES];
        }else{
            [weakself .baseRemindImageView setHidden:NO];
        }
        
        [weakself.allEvaTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)refreshHeaderOfAllEvaluation
{
    _pageEva = 1;
    [self getEvaluateDetailListsWithPage:@"1"];
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
