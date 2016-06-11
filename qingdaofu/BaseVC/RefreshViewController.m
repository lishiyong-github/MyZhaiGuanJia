//
//  RefreshViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/2/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RefreshViewController.h"
#import "AFNetworking.h"

@interface RefreshViewController ()

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)headerRefreshWithPage:(NSString *)page urlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (successBlock) {
            successBlock(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)footerRefreshWithPage:(NSString *)page urlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (successBlock) {
            successBlock(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)headerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (successBlock) {
            successBlock(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)footerRefreshWithUrlString:(NSString *)urlString Parameter:(NSDictionary *)params successBlock:(void(^)())successBlock andfailedBlock:(void(^)())failedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (successBlock) {
            successBlock(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
