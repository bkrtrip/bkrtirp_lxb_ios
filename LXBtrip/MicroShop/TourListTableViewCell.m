//
//  TourListTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListTableViewCell.h"
#import "AppMacro.h"
@interface TourListTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *tourImageView;
@property (strong, nonatomic) IBOutlet UILabel *tourTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourKeywordsLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@end


@implementation TourListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSupplierProduct:(SupplierProduct *)product
{
    NSString *imgString = [NSString stringWithFormat:@"%@_360*360", product.productTravelGoodsImg1];
    [_tourImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, imgString]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _tourTitleLabel.text = product.productTravelGoodsName;
    _tourKeywordsLabel.text = product.productIntroduce;
    _costLabel.text = [product.productTravelPrice stringValue];
}

- (IBAction)accompanyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithAccompanyButton)]) {
        [self.delegate supportClickWithAccompanyButton];
    }
}
- (IBAction)previewButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPreviewButton)]) {
        [self.delegate supportClickWithPreviewButton];
    }
}
- (IBAction)shareButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithShareButton)]) {
        [self.delegate supportClickWithShareButton];
    }
}

@end
