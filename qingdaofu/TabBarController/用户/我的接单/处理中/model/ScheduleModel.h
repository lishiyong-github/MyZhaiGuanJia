//
//  ScheduleModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//


@interface ScheduleModel : NSObject

@property (nonatomic,copy) NSString *audit;    //诉讼的案号状态：0=>一审,1=>二审,2=>再审,3=>执行
@property (nonatomic,copy) NSString *caseString;  //诉讼里面的暗号
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *content;  //进度内容
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *product_id;  //对应产品ID
@property (nonatomic,copy) NSString *status;

@end
