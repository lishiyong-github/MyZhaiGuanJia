//
//  MBResourceManager.h
//  MengBaby
//
//  Created by Magi on 14/10/26.
//  Copyright (c) 2014年 MengBaby Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBResourceManager : NSObject

@property (nonatomic, strong) NSMutableArray *unusedArray;

+ (instancetype)sharedInstance;

- (void)addUnusedResource:(NSString *)path;
- (void)removeFromUnuseArray:(NSString *)path;
- (void)removeUnusedResource;
- (void)save;

@end
