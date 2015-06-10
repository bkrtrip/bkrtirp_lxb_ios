//
//  AlterPhoneNumViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "AlterPhoneNumViewController.h"

//(238.0/255.0, 238.0/255.0, 238.0/255.0, 1.0)
//(68.0/255.0, 167.0/255.0, 248.0/255.0, 1.0)


@interface AlterPhoneNumViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *phoneSwitchBtn;
@property (weak, nonatomic) IBOutlet UIButton *telSwitchBtn;

@end

@implementation AlterPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:167.0/255.0 blue:248.0/255.0 alpha:1.0];
    self.phoneSwitchBtn.selected = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeContactNumber:(id)sender {
    //tag 33-phone, 44-tel
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
