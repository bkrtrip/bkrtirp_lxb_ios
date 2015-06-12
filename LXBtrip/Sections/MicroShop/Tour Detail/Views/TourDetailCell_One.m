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

- (void)setCellContentWithSupplierProduct:(SupplierProduct *)product
{
    // scroll top images
    NSMutableArray *imgURLs = [[NSMutableArray alloc] init];
    int picNum = 0;
    if (product.productTravelGoodsImg1) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg1]];
        picNum++;
    }
    if (product.productTravelGoodsImg2) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg2]];
        picNum++;
    }
    if (product.productTravelGoodsImg3) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg3]];
        picNum++;
    }
    if (product.productTravelGoodsImg4) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg4]];
        picNum++;
    }
    if (product.productTravelGoodsImg5) {
        [imgURLs addObject:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg5]];
        picNum++;
    }
    
    if (picNum > 1) {
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
    
    _tourIDLabel.text = [NSString stringWithFormat:@"产品ID: %@", product.productTravelGoodsId];
    _tourNameLabel.text = product.productTravelGoodsName;
    _tourDescriptionLabel.text = product.productIntroduce;
//    _adultPriceLabel.text = [NSString stringWithFormat:@"￥%@", product.]
}


@end
