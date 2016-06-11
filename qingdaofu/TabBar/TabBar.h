//
//  TabBar.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate;

@interface TabBar : UIView

@property (nonatomic,copy) NSArray *tabBarItems;
@property (nonatomic,weak) id <TabBarDelegate> delegate;

@end

@protocol TabBarDelegate <NSObject>

- (void)tabBarDidSelectedRiseButton;

@end
