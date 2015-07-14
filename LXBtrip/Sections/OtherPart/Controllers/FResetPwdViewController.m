//
//  FResetPwdViewController.m
//  lxb
//
//  Created by Sam on 5/31/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "FResetPwdViewController.h"
#import "UIViewController+CommonUsed.h"
#import "AFNetworking.h"
#import "AppMacro.h"
#import "CustomActivityIndicator.h"

@interface FResetPwdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPwdTf;
@end

@implementation FResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetPwdComplete:(id)sender {
    
    if (self.pwdTf.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"请输入密码。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if (self.confirmNewPwdTf.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"请输入确认密码。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.confirmNewPwdTf.text]) {
        [self showAlertViewWithTitle:nil message:@"两次输入的密码不一致，请重新输入。" cancelButtonTitle:@"确定"];
        return;
    }
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self setPassword:self.pwdTf.text forPhone:self.phoneNum];
}


- (void)setPassword:(NSString *)pwd forPhone:(NSString *)phoneNum
{
    __weak FResetPwdViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/register", HOST_BASE_URL];
    [manager POST:partialUrl parameters:@{@"name":phoneNum, @"pwd":pwd}
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

                 [weakSelf dismissViewControllerAnimated:YES completion:nil];

                 /*
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100038"];
                 NSString *pwd = [resultDic objectForKey:@"staff_pwd"];
                 
                 if (pwd) {
                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                 }
                 else {
                     [weakSelf showAlertViewWithTitle:@"提示" message:@"修改密码失败。" cancelButtonTitle:@"确定"];
                 }
                 */
             }
             
         }
         
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

     }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 20 && range.length == 0) {
        
        return NO;
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




@end
