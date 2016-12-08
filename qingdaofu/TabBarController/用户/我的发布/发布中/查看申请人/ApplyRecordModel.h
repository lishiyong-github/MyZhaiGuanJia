//
//  ApplyRecordModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrdersModel;

@interface ApplyRecordModel : NSObject

//申请model
@property (nonatomic,copy) NSString *applyid;
@property (nonatomic,copy) NSString *create_at;
@property (nonatomic,copy) NSString *create_by;
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *status;

//收藏model
@property (nonatomic,copy) NSString *collectid;

//生成者信息
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *idString;

//接单方
@property (nonatomic,strong) OrdersModel *orders;

@end
