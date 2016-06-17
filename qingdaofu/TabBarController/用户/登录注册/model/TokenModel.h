//
//  TokenModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface TokenModel : BaseModel

@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *uidString;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *idString;

@end
