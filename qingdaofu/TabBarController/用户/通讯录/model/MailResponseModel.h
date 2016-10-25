//
//  MailResponseModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MailModel;

@interface MailResponseModel : NSObject

@property (nonatomic,copy) NSString *contactsid;
@property (nonatomic,copy) NSString *create_at;
@property (nonatomic,copy) NSString *create_by;
@property (nonatomic,copy) NSString *modify_at;
@property (nonatomic,copy) NSString *modify_by;
@property (nonatomic,copy) NSString *ordersOperator;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *userid;
//@property (nonatomic,strong) MailModel *userinfo;
@property (nonatomic,copy) NSString *validflag;

@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;


@end
