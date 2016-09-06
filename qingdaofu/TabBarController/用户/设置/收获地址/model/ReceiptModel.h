//
//  ReceiptModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptModel : NSObject

@property (nonatomic,copy) NSString *address;  
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *isdefault;
@property (nonatomic,copy) NSString *modifytime;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *uidInner;
@property (nonatomic,copy) NSString *validflag;

@property (nonatomic,copy) NSString *province;//id
@property (nonatomic,copy) NSString *city;//id
@property (nonatomic,copy) NSString *area;//id
@property (nonatomic,copy) NSString *province_name; //name
@property (nonatomic,copy) NSString *city_name;//name
@property (nonatomic,copy) NSString *area_name;//name


@end
