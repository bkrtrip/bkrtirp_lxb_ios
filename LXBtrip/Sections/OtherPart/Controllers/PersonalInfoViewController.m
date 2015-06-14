//
//  PersonalInfoViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "PhotoTableViewCell.h"
#import "AlterUserInfoViewController.h"
#import "AlterPhoneNumViewController.h"
#import "NSDictionary+GetStringValue.h"
#import "AFNetworking.h"
#import "UIViewController+CommonUsed.h"

@interface PersonalInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *pInfoTableView;

@property (retain, nonatomic) NSDictionary *userInfoDic;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.pInfoTableView registerNib:[UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
    
    [self.pInfoTableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"userInfoCell"];

    self.pInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"我的信息";
    
    [self getUserInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getUserInformation
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/staffData", HOST_BASE_URL];
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100026"];
                 
                 if (resultDic) {
                     weakSelf.userInfoDic = resultDic;
                     [self.pInfoTableView reloadData];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        
        return cell;
    }
    else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
        
        switch (indexPath.row) {
            case 1:
            {
                cell.titleLabel.text = @"微店联系人";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_real_name"];
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"微店名称";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_departments_name"];
            }
                break;
            case 3:
            {
                cell.titleLabel.text = @"联系电话";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"wd_phone"];
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"所在地";
                if (self.userInfoDic) {
                    NSString *address = [NSString stringWithFormat:@"%@ %@", [self.userInfoDic objectForKey:@"staff_provinc_name"], [self.userInfoDic objectForKey:@"staff_city_name"]];
                    cell.contentLabel.text = address;
                }
            }
                break;
            case 5:
            {
                cell.titleLabel.text = @"详细地址";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_address"];
            }
                break;
                
                
            default:
                break;
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 1:
        {
            [self goToAlterInfoPageWithType:ShopContactName withInformation:@""];
        }
            break;
        case 2:
        {
            [self goToAlterInfoPageWithType:ShopName withInformation:@""];
        }
            break;
        case 3://联系方式
        {
            AlterPhoneNumViewController *viewController = [[AlterPhoneNumViewController alloc] init];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4://地址
        {
            
        }
            break;
        case 5:
        {
            [self goToAlterInfoPageWithType:DetailAdress withInformation:@""];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)goToAlterInfoPageWithType:(AlterInfoTypes)type withInformation:(NSString *)info
{
    AlterUserInfoViewController *viewController = [[AlterUserInfoViewController alloc] init];
    [viewController initailAlterType:type forInfomation:info];
    viewController.type = type;
    
    [self.navigationController pushViewController:viewController animated:YES];
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
