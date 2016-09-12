//
//  DelayHandleModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelayHandleModel : NSObject

@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *dalay_reason; //延期原因
@property (nonatomic,copy) NSString *delay_days; //延期时间
@property (nonatomic,copy) NSString *is_agree; //是否同意
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSArray *uid;
@end
