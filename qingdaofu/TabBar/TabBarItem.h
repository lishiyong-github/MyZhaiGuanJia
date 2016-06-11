//
//  TabBarItem.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TabBarItemType) {
    TabBarItemTypeNormal = 0,
    TabBarItemTypeRise,
};

@interface TabBarItem : UIButton

@property (nonatomic,assign) TabBarItemType tabBarItemType;

@end
