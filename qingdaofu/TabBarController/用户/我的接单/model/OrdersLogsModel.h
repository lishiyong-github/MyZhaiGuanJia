//
//  OrdersLogsModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersLogsModel : NSObject

@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *action_at;
@property (nonatomic,copy) NSString *action_by;
@property (nonatomic,copy) NSString *afterstatus;
@property (nonatomic,copy) NSString *beforestatus;
@property (nonatomic,copy) NSString *classString;  //消息类别
@property (nonatomic,copy) NSString *files;
@property (nonatomic,copy) NSString *filesImg;  //图片
@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *logid;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *ordersid;
@property (nonatomic,copy) NSString *relaid;
@property (nonatomic,copy) NSString *relatrigger;
@property (nonatomic,copy) NSString *trigger;
@property (nonatomic,copy) NSString *triggerLabel;
@property (nonatomic,copy) NSString *validflag;


@end
