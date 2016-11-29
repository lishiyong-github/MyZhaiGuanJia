//
//  MoreMessageModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
#import "CityModel.h"

@interface MoreMessageModel : BaseModel

@property (nonatomic,copy) NSString *relation_1; //params
@property (nonatomic,copy) NSString *relation_2;//params
@property (nonatomic,copy) NSString *relation_3;//params
@property (nonatomic,copy) NSString *relation_desc;//params
@property (nonatomic,copy) NSString *productid;//params
@property (nonatomic,copy) NSString *type;//params
@property (nonatomic,copy) NSString *mortgageid;//params

//抵押物地址
@property (nonatomic,copy) NSString *addressLabel;  //显示
@property (nonatomic,strong) CityModel *provincename;
@property (nonatomic,strong) CityModel *cityname;
@property (nonatomic,strong) CityModel *areaname;


//机动车抵押
@property (nonatomic,copy) NSString *brandLabel;
@property (nonatomic,strong) CityModel *audi;
@property (nonatomic,strong) CityModel *brand;

//合同纠纷
@property (nonatomic,copy) NSString *contractLabel;
//@property (nonatomic,copy) NSString *relation_1;

@end
