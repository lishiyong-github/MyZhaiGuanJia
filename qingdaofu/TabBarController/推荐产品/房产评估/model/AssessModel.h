//
//  AssessModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessModel : NSObject

@property (nonatomic,copy) NSString *codeStr;//
@property (nonatomic,copy) NSString *address;//小区
@property (nonatomic,copy) NSString *buildingNumber;//楼栋－号
@property (nonatomic,copy) NSString *city;//
@property (nonatomic,copy) NSString *create_time;//评估时间
@property (nonatomic,copy) NSString *district;  //地区
@property (nonatomic,copy) NSString *floor;// 楼层－层
@property (nonatomic,copy) NSString *idString;//
@property (nonatomic,copy) NSString *ip;//
@property (nonatomic,copy) NSString *maxFloor;//楼层－共几层
@property (nonatomic,copy) NSString *serviceCode;//
@property (nonatomic,copy) NSString *size;//面积
@property (nonatomic,copy) NSString *totalPrice;//评估价格
@property (nonatomic,copy) NSString *unitNumber;//楼栋－室
@property (nonatomic,copy) NSString *userid;//


@end
