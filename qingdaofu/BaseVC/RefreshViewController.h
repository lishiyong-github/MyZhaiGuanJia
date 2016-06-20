//
//  RefreshViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/2/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"


@interface RefreshViewController : BaseViewController

-(void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andFailBlock:(void(^)(NSError *error))failBlock;

-(void)headerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andfailedBlock:(void(^)(NSError *error))failedBlock;

-(void)footerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andfailedBlock:(void(^)(NSError *error))failedBlock;



@end
