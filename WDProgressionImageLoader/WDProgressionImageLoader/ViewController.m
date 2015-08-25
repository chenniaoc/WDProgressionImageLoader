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

- (void)loadImages
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
            
//            progress = tempData.
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
//    CFMutableDataRef tempData = CFDataCreateMutable(CFAllocatorGetDefault(), 1024*1024);
//    
//    NSUInteger consumeChunk = 1;
//    NSUInteger fileSize = testImageData.length;
//    
//    Ptr tempDataPtr = NULL;
//    Ptr baseDataPtr = (Ptr)testImageData.bytes;
//    
//    NSUInteger loopCounter = 0;
//    
//    // image source preparing
//    CGImageSourceRef imgSrcRef = CGImageSourceCreateIncremental(NULL);
//    
//    NSUInteger imageIndex = 0;
//    while (true) {
//        
//        long fileDiff = consumeChunk * loopCounter - fileSize;
//        if (fileDiff >= 0) {
//            CFDataDeleteBytes(tempData, CFRangeMake(consumeChunk * (loopCounter), fileDiff));
//            CGImageSourceUpdateData(imgSrcRef, tempData, YES);
//            
//            CGImageRef partialImage = CGImageSourceCreateImageAtIndex(imgSrcRef, 0, NULL);
//            
//            _pgImageView.layer.contents = (__bridge id)((void *) partialImage);
//            
//            
//            break;
//        }
//
//        
//        sleep(0.3);
//        
//        CGImageSourceUpdateData(imgSrcRef, tempData, NO);
//        
//        CGImageRef partialImage = CGImageSourceCreateImageAtIndex(imgSrcRef, 0, NULL);
//        if (partialImage) {
//            _pgImageView.layer.contents = (__bridge id)((void *) partialImage);
//            imageIndex++;
//        }
//        
//        CGImageRelease(partialImage);
//        
//        tempDataPtr = (baseDataPtr + consumeChunk * loopCounter);
//        CFDataAppendBytes(tempData, (void *)tempDataPtr, consumeChunk);
//        loopCounter++;
//    }
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
