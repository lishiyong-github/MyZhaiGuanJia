//
//  RequestEndViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RequestEndViewController.h"

#import "PublishCombineView.h"  //申请终止／再考虑一下

#import "MineUserCell.h"
#import "RequestEndCell.h"
#import "EditDebtAddressCell.h"  //终止原因
#import "TakePictureCell.h"  //照片

#import "UIViewController+MutipleImageChoice.h"

#import "ImageModel.h"  //图片

@interface RequestEndViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didsetupConstraints;
@property (nonatomic,strong) UIButton *requestEndRightButton;
@property (nonatomic,strong) UITableView *requestEndTableView;
@property (nonatomic,strong) PublishCombineView *requestEndFootView;

//json
@property (nonatomic,strong) NSMutableArray *reEndImageArray;
@property (nonatomic,strong) NSMutableDictionary *reEndDic; //上传

@end

@implementation RequestEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请终止";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.requestEndRightButton];
    
    [self.view addSubview:self.requestEndTableView];
    [self.view addSubview:self.requestEndFootView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didsetupConstraints) {
        
        [self.requestEndTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.requestEndTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.requestEndFootView];
        
        [self.requestEndFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.requestEndFootView autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didsetupConstraints = YES;
    }
    [super updateViewConstraints];
}

-(UIButton *)requestEndRightButton
{
    if (!_requestEndRightButton) {
        _requestEndRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_requestEndRightButton setTitle:@"平台介入" forState:0];
        [_requestEndRightButton setTitleColor:kWhiteColor forState:0];
        _requestEndRightButton.titleLabel.font = kFirstFont;
        
        QDFWeakSelf;
        [_requestEndRightButton addAction:^(UIButton *btn) {
            [weakself showHint:@"客服"];
            NSMutableString *telPhone = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telPhone]];
        }];
    }
    return _requestEndRightButton;
}

- (UITableView *)requestEndTableView
{
    if (!_requestEndTableView) {
        _requestEndTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _requestEndTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _requestEndTableView.backgroundColor = kBackColor;
        _requestEndTableView.separatorColor = kSeparateColor;
        _requestEndTableView.delegate = self;
        _requestEndTableView.dataSource = self;
    }
    return _requestEndTableView;
}

- (PublishCombineView *)requestEndFootView
{
    if (!_requestEndFootView) {
        _requestEndFootView = [PublishCombineView newAutoLayoutView];
        _requestEndFootView.comButton1.layer.borderColor = kBorderColor.CGColor;
        _requestEndFootView.comButton1.layer.borderWidth = kLineWidth;
        [_requestEndFootView.comButton1 setTitle:@"申请终止" forState:0];
        [_requestEndFootView.comButton1 setTitleColor:kLightGrayColor forState:0];
        
        _requestEndFootView.comButton2.backgroundColor = kButtonColor;
        [_requestEndFootView.comButton2 setTitle:@"再考虑一下" forState:0];
        
        QDFWeakSelf;
        [_requestEndFootView.comButton1 addAction:^(UIButton *btn) {
            [weakself showHint:@"申请终止"];
            [weakself endProduct];
        }];
        
        [_requestEndFootView.comButton2 addAction:^(UIButton *btn) {
            [weakself back];
        }];
    }
    return _requestEndFootView;
}

- (NSMutableArray *)reEndImageArray
{
    if (!_reEndImageArray) {
        _reEndImageArray = [NSMutableArray array];
    }
    return _reEndImageArray;
}

- (NSMutableDictionary *)reEndDic
{
    if (!_reEndDic) {
        _reEndDic = [NSMutableDictionary dictionary];
    }
    return _reEndDic;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kCellHeight1;
        }
        return 96;
    }
    
    if (indexPath.row == 0) {
        return kCellHeight4;
    }
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"reEnd00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            [cell.userActionButton setHidden:YES];
            cell.userNameButton.titleLabel.font = kFirstFont;
            
            [cell.userNameButton setTitle:@"请选择终止的原因：" forState:0];
            [cell.userNameButton setTitleColor:kGrayColor forState:0];
            
            return cell;
            
        }else{
            identifier = @"reEnd01";
            RequestEndCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[RequestEndCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kWhiteColor;
            
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//EditDebtAddressCell.h
            identifier = @"reEnd10";
            EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            cell.backgroundColor = kWhiteColor;
            [cell.ediLabel setHidden:YES];
            cell.leftTextViewConstraints.constant = kSmallPadding;
            
            cell.ediTextView.placeholderColor = kLightGrayColor;
            cell.ediTextView.font = kFirstFont;
            cell.ediTextView.placeholder = @"请详细描述申请终止的缘由，让接单方做的更好。";
            
            QDFWeakSelf;
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.reEndDic setValue:text forKey:@"applymemo"];
            }];
            
            return cell;
            
        }else{//TakePictureCell.h
            identifier = @"reEnd10";
            TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kWhiteColor;
            
            cell.collectionDataList = [NSMutableArray arrayWithObjects:@"upload_pictures", nil];
            
            QDFWeakSelf;
            QDFWeak(cell);
            [cell setDidSelectedItem:^(NSInteger itemTag) {
                if (itemTag == weakcell.collectionDataList.count-1) {//只允许点击最后一个collection
                    if (weakcell.collectionDataList.count < 3) {
                        [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                            
                            if (images.count > 0) {
                                NSData *imData = [NSData dataWithContentsOfFile:images[0]];
                                NSString *imString = [NSString stringWithFormat:@"%@",imData];
                                [weakself uploadImages:imString andType:@"jgp" andFilePath:images[0]];
                                
                                [weakself setDidGetValidImage:^(ImageModel *imageModel) {
                                    if ([imageModel.code isEqualToString:@"0000"]) {
                                        
                                        [weakself.reEndImageArray addObject:imageModel.fileid];
//                                        [weakself.reEndImageArray addObject:imageModel.url];
                                        [weakcell.collectionDataList insertObject:images[0] atIndex:0];
                                        [weakcell reloadData];
                                    }else{
                                        [weakself showHint:imageModel.msg];
                                    }
                                }];
                            }
                        }];
                    }else{
                        [weakself showHint:@"最多添加2张图片"];
                    }
                }else{
                    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除该图片" preferredStyle:0];
                    UIAlertAction *acty1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weakself.reEndImageArray removeObjectAtIndex:itemTag];
                        [weakcell.collectionDataList removeObjectAtIndex:itemTag];
                        [weakcell reloadData];
                        
                    }];
                    UIAlertAction *acty0 = [UIAlertAction actionWithTitle:@"否" style:0 handler:nil];
                    [alertContr addAction:acty0];
                    [alertContr addAction:acty1];
                    
                    [weakself presentViewController:alertContr animated:YES completion:nil];
                }
            }];
            
            return cell;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

#pragma mark - method
- (void)endProduct
{
    [self.view endEditing:YES];
    
    NSString *aaaa = @"";
    if (self.reEndImageArray.count > 0) {
        for (int i=0; i<self.reEndImageArray.count; i++) {
            aaaa = [NSString stringWithFormat:@"%@,%@",self.reEndImageArray[i],aaaa];
        }
        
        aaaa = [aaaa substringWithRange:NSMakeRange(0, aaaa.length-1)];
    }
    
    [self.reEndDic setValue:aaaa forKey:@"file"];
    [self.reEndDic setValue:[self getValidateToken] forKey:@"token"];
    [self.reEndDic setValue:self.ordersid forKey:@"ordersid"];
    
    NSString *endString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfEndString];
    NSDictionary *params = self.reEndDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:endString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
            [weakself back];
        }
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
