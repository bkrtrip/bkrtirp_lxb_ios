//
//  TourDetailCell_One.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_One.h"

@interface TourDetailCell_One()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *walkTypeImageView;

@property (strong, nonatomic) IBOutlet UILabel *tourIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *kidWithBedPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *kidNoBedPriceLabel;


@end

@implementation TourDetailCell_One

- (void)awakeFromNib {
    // Initialization code
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
    
    if (product.productTravelGoodsId && [product.productTravelGoodsId integerValue] > 0) {
        _tourIDLabel.hidden = NO;
        _tourIDLabel.text = [NSString stringWithFormat:@"产品编码字段信息: %@", product.productTravelGoodsId];
    } else {
        _tourIDLabel.hidden = YES;
    }
    
    _tourNameLabel.text = product.productTravelGoodsName;
    _tourDescriptionLabel.text = product.productIntroduce;
    
    CGSize nameLabeSize = [_tourNameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    CGSize descriptionLabelSize = [_tourDescriptionLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8.f, MAXFLOAT)];
    
    cellHeight += nameLabeSize.height + descriptionLabelSize.height;
    
    if (product.productMarketTicketGroup.count > 0) {
        if (dateString) {
            NSMutableArray *temp = product.productMarketTicketGroup;
            [temp enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
                if ([grp.marketTime isEqualToString:dateString]) {
                    _adultPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.marketAdultPrice];
                    _kidWithBedPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.marketKidPrice];
                    _kidNoBedPriceLabel.text = [NSString stringWithFormat:@"￥%@", grp.marketKidPriceNoBed];
                }
            }];
        }
    }
    return cellHeight;
}


@end
