//
//  CreditorFileModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DebtModel;

@interface CreditorFileModel : NSObject

@property (nonatomic,copy) NSString *address; //抵押物地址
@property (nonatomic,strong) DebtModel *creditorfile;//债权文件
@property (nonatomic,strong) NSMutableArray *borrowinginfo;//债务人信息
@property (nonatomic,strong) NSMutableArray *creditorinfo;//债权人信息
@property (nonatomic,strong) NSMutableArray *guaranteemethod; //抵押物

@end
