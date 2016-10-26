//
//  BaseModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *code; 
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *userid;

@end