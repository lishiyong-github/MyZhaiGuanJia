//
//  CaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CaseViewController.h"

#import "TextFieldCell.h"
@interface CaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIWebView *caseWebView;
@property (nonatomic,strong) UITableView *caseTableView;

//json
@property (nonatomic,strong)  NSMutableDictionary *caseDic;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"经典案例";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if ([self.toString integerValue] == 1) {
        [self.view addSubview:self.caseTableView];
    }else{
        [self.view addSubview:self.caseWebView];
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.toString integerValue] == 1) {
            [self.caseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }else{
            [self.caseWebView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIWebView *)caseWebView
{
    if (!_caseWebView) {
        _caseWebView = [UIWebView newAutoLayoutView];
        [_caseWebView loadHTMLString:self.caseString baseURL:nil];
    }
    return _caseWebView;
}

- (UITableView *)caseTableView
{
    if (!_caseTableView) {
        _caseTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _caseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _caseTableView.backgroundColor = kBackColor;
        _caseTableView.separatorColor = kSeparateColor;
        _caseTableView.delegate = self;
        _caseTableView.dataSource = self;
        _caseTableView.tableFooterView = [[UIView alloc] init];
        _caseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _caseTableView;
}

- (NSMutableDictionary *)caseDic
{
    if (!_caseDic) {
        _caseDic = [NSMutableDictionary dictionary];
    }
    return _caseDic;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"case";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topTextViewConstraints.constant = 0;
    cell.textField.placeholder = @"请输入诉讼、清收等成功案例";
    cell.textField.font = kSecondFont;
    cell.countLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)cell.textField.text.length];
    
    QDFWeakSelf;
    [cell setTouchBeginPoint:^(CGPoint point) {
        weakself.touchPoint = point;
    }];
    
    [cell setDidEndEditing:^(NSString *text) {
        [weakself.caseDic setValue:text forKey:@"case"];
    }];
    
    return cell;
}

#pragma mark - method
- (void)back
{
    [self.view endEditing:YES];
    if (self.didEndFinish) {
        self.didEndFinish(self.caseDic[@"case"]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
