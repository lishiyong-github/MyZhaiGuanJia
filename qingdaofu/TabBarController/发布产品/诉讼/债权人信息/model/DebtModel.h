//
//  DebtModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebtModel : NSObject

//债权人信息
@property (nonatomic,copy) NSString *creditorname;
@property (nonatomic,copy) NSString *creditormobile;
@property (nonatomic,copy) NSString *creditoraddress;
@property (nonatomic,copy) NSString *creditorcardcode;
@property (nonatomic,copy) NSString *creditorcardimage;

//债务人信息
@property (nonatomic,copy) NSString *borrowingname;
@property (nonatomic,copy) NSString *borrowingmobile;
@property (nonatomic,copy) NSString *borrowingaddress;
@property (nonatomic,copy) NSString *borrowingcardcode;
@property (nonatomic,copy) NSString *borrowingcardimage;

@end
