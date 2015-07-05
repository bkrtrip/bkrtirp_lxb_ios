//
//  DispaterInfoViewController.m
//  LXBtrip
//
//  Created by Sam on 6/14/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "DispaterInfoViewController.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

@interface DispaterInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dispatcherNameTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherPhoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherLoginPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherRepeatLoginPwdTF;


@end

@implementation DispaterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isUpdateDispatcher) {
        self.title = @"分销商信息";
        self.dispatcherNameTF.enabled = NO;

        [self initialDispatcherInfoWithDic:self.dispatcherDic];
    }
    else  {
        self.title = @"添加";
        
        self.dispatcherNameTF.text = @"";
        self.dispatcherPhoneNumTF.text = @"";
        self.dispatcherLoginPwdTF.text = @"";
        self.dispatcherRepeatLoginPwdTF.text = @"";
    }
    
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"完成" image:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClicked:(id)sender
{
    if (![self isValidDispatchreInfo]) {
        return;
    }
    
    
    if (self.isUpdateDispatcher) {
        NSDictionary *dispatcherDic;
        if (self.dispatcherLoginPwdTF.text.length > 0) {
            dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text, @"pwd":self.dispatcherLoginPwdTF.text};
        }
        else {
            dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text};
        }
        
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

        [self updateDispatchrer:dispatcherDic];
    }
    
}

- (void)initialDispatcherInfoWithDic:(NSDictionary *)dispatcherDic
{
    self.dispatcherNameTF.text = [dispatcherDic stringValueByKey:@"staff_real_name"];
    self.dispatcherPhoneNumTF.text = [dispatcherDic stringValueByKey:@"staff_partner_phonenum"];
    self.dispatcherLoginPwdTF.text = @"";
    self.dispatcherRepeatLoginPwdTF.text = @"";//[dispatcherDic stringValueByKey:@""];
}

- (BOOL)isValidDispatchreInfo
{
    if ((self.dispatcherLoginPwdTF.text.length > 0 || self.dispatcherRepeatLoginPwdTF.text.length > 0) && (![self.dispatcherLoginPwdTF.text isEqualToString:self.dispatcherRepeatLoginPwdTF.text])) {
        [self showAlertViewWithTitle:nil message:@"两次密码输入不一致。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    
    if (self.dispatcherNameTF.text == 0 || self.dispatcherPhoneNumTF.text == 0 || self.dispatcherLoginPwdTF.text == 0) {
        [self showAlertViewWithTitle:nil message:@"所有信息为必填项，您有还有信息未填写。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField.tag == 212) {
        
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
    else if (textField.tag == 212)
    {
        ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_1"];
    }
    else if (textField.tag == 213)
    {
        ((UIImageView *)[self.view viewWithTag:33]).image = [UIImage imageNamed:@"inputLine_1"];
    }
    else if (textField.tag == 214)
    {
        ((UIImageView *)[self.view viewWithTag:44]).image = [UIImage imageNamed:@"inputLine_1"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:33]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:44]).image = [UIImage imageNamed:@"inputLine_0"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 211) {
        [self.dispatcherPhoneNumTF becomeFirstResponder];
    }
    else if (textField.tag == 212)
    {
        [self.dispatcherLoginPwdTF becomeFirstResponder];
    }
    else if (textField.tag == 213)
    {
        [self.dispatcherRepeatLoginPwdTF becomeFirstResponder];
    }
    else if (textField.tag == 214)
    {
        if (![self isValidDispatchreInfo]) {
            return YES;
        }
        
        NSDictionary *dispatcherDic;
        if (self.dispatcherLoginPwdTF.text.length > 0) {
            dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text, @"pwd":self.dispatcherLoginPwdTF.text};
        }
        else {
            dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text};
        }

        [self updateDispatchrer:dispatcherDic];
    }
    
    return YES;
}




- (void)updateDispatchrer:(NSDictionary *)dispatchreDic
{
    __weak DispaterInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/setDistributor", HOST_BASE_URL];
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[staffDic stringValueByKey:@"staff_id" ], @"staffid", [staffDic stringValueByKey:@"dat_company_id"], @"companyid", nil];// @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    [parameterDic addEntriesFromDictionary:dispatchreDic];
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100053"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     //success
                     
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
