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
    _tourImageView.layer.cornerRadius = 5.0f;
    _tourImageView.layer.masksToBounds = YES;
}

- (void)setCellContentWithSupplierProduct:(SupplierProduct *)product
{
    NSString *imgString = [NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg1];
    [_tourImageView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _tourTitleLabel.text = product.productTravelGoodsName;
    _tourKeywordsLabel.text = product.productIntroduce;
    _costLabel.text = [NSString stringWithFormat:@"￥%@ 起", product.productTravelPrice];
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


