//
//  DealingEndViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DealingEndViewController.h"

#import "PublishCombineView.h"  //同意终止／拒绝终止

@interface DealingEndViewController ()
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *dealEndRightButton;
@property (nonatomic,strong) UIView *dealEndWhiteView;
@property (nonatomic,strong) PublishCombineView *dealEndFootView;

@end

@implementation DealingEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理终止";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dealEndRightButton];
    
    [self.view addSubview:self.dealEndWhiteView];
    [self.view addSubview:self.dealEndFootView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.dealEndWhiteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, 0, 0, 0) excludingEdge:ALEdgeBottom];
        [self.dealEndWhiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.dealEndFootView];
        
        [self.dealEndFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dealEndFootView autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)dealEndRightButton
{
    if (!_dealEndRightButton) {
        _dealEndRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_dealEndRightButton setTitleColor:kWhiteColor forState:0];
        [_dealEndRightButton setTitle:@"平台介入" forState:0];
        _dealEndRightButton.titleLabel.font = kFirstFont;
    }
    return _dealEndRightButton;
}

- (UIView *)dealEndWhiteView
{
    if (!_dealEndWhiteView) {
        _dealEndWhiteView = [UIView newAutoLayoutView];
        _dealEndWhiteView.backgroundColor = kBackColor;
        
        UILabel *textLabel = [UILabel newAutoLayoutView];
        textLabel.backgroundColor = kWhiteColor;
        textLabel.numberOfLines = 0;
        NSString *lll1 = [NSString stringWithFormat:@"申请事项：接单方申请终止\n"];
        NSString *lll2 = [NSString stringWithFormat:@"申请时间：2016-09-28 17:09\n"];
        NSString *lll3 = [NSString stringWithFormat:@"终止原因：%@",@"不看不好不"];
        NSString *lll = [NSString stringWithFormat:@"%@%@%@",lll1,lll2,lll3];
        NSMutableAttributedString *attributeLL = [[NSMutableAttributedString alloc] initWithString:lll];
        [attributeLL setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, lll.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:kSpacePadding];
        [style setParagraphSpacing:kSpacePadding];
        [style setFirstLineHeadIndent:kBigPadding];
        [style setHeadIndent:kBigPadding];
        [attributeLL addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, lll.length)];
        [textLabel setAttributedText:attributeLL];
        [_dealEndWhiteView addSubview:textLabel];
        
        UIView *imageView = [UIView newAutoLayoutView];
        imageView.backgroundColor = kWhiteColor;
        [_dealEndWhiteView addSubview:imageView];
        
        UIButton *imageButton1 = [UIButton newAutoLayoutView];
        imageButton1.backgroundColor = kGrayColor;
        [imageView addSubview:imageButton1];
        
        [textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_dealEndWhiteView];
        [textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_dealEndWhiteView];
        [textLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dealEndWhiteView];
        
        [imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_dealEndWhiteView];
        [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dealEndWhiteView];
        [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:textLabel];
        [imageView autoSetDimension:ALDimensionHeight toSize:80];
        
        [imageButton1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imageView withOffset:kBigPadding];
        [imageButton1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView withOffset:kBigPadding];
        [imageButton1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
    }
    return _dealEndWhiteView;
}

- (PublishCombineView *)dealEndFootView
{
    if (!_dealEndFootView) {
        _dealEndFootView = [PublishCombineView newAutoLayoutView];
        [_dealEndFootView.comButton1 setTitle:@"同意终止" forState:0];
        [_dealEndFootView.comButton1 setBackgroundColor:kButtonColor];
        
        [_dealEndFootView.comButton2 setTitle:@"拒绝终止" forState:0];
        [_dealEndFootView.comButton2 setTitleColor:kLightGrayColor forState:0];
        _dealEndFootView.comButton2.layer.borderColor = kBorderColor.CGColor;
        _dealEndFootView.comButton2.layer.borderWidth = kLineWidth;
    }
    return _dealEndFootView;
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
