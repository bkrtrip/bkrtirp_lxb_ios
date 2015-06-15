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

#import "PersonalInfoViewController.h"
#import "DispatchersViewController.h"
#import "LoginViewController.h"
#import "RPhoneNumViewController.h"//register procedure start point
#import "DispatchSettingsViewController.h"

@interface PersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderActionProtocol, LoginVCProtocol>
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

@property (assign, nonatomic) BOOL isAlreadyLogined;

@property (retain, nonatomic) NSDictionary *userInfoDic;

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
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
            return 2;
            
        //separate cell
        default:
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
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
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];

            if (indexPath.row == 0) {
                [(PCommonTableViewCell *)cell initailCellWithType:Message];
            }
            else if (indexPath.row == 1) {
                [(PCommonTableViewCell *)cell initailCellWithType:Alipay];
            }
            else if (indexPath.row == 2) {
                [(PCommonTableViewCell *)cell initailCellWithType:Dispatch];
                cell.separatorInset = UIEdgeInsetsZero;
            }
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
            
            if (indexPath.row == 0) {
                [(PCommonTableViewCell *)cell initailCellWithType:Help];
            }
            else if (indexPath.row == 1) {
                [(PCommonTableViewCell *)cell initailCellWithType:About];
                cell.separatorInset = UIEdgeInsetsZero;
            }
        }
            break;
        case 6:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
            
            [(PCommonTableViewCell *)cell initailCellWithType:SignOut];
            cell.separatorInset = UIEdgeInsetsZero;
        }
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"separateCell"];
            cell.separatorInset = UIEdgeInsetsZero;
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
                
            }
            //支付设置
            else if (indexPath.row == 1) {
                PayListViewController *viewController = [[PayListViewController alloc] initWithNibName:@"PayListViewController" bundle:nil];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
            //分销设置
            else if (indexPath.row == 2) {
                
                if (!self.isAlreadyLogined) {
                    [self showAlertViewWithTitle:nil message:@"您还未登录，请先登录" cancelButtonTitle:@"确认"];
                    return;
                }
                
                DispatchSettingsViewController *viewController = [[DispatchSettingsViewController alloc] init];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        case 4:
        {
            
        }
            break;
        //退出
        case 6:
        {
            if (self.isAlreadyLogined) {
                [self confirmLogOutWithAlert];
                
                [self updateUIForLoginState:NO];
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
    
    
}


#pragma mark HeaderViewDelegate

- (void)responseForAction:(ActionType)action
{
    // || action == GoToSuppliers || action == GoToOrders
    if (action == GoToDispatchers) {
        //TODO: 未登录不允许访问
        if (!self.isAlreadyLogined) {
            [self showAlertViewWithTitle:nil message:@"您还未开通企业分销服务，请进入我的－分销设置进行开通" cancelButtonTitle:@"确认"];
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
            DispatchersViewController *viewController = [[DispatchersViewController alloc] init];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case GoToSuppliers:
        {
            //跳转供应商(xiaozhu)

        }
            break;
        case GoToOrders:
        {
            //跳转用户订单页面(xiaozhu)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
