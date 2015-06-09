//
//  SupplierProduct.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketTicketGroup.h"
#import "TravelTicketGroup.h"

@interface SupplierProduct : NSObject

@property (nonatomic, copy) NSString *productLineClass;// LINE_CLASS "#1#283"
@property (nonatomic, copy) NSString *productCompanyName;//

@property (nonatomic, copy) NSString *productDetailURL;//
@property (nonatomic, copy) NSString *productIntroduceURL;//
@property (nonatomic, copy) NSString *productShareURL;//
@property (nonatomic, copy) NSString *productPreviewURL;//


@property (nonatomic, copy) NSString *productIntroduce;//
@property (nonatomic, copy) NSNumber *productIsTourServices;//

@property (nonatomic, copy) NSNumber *productMarketPrice;//
@property (nonatomic, copy) NSMutableArray *productMarketTicketGroup;

@property (nonatomic, copy) NSNumber *productPeerNotice;//
@property (nonatomic, copy) NSNumber *productTravelApplyTime;//
@property (nonatomic, copy) NSString *productTravelGoodsCode;//
@property (nonatomic, copy) NSNumber *productTravelGoodsCompanyId;//
@property (nonatomic, copy) NSString *productTravelGoodsImg1;//
@property (nonatomic, copy) NSString *productTravelGoodsImg2;//
@property (nonatomic, copy) NSString *productTravelGoodsImg3;//
@property (nonatomic, copy) NSString *productTravelGoodsImg4;//
@property (nonatomic, copy) NSString *productTravelGoodsImg5;//

@property (nonatomic, copy) NSString *productTravelGoodsName;//
@property (nonatomic, copy) NSNumber *productTravelGoodsUpdateTime;//
@property (nonatomic, copy) NSNumber *productTravelJourneyDays;//
@property (nonatomic, copy) NSNumber *productTravelPrice;//

@property (nonatomic, copy) NSMutableArray *productTravelTicketGroup;

@property (nonatomic, copy) NSNumber *productWalkType;//
//walk_type
@property (nonatomic, copy) NSString *productCompanyContactPhone;




//[{"market_adult_price":"2222","market_adult_person":"0","market_kid_price":"0","market_kid_person":"0","market_diff_price":"0","market_time":"2015-5-8"}]

- (id)initWithDict:(NSDictionary *)dict;

@end
