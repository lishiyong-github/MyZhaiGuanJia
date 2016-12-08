//
//  AllCommentsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllCommentsViewController.h"
#import "EvaluatePhotoCell.h"

#import "EvaluateResponse.h"
#import "EvaluateModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface AllCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *allEvaTableView;

//json解析
@property (nonatomic,strong) NSMutableArray *allEvaluateArray;
@property (nonatomic,assign) NSInteger pageEva;


@end

@implementation AllCommentsViewController

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
        _allEvaTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allEvaluateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allEvaluateArray.count > 0) {
        EvaluateModel *model = self.allEvaluateArray[indexPath.section];
        if (model.filesImg.count == 0) {
            return 85;
        }else{
            return 145;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"allComments";
    
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EvaluateModel *evaluateModel = self.allEvaluateArray[indexPath.section];
    
    NSString *sss = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,evaluateModel.headimg.file];
    [cell.evaNameButton sd_setImageWithURL:[NSURL URLWithString:sss] forState:0 placeholderImage:nil];
    NSString *namee = [NSString getValidStringFromString:evaluateModel.realname toString:evaluateModel.username];
    cell.evaNameLabel.text = namee;
    
    cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:evaluateModel.action_at];
    cell.evaTextLabel.text = [NSString getValidStringFromString:evaluateModel.memo toString:@"未填写评价内容"];
    [cell.evaStarImage setCurrentIndex:[evaluateModel.assort_score integerValue]];
    
    //图片
    QDFWeakSelf;
    if (evaluateModel.filesImg.count == 0) {
        [cell.evaProImageView1 setHidden:YES];
        [cell.evaProImageView2 setHidden:YES];
    }else if (evaluateModel.filesImg.count == 1) {
        
        ImageModel *imageModel = [ImageModel objectWithKeyValues:evaluateModel.filesImg[0]];
        
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:YES];
        NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel.file];
        NSURL *url1 = [NSURL URLWithString:imageStr1];
        
        [cell.evaProImageView1 sd_setImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        [cell.evaProImageView1 addAction:^(UIButton *btn) {
            [weakself showImages:@[url1]];
        }];
    }else if (evaluateModel.filesImg.count >= 2){
        [cell.evaProImageView1 setHidden:NO];
        [cell.evaProImageView2 setHidden:NO];
        
        ImageModel *imageModel1 = [ImageModel objectWithKeyValues:evaluateModel.filesImg[0]];
        ImageModel *imageModel2 = [ImageModel objectWithKeyValues:evaluateModel.filesImg[1]];
        
        NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel1.file];
        NSURL *url1 = [NSURL URLWithString:imageStr1];
        NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageModel2.file];
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
                             @"userid" : self.userid,
                             @"page" : page,
                             @"limit" : @"10"
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [weakself.allEvaluateArray removeAllObjects];
        }
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        
        if (response.evaluate.count == 0) {
            [weakself showHint:@"没有更多了"];
            _pageEva--;
        }
        
        for (EvaluateModel *model in response.Comments1) {
            [weakself.allEvaluateArray addObject:model];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageEva];
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
