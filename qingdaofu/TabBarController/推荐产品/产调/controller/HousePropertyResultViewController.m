//
//  HousePropertyResultViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePropertyResultViewController.h"

#import "MineUserCell.h"
#import "PropertyResultCell.h"

#import "PropertyResultResponse.h"
#import "PropertyResultOnesModel.h"

#import "UIImageView+WebCache.h"
#import "UIViewController+ImageBrowser.h"

@interface HousePropertyResultViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView *resultCollectionView;
@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,assign) BOOL didSetupConstarints;

//json
@property (nonatomic,strong) NSMutableArray *resultDataArray;
@property (nonatomic,strong) NSMutableArray *resultOnesArray;

@end

@implementation HousePropertyResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产调结果";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.resultTableView];

    [self.view setNeedsUpdateConstraints];
    
    [self getPropertyResultMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.resultTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)resultTableView
{
    if (!_resultTableView) {
        _resultTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _resultTableView.backgroundColor = kBackColor;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
    }
    return _resultTableView;
}

- (NSMutableArray *)resultDataArray
{
    if (!_resultDataArray) {
        _resultDataArray = [NSMutableArray array];
    }
    return _resultDataArray;
}

- (NSMutableArray *)resultOnesArray
{
    if (!_resultOnesArray) {
        _resultOnesArray = [NSMutableArray array];
    }
    return _resultOnesArray;
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.resultDataArray.count+self.resultOnesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCellHeight4;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {//MineUserCell.h
        identifier = @"resultCell0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackColor;
        [cell.userActionButton setHidden:YES];
        cell.userNameButton.titleLabel.numberOfLines = 0;
        
        PropertyResultOnesModel *onesModel = self.resultOnesArray[0];
        
        NSString *codeStr1 = [NSString stringWithFormat:@"产调编号：%@",onesModel.orderId];
        NSString *codeStr2 = [NSString stringWithFormat:@"产调地址：%@",onesModel.address];
        NSString *codeStr = [NSString stringWithFormat:@"%@\n%@",codeStr1,codeStr2];
        NSMutableAttributedString *codeAttributeStr = [[NSMutableAttributedString alloc] initWithString:codeStr];
        [codeAttributeStr addAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, codeStr1.length)];
        [codeAttributeStr addAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(codeStr1.length+1, codeStr2.length)];
        
        NSMutableParagraphStyle *stypew = [[NSMutableParagraphStyle alloc] init];
        [stypew setLineSpacing:kSpacePadding];
        [codeAttributeStr addAttribute:NSParagraphStyleAttributeName value:stypew range:NSMakeRange(0, codeStr.length)];
        [cell.userNameButton setAttributedTitle:codeAttributeStr forState:0];
        
        return cell;
    }
    
    identifier = @"resultCell1";
    PropertyResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PropertyResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *showString = self.resultDataArray[indexPath.section-1];
    NSURL *showUrl = [NSURL URLWithString:showString];
    [cell.showImageView sd_setImageWithURL:showUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showImages:self.resultDataArray currentIndex:indexPath.section-1];
}

#pragma mark - method
- (void)getPropertyResultMessages
{
    NSString *resultString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHousePropertyResultString];
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.attrString
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:resultString params:params successBlock:^(id responseObject) {
        
        PropertyResultResponse *respondey = [PropertyResultResponse objectWithKeyValues:responseObject];
        
        if ([respondey.code isEqualToString:@"0000"]) {
            
            if (respondey.data) {
                [weakself.resultDataArray addObject:respondey.data];
            }
            
            if (respondey.ones) {
                [weakself.resultOnesArray addObject:respondey.ones];
            }
        }
        
        [weakself.resultTableView reloadData];
        
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
