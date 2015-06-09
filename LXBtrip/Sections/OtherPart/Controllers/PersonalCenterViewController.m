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

@interface PersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HeaderActionProtocol>
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

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
    
    
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PSeperaterTableViewCell" bundle:nil] forCellReuseIdentifier:@"separateCell"];
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"PCommonTableViewCell" bundle:nil] forCellReuseIdentifier:@"commonCell"];

    [self.mineTableView registerNib:[UINib nibWithNibName:@"PHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    
    self.mineTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    

    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
        }
            break;
            
        default:
            break;
    }
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
            
        }
            break;
        case GoToRegister:
        {
            
        }
            break;
        case GoToDispatchers:
        {
            
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
