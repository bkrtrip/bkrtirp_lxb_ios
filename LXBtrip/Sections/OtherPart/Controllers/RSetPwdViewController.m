//
//  RSetPwdViewController.m
//  lxb
//
//  Created by Sam on 5/31/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "RSetPwdViewController.h"
#import "UIViewController+CommonUsed.h"
#import "AFNetworking.h"
#import "AppMacro.h"
#import "CustomActivityIndicator.h"

@interface RSetPwdViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPwdTf;

@end

@implementation RSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerationComplete:(id)sender {
    if (![self.pwdTf.text isEqualToString:self.confirmNewPwdTf.text]) {
        [self showAlertViewWithTitle:@"提示" message:@"两次输入的密码不一致，请重新输入。" cancelButtonTitle:@"确定"];
        return;
    }
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self setPassword:self.pwdTf.text forPhone:self.phoneNum];
}


- (void)setPassword:(NSString *)pwd forPhone:(NSString *)phoneNum
{
    __weak RSetPwdViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/register", HOST_BASE_URL];
    NSDictionary *paramDic;
    if (self.invitationCode && self.invitationCode.length == 5) {
        paramDic = @{@"name":phoneNum, @"pwd":pwd, @"code":self.invitationCode};
    }
    else {
        paramDic = @{@"name":phoneNum, @"pwd":pwd};
    }
    
    [manager POST:partialUrl parameters:paramDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                 
                 if (NSClassFromString(@"UIAlertController")) {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功。" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                     }];
                     
                     [alertController addAction:cancelAction];
                     
                     [weakSelf presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功。" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                 }
                 
//                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
             }
             
         }
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
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






