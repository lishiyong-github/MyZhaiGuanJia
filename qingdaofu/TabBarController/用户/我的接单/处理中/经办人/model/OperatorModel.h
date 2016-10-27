//
//  OperatorModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageModel;

@interface OperatorModel : NSObject

@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *level;//1-第一级，2-第二级
@property (nonatomic,copy) NSString *owner;  //从属标志
@property (nonatomic,copy) NSString *operatorid;
@property (nonatomic,copy) NSString *ordersid;
@property (nonatomic,copy) NSString *create_by;  // 经办人设置人


//经办人信息
@property (nonatomic,strong) ImageModel *headimg;  //图片
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;

@end
