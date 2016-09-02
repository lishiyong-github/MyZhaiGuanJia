//
//  UserNameModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNameModel : NSObject

@property (nonatomic,copy) NSString *deleteId; //删除
@property (nonatomic,copy) NSString *app_id;
@property (nonatomic,copy) NSString *jmobile;
@property (nonatomic,copy) NSString *jusername;//接单方，发布方
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *username; //本人

@end
