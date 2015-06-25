//
//  NoNetworkView.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "NoNetworkView.h"

@interface NoNetworkView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation NoNetworkView
singleton_implementation(NoNetworkView)

- (id)init
{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        [self addSubview:self.bgView];
    }
    return self;
}

- (UIView *)bgView
{
    if (_bgView != nil) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = BG_E9ECF5;
    [_bgView addSubview:self.imageView];
    
    return _bgView;
}

- (UIImageView *)imageView
{
    if (_imageView != nil) {
        return _imageView;
    }
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = ImageNamed(@"no_network");
    [_imageView addSubview:self.retryButton];
    
    return _imageView;
}

- (UIButton *)retryButton
{
    if (_retryButton != nil) {
        return _retryButton;
    }
    _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_retryButton addTarget:self action:@selector(retryNetworkReachability) forControlEvents:UIControlEventTouchUpInside];
    
    return _retryButton;
}

- (void)showWithYOrigin:(CGFloat)yOrigin height:(CGFloat)height;
{
    [self setFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, height)];
    [_bgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    
    CGFloat width_height_ratio = 575.f/571.f;
    CGFloat imgHeight = 0.4*height;
    CGFloat imgWidth = imgHeight*width_height_ratio;
    [_imageView setFrame:CGRectMake((SCREEN_WIDTH-imgWidth)/2.f, 0.2*height, imgWidth, imgHeight)];
    
    
    CGFloat xOrigin_percent_button = 96.f/575.f;
    CGFloat yOrigin_percent_button = 455.f/571.f;
    [_retryButton setFrame:
     CGRectMake(xOrigin_percent_button*_imageView.frame.size.width,
                yOrigin_percent_button*_imageView.frame.size.height,
                (1 - 2*xOrigin_percent_button)*_imageView.frame.size.width,
                (1 - yOrigin_percent_button)*_imageView.frame.size.height)];
    [self makeKeyAndVisible];
}

- (void)hide
{
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
}

#pragma mark - Action
- (void)retryNetworkReachability
{
    
}

@end
