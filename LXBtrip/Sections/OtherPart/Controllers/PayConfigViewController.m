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
#import "AlterUserInfoViewController.h"
#import "WCPayFooterTableViewCell.h"

@interface PayConfigViewController ()<UpdateUserInformationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *configTableView;

@property (retain, nonatomic) NSMutableDictionary *webChatPaymentConfigDic;

@property (assign, nonatomic) BOOL isOpenedWXPay;

@end

@implementation PayConfigViewController

- (NSMutableDictionary *)webChatPaymentConfigDic
{
    if (!_webChatPaymentConfigDic) {
        _webChatPaymentConfigDic = [[NSMutableDictionary alloc] init];
    }
    
    return _webChatPaymentConfigDic;
}

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
    if ([staffDic stringValueByKey:@"staff_id"].length == 0) {
        return;
    }
    
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
                 
                 if (resultDic && [resultDic stringValueByKey:@"error_code"].length == 0) {
                     weakSelf.isOpenedWXPay = YES;
                     [weakSelf.webChatPaymentConfigDic removeAllObjects];
                     [weakSelf.webChatPaymentConfigDic addEntriesFromDictionary:resultDic];
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
        
        [((WCPayFooterTableViewCell *)cell).openWebchatPayBtn addTarget:self action:@selector(openWebchatPayment) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (indexPath.section == 1) {
        
        AlterUserInfoViewController *viewController = [[AlterUserInfoViewController alloc] init];
        viewController.delegate = self;
        viewController.webChatPaymentConfigDic = self.webChatPaymentConfigDic;

        switch (indexPath.row) {
            case 0:
            {
                viewController.type = WX_loginname;
            }
                break;
            case 1:
            {
                viewController.type = WX_loginpwd;
            }
                break;
            case 2:
            {
                viewController.type = WX_appid;
            }
                break;
            case 3:
            {
                viewController.type = WX_appsecret;
            }
                break;
            case 4:
            {
                viewController.type = WX_partner;
            }
                break;
            case 5:
            {
                viewController.type = WX_paysecret;
            }
                break;
                
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - UpdateUserInformationDelegate

- (void)informationAlteredTo:(NSString *)changedInfor forType:(AlterInfoTypes)type
{
    switch (type) {
        case ShopContactName:
        case ShopName:
        case DetailAdress:
            break;
            //webchat payment settings
        case WX_loginname:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_loginname"];
            
            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case WX_loginpwd:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_loginpwd"];
            
            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case WX_appid:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_appid"];
            
            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case WX_appsecret:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_appsecret"];
            
            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case WX_partner:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_partner"];
            
            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case WX_paysecret:
        {
            [self.webChatPaymentConfigDic setValue:changedInfor forKey:@"wx_paysecret"];

            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        default:
            break;
    }
}


- (void)openWebchatPayment
{
    if (!self.isOpenedWXPay) {
        //all information required
    }
    
    [self createWebchatPaymentConfigWithInfo:self.webChatPaymentConfigDic];
}

- (void)createWebchatPaymentConfigWithInfo:(NSDictionary *)dic
{
    __weak PayConfigViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/paySet", HOST_BASE_URL];
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] init];
    [parameterDic setValue:[staffDic stringValueByKey:@"staff_id" ] forKey:@"staffid"];
    [parameterDic setValue:[staffDic stringValueByKey:@"dat_company_id"] forKey:@"companyid"];
    
    [parameterDic setValue:[dic stringValueByKey:@"wx_loginname"] forKey:@"loginname"];
    [parameterDic setValue:[dic stringValueByKey:@"wx_loginpwd"] forKey:@"loginpwd"];
    [parameterDic setValue:[dic stringValueByKey:@"wx_appid"] forKey:@"appid"];
    [parameterDic setValue:[dic stringValueByKey:@"wx_appsecret"] forKey:@"appsecret"];
    [parameterDic setValue:[dic stringValueByKey:@"wx_partner"] forKey:@"companyno"];
    [parameterDic setValue:[dic stringValueByKey:@"wx_paysecret"] forKey:@"paysecret"];

    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100030"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     //add or update success
                     NSString *msg;
                     if (weakSelf.isOpenedWXPay) {
                         msg = @"更新成功。";
                     }
                     else {
                         msg = @"开通成功。";
                     }
                     
                     [weakSelf showAlertViewWithTitle:nil message:msg cancelButtonTitle:@"确定"];
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
