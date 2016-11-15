//
//  UIViewController+ImageBrowser.m
//  JBHope
//
//  Created by Magi on 15/10/9.
//  Copyright (c) 2015年 MengBaby Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#import "UIViewController+ImageBrowser.h"
//#import "TSMessage.h"
//FSImageBrowser
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"

@implementation UIViewController (ImageBrowser)

- (void)showImages:(NSArray *)images currentIndex:(NSUInteger)index {
    
    //    id imageObj = images.firstObject;
    NSMutableArray *basicImageArray = [NSMutableArray array];
    for (id imageObj in images) {
        if ([imageObj isKindOfClass:[NSString class]]) {
            NSString *ssss = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imageObj];
            FSBasicImage *image = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:ssss]];

//            FSBasicImage *image = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:imageObj]];
            [basicImageArray addObject:image];
        }else if ([imageObj isKindOfClass:[NSURL class]]){
            FSBasicImage *image = [[FSBasicImage alloc] initWithImageURL:imageObj];
            [basicImageArray addObject:image];
        }else if ([imageObj isKindOfClass:[UIImage class]]){
            FSBasicImage *image = [[FSBasicImage alloc] initWithImage:imageObj];
            [basicImageArray addObject:image];
        }else if ([imageObj conformsToProtocol:@protocol(FSImage)]){
            [basicImageArray addObject:imageObj];
        }else{
            continue;
        }
    }
    if (!basicImageArray.count) {
//        [TSMessage showNotificationWithTitle:@"不支持的数据类型" type:TSMessageNotificationTypeWarning];
        return;
    }
    //    if ([imageObj isKindOfClass:[NSString class]]) {
    //        for (NSString *url in images) {
    //            FSBasicImage *image = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url]];
    //            [basicImageArray addObject:image];
    //        }
    //    }else if ([imageObj isKindOfClass:[NSURL class]]){
    //        for (NSURL *url in images) {
    //            FSBasicImage *image = [[FSBasicImage alloc] initWithImageURL:url];
    //            [basicImageArray addObject:image];
    //        }
    //    }else if ([imageObj isKindOfClass:[UIImage class]]){
    //        for (UIImage *img in images) {
    //            FSBasicImage *image = [[FSBasicImage alloc] initWithImage:img];
    //            [basicImageArray addObject:image];
    //        }
    //    }else if ([imageObj conformsToProtocol:@protocol(FSImage)]){
    //        [basicImageArray addObjectsFromArray:images];
    //    }else{
    //        [TSMessage showNotificationWithTitle:@"不支持的数据类型" type:TSMessageNotificationTypeWarning];
    //        return;
    //    }
    FSBasicImageSource *source = [[FSBasicImageSource alloc] initWithImages:basicImageArray];
    FSImageViewerViewController *browser = [[FSImageViewerViewController alloc] initWithImageSource:source imageIndex:index];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showImages:(NSArray *)images
{
    [self showImages:images currentIndex:0];
}

@end
