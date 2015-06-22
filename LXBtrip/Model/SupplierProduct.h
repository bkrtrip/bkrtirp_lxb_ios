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
@property (nonatomic, copy) NSString *productIsTourServices;//

@property (nonatomic, copy) NSNumber *productMarketPrice;//
@property (nonatomic, copy) NSMutableArray *productMarketTicketGroup;

@property (nonatomic, copy) NSString *productPeerNotice;//
@property (nonatomic, copy) NSNumber *productTravelApplyTime;//
@property (nonatomic, copy) NSString *productTravelGoodsCode;//
@property (nonatomic, copy) NSNumber *productTravelGoodsId;//
@property (nonatomic, copy) NSNumber *productTravelGoodsCompanyId;//
@property (nonatomic, copy) NSString *productTravelGoodsImg1;//
@property (nonatomic, copy) NSString *productTravelGoodsImg2;//
@property (nonatomic, copy) NSString *productTravelGoodsImg3;//
@property (nonatomic, copy) NSString *productTravelGoodsImg4;//
@property (nonatomic, copy) NSString *productTravelGoodsImg5;//

@property (nonatomic, copy) NSString *productTravelGoodsName;//
@property (nonatomic, copy) NSNumber *productTravelGoodsUpdateTime;//
@property (nonatomic, copy) NSString *productTravelJourneyDays;//
@property (nonatomic, copy) NSNumber *productTravelPrice;//

@property (nonatomic, copy) NSMutableArray *productTravelTicketGroup;

@property (nonatomic, copy) NSString *productWalkType;//
//walk_type
@property (nonatomic, copy) NSString *productCompanyContactPhone;


- (id)initWithDict:(NSDictionary *)dict;

@end
