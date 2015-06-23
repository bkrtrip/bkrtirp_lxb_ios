//
//  LoginViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "LoginViewController.h"
//#import "LoginRequestObjectManger.h"
#import "AFNetworking.h"
#import "UserModel.h"
#import "UIViewController+CommonUsed.h"
#import "NSDictionary+GetStringValue.h"

#import "PersonalCenterViewController.h"

#import "CustomActivityIndicator.h"


@interface LoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;//登陆手机号
@property (weak, nonatomic) IBOutlet UITextField *passwordText;//登陆密码
@property (weak, nonatomic) IBOutlet UIButton *loginItem;//登陆按钮

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}


-(void)loginSystemForUser:(NSString *)name withPwd:(NSString *)pwd
{
    __weak LoginViewController *weakSelf = self;
//    __strong LoginViewController *strongSelf = self;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSDictionary *parameters=@{@"name":name,@"pwd":pwd, @"clienttype":@"1"};
//    NSDictionary *parameters=@{@"name":@"18602929807",@"pwd":@"654321"};
//    NSDictionary *parameters=@{@"name":@"xahsly",@"pwd":@"qiqi63361888"};

    NSString *partialUrl = [NSString stringWithFormat:@"%@common/login", HOST_BASE_URL];
    [manager POST:partialUrl parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100034"];
                 if (resultDic && [resultDic stringValueByKey:@"error_code"].length > 0) {
                     
                     [weakSelf showAlertViewWithTitle:nil message:[resultDic stringValueByKey:@"error_info"] cancelButtonTitle:@"确定"];
                     
                     return ;
                 }

                 
                 [UserModel storeUserInformations:jsonObj];
                 
                 
                 
//                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                 [weakSelf performSelector:@selector(dismissSelf) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

//                 [weakSelf showAlertViewWithTitle:@"提示" message:@"登录成功。" cancelButtonTitle:@"确定"];
                 
                 if (NSClassFromString(@"UIAlertController")) {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功。" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                     }];
                     
                     [alertController addAction:cancelAction];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功。" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                 }
                 
                 if (weakSelf.delegate) {
                     [weakSelf.delegate loginSuccess];
                 }

             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         [weakSelf showAlertViewWithTitle:@"提示" message:@"登录失败，请重试。" cancelButtonTitle:@"确定"];
     }];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)login:(id)sender
{
    if (![self.phoneNumberText.text isEqualToString:@""]&&![self.passwordText.text isEqualToString:@""])
    {
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimatingWithMessage:@"登录中..."];
        [self loginSystemForUser:self.phoneNumberText.text withPwd:self.passwordText.text];
    }else
    {
        [self showAlertViewWithTitle:@"提示" message:@"请填写手机号或密码。" cancelButtonTitle:@"确定"];
    }
}
- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField.tag == 211) {
        
        NSError *error;
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"[0-9a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:&error];
        if (regEx && string.length > 0) {
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }
        
        if (range.location == 11 && range.length == 0) {
            
            return NO;
        }
        /*
        if (textField.text.length == 0 && (range.location == 0 && range.length == 0)) {
            NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"1" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }*/
    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 211) {
        ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_1"];
    }
    else if (textField.tag == 212)
    {
        ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_1"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_0"];
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
