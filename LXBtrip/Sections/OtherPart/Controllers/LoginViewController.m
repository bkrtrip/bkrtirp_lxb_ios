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

#import "PersonalCenterViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>

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

#pragma mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}
-(void)isActionLogin
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
//    NSDictionary *parameters=@{@"name":self.phoneNumberText.text,@"pwd":self.passwordText.text};
    NSDictionary *parameters=@{@"name":@"18602929807",@"pwd":@"654321"};

    NSString *partialUrl = [NSString stringWithFormat:@"%@common/login", HOST_BASE_URL];
    [manager POST:partialUrl parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [self jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                 [UserModel storeUserInformations:jsonObj];
                 
                 
                 //TODO: 跳转到主tab页面(xiaozhu)
                 
                 UIViewController *viewController = [[PersonalCenterViewController alloc] initWithNibName:@"PersonalCenterViewController" bundle:nil];
                 [self.navigationController pushViewController:viewController animated:YES];
                 
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}


-(IBAction)login:(id)sender
{
    if (![self.phoneNumberText.text isEqualToString:@""]&&![self.passwordText.text isEqualToString:@""])
    {
        [self isActionLogin];
    }else
    {
        [self showAlertViewWithTitle:@"提示" message:@"手机号与密码必填项。" cancelButtonTitle:@"确定"];
    }
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
