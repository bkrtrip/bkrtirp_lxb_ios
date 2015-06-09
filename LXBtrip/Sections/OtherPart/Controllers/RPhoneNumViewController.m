//
//  RPhoneNumViewController.m
//  lxb
//
//  Created by Sam on 5/31/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "RPhoneNumViewController.h"
#import "UIViewController+CommonUsed.h"
#import "RVerifyCodeViewController.h"
#import "AFNetworking.h"

@interface RPhoneNumViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;

@end

@implementation RPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToVerification:(id)sender {
    
    if (self.phoneNumTf.text.length != 11) {
        [self showAlertViewWithTitle:@"提示" message:@"手机号输入格式不正确，请重新输入。" cancelButtonTitle:@"确定"];
        
        return;
    }
    
    [self checkPhoneNumberAlreadyRegistered:self.phoneNumTf.text];
    
    
}


- (void)checkPhoneNumberAlreadyRegistered:(NSString *)phoneNum
{
    __weak RPhoneNumViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/userCheck", HOST_BASE_URL];
    [manager POST:partialUrl parameters:@{@"phone":phoneNum}
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *checkDic = [jsonObj objectForKey:@"RS100035"];
                 NSString *errorCode = [NSString stringWithFormat:@"%@", [checkDic objectForKey:@"error_code"]];
                 if ([errorCode isEqualToString:@"40001"]) {
                     [weakSelf performSegueWithIdentifier:@"goToRVerifyCode" sender:nil];
                 }
                 else {
                     [weakSelf showAlertViewWithTitle:@"提示" message:@"您的输入的手机号已经注册，请换个手机或找回回密码。" cancelButtonTitle:@"确定"];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}




- (IBAction)cancelRegisteration:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField.tag == 211) {
        
        NSError *error;
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
        if (regEx && string.length > 0) {
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }
        
        if (range.location == 11 && range.length == 0) {
            
            return NO;
        }
        
        if (textField.text.length == 0 && (range.location == 0 && range.length == 0)) {
            NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"1" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }
    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 211) {
        ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_1"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    RVerifyCodeViewController *viewController = (RVerifyCodeViewController *)[segue destinationViewController];
    viewController.phoneNum = self.phoneNumTf.text;
    
}


@end

















