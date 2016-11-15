//
//  SignProtocolViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SignProtocolViewController.h"
#import "PublishCombineView.h"

#import "UIViewController+MutipleImageChoice.h"
#import "UIViewController+ImageBrowser.h"

#import "MineUserCell.h"
#import "TakePictureCell.h"

#import "SignPactsResonse.h"
#import "ImageModel.h"

@interface SignProtocolViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *sighProtocolTableView;
@property (nonatomic,strong) PublishCombineView *signCommitButton;

//json
@property (nonatomic,strong) NSMutableArray *signImageArray; //添加图片
@property (nonatomic,strong) NSMutableArray *signDataArray;  //解析

@end

@implementation SignProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签约协议";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.sighProtocolTableView];
    
    if ([self.isShowString integerValue] == 1) {
        [self.view addSubview:self.signCommitButton];
    }else{
        [self getDetailsOfSign];
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        if ([self.isShowString integerValue] == 1) {
            [self.sighProtocolTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.sighProtocolTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.signCommitButton];
            
            [self.signCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.signCommitButton autoSetDimension:ALDimensionHeight toSize:116];
            
        }else{
            [self.sighProtocolTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)sighProtocolTableView
{
    if (!_sighProtocolTableView) {
        _sighProtocolTableView = [UITableView newAutoLayoutView];
        _sighProtocolTableView.backgroundColor = kBackColor;
        _sighProtocolTableView.separatorColor = kSeparateColor;
        _sighProtocolTableView.delegate = self;
        _sighProtocolTableView.dataSource = self;
        _sighProtocolTableView.tableFooterView = [[UIView alloc] init];
    }
    return _sighProtocolTableView;
}

- (PublishCombineView *)signCommitButton
{
    if (!_signCommitButton) {
        _signCommitButton = [PublishCombineView newAutoLayoutView];
        [_signCommitButton.comButton1 setBackgroundColor:kButtonColor];
        [_signCommitButton.comButton1 setTitleColor:kWhiteColor forState:0];
        [_signCommitButton.comButton1 setTitle:@"保存" forState:0];
        [_signCommitButton.comButton2 setTitle:@"确认上传并开始尽职调查" forState:0];
        _signCommitButton.comButton2.layer.borderColor = kBorderColor.CGColor;
        _signCommitButton.comButton2.layer.borderWidth = kLineWidth;
        [_signCommitButton.comButton2 setTitleColor:kLightGrayColor forState:0];
        
        QDFWeakSelf;
        [_signCommitButton.comButton1 addAction:^(UIButton *btn) {
            [weakself saveSignImages];
        }];
        
        [_signCommitButton.comButton2 addAction:^(UIButton *btn) {
            UIAlertController *signAlert = [UIAlertController alertControllerWithTitle:@"确认协议无误并上传吗？" message:@"确认后协议不能修改，并开始尽职调查" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *signAct0 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [weakself commitSignImages];
            }];
            
            UIAlertAction *signAct1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
            [signAlert addAction:signAct0];
            [signAlert addAction:signAct1];
            [weakself presentViewController:signAlert animated:YES completion:nil];
        }];
    }
    return _signCommitButton;
}

- (NSMutableArray *)signImageArray
{
    if (!_signImageArray) {
        _signImageArray = [NSMutableArray array];
    }
    return _signImageArray;
}

- (NSMutableArray *)signDataArray
{
    if (!_signDataArray) {
        _signDataArray = [NSMutableArray array];
    }
    return _signDataArray;
}

#pragma mark - tableView delagate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kCellHeight;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"sign0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackColor;
        [cell.userActionButton setHidden:YES];
        [cell.userNameButton setTitle:@"协议照片" forState:0];

        return cell;
    }
    
    identifier = @"sign1";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.signDataArray.count > 0) {
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.signDataArray];
        [cell reloadData];
    }else{
        cell.collectionDataList = [NSMutableArray arrayWithObjects:@"upload_pictures", nil];
    }
    
    QDFWeakSelf;
    QDFWeak(cell);
    [cell setDidSelectedItem:^(NSInteger itemTag) {
        
        if ([weakself.isShowString integerValue] == 0) {
            [weakself showImages:self.signDataArray currentIndex:0];
        }else{
            if (itemTag == weakcell.collectionDataList.count-1) {//只允许点击最后一个collection
                if (weakcell.collectionDataList.count < 3) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        
                        if (images.count > 0) {
                            NSData *imData = [NSData dataWithContentsOfFile:images[0]];
                            NSString *imString = [NSString stringWithFormat:@"%@",imData];
                            [weakself uploadImages:imString andType:@"jgp" andFilePath:images[0]];
                            
                            [weakself setDidGetValidImage:^(ImageModel *imageModel) {
                                if ([imageModel.code isEqualToString:@"0000"]) {
                                    [weakself.signImageArray addObject:imageModel.fileid];
                                    
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
                    //                    [weakself.signImageArray removeObjectAtIndex:itemTag];
                    //                    [weakself.additionalTableView reloadData];
                    
                    [weakself.signImageArray removeObjectAtIndex:itemTag];
                    [weakcell.collectionDataList removeObjectAtIndex:itemTag];
                    [weakcell reloadData];
                    
                }];
                UIAlertAction *acty0 = [UIAlertAction actionWithTitle:@"否" style:0 handler:nil];
                [alertContr addAction:acty0];
                [alertContr addAction:acty1];
                
                [weakself presentViewController:alertContr animated:YES completion:nil];
            }
        }
    }];
    
    return cell;
}

#pragma mark - method
- (void)saveSignImages
{
    NSString *signString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfSaveSign];
    
    NSString *dddd = @"";
    if (self.signImageArray.count > 0) {
        for (NSInteger i=0; i<self.signImageArray.count; i++) {
            dddd = [NSString stringWithFormat:@"%@,%@",self.signImageArray[i],dddd];
        }
        dddd = [dddd substringWithRange:NSMakeRange(0, dddd.length-1)];
    }
    
     NSDictionary *params = @{@"token" : [self getValidateToken],
               @"files" : dddd,
               @"ordersid" : self.ordersid
               };
    
    QDFWeakSelf;
    [self requestDataPostWithString:signString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)commitSignImages
{
    NSString *signString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfCommitSign];
    
    NSDictionary *params;
    if (self.signDataArray.count > 0) {
        params = @{@"token" : [self getValidateToken],
                   @"ordersid" : self.ordersid
                   };
    }else{
        NSString *dddd = @"";
        if (self.signImageArray.count > 0) {
            for (NSInteger i=0; i<self.signImageArray.count; i++) {
                dddd = [NSString stringWithFormat:@"%@,%@",self.signImageArray[i],dddd];
            }
            dddd = [dddd substringWithRange:NSMakeRange(0, dddd.length-1)];
        }
        params = @{@"token" : [self getValidateToken],
                   @"files" : dddd,
                   @"ordersid" : self.ordersid
                   };
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:signString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDetailsOfSign
{
    NSString *saveSignString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfCheckSign];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"ordersid" : self.ordersid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:saveSignString params:params successBlock:^(id responseObject) {
        
        NSDictionary *qop = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        SignPactsResonse *responsed = [SignPactsResonse objectWithKeyValues:responseObject];
        
        for (ImageModel *imageModel in responsed.pacts) {
            [weakself.signDataArray addObject:imageModel.file];
        }
        
        [weakself.sighProtocolTableView reloadData];
        
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
