//
//  TourDetailCell_Two.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Two.h"


const CGFloat bedImageWidth = 11.f;
const CGFloat bedImageHeight = 11.f;
const CGFloat adultMarketWidth = 78.f;
const CGFloat adultMarketHeight = 16.f;
const CGFloat yOrigin = 64.f;

@interface TourDetailCell_Two()
@property (strong, nonatomic) IBOutlet UILabel *providerMarketLabel; //自定义的与之对齐
@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;

@property (strong, nonatomic) UILabel *adultMarketLabel;
@property (strong, nonatomic) UILabel *kidWithBedMarketLabel;
@property (strong, nonatomic) UILabel *kidNoBedMarketLabel;
@property (strong, nonatomic) UIImageView *bedImageView;

@property (strong, nonatomic) UILabel *adultPriceLabel;
@property (strong, nonatomic) UILabel *childPerBedPriceLabel;
@property (strong, nonatomic) UILabel *childPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation TourDetailCell_Two

- (void)awakeFromNib {
    // Initialization code
    // Title
    if (!_adultMarketLabel) {
        _adultMarketLabel = [[UILabel alloc] init];
        _adultMarketLabel.font = [UIFont boldSystemFontOfSize:13.f];
        _adultMarketLabel.textColor = TEXT_333333;
        _adultMarketLabel.text = @"成人结算价:";
        [self.contentView addSubview:_adultMarketLabel];
    }
    if (!_kidNoBedMarketLabel) {
        _kidNoBedMarketLabel = [[UILabel alloc] init];
        _kidNoBedMarketLabel.font = [UIFont boldSystemFontOfSize:13.f];
        _kidNoBedMarketLabel.textColor = TEXT_333333;
        _kidNoBedMarketLabel.text = @"儿童结算价:";
        [self.contentView addSubview:_kidNoBedMarketLabel];
    }
    if (!_kidWithBedMarketLabel) {
        _kidWithBedMarketLabel = [[UILabel alloc] init];
        _kidWithBedMarketLabel.font = [UIFont boldSystemFontOfSize:13.f];
        _kidWithBedMarketLabel.textColor = TEXT_333333;
        _kidWithBedMarketLabel.text = @"儿童结算价:";
        [self.contentView addSubview:_kidWithBedMarketLabel];
    }
    
    // Price
    if (!_adultPriceLabel) {
        _adultPriceLabel = [[UILabel alloc] init];
        _adultPriceLabel.font = [UIFont systemFontOfSize:13.f];
        _adultPriceLabel.textColor = RED_FF0075;
        [self.contentView addSubview:_adultPriceLabel];
    }
    if (!_childPerBedPriceLabel) {
        _childPerBedPriceLabel = [[UILabel alloc] init];
        _childPerBedPriceLabel.font = [UIFont systemFontOfSize:13.f];
        _childPerBedPriceLabel.textColor = RED_FF0075;
        [self.contentView addSubview:_childPerBedPriceLabel];
    }
    if (!_childPriceLabel) {
        _childPriceLabel = [[UILabel alloc] init];
        _childPriceLabel.font = [UIFont systemFontOfSize:13.f];
        _childPriceLabel.textColor = RED_FF0075;
        [self.contentView addSubview:_childPriceLabel];
    }
    
    // specail bed imageView
    if (!_bedImageView) {
        _bedImageView = [[UIImageView alloc] initWithImage:ImageNamed(@"bed_red")];
        [self.contentView addSubview:_bedImageView];
    }
    
    _adultMarketLabel.hidden = YES;
    _kidWithBedMarketLabel.hidden = YES;
    _kidNoBedMarketLabel.hidden = YES;
    
    _adultPriceLabel.hidden = YES;
    _childPerBedPriceLabel.hidden = YES;
    _childPriceLabel.hidden = YES;
    
    _bedImageView.hidden = YES;
}

- (CGFloat)cellHeightWithSupplierProduct:(SupplierProduct *)product startDate:(NSString *)dateString
{
    __block CGFloat cellHeight = 92.f;
    
    _providerNameLabel.text = product.productCompanyName;
    _instructionsLabel.text = product.productPeerNotice;
    
    _instructionsLabel.text = [_instructionsLabel.text stringByAppendingString:@"\r \r联系我时，请说是在旅小宝看到的，谢谢！"];
    
    CGSize instructionsLabelSize = [_instructionsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    
    cellHeight += instructionsLabelSize.height;
    
    __block NSInteger priceNum = 0;

    if (product.productTravelTicketGroup.count > 0) {
        if (dateString) {
            NSMutableArray *temp = product.productTravelTicketGroup;
            [temp enumerateObjectsUsingBlock:^(TravelTicketGroup *grp, NSUInteger idx, BOOL *stop) {
                if ([grp.travelTime isEqualToString:dateString]) {
                    
                    CGFloat xOrigin = _providerMarketLabel.frame.origin.x;

                    if (grp.travelAdultPrice && [grp.travelAdultPrice integerValue] > 0) {
                        [_adultMarketLabel setFrame:CGRectMake(xOrigin, yOrigin, adultMarketWidth, adultMarketHeight)];
                        _adultMarketLabel.hidden = NO;
                        
                        [_adultPriceLabel setFrame:CGRectOffset(_adultMarketLabel.frame, adultMarketWidth, 0)];
                        _adultPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.travelAdultPrice];
                        _adultPriceLabel.hidden = NO;

                        priceNum ++;
                        cellHeight += 24.f;
                    }
                    
                    if (grp.travelKidPrice && [grp.travelKidPrice integerValue] > 0) {
                        [_kidWithBedMarketLabel setFrame:CGRectMake(xOrigin, yOrigin + priceNum*(adultMarketHeight + 8.f), adultMarketWidth, adultMarketHeight)];
                        _kidWithBedMarketLabel.hidden = NO;
                        
                        [_childPerBedPriceLabel setFrame:CGRectOffset(_kidWithBedMarketLabel.frame, adultMarketWidth, 0)];
                        _childPerBedPriceLabel.text = [NSString stringWithFormat:@"￥%@/", grp.travelKidPrice];
                        _childPerBedPriceLabel.hidden = NO;
                        [_childPerBedPriceLabel sizeToFit];
                        
                        [_bedImageView setFrame:CGRectMake(_childPerBedPriceLabel.frame.origin.x + _childPerBedPriceLabel.frame.size.width, _childPerBedPriceLabel.frame.origin.y+2, bedImageWidth, bedImageHeight)];
                        _bedImageView.hidden = NO;
                        
                        priceNum ++;
                        cellHeight += 24.f;
                    }
                    
                    if (grp.travelKidPriceNoBed && [grp.travelKidPriceNoBed integerValue] > 0) {
                        CGFloat actualXOrigin;
                        CGFloat actualYOrigin;
                        if (priceNum == 2) {
                            actualXOrigin = SCREEN_WIDTH/2.0 + 5.f;
                            actualYOrigin = yOrigin + adultMarketHeight + 8.f;
                        } else if (priceNum == 1) {
                            actualXOrigin = xOrigin;
                            actualYOrigin = yOrigin + adultMarketHeight + 8.f;
                            cellHeight += 24.f;
                        } else {
                            actualXOrigin = xOrigin;
                            actualYOrigin = yOrigin;
                            cellHeight += 24.f;
                        }
                        
                        [_kidNoBedMarketLabel setFrame:CGRectMake(actualXOrigin, actualYOrigin, adultMarketWidth, adultMarketHeight)];
                        _kidNoBedMarketLabel.hidden = NO;
                        
                        [_childPriceLabel setFrame:CGRectOffset(_kidNoBedMarketLabel.frame, adultMarketWidth, 0)];
                        _childPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.travelKidPriceNoBed];
                        _childPriceLabel.hidden = NO;
                    }
                }
            }];
        }
    }
    if (priceNum > 0) {
        cellHeight += 8.f;//有price，要加距离“同行须知”的8.f的距离
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
