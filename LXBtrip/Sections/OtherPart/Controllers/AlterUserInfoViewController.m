//
//  AlterUserInfoViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "AlterUserInfoViewController.h"

@interface AlterUserInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *infoTF;
@property (weak, nonatomic) IBOutlet UILabel *alterHintLabel;

@end

@implementation AlterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initailAlterType:(AlterInfoTypes)type forInfomation:(NSString *)info
{
    self.infoTF.text = info;
    
    switch (type) {
        case ShopContactName:
            self.alterHintLabel.text = @"请输入业务咨询联系人的真实姓名 !";
            break;
        case ShopName:
            self.alterHintLabel.text = @"请输入企业名称或门市名称（此名称在微店头部展示）";
            break;
        case DetailAdress:
            self.alterHintLabel.text = @"请正确填写旅行社的详细地址，如“碑林区太乙路十字向东” !";
            break;

            
        default:
            break;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
