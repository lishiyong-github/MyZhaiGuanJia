//
//  BrandViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BrandViewController.h"
#import "SkyAssociationMenuView.h"

@interface BrandViewController ()<SkyAssociationMenuViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) SkyAssociationMenuView *skyTableView;


@property (nonatomic,strong) NSMutableDictionary *brandDictionary;
@property (nonatomic,strong) NSMutableArray *brandArray;
@property (nonatomic,strong) NSMutableArray *audiArray;
@property (nonatomic,strong) NSString *idxType;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self getBrandList];
    [self getAudiList];
    [self.view addSubview:self.btn];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.btn autoSetDimension:ALDimensionHeight toSize:50];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton newAutoLayoutView];
        [_btn setBackgroundColor:kBlackColor];
        [_btn setTitle:@"请选择" forState:0];
        [_btn setTitleColor:kNavColor forState:0];
        
        QDFWeakSelf;
        [_btn addAction:^(UIButton *btn) {
            [weakself.skyTableView showAsDrawDownView:btn];
        }];
    }
    return _btn;
}

- (SkyAssociationMenuView *)skyTableView
{
    if (!_skyTableView) {
        _skyTableView = [SkyAssociationMenuView new];
//        _skyTableView.delegate = self;
    }
    return _skyTableView;
}

- (NSMutableDictionary *)brandDictionary
{
    if (!_brandDictionary) {
        _brandDictionary = [NSMutableDictionary dictionary];
    }
    return _brandDictionary;
}

- (NSMutableArray *)brandArray
{
    if (!_brandArray) {
        _brandArray = [NSMutableArray array];
    }
    return _brandArray;
}

- (NSMutableArray *)audiArray
{
    if (!_audiArray) {
        _audiArray = [NSMutableArray array];
    }
    return _audiArray;
}

//row
- (NSInteger)assciationMenuView:(SkyAssociationMenuView*)asView countForClass:(NSInteger)idx {
//    NSLog(@"choose %ld", idx);
    if ([self.idxType isEqualToString:@"1"]) {
        return self.brandArray.count;
    }else{
        return self.audiArray.count;
    }
}

- (BOOL)assciationMenuView:(SkyAssociationMenuView*)asView idxChooseInClass1:(NSInteger)idx_1
{
    [self getAudiList];
    self.idxType = @"2";
    return YES;
}

//显示第二列
- (BOOL)assciationMenuView:(SkyAssociationMenuView *)asView idxChooseInClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2
{
  
    return YES;
}

//不显示第三页
- (BOOL)assciationMenuView:(SkyAssociationMenuView *)asView idxChooseInClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 class3:(NSInteger)idx_3
{
    return NO;
}

//第一列内容
- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 {
//    NSLog(@"title %ld", idx_1);
//    return [NSString stringWithFormat:@"title %ld", idx_1];
    
//    NSString *brandString = self.brandDictionary.allValues[idx_1];
//    return self.brandDictionary.allKeys[idx_1-1];
//    return brandString;
    
    return @"车品牌";
}

//第二列内容
- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 {
//    NSLog(@"title %ld, %ld", idx_1, idx_2);
//    return [NSString stringWithFormat:@"title %ld, %ld", idx_1, idx_2];
    return @"1";
}

//第三列内容
- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 class_3:(NSInteger)idx_3 {
    NSLog(@"title %ld, %ld, %ld", idx_1, idx_2, idx_3);
    return [NSString stringWithFormat:@"%ld,%ld,%ld", idx_1, idx_2, idx_3];
}

#pragma mark - request method
- (void)getBrandList
{
    NSString *brandString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandString];
    [self requestDataPostWithString:brandString params:nil successBlock:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"@@@@@@@@@ %@",dic);
        
        for (int i=0; i<[[dic allKeys] count]; i++) {
            [self.brandArray addObject:dic.allValues[i]];
            
        }
        
        self.idxType = @"1";
        [self.skyTableView showAsDrawDownView:self.navigationController.navigationBar];
        
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//车系
- (void)getAudiList
{
    NSString *auditString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kBrandAudiString];
    
    [self requestDataPostWithString:auditString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"MMMMMMM %@",dic);
        
        for (int p=0; p<[[dic allKeys] count]; p++) {
            [self.audiArray addObject:dic.allValues[p]];
        }
    
        self.idxType = @"2";
        
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
