//
//  MailModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface MailModel : BaseModel

@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *realname;



@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *contactsid;//***参数
@end
