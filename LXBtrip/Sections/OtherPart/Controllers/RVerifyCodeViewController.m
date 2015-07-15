//
//  RVerifyCodeViewController.m
//  lxb
//
//  Created by Sam on 5/31/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "RVerifyCodeViewController.h"
#import "UIViewController+CommonUsed.h"
#import "AFNetworking.h"
#import "AppMacro.h"
#import "RSetPwdViewController.h"
#import "AppDelegate.h"

@interface RVerifyCodeViewController ()<UITextFieldDelegate, RTimerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *tryToGetNewVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeAlertLabel;

@property (nonatomic, retain) NSString *verificationCode;


@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTf;
@end

@implementation RVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTimerDelegate];
    
    if (self.phoneNum != nil && self.phoneNum.length == 11) {
        self.phoneNumLabel.text = self.phoneNum;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToInitialPwd:(id)sender {
    if (self.verifyCodeTf.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"验证码不能为空，请输入手机收到的验证码。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if (!self.verificationCode || self.verificationCode.length < 4) {
        [self showAlertViewWithTitle:nil message:@"请先获取验证码。" cancelButtonTitle:@"确定"];
        return;
    }
    
    NSRange range = [self.verificationCode rangeOfString:self.verifyCodeTf.text];
    
    if (range.location == NSNotFound || range.length != 4) {
        [self showAlertViewWithTitle:@"提示" message:@"验证码输入错误，请重新输入。" cancelButtonTitle:@"确定"];
        return;
    }
    
    if (self.invitationCodeTf.text.length > 0 && self.invitationCodeTf.text.length != 5) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入正确格式的邀请码(五位大些字母)。" cancelButtonTitle:@"确定"];
        return;
    }
    
    
    [self performSegueWithIdentifier:@"goToRSetPwd" sender:nil];
}
- (IBAction)getVerificationCode:(id)sender {
    AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedDelegate.delegateForRegister = self;
    [sharedDelegate startRTimer];
    
    [self getVerificationCodeForPhone:self.phoneNum];
}


- (void)dealloc
{
    [self removeTimerDelegate];
}

- (void)setTimerDelegate
{
    AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (sharedDelegate.rTimer != nil) {
        sharedDelegate.delegateForRegister = self;
//    }
}

- (void)removeTimerDelegate
{
    AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedDelegate.delegateForRegister = nil;
}

#pragma mark - RTimerDelegate

- (void)changeRState:(int)leftSeconds
{
    AppDelegate *sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (1 == leftSeconds) {
        
        self.tryToGetNewVerifyCodeBtn.hidden = NO;
        self.timeAlertLabel.hidden = YES;
        
        self.timeAlertLabel.text = @"获取验证码";
        
        [sharedDelegate stopRTimer];
    }
    else{
//        self.tryToGetNewVerifyCodeBtn.enabled = NO;
        self.tryToGetNewVerifyCodeBtn.hidden = YES;
        self.timeAlertLabel.hidden = NO;

        NSString *titleStr = [NSString stringWithFormat:@"(%d)秒后点击",leftSeconds];
        
        self.timeAlertLabel.text = titleStr;
    }
}


- (void)getVerificationCodeForPhone:(NSString *)phoneNum
{
    __weak RVerifyCodeViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/authCode", HOST_BASE_URL];
    [manager POST:partialUrl parameters:@{@"phone":phoneNum}
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
//             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *authCodeDic = [jsonObj objectForKey:@"RS100036"];
                 
                 weakSelf.verificationCode = [NSString stringWithFormat:@"%@", [authCodeDic objectForKey:@"authcode"]];
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
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
        
        if (range.location == 4 && range.length == 0) {
            
            return NO;
        }
        
        if (textField.text.length == 0 && (range.location == 0 && range.length == 0)) {
            NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }
    }
    else if (textField.tag == 212) {
        
        NSError *error;
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"[A-Z]" options:0 error:&error];
        if (regEx && string.length > 0) {
            NSArray *matchedArray = [regEx matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, 1)];
            if (matchedArray == nil || (matchedArray && matchedArray.count == 0)) {
                return NO;
            }
        }
        
        if (range.location == 5 && range.length == 0) {
            
            return NO;
        }
    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 211) {
        ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_1"];
    }
    else if (textField.tag == 212) {
        ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_1"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_0"];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    RSetPwdViewController *viewController = (RSetPwdViewController *)segue.destinationViewController;
    viewController.phoneNum = self.phoneNum;
    viewController.invitationCode = self.invitationCodeTf.text.length == 5 ? self.invitationCodeTf.text : @"";
}


@end
