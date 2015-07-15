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
#import "WebContentViewController.h"

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

//get a string that contains only number and alphabet, its length is 32
- (NSString *)getRandomPaymentSecret
{
    NSString *sourceAlphas = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < 32; i++)
    {
        unsigned index = rand() % [sourceAlphas length];
        NSString *oneStr = [sourceAlphas substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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
//             NSLog(@"%@", jsonObj);
             
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
        
        if (self.isOpenedWXPay) {
            [((WCPayFooterTableViewCell *)cell).openWebchatPayBtn setTitle:@"保存" forState:UIControlStateNormal];
        }
        else {
            [((WCPayFooterTableViewCell *)cell).openWebchatPayBtn setTitle:@"确认开通" forState:UIControlStateNormal];
        }
        
        [((WCPayFooterTableViewCell *)cell).webchatPaymentHelpBtn addTarget:self action:@selector(showHelpWebPage) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return cell;
}

- (UITableViewCell *)getSettingsCellForTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    InfoConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoConfigCell"];
    
    cell.contentLabel.hidden = NO;
    cell.contentTF.hidden = YES;
    
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
            
            cell.contentLabel.hidden = YES;
            cell.contentTF.hidden = NO;

            if (self.webChatPaymentConfigDic && [self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"].length > 0) {
                [cell setcontentInformation:[self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"]];
            }
            else {
                [cell setcontentInformation:@""];
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
                
                NSString *paySecret = [self getRandomPaymentSecret];
                [cell setcontentInformation:paySecret];
                [self.webChatPaymentConfigDic setValue:paySecret forKey:@"wx_paysecret"];
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        if (indexPath.row == 5) {
            
            if (self.isOpenedWXPay) {
                [self showMenueForCopyPaySecret];
            }
            
            return;
        }
        
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
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)showMenueForCopyPaySecret {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    InfoConfigTableViewCell *cell = (InfoConfigTableViewCell *)[self.configTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    CGRect selectionRect = CGRectMake(cell.frame.origin.x + cell.contentTF.frame.origin.x, cell.frame.origin.y + 5, 60, 20);
    [menuController setTargetRect:selectionRect inView:self.configTableView];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"拷贝支付秘钥" action:@selector(copyPaysecretToClipboard)];
    [menuController setMenuItems:[NSArray arrayWithObject:item]];
    [menuController setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    //@selector(copy:) == action ||

    BOOL result = NO;
    if(@selector(copyPaysecretToClipboard) == action) {
        result = YES;
    }
    return result;
}

// UIMenuController Methods

- (void)copyPaysecretToClipboard {
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = ((InfoConfigTableViewCell *)[self.configTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]]).contentTF.text;
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



- (void)showHelpWebPage
{
    WebContentViewController *viewController = [[WebContentViewController alloc] init];
    viewController.contentUrl = @"http://ws.bkrtrip.cn/view/server/pay/help.html";
    viewController.title = @"微信支付设置帮助";
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openWebchatPayment
{
    //all information required
    if ([self.webChatPaymentConfigDic stringValueByKey:@"wx_loginname"].length == 0) {
        
        [self showAlertViewWithTitle:nil message:@"微信公众平台用户名不能为空。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if ([self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"].length == 0) {
        
        [self showAlertViewWithTitle:nil message:@"微信密码不能为空。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if ([self.webChatPaymentConfigDic stringValueByKey:@"wx_appid"].length == 0) {
        
        [self showAlertViewWithTitle:nil message:@"公众号appid不能为空。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if ([self.webChatPaymentConfigDic stringValueByKey:@"wx_appsecret"].length == 0) {
        
        [self showAlertViewWithTitle:nil message:@"公众号appsecret不能为空。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if ([self.webChatPaymentConfigDic stringValueByKey:@"wx_partner"].length == 0) {
        
        [self showAlertViewWithTitle:nil message:@"微信支付商户号不能为空。" cancelButtonTitle:@"确定"];
        return;
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
//             NSLog(@"%@", jsonObj);
             
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
                     
//                     [weakSelf showAlertViewWithTitle:nil message:msg cancelButtonTitle:@"确定"];
                     [weakSelf.navigationController popViewControllerAnimated:YES];
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
