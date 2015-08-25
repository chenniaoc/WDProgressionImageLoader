//
//  WDProgressiveImageView.m
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 8/25/15.
//  Copyright (c) 2015 zhangyuchen. All rights reserved.
//

#import "WDProgressiveImageView.h"


/**
 *  I'm a concurrent queue
 */
static dispatch_queue_t kWDRemoteDownLoadQueue;

@interface WDProgressiveImageView () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) UIImageView *internalImageView;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *imageData;

@property (nonatomic, assign) NSInteger currentThresholderIndex;

@end

@implementation WDProgressiveImageView

+ (void)load
{
    
}

+ (void)initialize
{
    if (self == [WDProgressiveImageView self]) {
        // should only initial once
        kWDRemoteDownLoadQueue = dispatch_queue_create("com.koudai.progressive.jpeg.queue", DISPATCH_QUEUE_CONCURRENT);

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

- (void)_initialize
{
    _internalImageView = [[UIImageView alloc] init];
    _internalImageView.bounds = self.frame;
    
    _imageData = [NSMutableData data];
    
    _thresholders = @[@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9];
    _currentThresholderIndex = 0;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _internalImageView.bounds = frame;
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
    }
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    [_connection start];
}

#pragma mark Delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

/**
 *  response
 *
 *  @param connection connection
 *  @param response   response description
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

@end
