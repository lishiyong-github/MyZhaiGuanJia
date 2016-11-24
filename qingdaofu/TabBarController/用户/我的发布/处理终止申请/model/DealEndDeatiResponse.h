//
//  DealEndDeatiResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class ProductOrdersClosedOrEndApplyModel;

@interface DealEndDeatiResponse : BaseModel

@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *data;
@property (nonatomic,copy) NSString *accessTerminationAUTH; //是否能操作0-能操作，1-不能
@property (nonatomic,copy) NSString *dataLabel;


@end
