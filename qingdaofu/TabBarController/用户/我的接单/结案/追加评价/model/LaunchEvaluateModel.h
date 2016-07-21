//
//  LaunchEvaluateModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchEvaluateModel : NSObject  //给出的评价

@property (nonatomic,copy) NSString *creditor; //评分
@property (nonatomic,copy) NSString *buid;  //
@property (nonatomic,copy) NSString *cuid;  //

@property (nonatomic,copy) NSString *category;  //产品类型
@property (nonatomic,copy) NSString *code;  //产品编号
@property (nonatomic,copy) NSString *content; //评价内容
@property (nonatomic,copy) NSString *contents; //追加评价内容
@property (nonatomic,copy) NSString *create_time;// 评价时间
@property (nonatomic,copy) NSString *create_times;// 追加评价时间
@property (nonatomic,copy) NSString *gaoxiao;//
@property (nonatomic,copy) NSString *idString;//
@property (nonatomic,copy) NSString *isHide;//  
@property (nonatomic,copy) NSString *kuaijie;//
@property (nonatomic,copy) NSString *mobile;  //手机号
//@property (nonatomic,copy) NSString *picture;//评价图片
@property (nonatomic,strong) NSArray *pictures;  //图片列表
@property (nonatomic,copy) NSString *pid;//
@property (nonatomic,copy) NSString *product_id;//
@property (nonatomic,copy) NSString *professionalknowledge;//
@property (nonatomic,copy) NSString *serviceattitude;//
@property (nonatomic,copy) NSString *sid;//
@property (nonatomic,copy) NSString *superaddition;//
@property (nonatomic,copy) NSString *uidInner;//
@property (nonatomic,copy) NSString *workefficiency;//
@property (nonatomic,copy) NSString *youzhi;//
@property (nonatomic,copy) NSString *zhuanye;//

@property (nonatomic,copy) NSString *frequency; //评价次数
@end
