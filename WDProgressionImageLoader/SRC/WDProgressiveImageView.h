//
//  WDProgressiveImageView.h
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 8/25/15.
//  Copyright (c) 2015 zhangyuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDProgressiveImageView : UIImageView

@property (nonatomic, strong) NSArray *thresholders;

@property (nonatomic, assign) BOOL debug;

- (void)loadImageWithURL:(NSString *)url;



@end
