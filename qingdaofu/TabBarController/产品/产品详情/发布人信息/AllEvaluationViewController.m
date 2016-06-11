//
//  AllEvaluationViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllEvaluationViewController.h"

#import "EvaluatePhotoCell.h"

@interface AllEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *allEvaTableView;

@end

@implementation AllEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有评价";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.allEvaTableView];
    [self.view setNeedsUpdateConstraints];
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
        _allEvaTableView = [UITableView newAutoLayoutView];
        _allEvaTableView.delegate = self;
        _allEvaTableView.dataSource = self;
        _allEvaTableView.separatorColor = kSeparateColor;
        _allEvaTableView.backgroundColor = kBackColor;
    }
    return _allEvaTableView;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    
    cell.evaNameLabel.text = @"1234567889";
    cell.evaTimeLabel.text = @"2016-09-18";
    cell.evaStarImage.currentIndex = 4;
    cell.evaTextLabel.text =@"很好很好很好";
    cell.evaProImageView1.backgroundColor = kSeparateColor;
    cell.evaProImageView2.backgroundColor = kSeparateColor;
    [cell.evaProductButton setHidden:YES];
    
    return cell;
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
