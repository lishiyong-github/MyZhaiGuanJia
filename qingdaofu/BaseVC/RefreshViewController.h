//
//  RefreshViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/2/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

#import "AFNetworking.h"

@interface RefreshViewController : BaseViewController

-(void)headerRefreshWithPage:(NSString *)page urlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock;
-(void)footerRefreshWithPage:(NSString *)page urlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock;


-(void)headerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock;
-(void)footerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock;



@end
