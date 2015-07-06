//
//  TourDetailCell_One.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_One.h"
#import "MarketPriceLabel.h"

@interface TourDetailCell_One()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *walkTypeImageView;
@property (strong, nonatomic) IBOutlet UILabel *tourApplyTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *tourTravelGoodsCodePriLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourDescriptionLabel;

@property (strong, nonatomic) MarketPriceLabel *adultPriceLabel;
@property (strong, nonatomic) MarketPriceLabel *kidWithBedPriceLabel;
@property (strong, nonatomic) MarketPriceLabel *kidNoBedPriceLabel;


@end

@implementation TourDetailCell_One

- (void)awakeFromNib {
    if (!_adultPriceLabel) {
        _adultPriceLabel = [[NSBundle mainBundle] loadNibNamed:@"MarketPriceLabel" owner:nil options:nil][0];
        [self.contentView addSubview:_adultPriceLabel];
    }
    if (!_kidNoBedPriceLabel) {
        _kidNoBedPriceLabel = [[NSBundle mainBundle] loadNibNamed:@"MarketPriceLabel" owner:nil options:nil][0];
        [self.contentView addSubview:_kidNoBedPriceLabel];
    }
    if (!_kidWithBedPriceLabel) {
        _kidWithBedPriceLabel = [[NSBundle mainBundle] loadNibNamed:@"MarketPriceLabel" owner:nil options:nil][0];
        [self.contentView addSubview:_kidWithBedPriceLabel];
    }
    _adultPriceLabel.hidden = YES;
    _kidNoBedPriceLabel.hidden = YES;
    _kidWithBedPriceLabel.hidden = YES;
}

- (CGFloat)cellHeightWithSupplierProduct:(SupplierProduct *)product startDate:(NSString *)dateString
{
    CGFloat cellHeight = 254.f;
    // scroll top images
    _scrollView.pagingEnabled = YES;
    NSMutableArray *imgURLs = [[NSMutableArray alloc] init];
    int picNum = 0;
    if (product.productTravelGoodsImg1 && product.productTravelGoodsImg1.length>0) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg1]];
        picNum++;
    }
    if (product.productTravelGoodsImg2 && product.productTravelGoodsImg2.length>0) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg2]];
        picNum++;
    }
    if (product.productTravelGoodsImg3 && product.productTravelGoodsImg3.length>0) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg3]];
        picNum++;
    }
    if (product.productTravelGoodsImg4 && product.productTravelGoodsImg4.length>0) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg4]];
        picNum++;
    }
    if (product.productTravelGoodsImg5 && product.productTravelGoodsImg5.length>0) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg5]];
        picNum++;
    }
    
    if (picNum > 0) {
        [_scrollView setContentSize:CGSizeMake(picNum*SCREEN_WIDTH, _scrollView.frame.size.height)];
        for (int i = 0; i < picNum; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgURLs[i]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            [_scrollView addSubview:imgView];
        }
    }
    
    // walk type image
    WalkType walk = [product.productWalkType intValue];
    switch (walk) {
        case Follow_Group:
            _walkTypeImageView.image = ImageNamed(@"follow_group");
            break;
        case Half_Free:
            _walkTypeImageView.image = ImageNamed(@"half_free");
            break;
        case Free_Run:
            _walkTypeImageView.image = ImageNamed(@"free_run");
            break;
        default:
            _walkTypeImageView.image = nil;
            break;
    }
    
    if (product.productTravelGoodsCodePri && product.productTravelGoodsCodePri.length > 0) {
        _tourTravelGoodsCodePriLabel.hidden = NO;
        _tourTravelGoodsCodePriLabel.text = [NSString stringWithFormat:@"产品编码: %@", product.productTravelGoodsCodePri];
    }
    else {
        _tourTravelGoodsCodePriLabel.hidden = YES;
    }
    
    _tourNameLabel.text = product.productTravelGoodsName;
    _tourDescriptionLabel.text = product.productIntroduce;
    if (product.productTravelApplyTime && [product.productTravelApplyTime integerValue] > 0) {
        _tourApplyTimeLabel.text = [NSString stringWithFormat:@"请提前%@天预订", product.productTravelApplyTime];
        _tourApplyTimeLabel.hidden = NO;
    } else {
        _tourApplyTimeLabel.hidden = YES;
    }
    
    CGSize nameLabeSize = [_tourNameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    CGSize descriptionLabelSize = [_tourDescriptionLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    
    cellHeight += nameLabeSize.height + descriptionLabelSize.height;
    
    if (product.productMarketTicketGroup.count > 0) {
        if (dateString) {
            NSMutableArray *temp = product.productMarketTicketGroup;
            [temp enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
                if ([grp.marketTime isEqualToString:dateString]) {
                    
                    CGFloat yOrigin = _tourDescriptionLabel.frame.origin.y + descriptionLabelSize.height + 10.f;
                    CGFloat labelWidth = SCREEN_WIDTH/3.0;
                    NSInteger priceNum = 0;
                    if (grp.marketAdultPrice && [grp.marketAdultPrice integerValue] > 0) {
                        [_adultPriceLabel setFrame:CGRectMake(priceNum*labelWidth, yOrigin, labelWidth, 28.f)];
                        [_adultPriceLabel setMarketPriceLabelWithPriceType:Adult price:grp.marketAdultPrice];
                        _adultPriceLabel.hidden = NO;
                        priceNum ++;
                    }
                    
                    if (grp.marketKidPrice && [grp.marketKidPrice integerValue] > 0) {
                        [_kidWithBedPriceLabel setFrame:CGRectMake(priceNum*labelWidth, yOrigin, labelWidth, 28.f)];
                        [_kidWithBedPriceLabel setMarketPriceLabelWithPriceType:Kid_Bed price:grp.marketKidPrice];
                        _kidWithBedPriceLabel.hidden = NO;
                        priceNum ++;
                    }
                    
                    if (grp.marketKidPriceNoBed && [grp.marketKidPriceNoBed integerValue] > 0) {
                        [_kidNoBedPriceLabel setFrame:CGRectMake(priceNum*labelWidth, yOrigin, labelWidth, 28.f)];
                        [_kidNoBedPriceLabel setMarketPriceLabelWithPriceType:Kid_No_Bed price:grp.marketKidPriceNoBed];
                        _kidNoBedPriceLabel.hidden = NO;
                        priceNum ++;
                    }
                }
            }];
        }
    }
    return cellHeight;
}


@end
