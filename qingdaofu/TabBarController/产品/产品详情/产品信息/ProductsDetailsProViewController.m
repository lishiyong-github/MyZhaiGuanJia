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
        if ([leftModel.category intValue] == 1) {//融资
            
            NSString *moneyStr = [NSString stringWithFormat:@"%@万",leftModel.money];
            NSString *rebateStr = [NSString stringWithFormat:@"%@%@",leftModel.rebate,@"%"];
            NSString *rateStr = [NSString stringWithFormat:@"%@%@",leftModel.rate,@"%"];
            
            //利率类型
            NSString *rateCatStr;
            if ([leftModel.rate_cat intValue] == 1) {
                rateCatStr = @"天(%)";
            }else if ([leftModel.rate_cat intValue] == 2){
                rateCatStr = @"月(%)";
            }
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款金额",@"返点",@"借款利率",@"借款利率类型",@"抵押物地址",@"详细地址"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[moneyStr,rebateStr,rateStr,rateCatStr,leftModel.mortorage_community,leftModel.seatmortgage]];
        }else if ([leftModel.category intValue] == 2){//清收
            
            NSString *loanTypeStr;//债权类型
            if ([leftModel.loan_type intValue] == 1) {
                loanTypeStr = @"房产抵押";
            }else if ([leftModel.loan_type intValue] == 3){
                loanTypeStr = @"机动车抵押";
            }else if ([leftModel.loan_type intValue] == 2){
                loanTypeStr = @"应收账款";
            }else if ([leftModel.loan_type intValue] == 4){
                loanTypeStr = @"无抵押";
            }
            
            if ([leftModel.loan_type intValue] == 1) {//房产抵押
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用(%)",@"债权类型",@"抵押物地址",@"详细地址"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,leftModel.agencycommission,loanTypeStr,leftModel.mortorage_community,leftModel.seatmortgage]];
            }else if ([leftModel.loan_type intValue] == 3){//机动车抵押
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用(%)",@"债权类型",@"机动车抵押",@"车牌类型"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,leftModel.agencycommission,loanTypeStr,self.yyModel.car,self.yyModel.license]];
            }else if ([leftModel.loan_type intValue] == 2){//应收帐款
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用(%)",@"债权类型",@"应收帐款(万元)"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,leftModel.agencycommission,loanTypeStr,leftModel.accountr]];
            }else{
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用(%)",@"债权类型"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,leftModel.agencycommission,loanTypeStr]];
            }
            
        }else if ([leftModel.category intValue] == 3){//诉讼
            
            NSString *loan_typeStr;//债权类型
            if ([leftModel.loan_type intValue] == 1) {
                loan_typeStr = @"房产抵押";
            }else if ([leftModel.loan_type intValue] == 2){
                loan_typeStr = @"应收账款";
            }else if ([leftModel.loan_type intValue] == 3){
                loan_typeStr = @"机动车抵押";
            }else if ([leftModel.loan_type intValue] == 4){
                loan_typeStr = @"暂无抵押";
            }
            
            NSString *obligorStr;  //债务人主体
            if ([leftModel.obligor intValue] == 1) {
                obligorStr = @"自然人";
            }else if ([leftModel.obligor intValue] == 2){
                obligorStr = @"法人";
            }else if ([leftModel.obligor intValue] == 3){
                obligorStr = @"其他(未成年,外籍等)";
            }
            
            NSString *commitmentStr;  //委托事项
            if ([leftModel.commitment intValue] == 1) {
                commitmentStr = @"代理诉讼";
            }else if ([leftModel.commitment intValue] == 2){
                commitmentStr = @"代理仲裁";
            }else if ([leftModel.commitment intValue] == 3){
                commitmentStr = @"代理执行";
            }
            
            NSString *agencycommissiontypeStr;  //代理费用类型
            if ([leftModel.agencycommissiontype intValue] == 1) {
                agencycommissiontypeStr = @"固定费用(万)";
            }else if ([leftModel.agencycommissiontype intValue] ==2){
                agencycommissiontypeStr = @"风险费率(%)";
            }
            
            if ([leftModel.loan_type intValue] == 1) {//房产抵押
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"抵押物地址",@"详细地址"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,agencycommissiontypeStr,leftModel.agencycommission,loan_typeStr,leftModel.mortorage_community,leftModel.seatmortgage]];
            }else if ([leftModel.loan_type intValue] == 3){//机动车抵押
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"机动车抵押",@"车牌类型"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,agencycommissiontypeStr,leftModel.agencycommission,loan_typeStr,self.yyModel.car,self.yyModel.license]];
            }else if ([leftModel.loan_type intValue] == 2){//应收帐款
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"应收帐款(万元)"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,agencycommissiontypeStr,leftModel.agencycommission,loan_typeStr,leftModel.accountr]];
            }else{
                [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型"]];
                [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,agencycommissiontypeStr,leftModel.agencycommission,loan_typeStr]];
            }
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
        if ([rightModel.category intValue] == 1) {//融资
            
            NSString *rateCatStr = @"暂无"; //借款期限类型
            NSString *term = [NSString getValidStringFromString:rightModel.term];   //借款期限
            NSString *mortgagecategory = @"暂无";//抵押物类型
            NSString *status = @"暂无";  //抵押物状态
            NSString *rentmoney = [NSString getValidStringFromString:rightModel.rentmoney]; //租金
            NSString *mortgagearea = [NSString getValidStringFromString:rightModel.mortgagearea];  //抵押物面积
            NSString *loanyear = [NSString getValidStringFromString:rightModel.loanyear];   //借款人年龄
            NSString *obligeeyear = @"暂无";  //权利人年龄
            
            if ([rightModel.rate_cat intValue] == 1) {
                rateCatStr = @"天";
            }else if ([rightModel.rate_cat intValue] == 2){
                rateCatStr = @"月";
            }
            
            if (rightModel.mortgagecategory) {
                if ([rightModel.mortgagecategory intValue] == 1) {
                    mortgagecategory = @"住宅";
                }else if ([rightModel.mortgagecategory intValue] == 2){
                    mortgagecategory = @"商户";
                }else{
                    mortgagecategory = @"办公楼";
                }
            }
            
            if (rightModel.obligeeyear) {
                if ([rightModel.obligeeyear intValue] == 1) {
                    obligeeyear = @"65岁以上";
                }else{
                    obligeeyear = @"65岁以下";
                }
         }
            
            if ([rightModel.status integerValue] == 1) {
                status = @"自住";
                _rightTableView.dataList1 = [NSMutableArray arrayWithArray:@[@"借款期限",@"借款期限类型",@"抵押物类型",@"抵押物状态",@"抵押物面积(m²)",@"借款人年龄(岁)",@"权利人年龄"]];
                _rightTableView.dataList2 = [NSMutableArray arrayWithArray:@[term,rateCatStr,mortgagecategory,status,mortgagearea,loanyear,obligeeyear]];
            }else if([rightModel.status integerValue] == 2){//出租
                status = @"出租";
                _rightTableView.dataList1 = [NSMutableArray arrayWithArray:@[@"借款期限",@"借款期限类型",@"抵押物类型",@"抵押物状态",@"租金(元)",@"抵押物面积(m²)",@"借款人年龄(岁)",@"权利人年龄"]];
                _rightTableView.dataList2 = [NSMutableArray arrayWithArray:@[term,rateCatStr,mortgagecategory,status,rentmoney,mortgagearea,loanyear,obligeeyear]];
            }else{
                _rightTableView.dataList1 = [NSMutableArray arrayWithArray:@[@"借款期限",@"借款期限类型",@"抵押物类型",@"抵押物状态",@"抵押物面积(m²)",@"借款人年龄(岁)",@"权利人年龄"]];
                _rightTableView.dataList2 = [NSMutableArray arrayWithArray:@[term,rateCatStr,mortgagecategory,status,mortgagearea,loanyear,obligeeyear]];
            }
        }else{//清收，诉讼
            
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
                }else{
                    repaymethod = @"按月付息，到期还本";
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
            if (rightModel.commitment) {
                if ([rightModel.commitment intValue] == 1) {
                    commitment = @"代理诉讼";
                }else if([rightModel.commitment intValue] == 2){
                    commitment = @"代理仲裁";
                }else{
                    commitment = @"代理执行";
                }
            }
            
            if (self.yyModel.creditorinfos.count > 0) {
                creditorinfo = @"查看";
            }else{
                creditorinfo = @"暂无";
            }
            
            if (self.yyModel.borrowinginfos.count > 0) {
                borrowinginfo = @"查看";
            }else{
                borrowinginfo = @"暂无";
            }
            
            _rightTableView.dataList1 = [NSMutableArray arrayWithArray:@[@"借款利率(%)",@"借款利率类型",@"借款期限",@"借款期限类型",@"还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"]];
            _rightTableView.dataList2 = [NSMutableArray arrayWithArray:@[rate,rate_cat,term,rate_cat,repaymethod,obligor,commitment,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo]];
        }
        
        QDFWeakSelf;
        [_rightTableView setDidSelectedRow:^(NSInteger row) {
            switch (row) {
                case 11:{//债权文件
//                    ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
//                    [weakself.navigationController pushViewController:productsCheckFilesVC animated:YES];
                }
                    break;
                case 12:{//债权人信息
                    
                    if (weakself.yyModel.creditorinfos.count > 0) {
                        ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                        productsCheckDetailVC.listArray = weakself.yyModel.creditorinfos;
                        productsCheckDetailVC.categoryString = @"1";
                        [weakself.navigationController pushViewController:productsCheckDetailVC animated:YES];
                    }
                }
                    break;
                case 13:{//债务人信息
                    if (weakself.yyModel.borrowinginfos.count > 0) {
                        ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                        productsCheckDetailVC.listArray = weakself.yyModel.borrowinginfos;
                        productsCheckDetailVC.categoryString = @"2";
                        [weakself.navigationController pushViewController:productsCheckDetailVC animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }
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
    [self requestDataPostWithString:warnString params:params successBlock:^(id responseObject) {
        BaseModel *warnModel = [BaseModel objectWithKeyValues:responseObject];
        
        [self showHint:warnModel.msg];
        
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
