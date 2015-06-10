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

#import "PersonalInfoViewController.h"
#import "DispatchersViewController.h"
#import "LoginViewController.h"
#import "RPhoneNumViewController.h"//register procedure start point

@interface PersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderActionProtocol, LoginVCProtocol>
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

@property (assign, nonatomic) BOOL isAlreadyLogined;

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
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PSeperaterTableViewCell" bundle:nil] forCellReuseIdentifier:@"separateCell"];
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PCommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"commonCell"];

    [self.mineTableView registerNib:[UINib nibWithNibName:@"PHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    
    self.mineTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    

    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}


- (BOOL)getUserLoginState
{
    NSDictionary *userInfoDic = [UserModel getUserInformations];
    if (userInfoDic) {
        return YES;
    }
    
    return NO;
}


#pragma mark - LoginVCProtocol

- (void)loginSuccess
{
    self.isAlreadyLogined = YES;
    [self updateUIForLoginState:YES];
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
                [(PHeaderTableViewCell *)cell initialHeaderViewWithUserInfo:nil];
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
            if (indexPath.row == 0) {
                
            }
            else if (indexPath.row == 1) {
                PayListViewController *viewController = [[PayListViewController alloc] initWithNibName:@"PayListViewController" bundle:nil];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 3) {
                
            }
        }
            break;
        case 4:
        {
            
        }
            break;
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
            [cell initialHeaderViewWithUserInfo:[UserModel getUserInformations]];
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
    if (action == GoToDispatchers || action == GoToSuppliers || action == GoToOrders) {
        //TODO: 未登录不允许访问
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
            //跳转用户订单页面(xiaozhu)

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
            [self.navigationController pushViewController:personalInfoVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
