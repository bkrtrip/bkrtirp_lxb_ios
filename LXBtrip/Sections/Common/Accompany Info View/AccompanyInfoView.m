//
//  AccompanyInfoView.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AccompanyInfoView.h"

@interface AccompanyInfoView()

@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourKeywordsLabel;
@property (strong, nonatomic) IBOutlet UILabel *calPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation AccompanyInfoView

- (IBAction)sendMessageButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithShortMessage)]) {
        [self.delegate supportClickWithShortMessage];
    }
}

- (IBAction)makePhoneCallButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall)]) {
        [self.delegate supportClickWithPhoneCall];
    }
}

- (IBAction)moreInstructionsButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithMoreInstructions)]) {
        [self.delegate supportClickWithMoreInstructions];
    }
}







@end
