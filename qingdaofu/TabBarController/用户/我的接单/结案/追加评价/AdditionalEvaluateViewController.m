//
//  AdditionalEvaluateViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AdditionalEvaluateViewController.h"

#import "BaseCommitButton.h"
#import "MineUserCell.h"
#import "StarCell.h"
#import "TextFieldCell.h"
#import "TakePictureCell.h"

#import "UIViewController+MutipleImageChoice.h"
#import "UIViewController+Keyboard.h"

@interface AdditionalEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *additionalTableView;

@property (nonatomic,strong) BaseCommitButton *commitEvaButton;
@property (nonatomic,strong) NSMutableDictionary *evaDataDictionary;

@property (nonatomic,assign) NSInteger charCount;

@end

@implementation AdditionalEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写评价";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.additionalTableView];
    [self.view addSubview:self.commitEvaButton];
    [self.view setNeedsUpdateConstraints];
    
    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.additionalTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.additionalTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.commitEvaButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.commitEvaButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark -
- (UITableView *)additionalTableView
{
    if (!_additionalTableView) {
        _additionalTableView = [UITableView newAutoLayoutView];
        _additionalTableView.backgroundColor = kBackColor;
        _additionalTableView.delegate = self;
        _additionalTableView.dataSource = self;
        _additionalTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
        _additionalTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _additionalTableView;
}

- (BaseCommitButton *)commitEvaButton
{
    if (!_commitEvaButton) {
        _commitEvaButton = [BaseCommitButton newAutoLayoutView];
        [_commitEvaButton setTitle:@"提交评价" forState:0];
        [_commitEvaButton addTarget:self action:@selector(evaluateCommitMessages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitEvaButton;
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 1){
        return 145;
    }else if (indexPath.row ==2){
        return 100;
    }else if (indexPath.row == 3){
        return 80;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"additional0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = kBackColor;
        
        NSArray *tyArray = @[@"融资",@"清收",@"诉讼"];
        NSString *tyString = tyArray[[self.categoryString integerValue] -1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"您的%@单号%@已经结束，感谢您对平台的信任，请留下您的评价",tyString,self.codeString];
        cell.textLabel.font = kFirstFont;
        cell.textLabel.textColor = kBlueColor;
        cell.textLabel.numberOfLines = 0;
        
        return cell;
    }else if (indexPath.row == 1){
        identifier = @"additional1";
        StarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[StarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.typeString isEqualToString:@"发布方"]) {//发布方给接单方
            cell.starLabel1.text = @"真实性";
            cell.starLabel2.text = @"配合度";
            cell.starLabel3.text = @"响应度";
        }else if ([self.typeString isEqualToString:@"接单方"]){//接单方给发布方
            cell.starLabel1.text = @"态度";
            cell.starLabel2.text = @"专业知识";
            cell.starLabel3.text = @"办事效率";
        }
        
        [cell.starView1 setMarkComplete:^(CGFloat score) {
            NSString *scoreStr1 = [NSString stringWithFormat:@"%0.f",score/2];
            [self.evaDataDictionary setValue:scoreStr1 forKey:@"serviceattitude"];
        }];
        
        [cell.starView2 setMarkComplete:^(CGFloat score) {
            NSString *scoreStr2 = [NSString stringWithFormat:@"%0.f",score/2];
            [self.evaDataDictionary setValue:scoreStr2 forKey:@"professionalknowledge"];
        }];
        [cell.starView3 setMarkComplete:^(CGFloat score) {
            NSString *scoreStr3 = [NSString stringWithFormat:@"%0.f",score/2];
            [self.evaDataDictionary setValue:scoreStr3 forKey:@"workefficiency"];
        }];
        
        return cell;
        
    }else if (indexPath.row == 2){
        identifier = @"additional2";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textField.placeholder = @"请输入您的真实感受，对接单方的帮助很大奥";
        cell.textField.font = kSecondFont;
        cell.countLabel.text = [NSString stringWithFormat:@"%lu/600",(unsigned long)cell.textField.text.length];
        
        QDFWeakSelf;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.evaDataDictionary setValue:text forKey:@"content"];
        }];
        
        return cell;
        
    }else if (indexPath.row == 3){
        identifier = @"additional3";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.collectionDataList = [NSMutableArray arrayWithObjects:@"btn_camera", nil];
        
        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidSelectedItem:^(NSInteger itemTag) {
            [weakself addImageWithMaxSelection:2 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                
                NSData *tData;
                NSString *ttt = @"";
                NSString *tStr = @"";
                for (int i=0; i<images.count; i++) {
                    tData = [NSData dataWithContentsOfFile:images[i]];
                    ttt = [NSString stringWithFormat:@"%@",tData];
                    tStr = [NSString stringWithFormat:@"%@,%@",tStr,ttt];
                }
                [weakself.evaDataDictionary setValue:tStr forKey:@"pictures"];
                weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
                [weakcell reloadData];
            }];
        }];
        
        return cell;
    }
        identifier = @"additional4";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setTitle:@"匿名评价  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"anonymous"] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"real_name"] forState:UIControlStateSelected];
        
        [cell.userActionButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {//0为正常评价。1为匿名评价
                [self.evaDataDictionary setValue:@"1" forKey:@"isHide"];
            }else{
                [self.evaDataDictionary setValue:@"0" forKey:@"isHide"];
            }
        }];
        
        return cell;
}

#pragma mark - method
- (void)evaluateCommitMessages
{
    [self.view endEditing:YES];
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kEvaluateString];
    
    //发布方：态度。接单方：真实性
    self.evaDataDictionary[@"serviceattitude"] = self.evaDataDictionary[@"serviceattitude"]?self.evaDataDictionary[@"serviceattitude"]:@"";
    //发布方：专业知识。接单方：响应度
    self.evaDataDictionary[@"professionalknowledge"] = self.evaDataDictionary[@"professionalknowledge"]?self.evaDataDictionary[@"professionalknowledge"]:@"";
    //发布方：办事效率。接单方：响应度
    self.evaDataDictionary[@"workefficiency"] = self.evaDataDictionary[@"workefficiency"]?self.evaDataDictionary[@"workefficiency"]:@"";
    self.evaDataDictionary[@"content"] = self.evaDataDictionary[@"content"]?self.evaDataDictionary[@"content"]:@"优质，专业，高效，快捷";
    self.evaDataDictionary[@"isHide"] = self.evaDataDictionary[@"isHide"]?self.evaDataDictionary[@"isHide"]:@"0";

    self.evaDataDictionary[@"category"] = self.categoryString;
    self.evaDataDictionary[@"product_id"] = self.idString;
    self.evaDataDictionary[@"pictures"] = self.evaDataDictionary[@"pictures"]?self.evaDataDictionary[@"pictures"]:@"";
    self.evaDataDictionary[@"type"] = self.evaString;
    self.evaDataDictionary[@"token"] = [self getValidateToken];
    
    NSDictionary *params = self.evaDataDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        BaseModel *evaModel = [BaseModel objectWithKeyValues:responseObject];
        if ([evaModel.code isEqualToString:@"0000"]) {
            [weakself showHint:evaModel.msg];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else if (![evaModel.code isEqualToString:@"1014"]){
            [weakself showHint:evaModel.msg];
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
