//
//  ProductsDetailsProViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsDetailsProViewController.h"

#import "DebtDocumnetsViewController.h"    //债权文件

#import "EvaTopSwitchView.h"
#import "ProdLeftView.h"
#import "ProdRightView.h"

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

#pragma mark - method
- (void)remindPublisher
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否提醒发布方完善信息？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:act1];
    [alertController addAction:act2];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
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

- (ProdLeftView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [ProdLeftView newAutoLayoutView];
        PublishingModel *leftModel = self.yyModel.product;
        if ([leftModel.category intValue] == 1) {//融资
            
            //返点
            NSString *rebateStr = [NSString stringWithFormat:@"%@%@",leftModel.rebate,@"%"];
            //利率
            NSString *rateStr = [NSString stringWithFormat:@"%@%@",leftModel.rate,@"%"];
            
            //利率类型
            NSString *rateCatStr;
            if ([leftModel.rate_cat intValue] == 1) {
                rateCatStr = @"利率(天)";
            }else if ([leftModel.rate_cat intValue] == 2){
                rateCatStr = @"利率(月)";
            }
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"金额(万)",@"返点",rateCatStr,@"抵押物地址"]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,rebateStr,rateStr,leftModel.seatmortgage]];
        }else if ([leftModel.category intValue] == 2){//催收
            
            NSString *loanTypeStr;//债权类型
            if ([leftModel.loan_type intValue] == 1) {
                loanTypeStr = @"房产抵押";
            }else if ([leftModel.loan_type intValue] == 2){
                loanTypeStr = @"应收账款";
            }else if ([leftModel.loan_type intValue] == 3){
                loanTypeStr = @"机动车抵押";
            }else if ([leftModel.loan_type intValue] == 4){
                loanTypeStr = @"无抵押";
            }
            
             //代理费用
            NSString *agencycommissionStr = [NSString stringWithFormat:@"%@%@",leftModel.agencycommission,@"%"];
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金(万)",@"借款期限",@"还款方式",@"债权类型",@"债务人主体",@"委托代理期限",@"代理费用"]];
//            [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,@"暂无",leftModel.repaymethod,loanTypeStr,leftModel.guaranteemethod,leftModel.seatmortgage,leftModel.obligor,leftModel.commissionperiod,agencycommissionStr]];
            
            
        }else if ([leftModel.category intValue] == 3){//诉讼
            
            NSString *typeStr;//债权类型
            if ([leftModel.loan_type intValue] == 1) {
                typeStr = @"房产抵押";
            }else if ([leftModel.loan_type intValue] == 2){
                typeStr = @"应收账款";
            }else if ([leftModel.loan_type intValue] == 3){
                typeStr = @"机动车抵押";
            }else if ([leftModel.loan_type intValue] == 4){
                typeStr = @"无抵押";
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
            
            [_leftTableView.leftDataArray1 addObjectsFromArray:@[@"借款本金",@"借款期限",@"还款方式",@"债权类型",@"债务人主体",@"委托事项",@"委托代理期限",agencycommissiontypeStr]];
            [_leftTableView.leftDataArray2 addObjectsFromArray:@[leftModel.money,leftModel.term,leftModel.repaymethod,typeStr,leftModel.obligor,commitmentStr,leftModel.commissionperiod,leftModel.agencycommission]];
        }
        [_leftTableView reloadData];
    }
    return _leftTableView;
}

- (ProdRightView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [ProdRightView newAutoLayoutView];
        QDFWeakSelf;
        [_rightTableView setDidSelectedRow:^(NSInteger row) {
            switch (row) {
                case 9:{//债权文件
                    DebtDocumnetsViewController *debtDocumnetsVC = [[DebtDocumnetsViewController alloc] init];
                    [weakself.navigationController pushViewController:debtDocumnetsVC animated:YES];
                }
                    break;
                case 10:{//债权人信息
                    
                }
                    break;
                case 11:{//债务人信息
                    
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
    return _rightTableView;
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
