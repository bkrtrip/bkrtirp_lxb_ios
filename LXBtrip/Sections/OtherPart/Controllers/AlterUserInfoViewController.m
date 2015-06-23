//
//  AlterUserInfoViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "AlterUserInfoViewController.h"
#import "NSDictionary+GetStringValue.h"
#import "AFNetworking.h"
#import "UIViewController+CommonUsed.h"

@interface AlterUserInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *infoTF;
@property (weak, nonatomic) IBOutlet UILabel *alterHintLabel;

@end

@implementation AlterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initailWithAlterType:self.type];
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存" image:nil];
    [self.infoTF becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClicked:(id)sender
{
    NSDictionary *alterInfoDic;
    
    switch (self.type) {
        case ShopContactName:
        {
            alterInfoDic = @{@"staffid":[self.userInfoDic stringValueByKey:@"staff_id"], @"companyid":[self.userInfoDic stringValueByKey:@"company_id"], @"contacts":self.infoTF.text};
            
            [self updateUserInfo:alterInfoDic];
        }
            break;
        case ShopName:
        {
            alterInfoDic = @{@"staffid":[self.userInfoDic stringValueByKey:@"staff_id"], @"companyid":[self.userInfoDic stringValueByKey:@"company_id"], @"wdname":self.infoTF.text};
            
            [self updateUserInfo:alterInfoDic];
        }
            break;
        case DetailAdress:
        {
            alterInfoDic = @{@"staffid":[self.userInfoDic stringValueByKey:@"staff_id"], @"companyid":[self.userInfoDic stringValueByKey:@"company_id"], @"address":self.infoTF.text};
            
            [self updateUserInfo:alterInfoDic];
        }
            break;
            //webchat payment settings
        case WX_loginname:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_loginname];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case WX_loginpwd:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_loginpwd];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case WX_appid:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_appid];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case WX_appsecret:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_appsecret];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case WX_partner:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_partner];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case WX_paysecret:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:WX_paysecret];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case DispatchRate:
        {
            if (self.delegate) {
                [self.delegate informationAlteredTo:self.infoTF.text forType:DispatchRate];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)updateUserInfo:(NSDictionary *)userDic
{
    __weak AlterUserInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/setStaff", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:userDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100024"];
                 
                 //update user info successfully
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     
                     if (weakSelf.delegate) {
                         [weakSelf.delegate updateUserInformationSuccessfully];
                         
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}


- (void)initailWithAlterType:(AlterInfoTypes)type
{
    switch (type) {
        case ShopContactName:
        {
            self.alterHintLabel.text = @"请输入业务咨询联系人的真实姓名 !";
            self.title = @"微店联系人";
            
            self.infoTF.text = [self.userInfoDic stringValueByKey:@"staff_real_name"];
        }
            break;
        case ShopName:
        {
            self.alterHintLabel.text = @"请输入企业名称或门市名称（此名称在微店头部展示）";
            self.title = @"微店名称";
            
            self.infoTF.text = [self.userInfoDic stringValueByKey:@"staff_departments_name"];
        }
            break;
        case DetailAdress:
        {
            self.alterHintLabel.text = @"请正确填写旅行社的详细地址，如“碑林区太乙路十字向东” !";
            self.title = @"详细地址";
            
            self.infoTF.text = [self.userInfoDic stringValueByKey:@"staff_address"];
        }
            break;
            //webchat payment settings
        case WX_loginname:
        {
            self.alterHintLabel.text = @"";
            self.title = @"微信公众平台用户名";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_loginname"];
        }
            break;
        case WX_loginpwd:
        {
            self.alterHintLabel.text = @"";
            self.title = @"微信密码";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_loginpwd"];
        }
            break;
        case WX_appid:
        {
            self.alterHintLabel.text = @"";
            self.title = @"公众号appid";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_appid"];
        }
            break;
        case WX_appsecret:
        {
            self.alterHintLabel.text = @"";
            self.title = @"公众号appsecret";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_appsecret"];
        }
            break;
        case WX_partner:
        {
            self.alterHintLabel.text = @"";
            self.title = @"微信支付商户号";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_partner"];
        }
            break;
        case WX_paysecret:
        {
            self.alterHintLabel.text = @"";
            self.title = @"支付密钥";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_paysecret"];
        }
            break;
        case DispatchRate:
        {
            self.alterHintLabel.text = @"";
            self.title = @"利润率";
            
            self.infoTF.text = [self.webChatPaymentConfigDic stringValueByKey:@"wx_paysecret"];
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_1"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
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
