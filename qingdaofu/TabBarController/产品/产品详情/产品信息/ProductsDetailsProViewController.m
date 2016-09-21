//
//  ProductsDetailsProViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsDetailsProViewController.h"

#import "ProductsCheckDetailViewController.h"  //债权人信息
#import "ProductsCheckFilesViewController.h"  //债权文件

#import "EvaTopSwitchView.h"
#import "ProdLeftView.h"
#import "ProdRightView.h"

#import "DebtModel.h"
#import "UIImage+Color.h"

@interface ProductsDetailsProViewController ()

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) EvaTopSwitchView *productsDeTopView;
@property (nonatomic,strong) ProdLeftView *leftTableView;
@property (nonatomic,strong) ProdRightView *rightTableView;

@end

@implementation ProductsDetailsProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.title = @"产品信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"information_nav_remind"] style:UIBarButtonItemStylePlain target:self action:@selector(remindPublisher)];
    
    [self.view addSubview:self.productsDeTopView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self.rightTableView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.productsDeTopView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.productsDeTopView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.leftTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.productsDeTopView];
        [self.leftTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self.rightTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.productsDeTopView];
        [self.rightTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)productsDeTopView
{
    if (!_productsDeTopView) {
        _productsDeTopView = [EvaTopSwitchView newAutoLayoutView];
        _productsDeTopView.backgroundColor = kNavColor;
        
        [_productsDeTopView.getbutton setTitle:@"基本信息" forState:0];
        _productsDeTopView.getbutton.titleLabel.font = kBigFont;
        [_productsDeTopView.sendButton setTitle:@"补充信息" forState:0];
        _productsDeTopView.sendButton.titleLabel.font = kFirstFont;
        
        QDFWeakSelf;
        [_productsDeTopView setDidSelectedButton:^(NSInteger btnTag) {
            if (btnTag ==33) {//基本信息
                
                [weakself.productsDeTopView.getbutton setTitleColor:kBlueColor forState:0];
                weakself.productsDeTopView.getbutton.titleLabel.font = kBigFont;
                [weakself.productsDeTopView.sendButton setTitleColor:kBlackColor forState:0];
                weakself.productsDeTopView.sendButton.titleLabel.font = kFirstFont;
                
                [weakself.leftTableView setHidden:NO];
                [weakself.rightTableView setHidden:YES];
                [weakself.view bringSubviewToFront:weakself.leftTableView];
                
            }else{//补充信息
                
                [weakself.productsDeTopView.sendButton setTitleColor:kBlueColor forState:0];
                weakself.productsDeTopView.sendButton.titleLabel.font = kBigFont;
                [weakself.productsDeTopView.getbutton setTitleColor:kBlackColor forState:0];
                weakself.productsDeTopView.getbutton.titleLabel.font = kFirstFont;
                
                [weakself.leftTableView setHidden:YES];
                [weakself.rightTableView setHidden:NO];
                [weakself.view bringSubviewToFront:weakself.rightTableView];
            }
        }];
    }
    return _productsDeTopView;
}

//基本信息
- (ProdLeftView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [ProdLeftView newAutoLayoutView];
        PublishingModel *leftModel = self.yyModel.product;
        //清收,诉讼
        //金额
        NSString *moneyStr1 = [NSString getValidStringFromString:leftModel.money toString:@"0"];
        //代理费用
        NSString *agencycommissionStr1 = [NSString getValidStringFromString:leftModel.agencycommission toString:@"0"];
        
        NSString *loan_typeStr = @"暂无";//债权类型
        if ([leftModel.loan_type intValue] == 1) {
            loan_typeStr = @"房产抵押";
        }else if ([leftModel.loan_type intValue] == 2){
            loan_typeStr = @"应收账款";
        }else if ([leftModel.loan_type intValue] == 3){
            loan_typeStr = @"机动车抵押";
        }else{
            loan_typeStr = @"无抵押";
        }
        
        NSString *agencycommissiontypeStr = @"暂无";  //代理费用类型
        if ([leftModel.agencycommissiontype intValue] == 1) {
            if ([leftModel.category integerValue] == 2) {
                agencycommissiontypeStr = @"服务佣金(%)";
            }else{
                agencycommissiontypeStr = @"固定费用(万元)";
            }
        }else if ([leftModel.agencycommissiontype intValue] ==2){
            if ([leftModel.category integerValue] == 2) {
                agencycommissiontypeStr = @"固定费用(万元)";
            }else{
                agencycommissiontypeStr = @"风险费率(%)";
            }
        }
        
        if ([leftModel.loan_type intValue] == 1) {//房产抵押
            NSString *mortorage_communityStr1 = [NSString getValidStringFromString:leftModel.mortorage_community];
            NSString *seatmortgageStr1 = [NSString getValidStringFromString:leftModel.seatmortgage];
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"抵押物地址",@"详细地址"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,mortorage_communityStr1,seatmortgageStr1]];
        }else if ([leftModel.loan_type intValue] == 3){//机动车抵押
            NSString *carStr1 = [NSString getValidStringFromString:self.yyModel.car];
            NSString *licenseStr1 = [NSString getValidStringFromString:self.yyModel.license];
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"机动车抵押",@"车牌类型"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,carStr1,licenseStr1]];
        }else if ([leftModel.loan_type intValue] == 2){//应收帐款
            NSString *accountrStr1 = [NSString getValidStringFromString:leftModel.accountr toString:@"0"];
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"应收帐款(万元)"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,accountrStr1]];
        }else{
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr]];
        }
        [_leftTableView reloadData];
    }
    return _leftTableView;
}

//补充信息
- (ProdRightView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [ProdRightView newAutoLayoutView];
        PublishingModel *rightModel = self.yyModel.product;
        //清收，诉讼
            
            NSString *rate = [NSString getValidStringFromString:rightModel.rate]; //借款利率
            NSString *rate_cat = @"暂无"; //借款期限类型
            NSString *term = [NSString getValidStringFromString:rightModel.term];   //借款期限
            NSString *repaymethod = @"暂无";//还款方式
            NSString *obligor = @"暂无";  //债务人主体
            NSString *commitment = @"暂无";  //委托事项
            NSString *commissionperiod = [NSString getValidStringFromString:rightModel.commissionperiod];   //委托代理期限
            NSString *paidmoney = [NSString getValidStringFromString:rightModel.paidmoney];  //已付本金
            NSString *interestpaid = [NSString getValidStringFromString:rightModel.interestpaid];  //已付利息
            NSString *performancecontract = [NSString getValidStringFromString:rightModel.performancecontract];  //合同履行地
            NSString *creditorfile = @"查看";  //债权文件
            NSString *creditorinfo;  //债权人信息
            NSString *borrowinginfo;  //债务人信息

            if (rightModel.rate_cat) {
                if ([rightModel.rate_cat intValue] == 1) {
                    rate_cat = @"天";
                }else{
                    rate_cat = @"月";
                }
            }
            if (rightModel.repaymethod) {
                if ([rightModel.repaymethod intValue] == 1) {
                    repaymethod = @"一次性到期还本付息";
                }else if([rightModel.repaymethod intValue] == 2){
                    repaymethod = @"按月付息，到期还本";
                }else{
                    repaymethod = @"其他";
                }
            }
            if (rightModel.obligor) {
                if ([rightModel.obligor intValue] == 1) {
                    obligor = @"自然人";
                }else if([rightModel.obligor intValue] == 2){
                    obligor = @"法人";
                }else{
                    obligor = @"其他";
                }
            }
        
            if (self.yyModel.creditorinfo.count > 0) {
                creditorinfo = @"查看";
            }else{
                creditorinfo = @"暂无";
            }
            
            if (self.yyModel.borrowinginfo.count > 0) {
                borrowinginfo = @"查看";
            }else{
                borrowinginfo = @"暂无";
            }
            
            _rightTableView.dataList1 = [NSMutableArray arrayWithArray:@[@"借款利率(%)",@"借款利率类型",@"借款期限",@"借款期限类型",@"还款方式",@"债务人主体",@"委托代理期限(月)",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"]];
            _rightTableView.dataList2 = [NSMutableArray arrayWithArray:@[rate,rate_cat,term,rate_cat,repaymethod,obligor,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo]];
        }
        
        QDFWeakSelf;
        [_rightTableView setDidSelectedRow:^(NSInteger row) {
            switch (row) {
                case 11:{//债权文件
                    ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
                    productsCheckFilesVC.fileResponse = weakself.yyModel;
                    [weakself.navigationController pushViewController:productsCheckFilesVC animated:YES];
                }
                    break;
                case 12:{//债权人信息
                    if (weakself.yyModel.creditorinfo.count > 0) {
                        ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                        productsCheckDetailVC.listArray = weakself.yyModel.creditorinfo;
                        productsCheckDetailVC.categoryString = @"1";
                        [weakself.navigationController pushViewController:productsCheckDetailVC animated:YES];
                    }
                }
                    break;
                case 13:{//债务人信息
                    if (weakself.yyModel.borrowinginfo.count > 0) {
                        ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                        productsCheckDetailVC.listArray = weakself.yyModel.borrowinginfo;
                        productsCheckDetailVC.categoryString = @"2";
                        [weakself.navigationController pushViewController:productsCheckDetailVC animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    return _rightTableView;
}

#pragma mark - method
- (void)remindPublisher
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否提醒发布方完善信息？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self warnningMethod];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:act1];
    [alertController addAction:act2];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)warnningMethod
{
    NSString *warnString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToWarnning];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.yyModel.product.idString,
                             @"category" : self.yyModel.product.category,
                             @"pid" : self.yyModel.product.uidInner
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:warnString params:params successBlock:^(id responseObject) {
        BaseModel *warnModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:warnModel.msg];
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
