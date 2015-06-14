//
//  AccompanyInfoView.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AccompanyInfoView.h"

@interface AccompanyInfoView()
{
    CGFloat viewHeight;
}

@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourKeywordsLabel;
@property (strong, nonatomic) IBOutlet UILabel *calPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation AccompanyInfoView

- (CGFloat)accompanyInfoViewHeightWithSupplierName:(NSString *)supplierName introduce:(NSString *)introduce price:(NSNumber *)price instructions:(NSString *)instruction
{
    viewHeight = 163.f;
    
    _providerNameLabel.text = supplierName;
    _tourKeywordsLabel.text = introduce;
    _calPriceLabel.text = [NSString stringWithFormat:@"￥%@起", price];
    _instructionsLabel.text = instruction;
    
    CGSize keywordsSize = [_tourKeywordsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8, MAXFLOAT)];
    
    CGSize instructionSize = [_instructionsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8, MAXFLOAT)];
    
    viewHeight += keywordsSize.height + instructionSize.height;
    return viewHeight;
}

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
