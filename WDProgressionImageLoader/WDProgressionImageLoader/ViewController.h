//
//  ViewController.h
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 15-8-20.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageUtil.h"
#import "WDProgressiveImageView.h"

#define TEST_JPEG_PROGRESSIVE_URL @"";

@interface ViewController : UIViewController

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *pgImageView;

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *remoteImageView;

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *wdShopImageView;

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *wdGoodsImageView;

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *remoteImageView1;

@property(nonatomic, assign) IBOutlet WDProgressiveImageView *remoteImageView2;

@property (nonatomic, strong) IBOutlet UIButton *gotoTableView;


@end

