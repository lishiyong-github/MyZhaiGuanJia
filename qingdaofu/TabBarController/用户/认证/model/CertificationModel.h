//
//  CertificationModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertificationModel : NSObject

@property (nonatomic,strong) NSMutableArray *img;  //最新图片
//@property (nonatomic,strong) NSArray *cardimg;   //cardimg
@property (nonatomic,copy) NSString *address;   //联系地址
@property (nonatomic,copy) NSString *canModify;
//@property (nonatomic,copy) NSString *cardimg;   //cardimg
@property (nonatomic,copy) NSString *cardno;   //证件号号码
@property (nonatomic,copy) NSString *casedesc;   //案例说明
@property (nonatomic,copy) NSString *category;  //1为个人。2为律所。3为公司。
@property (nonatomic,copy) NSString *contact;     //联系人
@property (nonatomic,copy) NSString *create_time;  //认证时间
@property (nonatomic,copy) NSString *education_level;   //教育水平
@property (nonatomic,copy) NSString *email;    //邮箱
@property (nonatomic,copy) NSString *enterprisewebsite;   //公司网址
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *lang;
@property (nonatomic,copy) NSString *managersnumber;
@property (nonatomic,copy) NSString *mobile;//联系方式
@property (nonatomic,copy) NSString *name;      //用户名
@property (nonatomic,copy) NSString *professional_area;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *uidInner;
@property (nonatomic,copy) NSString *working_life;

@end
