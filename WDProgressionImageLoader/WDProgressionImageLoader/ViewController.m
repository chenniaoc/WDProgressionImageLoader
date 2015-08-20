//
//  ViewController.m
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 15-8-20.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadImages
{
    
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    int counter = 1;
    while (YES) {
        NSString *fileName = [NSString stringWithFormat:@"PG_sample%02d", counter];
        NSURL *fileURL = [mainBundle URLForResource:fileName withExtension:@"jpg"];
        if (!fileURL) {
            break;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        
        WDPJpegType type = WDP_detectJpegType((char *)data.bytes, data.length);
        
        
        NSLog(@"file:%@'type is %d", fileName , type);
        
        counter++;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
