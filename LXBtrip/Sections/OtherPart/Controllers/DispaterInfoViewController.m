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
        [self initialDispatcherInfoWithDic:self.dispatcherRepeatLoginPwdTF];
    }
    else  {
        self.title = @"添加";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialDispatcherInfoWithDic:(NSDictionary *)dispatcherDic
{
    self.dispatcherNameTF.text = [dispatcherDic stringValueByKey:@""];
    self.dispatcherPhoneNumTF.text = [dispatcherDic stringValueByKey:@""];
    self.dispatcherLoginPwdTF.text = [dispatcherDic stringValueByKey:@""];
    self.dispatcherRepeatLoginPwdTF.text = [dispatcherDic stringValueByKey:@""];
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
        //TODO:create or update dispatcher info
    }
    
    return YES;
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
