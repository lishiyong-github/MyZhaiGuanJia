//
//  TabBar.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TabBar.h"
#import "TabBarItem.h"
#import "UIView+LBExtension.h"
@implementation TabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    return self;
}

#pragma mark - private method
- (void)config
{
//    [self setImage:[UIImage imageNamed:@"color"] forState:0];
    
//    [self setBackgroundImage:[UIImage imageNamed:@"tab_bar"] forState:0];
    
//    self.backgroundColor = [UIImage imageNamed:@"tab_bar"];
    
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bar"]];
    
//    self.backgroundImage = [UIImage imageNamed:@"tab_bar"];
//    self.backgroundColor = kRedColor;
//
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, 1)];
    topLine.image = [UIImage imageNamed:@"line"];
    topLine.backgroundColor = kSelectedColor;

    [self addSubview:topLine];
    
}

- (void)setSelectedIndex:(NSInteger)index
{
    for (TabBarItem *item in self.tabBarItems) {
        if (item.tag == index) {
            item.selected = YES;
        }else{
            item.selected = NO;
        }
    }
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
    
    if (tabBarController) {
        tabBarController.selectedIndex = index;
    }
}

#pragma mark - touch event
- (void)itemSelected:(TabBarItem *)sender
{
    if (sender.tabBarItemType != TabBarItemTypeRise) {
        
        if (sender.tag > 1){//消息，用户
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(tabbarDicSelectedCommonButton:)]) {
                    [self.delegate tabbarDicSelectedCommonButton:sender.tag];
                }
            }
        }else{
            [self setSelectedIndex:sender.tag];
        }
    }else{//发布
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
                [self.delegate tabBarDidSelectedRiseButton];
            }
        }
    }
}

#pragma mark - setter
- (void)setTabBarItems:(NSArray *)tabBarItems
{
    _tabBarItems = tabBarItems;
    
    NSInteger itemTag = 0;
    for (id item in tabBarItems) {
        if ([item isKindOfClass:[TabBarItem class]]) {
            if (itemTag == 0) {
                ((TabBarItem *)item).selected = YES;
            }
            [((TabBarItem *)item) addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:item];
            if (((TabBarItem *)item).tabBarItemType != TabBarItemTypeRise) {
                ((TabBarItem *)item).tag = itemTag;
                itemTag ++;
            }
        }
    }
}

//重新绘制按钮
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    //系统自带的按钮类型是UITabBarButton,找出这些类型的按钮,然后重新排布位置 ,空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度 == tabbar的五分之一
            btn.width = self.width * 0.2;
            btn.x = btn.width * btnIndex;
            btnIndex ++;
            //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
