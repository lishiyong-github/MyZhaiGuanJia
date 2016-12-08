//
//  CityModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/12/8.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel


//////房产抵押
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *provinceID;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *cityID;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *areaID;

//机动车抵押
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;

@end
