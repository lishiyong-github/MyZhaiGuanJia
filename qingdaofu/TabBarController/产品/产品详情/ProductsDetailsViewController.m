//
//  ProductsDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsDetailsViewController.h"
#import "ProductsDetailsProViewController.h"   //产品信息
#import "CheckDetailPublishViewController.h" //发布人信息

#import "UIImage+Color.h"
#import "UIButton+Addition.h"
#import "BaseCommitButton.h"
#import "MineUserCell.h"
#import "ProDetailCell.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

@interface ProductsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *leftItemButton;
@property (nonatomic,strong) UIButton *rightItemButton;
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *productsDetailsTableView;
@property (nonatomic,strong) BaseCommitButton *proDetailsCommitButton;

@property (nonatomic,strong) NSMutableArray *recommendDataArray;

@end

@implementation ProductsDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor,NSFontAttributeName:kNavFont}];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor1] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //去掉导航栏的边界黑线
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    
    self.view.backgroundColor = kBackColor;
    
    [self.view addSubview:self.productsDetailsTableView];
    [self.view addSubview:self.proDetailsCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessage];
}

- (UIButton *)leftItemButton
{
    if (!_leftItemButton) {
        _leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_leftItemButton setImage:[UIImage imageNamed:@"nav_back"] forState:0];
        QDFWeakSelf;
        [_leftItemButton addAction:^(UIButton *btn) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _leftItemButton;
}

- (UIButton *)rightItemButton
{
    if (!_rightItemButton) {
        _rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_rightItemButton setImage:[UIImage imageNamed:@"nav_collection"] forState:0];
        [_rightItemButton setImage:[UIImage imageNamed:@"nav_collection_s"] forState:UIControlStateSelected];
        QDFWeakSelf;
        [_rightItemButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
//            [weakself showHint:@"收藏成功" yOffset:-(kScreenHeight-200)/2];
            
            PublishingResponse *rightResponse = weakself.recommendDataArray[0];
            PublishingModel *rightModel = rightResponse.product;
            NSString *rightString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kRequestStoreString];
            NSDictionary *params = @{@"id" : rightModel.idString,
                                     @"category" : rightModel.category,
                                     @"token" : [weakself getValidateToken]
                                     };
            [weakself requestDataPostWithString:rightString params:params successBlock:^(id responseObject){
                BaseModel *rightModel = [BaseModel objectWithKeyValues:responseObject];
                [weakself showHint:rightModel.msg];
                
            } andFailBlock:^(NSError *error){
                
            }];
        }];
    }
    return _rightItemButton;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.productsDetailsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.productsDetailsTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.proDetailsCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.proDetailsCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)productsDetailsTableView
{
    if (!_productsDetailsTableView) {
        _productsDetailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _productsDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _productsDetailsTableView.delegate = self;
        _productsDetailsTableView.dataSource = self;
        _productsDetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _productsDetailsTableView.backgroundColor = kBackColor;
    }
    return _productsDetailsTableView;
}

- (BaseCommitButton *)proDetailsCommitButton
{
    if (!_proDetailsCommitButton) {
        _proDetailsCommitButton = [BaseCommitButton newAutoLayoutView];
        
        // add call
        UIButton *phoneButton = [UIButton newAutoLayoutView];
        [phoneButton setImage:[UIImage imageNamed:@"phone"] forState:0];
        phoneButton.backgroundColor = kBlueColor;
        [phoneButton addAction:^(UIButton *btn) {
            NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }];
        [_proDetailsCommitButton addSubview:phoneButton];
        [phoneButton setHidden:YES];
        
        [phoneButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_proDetailsCommitButton];
        [phoneButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_proDetailsCommitButton];
        [phoneButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proDetailsCommitButton];
        [phoneButton autoSetDimension:ALDimensionWidth toSize:kTabBarHeight];

        NSString *isSuccess = @"未申请";
        if ([isSuccess isEqualToString:@"未申请"]) {
            [phoneButton setHidden:YES];
            QDFWeakSelf;
            [_proDetailsCommitButton setTitle:@"立即申请" forState:0];
            [_proDetailsCommitButton addAction:^(UIButton *btn) {

                [weakself showHint:@"申请中" yOffset:-(kScreenHeight-200)/2];
                
                [btn setBackgroundColor:kSelectedColor];
                [btn setTitle:@"申请中" forState:0];
                [btn setTitleColor:kBlackColor forState:0];
                btn.userInteractionEnabled = NO;
            }];

        }else{
            [_proDetailsCommitButton setTitleColor:kBlackColor forState:0];
            [_proDetailsCommitButton setBackgroundColor:kSelectedColor];
            if ([isSuccess isEqualToString:@"申请成功"]) {
                [phoneButton setHidden:NO];
                [_proDetailsCommitButton setTitle:@"申请成功" forState:0];
            }else{
                [phoneButton setHidden:YES];
                [_proDetailsCommitButton setTitle:isSuccess forState:0];
//                [_proDetailsCommitButton setTitleColor:kBlackColor forState:0];
//                [_proDetailsCommitButton setBackgroundColor:kSelectedColor];
            }
        }
    }
    return _proDetailsCommitButton;
}

- (NSMutableArray *)recommendDataArray
{
    if (!_recommendDataArray) {
        _recommendDataArray = [NSMutableArray array];
    }
    return _recommendDataArray;
}

#pragma mark - tableView deleagate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.recommendDataArray.count > 0) {
        return 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recommendDataArray.count > 0) {
        if (section == 1) {
            return 2;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"proDetais";
    PublishingResponse *ewModel;
    PublishingModel *proModel;
    if (self.recommendDataArray.count > 0) {
        ewModel = self.recommendDataArray[0];
        proModel = ewModel.product;
    }
    
        if (indexPath.section == 0) {
            ProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ProDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kNavColor1;
            
//            NSString *str1 = @"5.6";
//            NSString *str2 = @"%";
//            NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
//            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
//            [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, str1.length)];
//            [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(str1.length, str2.length)];
//            [cell.deRateLabel1 setAttributedText:attributeStr];
            
            if ([proModel.category intValue] == 1) {//融资
                //上边
                cell.deRateLabel.text = @"返点(%)";
                cell.deRateLabel1.text = proModel.rebate;
                
                //右边
                if ([proModel.rate_cat integerValue] == 1) {
                    cell.deTypeView.fLabel1.text = @"借款利率(天)";
                }else{
                    cell.deTypeView.fLabel1.text = @"借款利率(月)";
                }
                cell.deTypeView.fLabel2.text = proModel.rate;
                
            }else if ([proModel.category intValue] == 2){//催收
                //上边
                cell.deRateLabel.text = @"代理费率(%)";
                cell.deRateLabel1.text = proModel.agencycommission;
                
                //右边
                cell.deTypeView.fLabel1.text = @"债权类型";
                if ([proModel.loan_type isEqualToString:@"1"]) {
                    cell.deTypeView.fLabel2.text = @"房产抵押";
                }else if ([proModel.loan_type isEqualToString:@"2"]){
                    cell.deTypeView.fLabel2.text = @"应收账款";
                }else if ([proModel.loan_type isEqualToString:@"3"]){
                    cell.deTypeView.fLabel2.text = @"机动车抵押";
                }else if([proModel.loan_type isEqualToString:@"4"]){
                    cell.deTypeView.fLabel2.text = @"无抵押";
                }
                
            }else if ([proModel.category intValue] == 3){//诉讼
                //上边
                if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                    cell.deRateLabel.text = @"固定费用(万)";
                }else{
                    cell.deRateLabel.text = @"风险费率(%)";
                }
                cell.deRateLabel1.text = proModel.agencycommission;
                
                //右边
                cell.deTypeView.fLabel1.text = @"债权类型";
                if ([proModel.loan_type isEqualToString:@"1"]) {
                    cell.deTypeView.fLabel2.text = @"房产抵押";
                }else if ([proModel.loan_type isEqualToString:@"2"]){
                    cell.deTypeView.fLabel2.text = @"应收账款";
                }else if ([proModel.loan_type isEqualToString:@"3"]){
                    cell.deTypeView.fLabel2.text = @"机动车抵押";
                }else if([proModel.loan_type isEqualToString:@"4"]){
                    cell.deTypeView.fLabel2.text = @"无抵押";
                }
            }
            
            //左边－－－－通用
            cell.deMoneyView.fLabel1.text = @"借款本金(万)";
            cell.deMoneyView.fLabel2.text = proModel.money;
            
            return cell;
        }
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[@"  产品信息",@"  发布人信息"] forKeys:@[@"list_icon_product",@"list_icon_user"]];
        
        [cell.userNameButton setImage:[UIImage imageNamed:dataDic.allKeys[indexPath.row]] forState:0];
        [cell.userNameButton setTitle:dataDic.allValues[indexPath.row] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (indexPath.row == 1) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell.userActionButton setTitleColor:kYellowColor forState:0];
            [cell.userActionButton setTitle:@"已认证" forState:0];
            cell.userActionButton.titleLabel.font = kFirstFont;
        }
        
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.recommendDataArray.count > 0) {
        PublishingResponse *qModel = self.recommendDataArray[0];
        PublishingModel *pModel = qModel.product;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ProductsDetailsProViewController *productsDetailsProVC = [[ProductsDetailsProViewController alloc] init];
            productsDetailsProVC.yyModel = qModel;
            [self.navigationController pushViewController:productsDetailsProVC animated:YES];
        }else{
            CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
            checkDetailPublishVC.idString = self.idString;
            checkDetailPublishVC.categoryString = self.categoryString;
            checkDetailPublishVC.pidString = pModel.uidInner;
            checkDetailPublishVC.typeString = @"发布方";
            checkDetailPublishVC.evaTypeString = @"launchevaluation";
            [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
        }
    }
    }
}

#pragma mark - method
- (void)getDetailMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *respModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        self.navigationItem.title = respModel.product.codeString;
        
        [self.recommendDataArray addObject:respModel];
        [self.productsDetailsTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
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
