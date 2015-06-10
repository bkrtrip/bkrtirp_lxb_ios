//
//  CustomActivityIndicator.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomActivityIndicator.h"

#define SCREENRECT [[UIScreen mainScreen] bounds]
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define LOADINGVIEW_WIDTH 100.0
#define LOADINGVIEW_HEIGHT 40.0

#define SPINRECT CGRectMake(5, 5, 30, 30)

#define LOADING_LABEL_ORIGIN_X 35.0
#define LOADING_LABEL_WIDTH 60.0
#define LOADING_LABEL_HEIGHT 30.0
#define LOADING_LABEL_FONT_SIZE 16.0

@interface CustomActivityIndicator ()
@property (nonatomic, strong) UIView *freezeLayer;

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *loadingLabel;
@end

@implementation CustomActivityIndicator

+ (CustomActivityIndicator *)sharedActivityIndicator
{
    static CustomActivityIndicator *sharedActivityIndicator;
    if (!sharedActivityIndicator) {
        sharedActivityIndicator = [[super allocWithZone:nil] init];
    }
    return sharedActivityIndicator;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedActivityIndicator];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (id)init
{
    self = [super initWithFrame:SCREENRECT];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        
        [self addSubview:self.freezeLayer];
        [self addSubview:self.loadingView];
        self.hidden = YES;
    }
    return self;
}


#pragma mark - setters

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [_activityIndicator setFrame:SPINRECT];
    _activityIndicator.hidesWhenStopped = YES;
    return _activityIndicator;
}

- (UILabel *)loadingLabel
{
    if (_loadingLabel != nil) {
        return _loadingLabel;
    }
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(LOADING_LABEL_ORIGIN_X, 5, LOADING_LABEL_WIDTH, LOADING_LABEL_HEIGHT)];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.text = @"加载中...";
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.font = [UIFont systemFontOfSize:LOADING_LABEL_FONT_SIZE];
    return _loadingLabel;
}

- (UIView *)loadingView
{
    if (_loadingView != nil) {
        return _loadingView;
    }
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH-LOADINGVIEW_WIDTH)/2.0, (SCREENHEIGHT-LOADINGVIEW_HEIGHT)/2.0, LOADINGVIEW_WIDTH, LOADINGVIEW_HEIGHT)];
    _loadingView.backgroundColor = [UIColor darkGrayColor];
//    _loadingView.alpha = 0.3;
    _loadingView.layer.cornerRadius = 5.0;
    [_loadingView addSubview:self.activityIndicator];
    [_loadingView addSubview:self.loadingLabel];
    return _loadingView;
}

- (UIView *)freezeLayer
{
    if (_freezeLayer != nil) {
        return _freezeLayer;
    }
    
    _freezeLayer = [[UIView alloc] initWithFrame:SCREENRECT];
    _freezeLayer.backgroundColor = [UIColor blackColor];
    _freezeLayer.alpha = 0.3;
    return _freezeLayer;
}

#pragma mark - Synchronous -- with gray mask

- (void)startSynchAnimating
{
    [self setAlertWithText:@"加载中..."];
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopSynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
}

- (void)startSynchAnimatingWithMessage:(NSString *)message {
    [self setAlertWithText:message];
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)setAlertWithText:(NSString*)text {
    _loadingLabel.text = text;
    _loadingLabel.numberOfLines = 0;
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, LOADING_LABEL_HEIGHT);
    
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:LOADING_LABEL_FONT_SIZE] constrainedToSize:constrainedSize];
    CGFloat horizontalMargin = 20.0;
    
    CGFloat loadingViewWidth = textSize.width + SPINRECT.size.width + horizontalMargin;
    [_loadingView setFrame:CGRectMake((SCREENWIDTH-loadingViewWidth)/2.0, (SCREENHEIGHT-LOADINGVIEW_HEIGHT)/2.0, loadingViewWidth, LOADINGVIEW_HEIGHT)];
    
    [_loadingLabel setFrame:CGRectMake(SPINRECT.size.width+SPINRECT.origin.x, 5, textSize.width, LOADING_LABEL_HEIGHT)];
}


@end
