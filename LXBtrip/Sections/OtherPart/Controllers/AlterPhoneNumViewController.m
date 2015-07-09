//
//  AlterPhoneNumViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "AlterPhoneNumViewController.h"
#import "NSDictionary+GetStringValue.h"
#import "AppMacro.h"
#import "AFNetworking.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

//(238.0/255.0, 238.0/255.0, 238.0/255.0, 1.0)
//(68.0/255.0, 167.0/255.0, 248.0/255.0, 1.0)


@interface AlterPhoneNumViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *phoneSwitchBtn;
@property (weak, nonatomic) IBOutlet UIButton *telSwitchBtn;

@property (nonatomic, retain) NSString *phoneNum;
@property (nonatomic, retain) NSString *telNum;

@end

@implementation AlterPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self editInfoForPhoneNumber:YES];
    
    self.title = @"联系电话";
    
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存"image:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClicked:(id)sender
{
    NSDictionary *alterInfoDic = @{@"staffid":[self.userInfoDic stringValueByKey:@"staff_id"], @"companyid":[self.userInfoDic stringValueByKey:@"company_id"], @"phone":self.contactNumberTF.text};
    
    [self updateUserInfo:alterInfoDic];
}


- (void)editInfoForPhoneNumber:(BOOL)isEditPhoneNum
{
    if (isEditPhoneNum) {
        self.phoneLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:167.0/255.0 blue:248.0/255.0 alpha:1.0];
        self.phoneSwitchBtn.selected = YES;
        
        self.telLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        self.telSwitchBtn.selected = NO;
        
        self.contactNumberTF.text = [self.userInfoDic stringValueByKey:@"wd_phone"];
    }
    else {
        self.phoneLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        self.phoneSwitchBtn.selected = NO;
        
        self.telLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:167.0/255.0 blue:248.0/255.0 alpha:1.0];
        self.telSwitchBtn.selected = YES;
        
        self.contactNumberTF.text = @"";//[self.userInfoDic stringValueByKey:@""];
    }
}

- (IBAction)changeContactNumber:(id)sender {
    //tag 33-phone, 44-tel
    
    if (((UIButton *) sender).tag == 33) {
        [self editInfoForPhoneNumber:YES];
    }
    else {
        [self editInfoForPhoneNumber:NO];
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

- (void)updateUserInfo:(NSDictionary *)userDic
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    __weak AlterPhoneNumViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/setStaff", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:userDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         
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
                     }
                     
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             }
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         [weakSelf showAlertViewWithTitle:nil message:@"更新失败 ！" cancelButtonTitle:@"确定"];
         
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
