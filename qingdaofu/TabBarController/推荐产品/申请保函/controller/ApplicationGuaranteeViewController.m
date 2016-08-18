//
//  ApplicationGuaranteeViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeViewController.h"
#import "ApplicationCourtViewController.h"  //选择法院
#import "ApplicationListViewController.h"   //我的保函

#import "ApplicationGuaranteeView.h"
#import "ApplicationGuaranteeFirstView.h"
#import "ApplicationGuaranteeSecondView.h"
#import "ApplicationGuaranteeThirdView.h"

#import "AgentCell.h"
#import "MineUserCell.h"
#import "TakePictureCell.h"

#import "UIViewController+MutipleImageChoice.h"
#import "UIViewController+BlurView.h"

@interface ApplicationGuaranteeViewController ()

@property (nonatomic,strong) ApplicationGuaranteeView *applicationTopView;
@property (nonatomic,strong) ApplicationGuaranteeFirstView *guaranteeFirstView;
@property (nonatomic,strong) ApplicationGuaranteeSecondView *guaranteeSecondView;
@property (nonatomic,strong) ApplicationGuaranteeThirdView *guaranteeThirdView;

@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableDictionary *applicationDic;
@property (nonatomic,strong) NSString *provinceStr;
@property (nonatomic,strong) NSString *cityStr;
@property (nonatomic,strong) NSString *districtStr;

@end

@implementation ApplicationGuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请保函";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    _districtStr = @"请选择";
    
    [self.view addSubview:self.applicationTopView];
    [self.view addSubview:self.guaranteeFirstView];
    [self.view addSubview:self.guaranteeSecondView];
    [self.guaranteeSecondView setHidden:YES];
    [self.view addSubview:self.guaranteeThirdView];
    [self.guaranteeThirdView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applicationTopView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.applicationTopView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        [self.guaranteeFirstView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.guaranteeFirstView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.applicationTopView];
        
        [self.guaranteeSecondView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.guaranteeSecondView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.applicationTopView];
        
        [self.guaranteeThirdView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.guaranteeThirdView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.applicationTopView];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (ApplicationGuaranteeView *)applicationTopView
{
    if (!_applicationTopView) {
        _applicationTopView = [ApplicationGuaranteeView newAutoLayoutView];
        [_applicationTopView.firstButton setTitle:@"基本信息" forState:0];
        [_applicationTopView.secondButton setTitle:@"完善资料" forState:0];
        [_applicationTopView.thirdButton setTitle:@"完成" forState:0];
    }
    return _applicationTopView;
}

- (ApplicationGuaranteeFirstView *)guaranteeFirstView
{
    if (!_guaranteeFirstView) {
        _guaranteeFirstView = [ApplicationGuaranteeFirstView newAutoLayoutView];
        
        QDFWeakSelf;
        [_guaranteeFirstView setDidSelectedRow:^(NSInteger row) {
            switch (row) {
                case 0:{//选择法院
                    ApplicationCourtViewController *applicationCourtVC = [[ApplicationCourtViewController alloc] init];
                    [weakself.navigationController pushViewController:applicationCourtVC animated:YES];
                    
                    [applicationCourtVC setDidSelectedRow:^(NSString *nameString,NSString *idString) {
                        AgentCell *cell = [weakself.guaranteeFirstView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.agentTextField.text = nameString;
                        [weakself.applicationDic setObject:idString forKey:@"fayuan_id"];
                    }];
                }
                    break;
                case 1:{//案件类型
                    NSArray *array11 = @[@"借贷纠纷",@"房产土地",@"劳动纠纷",@"婚姻家庭",@" 合同纠纷",@"公司治理",@"知识产权",@"其他民事纠纷"];
                    [weakself showBlurInView:weakself.view withArray:array11 andTitle:@"选择案件类型" finishBlock:^(NSString *text, NSInteger row) {
                        AgentCell *cell = [weakself.guaranteeFirstView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell.agentTextField.text = text;
                        [weakself.applicationDic setObject:text forKey:@"category"];
                    }];
                }
                    break;
                case 7:{//收货地址
                    if (weakself.applicationDic[@"court"]) {
                        NSLog(@"选择收货地址");
                    }
                }
                    break;
                case 10:{//下一步
                    [weakself.guaranteeFirstView setHidden:YES];
                    [weakself.guaranteeSecondView setHidden:NO];
                    
                    weakself.applicationTopView.leftBlueConstraints.constant = kScreenWidth/3;
                    [weakself.applicationTopView.firstButton setTitleColor:kGrayColor forState:0];
                    [weakself.applicationTopView.secondButton setTitleColor:kBlueColor forState:0];
                }
                    break;
                case 11:{//取函方式－快递
                    AgentCell *cell = [weakself.guaranteeFirstView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    cell.agentLabel.text = @"收获地址";
                    cell.agentTextField.text = @"";
                    [cell.agentButton setHidden:NO];
                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }
                    break;
                case 12:{//取函方式－自取
                    if (weakself.applicationDic[@"court"]) {
                        NSLog(@"自取");
                        AgentCell *cell = [weakself.guaranteeFirstView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                        cell.agentLabel.text = @"取函地址";
                        [cell.agentButton setHidden:YES];

                        cell.agentTextField.text = weakself.applicationDic[@"court"];
                    }else{
                        [weakself showHint:@"请先选择法院"];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }
    return _guaranteeFirstView;
}

- (ApplicationGuaranteeSecondView *)guaranteeSecondView
{
    if (!_guaranteeSecondView) {
        _guaranteeSecondView = [ApplicationGuaranteeSecondView newAutoLayoutView];
        
        QDFWeakSelf;
        [_guaranteeSecondView setDidSelectedRow:^(NSInteger tag) {
            
            if (tag < 8) {//1,3,5,7
                [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                    if (tag == 1) {//起诉书
                        
                        for(NSInteger i = 0; i < images.count; i++) {
                            NSData * imageData = UIImageJPEGRepresentation(images[i], 0.5);
                            // 上传的参数名
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        }
                        
                        TakePictureCell *cell = [weakself.guaranteeSecondView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                        [cell reloadData];
                        
                        
                    }else if (tag == 3){//财产保全申请书
                        TakePictureCell *cell = [weakself.guaranteeSecondView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                        cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                        [cell reloadData];

                    }else if (tag == 5){//相关证据材料
                        TakePictureCell *cell = [weakself.guaranteeSecondView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                        cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                        [cell reloadData];

                    }else if (tag == 7){//案件受理通知书
                        TakePictureCell *cell = [weakself.guaranteeSecondView.tableViewa cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
                        cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                        [cell reloadData];

                    }
                }];
            }else if (tag == 11){//上一步
                [weakself.guaranteeSecondView setHidden:YES];
                [weakself.guaranteeFirstView setHidden:NO];
                
                weakself.applicationTopView.leftBlueConstraints.constant = 0;
                [weakself.applicationTopView.secondButton setTitleColor:kGrayColor forState:0];
                [weakself.applicationTopView.firstButton setTitleColor:kBlueColor forState:0];

            }else if (tag == 12){//立即申请
                [weakself.guaranteeThirdView setHidden:NO];
                [weakself.guaranteeSecondView setHidden:YES];
                
                weakself.applicationTopView.leftBlueConstraints.constant = kScreenWidth/3*2;
                [weakself.applicationTopView.secondButton setTitleColor:kGrayColor forState:0];
                [weakself.applicationTopView.thirdButton setTitleColor:kBlueColor forState:0];
            }
        }];
    }
    return _guaranteeSecondView;
}

- (ApplicationGuaranteeThirdView *)guaranteeThirdView
{
    if (!_guaranteeThirdView) {
        _guaranteeThirdView = [ApplicationGuaranteeThirdView newAutoLayoutView];
        
        QDFWeakSelf;
        [_guaranteeThirdView setDidSelectedRow:^(NSInteger tag) {
            if (tag == 21) {//回首页
                
            }else if (tag == 22){//我的保函
                UINavigationController *nav = weakself.navigationController;
                [nav popViewControllerAnimated:NO];
                
                ApplicationListViewController *applicationListVC = [[ApplicationListViewController alloc] init];
                applicationListVC.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:applicationListVC animated:NO];
            }
        }];
    }
    return _guaranteeThirdView;
}

/*
- (UIView *)pickerChooseView
{
    if (!_pickerChooseView) {
        _pickerChooseView = [UIView newAutoLayoutView];
        [_pickerChooseView addSubview:self.pickerButton];
        [_pickerChooseView addSubview:self.applicationPickerView];
        
        [self.pickerButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.pickerButton autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.applicationPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.applicationPickerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pickerButton];
    }
    return _pickerChooseView;
}

- (UIButton *)pickerButton
{
    if (!_pickerButton) {
        _pickerButton = [UIButton newAutoLayoutView];
        [_pickerButton setTitle:@"完成" forState:0];
        [_pickerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kBigPadding)];
        _pickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _pickerButton.titleLabel.font = kSecondFont;
        [_pickerButton setTitleColor:kBlackColor forState:0];
        _pickerButton.layer.borderColor = kLightGrayColor.CGColor;
        _pickerButton.layer.borderWidth = kLineWidth;
    
        QDFWeakSelf;
        [_pickerButton addAction:^(UIButton *btn) {
            [weakself.pickerChooseView setHidden:YES];
            MineUserCell *cell = [weakself.applicationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.userActionButton setTitle:weakself.districtStr forState:0];
        }];
        
    }
    return _pickerButton;
}


- (UIPickerView *)applicationPickerView
{
    if (!_applicationPickerView) {
        _applicationPickerView = [UIPickerView newAutoLayoutView];
        _applicationPickerView.delegate = self;
        _applicationPickerView.dataSource = self;
    }
    return _applicationPickerView;
}

 */
- (NSMutableDictionary *)applicationDic
{
    if (!_applicationDic) {
        _applicationDic = [NSMutableDictionary dictionary];
    }
    return _applicationDic;
}

#pragma mark - method
- (void)uploadImages:(NSData *)imgData
{
    NSString *uploadsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kUploadImagesString];
    NSDictionary *params = @{@"filetype" : @"1",
                             @"extension" : @"jpg",
                             @"picture" : imgData
                             };
//    [self req];
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
