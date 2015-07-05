//
//  MyShopWebPreviewViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyShopWebPreviewViewController.h"
#import "TourListViewController.h"
#import "ShareView.h"

@interface MyShopWebPreviewViewController ()<UIWebViewDelegate, ShareViewDelegate>
{
    NSTimer *loadTimer;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) ShareView *shareView;
@property (strong, nonatomic) UIControl *darkMask;

@end

@implementation MyShopWebPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.title isEqualToString:@"邀请供应商"]) {
        [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:nil image:ImageNamed(@"share_red")];
    }
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];

    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_ShopURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(stopLoading) userInfo:nil repeats:NO];
}

- (void)stopLoading
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [_webView stopLoading];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//    [alert show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)rightBarButtonItemClicked:(id)sender
{
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
        _shareView.delegate = self;
        [self.view addSubview:_shareView];
    }
    CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:nil];
    [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
    
    [self showShareView];
}

- (void)hidePopUpViews
{
    [self hideShareView];
    _darkMask.alpha = 0;
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadTimer invalidate];
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *predicate = [NSString stringWithFormat:@"http://mobile.bkrtrip.com/line/custom/%@/%@/", [UserModel companyId], [UserModel staffId]];
    if ([request.URL.absoluteString hasPrefix:predicate]) {
        
        NSString *infoString = [request.URL.absoluteString substringFromIndex:predicate.length];
        NSArray *infoArray = [infoString componentsSeparatedByString:@"?"];
        NSString *customId;
        NSString *templateId;
        if (infoArray.count == 2) {
            customId = infoArray[0];
            templateId = [infoArray[1] stringByReplacingOccurrencesOfString:@"tpd=" withString:@""];
        }
        
        TourListViewController *tourList = [[TourListViewController alloc] init];
        tourList.templateId = @([templateId integerValue]);
        tourList.customId = customId;
        [self.navigationController pushViewController:tourList animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaWeChatWithURLString:_ShopURLString title:@"旅游行业微商运营秘籍" content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaWeChatWithURLString:_ShopURLString title:[UserModel staffDepartmentName] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
    }
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaQQWithURLString:_ShopURLString title:@"旅游行业微商运营秘籍" content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self shareType:QQ_Share_Session];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaQQWithURLString:_ShopURLString title:[UserModel staffDepartmentName] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self shareType:QQ_Share_Session];
    }
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaQQWithURLString:_ShopURLString title:@"旅游行业微商运营秘籍" content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaQQWithURLString:_ShopURLString title:[UserModel staffDepartmentName] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
    }
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaSMSWithContent:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" presentedController:self];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaSMSWithContent:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] presentedController:self];
    }
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self supportClickWithQQWithShareObject:obj];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaYiXinWithURLString:_ShopURLString content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaYiXinWithURLString:_ShopURLString content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
    }
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaSinaWithURLString:_ShopURLString content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaSinaWithURLString:_ShopURLString content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self];
    }
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareView];
    if ([self.title isEqualToString:@"微商运营指导"]) {
        [[Global sharedGlobal] shareViaWeChatWithURLString:_ShopURLString title:@"旅游行业微商运营秘籍" content:@"旅游微商多渠道运营模式，帮您快速实现业务量的翻倍增长。" image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
    } else if ([self.title isEqualToString:@"线路详情"]) {
        [[Global sharedGlobal] shareViaWeChatWithURLString:_ShopURLString title:[UserModel staffDepartmentName] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [UserModel staffDepartmentName]] image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
    }
}

- (void)supportClickWithCancel
{
    [self hideShareView];
}

#pragma mark - private
- (void)hideShareView
{
    // must not delete, otherwise 'hidePopUpViews' will make the y-offset incorrect
    if (_shareView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationController.navigationBar.alpha = 1;
        }
    }];
}
- (void)showShareView
{
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height-_shareView.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    }];
}


@end
