//
//  CustomActivityIndicator.m
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import "CustomActivityIndicator.h"
#import "Global.h"

#define SCREENRECT [[UIScreen mainScreen] bounds]
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define LOADINGVIEW_WIDTH 67.0
#define LOADINGVIEW_HEIGHT 100.0


#define LOADING_LABEL_ORIGIN_X 0
#define LOADING_LABEL_ORIGIN_Y 70
#define LOADING_LABEL_WIDTH 67.0
#define LOADING_LABEL_HEIGHT 30.0
#define LOADING_LABEL_FONT_SIZE 8.0

@interface CustomActivityIndicator ()
@property (nonatomic, strong) UIView *freezeLayer;

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *activityIndicator;
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

- (UIImageView *)activityIndicator
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    _activityIndicator = [[UIImageView alloc] init];
    [_activityIndicator setFrame:CGRectMake(0,
                                            0,
                                            LOADINGVIEW_WIDTH,
                                            LOADINGVIEW_WIDTH)];
    _activityIndicator.image = [UIImage animatedImageNamed:@"loading" duration:1];
    
    return _activityIndicator;
}

- (UILabel *)loadingLabel
{
    if (_loadingLabel != nil) {
        return _loadingLabel;
    }
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(LOADING_LABEL_ORIGIN_X, LOADING_LABEL_ORIGIN_Y, LOADING_LABEL_WIDTH, LOADING_LABEL_HEIGHT)];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.text = @"页面正在加载......";
    _loadingLabel.textColor = RED_FF0075;
    _loadingLabel.font = [UIFont systemFontOfSize:LOADING_LABEL_FONT_SIZE];
    return _loadingLabel;
}

- (UIView *)loadingView
{
    if (_loadingView != nil) {
        return _loadingView;
    }
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH-LOADINGVIEW_WIDTH)/2.0, (SCREENHEIGHT-LOADINGVIEW_HEIGHT)/2.0, LOADINGVIEW_WIDTH, LOADINGVIEW_HEIGHT)];
//    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    _loadingView.backgroundColor = [UIColor whiteColor];
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
//    _freezeLayer.backgroundColor = [UIColor blackColor];
//    _freezeLayer.alpha = 0.3;
    _freezeLayer.backgroundColor = [UIColor whiteColor];
    return _freezeLayer;
}

#pragma mark - Synchronous -- with gray mask

- (void)startSynchAnimating
{
    self.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopSynchAnimating
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
}

// green, no words, simple style
//- (void)startSimpleStyleSynchAnimating
//{
//    [self setSimpleStyle];
//    self.hidden = NO;
//    [_activityIndicator startAnimating];
//}
//- (void)stopSimpleStyleSynchAnimating
//{
//    [_activityIndicator stopAnimating];
//    self.hidden = YES;
//}

// gray, black mask, complex style
//- (void)startComplexStyleSynchAnimatingWithMessage:(NSString *)message {
//    [self setComplexStyle];
//    [self setAlertWithText:message];
//    self.hidden = NO;
//    [_activityIndicator startAnimating];
//}
//- (void)stopComplexStyleSynchAnimating
//{
//    [_activityIndicator stopAnimating];
//    self.hidden = YES;
//}

#pragma mark - private methods
//- (void)setSimpleStyle
//{
//    [_activityIndicator setImage:ImageNamed(@"refresh-green")];
//    _loadingLabel.hidden = YES;
//    _loadingView.backgroundColor = [UIColor clearColor];
//}

//- (void)setComplexStyle
//{
//    [_activityIndicator setImage:ImageNamed(@"refresh-white")];
//    _loadingLabel.hidden = NO;
//    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//}

//- (void)setAlertWithText:(NSString*)text {
//    _loadingLabel.text = text;
//    _loadingLabel.numberOfLines = 0;
//    _loadingLabel.textAlignment = NSTextAlignmentCenter;
//    
//    CGSize constrainedSize = CGSizeMake(MAXFLOAT, LOADING_LABEL_HEIGHT);
//    
//    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:LOADING_LABEL_FONT_SIZE] constrainedToSize:constrainedSize];
//    [_loadingLabel setFrame:CGRectMake((LOADINGVIEW_WIDTH - textSize.width)/2.0, _loadingLabel.frame.origin.y, textSize.width, _loadingLabel.frame.size.height)];
//}

@end
