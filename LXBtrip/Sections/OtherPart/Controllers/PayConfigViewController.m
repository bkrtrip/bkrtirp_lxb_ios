//
//  PayConfigViewController.m
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PayConfigViewController.h"
#import "InfoConfigTableViewCell.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "UserModel.h"

@interface PayConfigViewController ()
@property (weak, nonatomic) IBOutlet UITableView *configTableView;

@property (retain, nonatomic) NSDictionary *webChatPaymentConfigDic;

@end

@implementation PayConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.configTableView registerNib:[UINib nibWithNibName:@"InfoConfigTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoConfigCell"];
    
    [self.configTableView registerNib:[UINib nibWithNibName:@"WCPayFooterTableViewCell" bundle:nil] forCellReuseIdentifier:@"wcConfigFooterCell"];

    
    [self.configTableView registerNib:[UINib nibWithNibName:@"WCPayHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"wcConfigHeaderCell"];

    
    self.configTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.title = @"微信支付";
    
    [self getPaymentInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getPaymentInformation
{
    __weak PayConfigViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/isOpenPay", HOST_BASE_URL];
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100029"];
                 
                 if (resultDic) {
                     weakSelf.webChatPaymentConfigDic = resultDic;
                     [weakSelf.configTableView reloadData];
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
    if (section == 0 || section == 2) {
        return 1;
    }
    
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"wcConfigHeaderCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
    }
    else if (indexPath.section == 1) {
        cell = [self getSettingsCellForTableView:tableView IndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"wcConfigFooterCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
    }
    
    return cell;
}

- (UITableViewCell *)getSettingsCellForTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    InfoConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoConfigCell"];
    
    switch (indexPath.row) {
        case 0:
        {
            [cell initializeCellForType:WCPublicUserName];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_loginname"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_loginname"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
        case 1:
        {
            [cell initializeCellForType:WCPwd];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
        case 2:
        {
            [cell initializeCellForType:PublicAppId];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_appid"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_appid"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
        case 3:
        {
            [cell initializeCellForType:PublicSecret];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_appsecret"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_appsecret"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
        case 4:
        {
            [cell initializeCellForType:WCPayAcount];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_partner"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_partner"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
        case 5:
        {
            [cell initializeCellForType:WCPaySecret];
            
            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_paysecret"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_paysecret"]];
            }
            else {
                [cell setcontentInformation:@"未设置"];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    else if (indexPath.section == 2) {
        return 150;
    }
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
