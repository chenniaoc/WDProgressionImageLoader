//
//  WDProgressiveImageView.m
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 8/25/15.
//  Copyright (c) 2015 zhangyuchen. All rights reserved.
//

#import "WDProgressiveImageView.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>


/**
 *  I'm a concurrent queue
 */
static dispatch_queue_t kWDRemoteDownLoadQueue;

static NSOperationQueue *kWDProgressiveOperationDownloadQueue;

@interface WDProgressiveImageView () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    CGImageSourceRef m_imgSrcRef;
}

@property (nonatomic, strong) UIImageView *internalImageView;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *imageData;

@property (nonatomic, assign) NSInteger currentThresholderIndex;

@property (nonatomic, assign) float currentProgress;

@property (nonatomic, assign) NSUInteger expectedImageSize;


@end

@implementation WDProgressiveImageView

+ (void)load
{
    
}

+ (void)initialize
{
    if (self == [WDProgressiveImageView self]) {
        // should only initial once
        kWDRemoteDownLoadQueue = dispatch_queue_create("com.koudai.progressive.jpeg.queue.gcd", DISPATCH_QUEUE_CONCURRENT);
        
        kWDProgressiveOperationDownloadQueue = [[NSOperationQueue alloc] init];
        kWDProgressiveOperationDownloadQueue.name = @"com.koudai.progressive.jpeg.queue.operation";

    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self _initialize];
    }

    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    _internalImageView = [[UIImageView alloc] init];
    _internalImageView.bounds = self.frame;
    
    _imageData = [NSMutableData data];
    
    _thresholders = @[@0.001,@0.01,@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9];
    _currentThresholderIndex = 0;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _internalImageView.bounds = frame;
}

- (void)setThresholders:(NSArray *)thresholders
{
    if (_thresholders != thresholders) {
        _thresholders = thresholders;
    }
    
    if (_thresholders == nil) {
        float starter = 0.001f;
        float stride = 1.0f * starter;
        NSMutableArray *tempThres = [NSMutableArray arrayWithCapacity:200];
        while (starter < 0.99f) {
            NSNumber *newNum = [[NSNumber alloc] initWithFloat:starter];
            [tempThres addObject:newNum];
            starter += stride;
        }
        
        _thresholders = tempThres;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark Image Loader
- (void)loadImageWithURL:(NSString *)url
{
    if (_connection != nil) {
        // maybe loading or failed, need retry if failed
        
        [_connection cancel];
        self.image = nil;
        
        
    }
    
    NSURL *reqURL = [[NSURL alloc] initWithString:url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:reqURL];
    
#if DEBUG
    req = [[NSURLRequest alloc] initWithURL:reqURL
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:60.0f];
#endif
    _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    
    [_connection setDelegateQueue:kWDProgressiveOperationDownloadQueue];
    NSRunLoop *stackRunLoop = [NSRunLoop currentRunLoop];
    
    NSLog(@"stackRunLoop %p", stackRunLoop);
    dispatch_async(kWDRemoteDownLoadQueue, ^{
        NSRunLoop *blockRunLoop = [NSRunLoop currentRunLoop];
        NSLog(@"stackRunLoop %p", blockRunLoop);
        [_connection scheduleInRunLoop:blockRunLoop
                               forMode:NSDefaultRunLoopMode];
    });
    
    [_connection start];
}

#pragma mark Delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSRunLoop *blockRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"connection: connectionDidFinishLoading %p", blockRunLoop);
    
    CGImageSourceUpdateData(m_imgSrcRef, (CFDataRef)_imageData, YES);
    CGImageRef finalImageRef = CGImageSourceCreateImageAtIndex(m_imgSrcRef, 0, NULL);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithCGImage:finalImageRef];
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSRunLoop *blockRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"connection: didFailWithError %p", blockRunLoop);
}

/**
 *  response
 *
 *  @param connection connection
 *  @param response   response description
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSRunLoop *blockRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"connection: didReceiveResponse %p", blockRunLoop);
    
    if (response.expectedContentLength > 0) {
        _expectedImageSize = response.expectedContentLength;
    }
    _expectedImageSize = response.expectedContentLength;
    _currentProgress = 0.0f;

    
    _imageData = [[NSMutableData alloc] init];
    m_imgSrcRef = CGImageSourceCreateIncremental(NULL);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSRunLoop *blockRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"connection: didReceiveData %p", blockRunLoop);

    _currentProgress = (_imageData.length * 1.0f) / (_expectedImageSize * 1.0f);
    
    if (_debug) {
        NSLog(@"progress result : %20f ", _currentProgress);
        
    }
    
    [_imageData appendData:data];
    
    UIImage *partialImage = [self processCurrentImage];
    
//    NSLog(@"processed image:%@", [partialImage debugDescription]);
    
    if (partialImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = partialImage;
        });
    }
    
}


#pragma mark ImageProcess
- (UIImage *)processCurrentImage
{
    UIImage *partialImage = nil;
    
    CGImageSourceUpdateData(m_imgSrcRef, (CFDataRef)_imageData, NO);
    
    if (_thresholders == nil) {
        // here will not use thresholders
        CGImageRef tempImageRef = CGImageSourceCreateImageAtIndex(m_imgSrcRef, 0, NULL);
        partialImage = [[UIImage alloc] initWithCGImage:tempImageRef];
        CGImageRelease(tempImageRef);
        return partialImage;
    }
    
    // make image only if current loaded size was greater than thresholders
    if (_currentThresholderIndex == _thresholders.count) {
        // already reached the max threasholder value.
        return nil;
    }
    
    
    if (_currentProgress > 0.0 && _currentProgress < 0.99
        && _currentThresholderIndex < _thresholders.count) {

        CGFloat currentThresholder = [_thresholders[_currentThresholderIndex] floatValue];
    
        if (_currentProgress > currentThresholder) {
            CGImageRef tempImageRef = CGImageSourceCreateImageAtIndex(m_imgSrcRef, 0, NULL);
            partialImage = [[UIImage alloc] initWithCGImage:tempImageRef];
            CGImageRelease(tempImageRef);
            
            while (_thresholders.count > _currentThresholderIndex && _currentProgress < [_thresholders[_currentThresholderIndex++] floatValue]) {
                // maybe there are many thresholders,the number of thresholders more than progress value
                // so it is better to change _currentThresholderIndex that indicates nearest idx of next value
            }
        }
    }

    return partialImage;
}

@end
