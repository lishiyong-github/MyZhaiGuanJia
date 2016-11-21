//
//  OrdersLogsModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersLogsModel : NSObject

@property (nonatomic,copy) NSString *action;//接单动作日志类型 10系统 20进度30评论 404142结案申请同意否决 			        505152中止申请同意否决',
@property (nonatomic,copy) NSString *action_at;
@property (nonatomic,copy) NSString *action_by;//操作人
@property (nonatomic,copy) NSString *afterstatus;//关联记录新状态
@property (nonatomic,copy) NSString *beforestatus;//关联记录源状态
@property (nonatomic,copy) NSString *classString;  //消息类别
@property (nonatomic,copy) NSString *files;//日志图片ID集
@property (nonatomic,copy) NSString *filesImg;  //图片
@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSString *level;//日志级别 1进度日志，2子表日志
@property (nonatomic,copy) NSString *logid; //日志ID
@property (nonatomic,copy) NSString *memo;//日志描述
@property (nonatomic,copy) NSString *ordersid;//日志归属订单ID
@property (nonatomic,copy) NSString *relaid; //关联ID
@property (nonatomic,copy) NSString *relatrigger;//关联触发  0代表未触发  1代表已经处理过了
@property (nonatomic,copy) NSString *trigger; //是否有触发事件
@property (nonatomic,copy) NSString *triggerLabel;//触发按钮文本
@property (nonatomic,copy) NSString *validflag;


@end
