//
//  AdditionalEvaluateViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AdditionalEvaluateViewController.h"

#import "MineUserCell.h"
#import "ExeCell.h"
#import "StarCell.h"
#import "TextFieldCell.h"
#import "TakePictureCell.h"

#import "UIViewController+MutipleImageChoice.h"

@interface AdditionalEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *additionalTableView;

@property (nonatomic,strong) NSMutableDictionary *evaDataDictionary;
@property (nonatomic,strong) NSMutableArray *evaImageArray;

@property (nonatomic,assign) NSInteger charCount;

@end

@implementation AdditionalEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写评价";
    self.navigationItem.leftBarButtonItem = self.leftItemAnother;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"提交" forState:0];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(evaluateCommitMessages)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    [self addKeyboardObserver];
    
    [self.view addSubview:self.additionalTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.additionalTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - init
- (UITableView *)additionalTableView
{
    if (!_additionalTableView) {
        _additionalTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _additionalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _additionalTableView.backgroundColor = kBackColor;
        _additionalTableView.separatorColor = kSeparateColor;
        _additionalTableView.delegate = self;
        _additionalTableView.dataSource = self;
    }
    return _additionalTableView;
}

- (NSMutableArray *)evaImageArray
{
    if (!_evaImageArray) {
        _evaImageArray = [NSMutableArray array];
    }
    return _evaImageArray;
}

- (NSMutableDictionary *)evaDataDictionary
{
    if (!_evaDataDictionary) {
        _evaDataDictionary = [NSMutableDictionary dictionary];
    }
    return _evaDataDictionary;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.evaString integerValue] == 0) {
        if (section == 0) {
            return 1;
        }
        return 2;
    }
    return 2;//追评
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.evaString integerValue] == 0) {
        return 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.evaString integerValue] == 0) {
        if (indexPath.section == 0) {
            return 124;
        }else if (indexPath.section == 1 &&indexPath.row == 1){
            return 80;
        }else if (indexPath.section == 2 &&indexPath.row == 1){
            return 80;
        }else if (indexPath.section == 1 &&indexPath.row == 0){
            return 40;
        }
        return 30;
    }
    
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1){
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if ([self.evaString integerValue] == 0) {
        if (indexPath.section == 0){
            identifier = @"additional0";
            StarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[StarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([self.typeString isEqualToString:@"发布方"]) {//发布方给接单方评价
                cell.starLabel1.text = @"态度";
                cell.starLabel2.text = @"专业知识";
                cell.starLabel3.text = @"办事效率";
            }else if ([self.typeString isEqualToString:@"接单方"]){//接单方给发布方
                cell.starLabel1.text = @"真实性";
                cell.starLabel2.text = @"配合度";
                cell.starLabel3.text = @"响应度";
            }
            
            [cell.starView1 setMarkComplete:^(CGFloat score) {
                NSString *scoreStr1 = [NSString stringWithFormat:@"%0.f",score/2];
                [self.evaDataDictionary setValue:scoreStr1 forKey:@"truth_score"];
            }];
            
            [cell.starView2 setMarkComplete:^(CGFloat score) {
                NSString *scoreStr2 = [NSString stringWithFormat:@"%0.f",score/2];
                [self.evaDataDictionary setValue:scoreStr2 forKey:@"assort_score"];
            }];
            [cell.starView3 setMarkComplete:^(CGFloat score) {
                NSString *scoreStr3 = [NSString stringWithFormat:@"%0.f",score/2];
                [self.evaDataDictionary setValue:scoreStr3 forKey:@"response_score"];
            }];
            
            return cell;
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                identifier = @"additional10";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
                }
                
                [cell.userActionButton setHidden:YES];
                [cell.userNameButton setTitle:@"自我感受" forState:0];
                
                return cell;
            }
            
            identifier = @"additional11";
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textField.placeholder = @"请输入您的真实感受，对接单方的帮助很大奥！不少于5个字。";
            cell.textField.font = kSecondFont;
            cell.countLabel.text = [NSString stringWithFormat:@"%lu/400",(unsigned long)cell.textField.text.length];
            
            QDFWeakSelf;
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.evaDataDictionary setValue:text forKey:@"memo"];
            }];
            
            return cell;
            
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                identifier = @"additional20";
                ExeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ExeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.ceButton setTitle:@"添加图片" forState:0];
                
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
                }
                
                return cell;
            }
            
            identifier = @"additional21";
            TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
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
                                    if ([imageModel.error isEqualToString:@"0"]) {

                                        [weakself.evaImageArray addObject:imageModel.fileid];
                                        
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
                        //                    [weakself.evaImageArray removeObjectAtIndex:itemTag];
                        //                    [weakself.additionalTableView reloadData];
                        
                        [weakself.evaImageArray removeObjectAtIndex:itemTag];
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
    }else{//追评
        if (indexPath.row == 0) {
            identifier = @"twice0";
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topTextViewConstraints.constant = 0;
            [cell.countLabel setHidden:YES];
            
            cell.textField.placeholder = @"请输入";
            cell.textField.font = kSecondFont;
            
            QDFWeakSelf;
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.evaDataDictionary setValue:text forKey:@"memo"];
            }];
            
            return cell;
        }
        
        identifier = @"twice1";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
                                if ([imageModel.error isEqualToString:@"0"]) {
                                    [weakself.evaImageArray addObject:imageModel.fileid];
                                    
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
                    //                    [weakself.evaImageArray removeObjectAtIndex:itemTag];
                    //                    [weakself.additionalTableView reloadData];
                    
                    [weakself.evaImageArray removeObjectAtIndex:itemTag];
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return kBigPadding;
    }
    return 0.1f;
}

#pragma mark - method
- (void)rightItemAction
{
    [self.view endEditing:YES];
    
    NSString *evaluateString;
    if ([self.evaString integerValue] == 0) {//评价
        evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kEvaluateString];
    }else if ([self.evaString integerValue] == 1){//追评
        evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kTwiceEvaluateString];
    }
    
    //发布方：态度。接单方：真实性
    self.evaDataDictionary[@"truth_score"] = [NSString getValidStringFromString:self.evaDataDictionary[@"truth_score"] toString:@""];
    //发布方：专业知识。接单方：配合度
    self.evaDataDictionary[@"assort_score"] = [NSString getValidStringFromString:self.evaDataDictionary[@"assort_score"] toString:@""];
    //发布方：办事效率。接单方：响应度
    self.evaDataDictionary[@"response_score"] = [NSString getValidStringFromString:self.evaDataDictionary[@"response_score"] toString:@""];
    
    [self.evaDataDictionary setValue:self.ordersid forKey:@"ordersid"];
    [self.evaDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    NSString *imageStr = @"";
    for (NSInteger i=0; i<self.evaImageArray.count; i++) {
        imageStr = [NSString stringWithFormat:@"%@,%@",self.evaImageArray[i],imageStr];
    }
    if (imageStr.length > 0) {
        imageStr = [imageStr substringToIndex:imageStr.length-1];
    }
    [self.evaDataDictionary setObject:imageStr forKey:@"files"];
    
    NSDictionary *params = self.evaDataDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        BaseModel *evaModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:evaModel.msg];
        if ([evaModel.code isEqualToString:@"0000"]) {
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
