//
//  ApplicationModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationModel : NSObject

@property (nonatomic,copy) NSString *address;  //收获地址
@property (nonatomic,copy) NSString *anhao;  //案号
@property (nonatomic,copy) NSString *category; //案件类型
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *area_name;
@property (nonatomic,copy) NSString *area_pid;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *created_by;
@property (nonatomic,copy) NSString *fayuan_address; //取函地址
@property (nonatomic,copy) NSString *fayuan_id;//法院ID
@property (nonatomic,copy) NSString *fayuan_name; //法院名
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *money; //保函金额
@property (nonatomic,copy) NSString *orderid; //BH201608300003
@property (nonatomic,copy) NSString *phone; //电话
@property (nonatomic,copy) NSString *shenhe_status;
@property (nonatomic,copy) NSString *status;  //审核状态
@property (nonatomic,copy) NSString *type;//1-法院,2-快递
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *updated_by;

//图片
@property (nonatomic,strong) NSMutableArray *qisus;//起诉
@property (nonatomic,strong) NSMutableArray *caichans;//财产
@property (nonatomic,strong) NSMutableArray *zhengjus;//证据
@property (nonatomic,strong) NSMutableArray *anjians;//案件



@end
