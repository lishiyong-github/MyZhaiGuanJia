//
//  SearchViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SearchViewController.h"

#import "MineUserCell.h"
@interface SearchViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *searchTableView;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backController)];
    
    [self.view addSubview:self.searchTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.searchTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}
- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [UITableView newAutoLayoutView];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.backgroundColor = kBackColor;
        _searchTableView.separatorColor = kSeparateColor;
        _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _searchTableView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40*2, 44)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleProminent;
    }
    return _searchBar;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"大兴", @"丰台", @"海淀", @"朝阳", @"东城", @"崇文", @"西城", @"石景山",@"通州", @"密云", @"迪拜", @"华仔", @"三胖子", @"大连",  nil];
    }
    return _dataArray;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{

}
- (void)didPresentSearchController:(UISearchController *)searchController
{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.searchTableView reloadData];
}

#pragma mark -tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"search";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView.backgroundColor = kSeparateColor;
    cell.backgroundColor = kNavColor;
    [cell.userNameButton setImage:[UIImage imageNamed:@"list_financing"] forState:0];
    [cell.userNameButton setTitle:self.dataArray[indexPath.row] forState:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - collection delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"searchCollection";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    cell.backgroundColor = kRedColor;
    
    return cell;
}

#pragma mark - method
- (void)backController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        NSString *InsureSolutionID = [aDecoder decodeObjectForKey:@"personName"];
//        NSString *InsureSolutionName = [aDecoder decodeObjectForKey:@"personAge"];
    }
    return self;
}



//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
////    a:1:{i:0;a:2:{s:4:"name";s:5:"adasd";s:6:"mobile";s:11:"18221497868";}}
////    [aDecoder encodeObject:@"" forKey:@""];
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


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

@end
