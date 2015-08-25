//
//  WDProgressiveImageView.h
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 8/25/15.
//  Copyright (c) 2015 zhangyuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDProgressiveImageView : UIView

@property (nonatomic, strong) NSArray *thresholders;

- (void)loadImageWithURL:(NSString *)url;

@end
