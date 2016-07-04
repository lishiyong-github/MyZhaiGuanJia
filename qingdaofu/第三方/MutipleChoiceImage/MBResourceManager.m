
//  MBResourceManager.m
//  MengBaby
//
//  Created by Magi on 14/10/26.
//  Copyright (c) 2014年 MengBaby Information Technology (Shanghai) Co., Ltd. All rights reserved.
//
#import "MBResourceManager.h"
#import "StandardPaths.h"
@implementation MBResourceManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        NSString *cartFile = [[NSFileManager defaultManager] pathForPrivateFile:@"resource"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:cartFile]) {//get resource data from file
            NSData *cartData = [NSData dataWithContentsOfFile:cartFile];
//            sharedInstance = [self.class objectWithKeyValues:cartData];
        }else{
            sharedInstance = [[self.class alloc] init];
        }
    });
    
    return sharedInstance;
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"unusedArray":@"NSString"
             };
}

- (void)setUnusedArray:(NSMutableArray *)unusedArray
{
    if (![unusedArray isMemberOfClass:[NSMutableArray class]]) {
        _unusedArray = [NSMutableArray arrayWithArray:unusedArray];
    }else{
        _unusedArray = unusedArray;
    }
}

- (void)removeUnusedResource
{
    if (self.unusedArray.count==0) {
        return;
    }
    NSArray *unusedCopy = self.unusedArray.copy;
    for (NSString *path in unusedCopy) {
        BOOL directory;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory]) {
            BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            if (result) {
                [self.unusedArray removeObject:path];
            }
        }else{
//            [self.unusedArray removeObject:path];
            [self removeFromUnuseArray:path];
        }
    }
}

- (void)removeFromUnuseArray:(NSString *)path
{
    if ([self.unusedArray indexOfObject:path] != NSNotFound) {
        [self.unusedArray removeObject:path];
    }
    [self save];
}

- (void)save
{
    NSString *cartFile = [[NSFileManager defaultManager] pathForPrivateFile:@"resource"];
    [self.JSONData writeToFile:cartFile atomically:YES];
}

- (void)addUnusedResource:(NSString *)path
{
    if (!_unusedArray) {
        _unusedArray = [NSMutableArray array];
    }
    if (![self.unusedArray containsObject:path]) {
        [self.unusedArray addObject:path];
        [self save];
    }
}


@end
