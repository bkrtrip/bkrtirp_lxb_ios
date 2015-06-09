//
//  YesOrNoView.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "YesOrNoView.h"

@interface YesOrNoView()

@property (strong, nonatomic) IBOutlet UILabel *introductionLabel;
@property (strong, nonatomic) IBOutlet UILabel *confirmLabel;


@end

@implementation YesOrNoView

- (void)setYesOrNoViewWithIntroductionString:(NSString *)introString confirmString:(NSString *)confString
{
    _introductionLabel.text = introString;
    _confirmLabel.text = confString;
}

- (IBAction)noButtonClicked:(id)sender {
    
}

- (IBAction)yesButtonClicked:(id)sender {
    
}

@end
