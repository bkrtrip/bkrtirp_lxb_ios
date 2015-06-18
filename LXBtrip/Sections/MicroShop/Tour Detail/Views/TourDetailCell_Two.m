//
//  TourDetailCell_Two.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Two.h"

@interface TourDetailCell_Two()

@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPerBedPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation TourDetailCell_Two

- (void)awakeFromNib {
    // Initialization code
}

- (CGFloat)cellHeightWithSupplierProduct:(SupplierProduct *)product startDate:(NSString *)dateString
{
    CGFloat cellHeight = 150.f;
    
    _providerNameLabel.text = product.productCompanyName;
    _instructionsLabel.text = product.productPeerNotice;
    
    CGSize instructionsLabelSize = [_instructionsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    
    cellHeight += instructionsLabelSize.height;
    
    if (product.productTravelTicketGroup.count > 0) {
        if (dateString) {
            NSMutableArray *temp = product.productTravelTicketGroup;
            [temp enumerateObjectsUsingBlock:^(TravelTicketGroup *grp, NSUInteger idx, BOOL *stop) {
                if ([grp.travelTime isEqualToString:dateString]) {
                    _adultPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.travelAdultPrice];
                    _childPerBedPriceLabel.text = [NSString stringWithFormat:@"￥%@/", grp.travelKidPrice];
                    _childPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.travelKidPriceNoBed];
                }
            }];
        }
    }
    return cellHeight;
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
