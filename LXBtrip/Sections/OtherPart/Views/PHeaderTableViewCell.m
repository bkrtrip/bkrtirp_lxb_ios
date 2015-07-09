//
//  PHeaderTableViewCell.m
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PHeaderTableViewCell.h"
#import "NSDictionary+GetStringValue.h"
#import "AppMacro.h"

@interface PHeaderTableViewCell ()

//用户登录后的显示信息
@property (weak, nonatomic) IBOutlet UIView *signSuccView;

@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImgView;
@property (weak, nonatomic) IBOutlet UILabel *userInfoNotSetAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;


//要求用户进行登录/注册流程
@property (weak, nonatomic) IBOutlet UIView *notSigninView;

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
    // when shopname and shop contacter name are not set, show tint label
    if (userInfoDic) {
        NSString *staffRealName = [userInfoDic stringValueByKey:STAFF_REAL_NAME];
        NSString *shopName = [userInfoDic stringValueByKey:MICRO_SHOP_NAME];
        
        if (staffRealName.length == 0 && shopName.length == 0) {
            self.userInfoNotSetAlertLabel.hidden = NO;
            self.contactNameLabel.hidden = YES;
            self.shopNameLabel.hidden = YES;
        }
        else {
            self.userInfoNotSetAlertLabel.hidden = YES;
            self.contactNameLabel.hidden = NO;
            self.shopNameLabel.hidden = NO;
            
            self.contactNameLabel.text = staffRealName;
            self.shopNameLabel.text = shopName;

        }
        
        NSString *photoURL = [userInfoDic stringValueByKey:PHOTO_URL];
        if (photoURL.length > 0) {
            NSURL *pUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL,photoURL]];
            
            [self.userPhotoImgView sd_setImageWithURL:pUrl placeholderImage:[UIImage imageNamed:@"defaultIcon.jpg"]];
        }
        else {
            self.userPhotoImgView.image = [UIImage imageNamed:@"defaultIcon.jpg"];
        }
    }
    else {
        self.userInfoNotSetAlertLabel.hidden = NO;
        self.contactNameLabel.hidden = YES;
        self.shopNameLabel.hidden = YES;
    }
}

- (void)needUserToSignin:(BOOL)isRequired
{
    if (isRequired) {
        self.notSigninView.hidden = NO;
        self.signSuccView.hidden = YES;
    }
    else {
        self.notSigninView.hidden = YES;
        self.signSuccView.hidden = NO;
    }
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
