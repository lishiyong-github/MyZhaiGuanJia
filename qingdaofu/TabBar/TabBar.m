//
//  TabBar.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TabBar.h"
#import "TabBarItem.h"

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
    self.backgroundColor = kTabBarColor;
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, kScreenWidth, 5)];
//    topLine.image = [UIImage imageNamed:@""];
//    topLine.backgroundColor = [UIColor redColor];
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
        [self setSelectedIndex:sender.tag];
    }else{
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
