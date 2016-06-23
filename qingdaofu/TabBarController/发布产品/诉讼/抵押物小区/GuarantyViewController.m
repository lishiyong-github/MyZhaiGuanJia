//
//  GuarantyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "GuarantyViewController.h"

#import "GuarantyResponse.h"
#import "GuarantyModel.h"

@interface GuarantyViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *guTableView;
@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *guDataArray;

@end

@implementation GuarantyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抵押物地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.guTableView];
}

- (UITableView *)guTableView
{
    if (!_guTableView) {
        _guTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
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
        _searchController.searchBar.frame = CGRectMake(0, kNavHeight, kScreenWidth/2, kCellHeight);
        _searchController.searchBar.tintColor = kBlueColor;
        _searchController.dimsBackgroundDuringPresentation = NO;//设置为NO,可以点击搜索出来的内容
    }
    return _searchController;
}

- (NSMutableArray *)guDataArray
{
    if (!_guDataArray) {
        _guDataArray = [NSMutableArray array];
    }
    return _guDataArray;
}

#pragma mark - tabelView deleagte and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.guDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    GuarantyModel *model = self.guDataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedArea) {
        GuarantyModel *model = self.guDataArray[indexPath.row];
        self.didSelectedArea(model.name,@"1",@"2",@"3");
    }

    [self didDismissSearchController:self.searchController];
    [self.guTableView removeFromSuperview];
    
//    _searchAPI = [[AMapSearchAPI alloc] init];
//    _searchAPI.delegate = self;
//    //构造AMapReGeocodeSearchRequest对象
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
//    regeo.radius = 10000;
//    //    regeoRequest.requireExtension = YES;
//    
//    //发起逆地理编码
//    [_searchAPI AMapReGoecodeSearch: regeo];
    
    [self back];
}

////实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if(response.regeocode != nil)
//    {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        NSLog(@"ReGeo: %@", result);
//    }
//}


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
    [searchController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 搜索方法
// 搜索时触发的方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchStr = [searchController.searchBar text];
    
    if (searchStr && searchController.active) {
        // 调用小区的方法
        [self getGuarantyListWithString:searchStr];
    }
}

- (void)getGuarantyListWithString:(NSString *)predicate
{
    NSString *guarantyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kGuarantyString];
    NSDictionary *params = @{@"name" : predicate};
    [self requestDataPostWithString:guarantyString params:params successBlock:^(id responseObject) {
        
        [self.guDataArray removeAllObjects];
        
        GuarantyResponse *response = [GuarantyResponse objectWithKeyValues:responseObject];
        
        for (GuarantyModel *model in response.result) {
            [self.guDataArray addObject:model];
        }
        
        // 刷新列表
        [self.guTableView reloadData];

    } andFailBlock:^(NSError *error) {
        [self showHint:@"加载失败"];
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
