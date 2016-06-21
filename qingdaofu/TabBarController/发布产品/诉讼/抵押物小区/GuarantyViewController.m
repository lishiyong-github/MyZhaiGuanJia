//
//  GuarantyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "GuarantyViewController.h"

@interface GuarantyViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *guTableView;
@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) UITextField *navTextField;

@end

@implementation GuarantyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抵押物地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
//    self.navigationItem.titleView = self.searchController.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    [self.view addSubview:self.guTableView];
    [self.view setNeedsUpdateConstraints];
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.guTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITextField *)navTextField
{
    if (!_navTextField) {
        _navTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _navTextField.placeholder = @"输入小区名";
        _navTextField.font = kNavFont;
    }
    return _navTextField;
}

- (UITableView *)guTableView
{
    if (!_guTableView) {
        _guTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _guTableView.delegate = self;
        _guTableView.dataSource = self;
        _guTableView.tableFooterView = [[UIView alloc] init];
        _guTableView.backgroundColor = [UIColor clearColor];
        _guTableView.tableHeaderView = self.searchController.searchBar;
    }
    return _guTableView;
}

-(UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.frame = CGRectMake(0, kCellHeight, kScreenWidth/2, kCellHeight);
        _searchController.searchBar.tintColor = kBlueColor;
        _searchController.dimsBackgroundDuringPresentation = NO;//设置为NO,可以点击搜索出来的内容
    }
    return _searchController;
}

#pragma mark - tabelView deleagte and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"gu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"小区小徐";
    
    return cell;
}

#pragma mark - search
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  开始  搜索时触发的方法");
}

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  取消  搜索时触发的方法");
}

//搜索界面消失
-(void)didDismissSearchController:(UISearchController *)searchController
{
//    [self customSortingOfChinese:self.dataArray];
    [self.guTableView reloadData];
}

#pragma mark -- 搜索方法
// 搜索时触发的方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    NSString *searchStr = [searchController.searchBar text];
    NSString *searchStr = @"1";
    
    // 谓词
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchStr];
    
    // 调用小区的方法
    [self getGuarantyListWithString:searchStr];
}

- (void)getGuarantyListWithString:(NSString *)predicate
{
    NSString *guarantyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kGuarantyString];
    NSDictionary *params = @{@"name" : predicate};
    [self requestDataPostWithString:guarantyString params:params successBlock:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"++++++ %@",dic);
        // 刷新列表
        [self.guTableView reloadData];

    } andFailBlock:^(NSError *error) {
        
    }];
}

//- (void)cancel
//{
//    [self.guTableView setHidden:YES];
//}


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
