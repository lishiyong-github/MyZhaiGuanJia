//
//  PayModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString *noncestr; //随机字符串
@property (nonatomic,copy) NSString *package;  //扩展字段
@property (nonatomic,copy) NSString *paySign;  //签名
@property (nonatomic,copy) NSString *signType;  //
@property (nonatomic,copy) NSString *timestamp; //时间戳
@property (nonatomic,copy) NSString *prepayid;
@property (nonatomic,copy) NSString *partnerid;



@end
