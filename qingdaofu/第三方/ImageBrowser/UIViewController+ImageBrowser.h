//
//  UIViewController+ImageBrowser.h
//  JBHope
//
//  Created by Magi on 15/10/9.
//  Copyright (c) 2015年 MengBaby Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImageBrowser)

/**
 *  Show images browser according to the images and index
 *
 *  @param images The image container,the type can be:NSString,NSURL,UIImage,id<FSImage>
 *  @param index  Specific the current index
 */
- (void)showImages:(NSArray *)images currentIndex:(NSUInteger)index;
/**
 *  Show images browser according to the images current index is 0
 *
 *  @param images The image container,the type can be:NSString,NSURL,UIImage,id<FSImage>
 */
- (void)showImages:(NSArray *)images;

@end
