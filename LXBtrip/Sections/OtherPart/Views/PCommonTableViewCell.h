//
//  PCommonTableViewCell.h
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Message,
    Alipay,
    Dispatch,
    Help,
    About,
    SignOut,
    Invitation
} SettingsType;

@interface PCommonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *settingIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *settingTitleLabel;

- (void)initailCellWithType:(SettingsType)type;
@end
