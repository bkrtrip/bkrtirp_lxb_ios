//
//  AddDispatcherViewController.m
//  LXBtrip
//
//  Created by Sam on 6/22/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "AddDispatcherViewController.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

@interface AddDispatcherViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dispatcherNameTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherPhoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherLoginPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherRepeatLoginPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *dispatcherLoginUNTF;

@end

@implementation AddDispatcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.dispatcherLoginPwdTF. = @"";
//    self.dispatcherRepeatLoginPwdTF.text = @"";
    
    if (self.isAlterDispatcher) {
        
        self.title = @"分销商信息";
        self.dispatcherLoginUNTF.enabled = NO;
        
        [self initialDispatcherInfoWithDic:self.dispatcherInfoDic];
    }
    else {
        self.title = @"添加";

        self.dispatcherLoginUNTF.text = @"";
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
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    
    NSDictionary *dispatcherDic;
    
    if (self.isAlterDispatcher) {
        dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text, @"pwd":self.dispatcherLoginPwdTF.text, @"name":self.dispatcherLoginUNTF.text};
        
        [self updateDispatchrer:dispatcherDic];
    }
    else {
        dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text, @"pwd":self.dispatcherLoginPwdTF.text, @"name":self.dispatcherLoginUNTF.text};
        
        [self createNewDispatchrer:dispatcherDic];
    }
}

- (void)initialDispatcherInfoWithDic:(NSDictionary *)dispatcherDic
{
    self.dispatcherLoginUNTF.text = [dispatcherDic stringValueByKey:@"staff_name"];
    self.dispatcherNameTF.text = [dispatcherDic stringValueByKey:@"staff_real_name"];
    self.dispatcherPhoneNumTF.text = [dispatcherDic stringValueByKey:@"staff_partner_phonenum"];
    self.dispatcherLoginPwdTF.text = [dispatcherDic stringValueByKey:@"staff_pwd"];
    self.dispatcherRepeatLoginPwdTF.text = [dispatcherDic stringValueByKey:@"staff_pwd"];//[dispatcherDic stringValueByKey:@""];
}

- (void)updateDispatchrer:(NSDictionary *)dispatchreDic
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

    __weak AddDispatcherViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/setDistributor", HOST_BASE_URL];
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self.dispatcherInfoDic stringValueByKey:@"staff_id" ], @"staffid", [self.dispatcherInfoDic stringValueByKey:@"dat_company_id"], @"companyid", nil];// @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    [parameterDic addEntriesFromDictionary:dispatchreDic];
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
//             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100053"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     //success
                     [weakSelf sendMsgToDelegate];
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}

- (void)createNewDispatchrer:(NSDictionary *)dispatchreDic
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

    __weak AddDispatcherViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/addDistributor", HOST_BASE_URL];
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[staffDic stringValueByKey:@"staff_id" ], @"staffid", [staffDic stringValueByKey:@"dat_company_id"], @"companyid", nil];// @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    [parameterDic addEntriesFromDictionary:dispatchreDic];
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
//             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100047"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     //success
                     
                     [weakSelf sendMsgToDelegate];
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
                 else if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"40005"]) {
                     [self.dispatcherLoginUNTF becomeFirstResponder];
                     [self.dispatcherLoginUNTF setSelected:YES];
                     
                     [weakSelf showAlertViewWithTitle:nil message:@"用户名已存在。" cancelButtonTitle:@"确定"];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}


- (BOOL)isValidDispatchreInfo
{
    if (self.dispatcherLoginUNTF.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"用户名不能为空。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    if (self.dispatcherNameTF.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"姓名不能为空。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    if (self.dispatcherPhoneNumTF.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"手机号不能为空。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    if (self.dispatcherLoginPwdTF.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"密码不能为空。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    if (self.dispatcherRepeatLoginPwdTF.text.length == 0) {
        [self showAlertViewWithTitle:nil message:@"确认密码不能为空。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    if (![self.dispatcherLoginPwdTF.text isEqualToString:self.dispatcherRepeatLoginPwdTF.text]) {
        [self showAlertViewWithTitle:nil message:@"两次密码输入不一致。" cancelButtonTitle:@"确定"];
        
        return NO;
    }
    
    return YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField.tag == 213) {
        
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
    else if (textField.tag == 211) {
        
        NSError *error;
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"[0-9a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:&error];
        if (regEx && string.length > 0) {
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
    NSInteger tag = textField.tag % 100;
    tag += tag % 11 * 10;
    ((UIImageView *)[self.view viewWithTag:tag]).image = [UIImage imageNamed:@"inputLine_1"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)[self.view viewWithTag:11]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:22]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:33]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:44]).image = [UIImage imageNamed:@"inputLine_0"];
    ((UIImageView *)[self.view viewWithTag:55]).image = [UIImage imageNamed:@"inputLine_0"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 211) {
        [self.dispatcherNameTF becomeFirstResponder];
    }
    else if (textField.tag == 212)
    {
        [self.dispatcherPhoneNumTF becomeFirstResponder];
    }
    else if (textField.tag == 213)
    {
        [self.dispatcherLoginPwdTF becomeFirstResponder];
    }
    else if (textField.tag == 214)
    {
        [self.dispatcherRepeatLoginPwdTF becomeFirstResponder];
    }
    else {
        if (![self isValidDispatchreInfo]) {
            return YES;
        }
        
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        
        NSDictionary *dispatcherDic = @{@"contacts":self.dispatcherNameTF.text, @"phone":self.dispatcherPhoneNumTF.text, @"pwd":self.dispatcherLoginPwdTF.text, @"name":self.dispatcherLoginUNTF.text};
        
        [self createNewDispatchrer:dispatcherDic];    }
    
    return YES;
}

- (void)sendMsgToDelegate
{
    if (self.delegate) {
        [self.delegate finishAddOrUpdateDispater];
    }
}

@end
