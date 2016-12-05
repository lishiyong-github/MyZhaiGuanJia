//
//  ApplicationGuaranteeSecondView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeSecondView.h"

#import "BaseCommitButton.h"
#import "MineUserCell.h"
#import "TakePictureCell.h"

@interface ApplicationGuaranteeSecondView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *lastButton;
@property (nonatomic,strong) UIButton *applyButton;

@end

@implementation ApplicationGuaranteeSecondView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackColor;

        [self addSubview:self.tableViewa];
        [self addSubview:self.lastButton];
        [self addSubview:self.applyButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSrtupConstraints) {
        
        [self.tableViewa autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.tableViewa autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.lastButton];
        
        [self.lastButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.lastButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.lastButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.lastButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth/2];
        
        [self.applyButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.applyButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.applyButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.lastButton];
        [self.applyButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.lastButton];
        
        self.didSrtupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITableView *)tableViewa
{
    if (!_tableViewa) {
        _tableViewa.translatesAutoresizingMaskIntoConstraints = NO;
        _tableViewa = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableViewa.delegate = self;
        _tableViewa.dataSource = self;
        _tableViewa.backgroundColor = kBackColor;
        _tableViewa.separatorColor = kSeparateColor;
    }
    return _tableViewa;
}

- (UIButton *)lastButton
{
    if (!_lastButton) {
        _lastButton = [UIButton newAutoLayoutView];
        [_lastButton setBackgroundColor:kWhiteColor];
        [_lastButton setTitle:@"上一步" forState:0];
        [_lastButton setTitleColor:kGrayColor forState:0];
        _lastButton.titleLabel.font = kBigFont;
        _lastButton.layer.borderColor = kSeparateColor.CGColor;
        _lastButton.layer.borderWidth = kLineWidth;
        
        QDFWeakSelf;
        [_lastButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedRow) {
                weakself.didSelectedRow(11);
            }
        }];
    }
    return _lastButton;
}

- (UIButton *)applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton newAutoLayoutView];
        [_applyButton setTitle:@"立即申请" forState:0];
        [_applyButton setBackgroundColor:kBlueColor];
        [_applyButton setTitleColor:kWhiteColor forState:0];
        _applyButton.titleLabel.font = kBigFont;
        
        QDFWeakSelf;
        [_applyButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedRow) {
                weakself.didSelectedRow(12);
            }
        }];
    }
    return _applyButton;
}

#pragma mark -tableview delegate and datasoyrce
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 50+kBigPadding*2;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"upImage0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setHidden:YES];
        
        NSArray *upArray = @[@"起诉书",@"财产保全申请书",@"相关证据材料",@"案件受理通知书"];
        [cell.userNameButton setTitle:upArray[indexPath.section] forState:0];
        
        return cell;
    }
    
    identifier = @"upImage1";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectionDataList = [NSMutableArray arrayWithObject:@"upload_pictures"];
    [cell reloadData];
    
    QDFWeakSelf;
    [cell setDidSelectedItem:^(NSInteger items) {
        
        if (weakself.didSelectedRow) {
            weakself.didSelectedRow(indexPath.section*2+indexPath.row);
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 30;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        footerView.backgroundColor = kBackColor;
        
        UIButton *footerButton = [UIButton newAutoLayoutView];
        [footerButton setImage:[UIImage imageNamed:@"tip_message"] forState:0];
        [footerButton setTitle:@"  请确保提供的材料真实性和完整性，同时我们会保护您的隐私" forState:0];
        [footerButton setTitleColor:kLightGrayColor forState:0];
        footerButton.titleLabel.font = kTabBarFont;
        [footerButton setContentHorizontalAlignment:1];
        [footerView addSubview:footerButton];
        
        [footerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [footerButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [footerButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        return footerView;
    }
    
    return nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
