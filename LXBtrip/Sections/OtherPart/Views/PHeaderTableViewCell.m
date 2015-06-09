//
//  PHeaderTableViewCell.m
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PHeaderTableViewCell.h"

@interface PHeaderTableViewCell ()

//用户登录后的显示信息
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImgView;
@property (weak, nonatomic) IBOutlet UILabel *userInfoNotSetAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@end

@implementation PHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userPhotoImgView.layer.cornerRadius = self.userPhotoImgView.bounds.size.width/2;
    self.userPhotoImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initialHeaderViewWithUserInfo:(NSDictionary *)userInfoDic
{
    
}



- (IBAction)registerUser:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToRegister];
    }
}
- (IBAction)loginToSystem:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToLogin];
    }
}


- (IBAction)goToMySuppliers:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToSuppliers];
    }
}
- (IBAction)goToMyOrders:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToOrders];
    }
}
- (IBAction)goToMyDipatchers:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToDispatchers];
    }
}

- (IBAction)setUserInfomation:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:GoToInfoSettings];
    }
}



@end
