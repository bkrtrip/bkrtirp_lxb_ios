//
//  OrderDetailCell_TouristsInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailCell_TouristsInfo.h"

@interface OrderDetailCell_TouristsInfo()

@property (strong, nonatomic) IBOutlet UILabel *touristNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *touristCertificateNoLabel;

@end

@implementation OrderDetailCell_TouristsInfo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithTouristInfo:(TouristInfo *)tourist
{
    _touristNameLabel.text = tourist.touristName;
    _touristCertificateNoLabel.text = tourist.touristCode;
}


@end
