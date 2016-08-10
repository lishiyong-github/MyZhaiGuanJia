//
//  ApplicationGuaranteeThirdView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeThirdView.h"

#import "ApplicationSuccessCell.h"

@interface ApplicationGuaranteeThirdView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViewa;

@end

@implementation ApplicationGuaranteeThirdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackColor;
        
        [self addSubview:self.tableViewa];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSrtupConstraints) {
        
        [self.tableViewa autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSrtupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITableView *)tableViewa
{
    if (!_tableViewa) {
        _tableViewa = [UITableView newAutoLayoutView];
        _tableViewa.delegate = self;
        _tableViewa.dataSource = self;
        _tableViewa.backgroundColor = kBackColor;
        _tableViewa.tableFooterView = [[UIView alloc] init];
    }
    return _tableViewa;
}

#pragma mark -tableview delegate and datasoyrce
#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"thirds";
    ApplicationSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ApplicationSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kBackColor;
    
    cell.appLabel1.text = @"申请成功";
    cell.appLabel2.text = @"保函申请成功，我们将在24小内与您联系。";
    
    [cell.appButton1 setTitle:@"回首页" forState:0];
    [cell.appButton2 setTitle:@"我的保函" forState:0];
    
    QDFWeakSelf;
    [cell.appButton1 addAction:^(UIButton *btn) {
        if (weakself.didSelectedRow) {
            weakself.didSelectedRow(21);
        }
    }];
    
    [cell.appButton2 addAction:^(UIButton *btn) {
        if (weakself.didSelectedRow) {
            weakself.didSelectedRow(22);
        }
    }];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
