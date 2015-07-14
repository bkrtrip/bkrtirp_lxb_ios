//
//  PersonalCenterViewController.m
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PCommonTableViewCell.h"
#import "PHeaderTableViewCell.h"
#import "PayListViewController.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

#import "PersonalInfoViewController.h"
#import "DispatchersViewController.h"
#import "LoginViewController.h"
#import "RPhoneNumViewController.h"//register procedure start point
#import "DispatchSettingsViewController.h"
#import "MyOrderListViewController.h"
#import "MySupplierViewController.h"
#import "NotificationCenterViewController.h"
#import "WebContentViewController.h"
#import "ShareView.h"

@interface PersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderActionProtocol, LoginVCProtocol, ShareViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

@property (assign, nonatomic) BOOL isAlreadyLogined;

@property (retain, nonatomic) NSDictionary *userInfoDic;

@property (strong, nonatomic) ShareView *shareView;
@property (strong, nonatomic) UIControl *darkMask;

@end

@implementation PersonalCenterViewController

- (id)init
{
    self = [super init];
    if (self) {
        // tabBarItem
        UIImage *normal = [ImageNamed(@"mine_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [ImageNamed(@"mine_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:normal selectedImage:selected];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isAlreadyLogined = [self getUserLoginState];
    if (self.isAlreadyLogined) {
        [self getUserInformation];
    }
    
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PSeperaterTableViewCell" bundle:nil] forCellReuseIdentifier:@"separateCell"];
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PCommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"commonCell"];

    [self.mineTableView registerNib:[UINib nibWithNibName:@"PHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    
    self.mineTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    

    [self.navigationController setNavigationBarHidden:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    if (self.isAlreadyLogined) {
        [self getUserInformation];
    }
    [[NoNetworkView sharedNoNetworkView] hide];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NoNetworkView sharedNoNetworkView] hide];
    
    [self initializeShareViewBgView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}


- (void)initializeShareViewBgView
{
    if (!_darkMask) {
        _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
        _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _darkMask.alpha = 0;// initally transparent
        [self.view addSubview:_darkMask];
    }
}

- (BOOL)getUserLoginState
{
    NSString *staffId = [UserModel getUserPropertyByKey:@"staff_id"];
    if (staffId && staffId.length > 0) {
        return YES;
    }
    
    return NO;
}


#pragma mark - LoginVCProtocol

- (void)loginSuccess
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    self.isAlreadyLogined = YES;
    [self getUserInformation];
//    [self updateUIForLoginState:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 2:
            return 3;
        case 4:
            return 3;
            
        //separate cell
        default:
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.isAlreadyLogined = [self getUserLoginState];
    if (self.isAlreadyLogined) {
        return 7;
    }
    else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
            ((PHeaderTableViewCell *)cell).delegate = self;
            if (self.isAlreadyLogined) {
                [(PHeaderTableViewCell *)cell needUserToSignin:NO];
                
                //initial user info
                [(PHeaderTableViewCell *)cell initialHeaderViewWithUserInfo:self.userInfoDic];
            }
            else {
                [(PHeaderTableViewCell *)cell needUserToSignin:YES];
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
            
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
            ((PCommonTableViewCell *)cell).invitationLabel.hidden = YES;

            if (indexPath.row == 0) {
                [(PCommonTableViewCell *)cell initailCellWithType:Message];
            }
            else if (indexPath.row == 1) {
                [(PCommonTableViewCell *)cell initailCellWithType:Alipay];
            }
            else if (indexPath.row == 2) {
                [(PCommonTableViewCell *)cell initailCellWithType:Dispatch];
                cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
            }
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
            ((PCommonTableViewCell *)cell).invitationLabel.hidden = YES;
            
            switch (indexPath.row) {
                case 0:
                {
                    [(PCommonTableViewCell *)cell initailCellWithType:Help];
                }
                    break;
                case 1:
                {
                    [(PCommonTableViewCell *)cell initailCellWithType:About];
                }
                    break;
                case 2:
                {
                    [(PCommonTableViewCell *)cell initailCellWithType:Invitation];
                    NSString *invitationCode = [UserModel getUserPropertyByKey:@"invite_code"];
                    if (invitationCode && invitationCode.length == 5) {
                        ((PCommonTableViewCell *)cell).invitationLabel.hidden = NO;
                        ((PCommonTableViewCell *)cell).invitationLabel.text = [NSString stringWithFormat:@"[邀请码:%@]", invitationCode];
                    }
                    
                    
                    cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 6:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
            ((PCommonTableViewCell *)cell).invitationLabel.hidden = YES;

            [(PCommonTableViewCell *)cell initailCellWithType:SignOut];
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        }
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"separateCell"];
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
            break;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 268;
        case 2:
        case 4:
        case 6:
            return 50;
            
        default:
            return 15;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 2:
        {
            //消息设置
            if (indexPath.row == 0) {
                NotificationCenterViewController *viewController = [[NotificationCenterViewController alloc] init];
                
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
            //支付设置
            else if (indexPath.row == 1) {
                self.isAlreadyLogined = [self getUserLoginState];
                
                if (!self.isAlreadyLogined) {
                    [self showLoginPage];
                    
                    return;
                }
                
                PayListViewController *viewController = [[PayListViewController alloc] initWithNibName:@"PayListViewController" bundle:nil];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
            //分销设置
            else if (indexPath.row == 2) {
                
                self.isAlreadyLogined = [self getUserLoginState];
                
                if (!self.isAlreadyLogined) {
                    [self showLoginPage];
                    
                    return;
                }
                
                DispatchSettingsViewController *viewController = [[DispatchSettingsViewController alloc] init];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        case 4:
        {
            //http://mobile.bkrtrip.com/view/other/line/version.html
            //http://mobile.bkrtrip.com/view/other/line/help.html
            //http://mobile.bkrtrip.com/com/about
            
            
            if (indexPath.row == 2) {
                [self creatAndShowShareView];
                
                return;
            }
            
            WebContentViewController *viewController = [[WebContentViewController alloc] init];
            if (indexPath.row == 0) {
                viewController.contentUrl = @"http://mobile.bkrtrip.com/view/other/line/help.html";
                viewController.title = @"帮助";
            }
            else if (indexPath.row == 1) {
                viewController.contentUrl = @"http://mobile.bkrtrip.com/view/other/line/version.html";
                viewController.title = @"关于旅小宝";
            }
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        //退出
        case 6:
        {
            if (self.isAlreadyLogined) {
                [self confirmLogOutWithAlert];
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)updateUIForLoginState:(BOOL)isAlreadyLogin
{
    PHeaderTableViewCell *cell = (PHeaderTableViewCell *)[self.mineTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        [cell needUserToSignin:!isAlreadyLogin];
        
        if (isAlreadyLogin) {
            [cell initialHeaderViewWithUserInfo:self.userInfoDic];
        }
    }
    
    [self.mineTableView reloadData];
}


- (void)confirmLogOutWithAlert
{
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"退出当前帐号，您的微店将不能使用，确定要退出 ？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self signOut];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            ;
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:telAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"退出当前帐号，您的微店将不能使用，确定要退出 ？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self signOut];
    }
}


- (void)signOut
{
    //clear user infomation
    [UserModel clearUserInformation];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_ALL_LIST_WITH_LOGINING_SUCCESS object:self];
    
    self.userInfoDic = nil;
    
    [self updateUIForLoginState:NO];
}


#pragma mark HeaderViewDelegate

- (void)responseForAction:(ActionType)action
{
    // || action == GoToSuppliers || action == GoToOrders
    if (action == GoToDispatchers) {
        //TODO: 未登录不允许访问
        
        self.isAlreadyLogined = [self getUserLoginState];

        if (!self.isAlreadyLogined) {
            [self showLoginPage];
            
            return;
        }
    }
    
    switch (action) {
        case GoToLogin:
        {
            //登录界面
            
            UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:nil];
            UIViewController *viewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginControllerNavController"];
            ((LoginViewController *)(((UINavigationController *)viewController).viewControllers.firstObject)).delegate = self;
            
            [self presentViewController:viewController animated:YES completion:nil];
        }
            break;
        case GoToRegister:
        {
            UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:nil];
            UIViewController *viewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"registerNavController"];
            
            [self presentViewController:viewController animated:YES completion:nil];
        }
            break;
        case GoToDispatchers:
        {
            [self getDispatchSettingsInfo];
        }
            break;
        case GoToSuppliers:
        {
            //跳转供应商(xiaozhu)
            if ([UserModel companyId]  && [UserModel staffId]) {
                MySupplierViewController *mySupplier = [[MySupplierViewController alloc] init];
                [self.navigationController pushViewController:mySupplier animated:YES];
                return;
            }
            [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
        }
            break;
        case GoToOrders:
        {
            if ([UserModel companyId] && [UserModel staffId]) {
                //跳转用户订单页面(xiaozhu)
                MyOrderListViewController *orderList = [[MyOrderListViewController alloc] init];
                [self.navigationController pushViewController:orderList animated:YES];
            } else {
                [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
            }
        }
            break;
        case GoToInfoSettings:
        {
            PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc] init];
            personalInfoVC.userInfoDic = self.userInfoDic;
            
            [self.navigationController pushViewController:personalInfoVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (void)showLoginPage
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:nil];
    UIViewController *viewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginControllerNavController"];
    ((LoginViewController *)(((UINavigationController *)viewController).viewControllers.firstObject)).delegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)getUserInformation
{
    __weak PersonalCenterViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/staffData", HOST_BASE_URL];
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100026"];
                 
                 if (resultDic) {
                     weakSelf.userInfoDic = resultDic;
                     [weakSelf updateUIForLoginState:YES];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}


- (void)getDispatchSettingsInfo
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    __weak PersonalCenterViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 3;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/isOpenDistributor", HOST_BASE_URL];
    
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100054"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"key"] isEqualToString:@"0"]) {
                     [self showAlertViewWithTitle:nil message:@"您还未开通企业分销服务，请进入我的－分销设置进行开通" cancelButtonTitle:@"确认"];
                 }
                 else if (resultDic && [[resultDic stringValueByKey:@"key"] isEqualToString:@"1"]) {
                     
                     DispatchersViewController *viewController = [[DispatchersViewController alloc] init];
                     
                     [self.navigationController pushViewController:viewController animated:YES];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}

    

//https://itunes.apple.com/cn/app/lu-xiao-bao/id1015845012?mt=8
#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";
    
    NSString *title = [NSString stringWithFormat:@"%@邀您加入旅小宝", [UserModel getUserPropertyByKey:@"staff_departments_name"]];
    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaWeChatWithURLString:appUrl title:title content:content image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";

    NSString *title = [NSString stringWithFormat:@"%@邀您加入旅小宝", [UserModel getUserPropertyByKey:@"staff_departments_name"]];
    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaQQWithURLString:appUrl title:title content:content image:nil location:nil presentedController:self shareType:QQ_Share_Session];
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";
    
    NSString *title = [NSString stringWithFormat:@"%@邀您加入旅小宝", [UserModel getUserPropertyByKey:@"staff_departments_name"]];
    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaQQWithURLString:appUrl title:title content:content image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareView];
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";

    NSString *content = [NSString stringWithFormat:@"我是%@，旅小宝提供免费微店，不用录产品即可销售线路了，还能免费开通外联、分销账户，特别方便！注册邀请码：%@，旅小宝下载地址：%@", [UserModel getUserPropertyByKey:@"staff_departments_name"], [UserModel getUserPropertyByKey:@"invite_code"], appUrl];
    
    [[Global sharedGlobal] shareViaSMSWithContent:content presentedController:self];
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self supportClickWithQQWithShareObject:obj];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";

    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaYiXinWithURLString:appUrl content:content image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";

    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaSinaWithURLString:appUrl content:content image:nil location:nil presentedController:self];
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareView];
    
    NSString *appUrl = @"https://itunes.apple.com/app/id1015845012";

    NSString *title = [NSString stringWithFormat:@"%@邀您加入旅小宝", [UserModel getUserPropertyByKey:@"staff_departments_name"]];
    NSString *content = [NSString stringWithFormat:@"旅小宝提供免费微店，不用录产品即可销售线路！还能免费开通外联、分销账户！注册邀请码：%@", [UserModel getUserPropertyByKey:@"invite_code"]];
    
    [[Global sharedGlobal] shareViaWeChatWithURLString:appUrl title:title content:content image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
}


- (void)supportClickWithCancel
{
    [self hideShareView];
}

#pragma mark - private


- (void)creatAndShowShareView
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

- (void)hidePopUpViews
{
    [self hideShareView];
    _darkMask.alpha = 0;
}

@end
