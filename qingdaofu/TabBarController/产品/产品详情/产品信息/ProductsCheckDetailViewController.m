//
//  ProductsCheckDetailViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsCheckDetailViewController.h"
#import "DebtCell.h"
#import "DebtModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+ImageBrowser.h"


@interface ProductsCheckDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupconstraints;
@property (nonatomic,strong) UITableView *listTableView;

@end

@implementation ProductsCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.categoryString integerValue] == 1) {
        self.title = @"债权人信息";
    }else{
        self.title = @"债务人信息";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    [self.view addSubview:self.listTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupconstraints) {
        [self.listTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupconstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _listTableView.backgroundColor = kBackColor;
        _listTableView.separatorColor = kSeparateColor;
    }
    return _listTableView;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"debtCredit";
    DebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.debtEditButton setHidden:YES];

    DebtModel *deModel = self.listArray[indexPath.section];
    
    NSString *name;
    if ([self.categoryString  integerValue] == 1) {//债权人信息
        name = [NSString getValidStringFromString:deModel.creditorname];
    }else{//债务人信息
        name = [NSString getValidStringFromString:deModel.borrowingname];
    }
    NSMutableAttributedString *nameStr = [cell.debtNameLabel setAttributeString:@"姓        名    " withColor:kBlackColor andSecond:name withColor:kLightGrayColor withFont:14];
    [cell.debtNameLabel setAttributedText:nameStr];
    
    NSString *tel;
    if ([self.categoryString  integerValue] == 1) {
        tel = [NSString getValidStringFromString:deModel.creditormobile];;
    }else{
        tel = [NSString getValidStringFromString:deModel.borrowingmobile];;
    }
    NSMutableAttributedString *telStr = [cell.debtTelLabel setAttributeString:@"联系方式    " withColor:kBlackColor andSecond:tel withColor:kLightGrayColor withFont:14];
    [cell.debtTelLabel setAttributedText:telStr];
    
//    cell.debtAddressLabel.text = @"联系地址";
    if ([self.categoryString integerValue] == 1) {
        NSString *yuy = [NSString getValidStringFromString:deModel.creditoraddress];
        NSMutableAttributedString *addressStr = [cell.debtTelLabel setAttributeString:@"联系地址    " withColor:kBlackColor andSecond:yuy withColor:kLightGrayColor withFont:14];
        [cell.debtAddressLabel setAttributedText:addressStr];
    }else{
        NSString *yuy = [NSString getValidStringFromString:deModel.borrowingaddress];
        NSMutableAttributedString *addressStr = [cell.debtTelLabel setAttributeString:@"联系地址    " withColor:kBlackColor andSecond:yuy withColor:kLightGrayColor withFont:14];
        [cell.debtAddressLabel setAttributedText:addressStr];
    }
    
    NSString *ID;
    if ([self.categoryString  integerValue] == 1) {//债权人
        ID = [NSString getValidStringFromString:deModel.creditorcardcode];
    }else{
        ID = [NSString getValidStringFromString:deModel.borrowingcardcode];
    }
    NSMutableAttributedString *IDStr = [cell.debtIDLabel setAttributeString:@"证件号        " withColor:kBlackColor andSecond:ID withColor:kLightGrayColor withFont:14];
    [cell.debtIDLabel setAttributedText:IDStr];
    
    QDFWeakSelf;
    if (deModel.creditorcardimage.count < 2) {
        [cell.debtImageView1 setHidden:NO];
        [cell.debtImageView2 setHidden:YES];
        
        NSString *subImgw;
        if (deModel.creditorcardimage.count == 1) {
            NSString *gugug = deModel.creditorcardimage[0];
            if ([gugug isEqualToString:@""]) {
                subImgw = @"";
            }else{
                NSString *imgw = deModel.creditorcardimage[0];
                subImgw = [imgw substringWithRange:NSMakeRange(1, imgw.length-2)];
            }
        }else{
            subImgw = @"";
        }
        
        NSString *urlImgw = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subImgw];
        NSURL *Url = [NSURL URLWithString:urlImgw];
        [cell.debtImageView1 sd_setImageWithURL:Url forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        [cell.debtImageView1 addAction:^(UIButton *btn) {
            [weakself showImages:@[Url]];
        }];
        
    }else if(deModel.creditorcardimage.count >= 2){
        [cell.debtImageView1 setHidden:NO];
        [cell.debtImageView2 setHidden:NO];
        
        NSString *imgw1 = deModel.creditorcardimage[0];
        NSString *subImgw1 = [imgw1 substringWithRange:NSMakeRange(1, imgw1.length-2)];
        NSString *urlImgw1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subImgw1];
        NSURL *Url1 = [NSURL URLWithString:urlImgw1];
        [cell.debtImageView1 sd_setImageWithURL:Url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        NSString *imgw2 = deModel.creditorcardimage[0];
        NSString *subImgw2 = [imgw2 substringWithRange:NSMakeRange(1, imgw2.length-2)];
        NSString *urlImgw2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subImgw2];
        NSURL *Url2 = [NSURL URLWithString:urlImgw2];
        [cell.debtImageView2 sd_setImageWithURL:Url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        
        [cell.debtImageView1 addAction:^(UIButton *btn) {
            [weakself showImages:@[Url1,Url2]];
        }];
        [cell.debtImageView2 addAction:^(UIButton *btn) {
            [weakself showImages:@[Url1,Url2]];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
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
