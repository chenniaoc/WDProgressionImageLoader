//
//  ViewController.m
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 15-8-20.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)forStudyCode
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSData *data;
    NSData *testImageData;
    
    int counter = 1;
    while (YES) {
        NSString *fileName = [NSString stringWithFormat:@"PG_sample%02d", counter];
        NSURL *fileURL = [mainBundle URLForResource:fileName withExtension:@"jpg"];
        if (!fileURL) {
            break;
        }
        
        data = [NSData dataWithContentsOfURL:fileURL];
        
        if (counter == 1) {
            testImageData = data;
        }
        
        WDPJpegType type = WDP_detectJpegType((char *)data.bytes, data.length);
        
        
        NSLog(@"file:%@'type is %d", fileName , type);
        
        counter++;
    }
    
    __block float progress = 0.0;
    NSArray *thresholders = @[@0.001,@0.01,@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9];
    __block NSInteger currentThresHolder = 0;
    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
        CFMutableDataRef tempData = CFDataCreateMutable(CFAllocatorGetDefault(), 1024*1024);
        
        NSUInteger consumeChunk = 1;
        NSUInteger fileSize = testImageData.length;
        
        Ptr tempDataPtr = NULL;
        Ptr baseDataPtr = (Ptr)testImageData.bytes;
        
        NSUInteger loopCounter = 0;
        
        // image source preparing
        CGImageSourceRef imgSrcRef = CGImageSourceCreateIncremental(NULL);
        
        NSUInteger imageIndex = 0;
        NSUInteger totalLength = data.length;
        while (true) {
            
            long fileDiff = consumeChunk * loopCounter - fileSize;
            if (fileDiff >= 0) {
                CFDataDeleteBytes(tempData, CFRangeMake(consumeChunk * (loopCounter), fileDiff));
                CGImageSourceUpdateData(imgSrcRef, tempData, YES);
                
                CGImageRef partialImage = CGImageSourceCreateImageAtIndex(imgSrcRef, 0, NULL);
                
                //                 _pgImageView.image = [UIImage imageWithCGImage:partialImage];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _pgImageView.image = [UIImage imageWithCGImage:partialImage];
                });
                break;
            }
            
            
            CGImageSourceUpdateData(imgSrcRef, tempData, NO);
            
            CFIndex tempLength = CFDataGetLength(tempData);
            progress = tempLength / (totalLength * 1.0);
            
            
            if (currentThresHolder < thresholders.count && progress > [thresholders[currentThresHolder] floatValue]) {
                
                CGImageRef partialImage = CGImageSourceCreateImageAtIndex(imgSrcRef, 0, NULL);
                if (partialImage) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _pgImageView.image = [UIImage imageWithCGImage:partialImage];
                    });
                    imageIndex++;
                    sleep(1.0);
                }
                
                CGImageRelease(partialImage);
                currentThresHolder++;
                
                
                
            }
            
            tempDataPtr = (baseDataPtr + consumeChunk * loopCounter);
            CFDataAppendBytes(tempData, (void *)tempDataPtr, consumeChunk);
            loopCounter++;
        }
    });
}

- (void)loadImages
{
    
    _pgImageView.thresholders = nil;
    [_pgImageView loadImageWithURL:@"http://madeira.cc.hokudai.ac.jp/RD/jovi/info96/html/images/mand_prgrsv.jpg"];
    
    [_remoteImageView loadImageWithURL:@"http://i.ytimg.com/vi/nDuYUlHc1r4/maxresdefault.jpg"];
    
    [_wdGoodsImageView loadImageWithURL:@"http://wd.geilicdn.com/vshop265496221-1416649037-627682.jpg?w=750&h=750"];
    
    [_wdShopImageView loadImageWithURL:@"http://wd.geilicdn.com/vshop13042-1422705517.jpeg?w=640&h=330&cp=1"];
    
    
    // this is 4k
//    _remoteImageView1.thresholders = @[@0.01,@0.02,@0.03,@0.1,@0.5,@0.6,@0.66,@0.7,@0.77,@0.8,@0.85,@0.9];
//    _remoteImageView1.thresholders = nil;
//    _remoteImageView1.debug = YES;
    [_remoteImageView1 loadImageWithURL:@"https://upload.wikimedia.org/wikipedia/commons/6/64/Pittsfield_township_new_progressive_missionary_baptist_church.JPG"];
    
    // this is 1024 and progressive
    _remoteImageView2.thresholders = nil;
    [_remoteImageView2 loadImageWithURL:@"http://www.webdesignref.com/examples/images/jpeg_prog_big.jpg"];
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
