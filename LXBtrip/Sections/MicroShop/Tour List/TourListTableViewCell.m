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
{
    SupplierProduct *supplierProduct;
}

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
    supplierProduct = product;
    
    NSString *imgString = [NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, product.productTravelGoodsImg1];
    [_tourImageView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _tourTitleLabel.text = [NSString stringWithFormat:@"【%@出发】%@", product.productTravelStartCity ,product.productTravelGoodsName];
//    _tourKeywordsLabel.text = product.productIntroduce;
    _tourKeywordsLabel.text = @"";

    _costLabel.text = [NSString stringWithFormat:@"￥%@ 起", product.productMarketPrice];
}

- (IBAction)accompanyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithAccompanyInfoWithProduct:)]) {
        [self.delegate supportClickWithAccompanyInfoWithProduct:supplierProduct];
    }
}
- (IBAction)previewButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPreviewButtonWithProduct:)]) {
        [self.delegate supportClickWithPreviewButtonWithProduct:supplierProduct];
    }
}
- (IBAction)shareButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithShareButtonWithProduct:)]) {
        [self.delegate supportClickWithShareButtonWithProduct:supplierProduct];
    }
}

@end


