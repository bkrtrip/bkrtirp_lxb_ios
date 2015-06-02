//
//  TravelTicketGroup.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelTicketGroup : NSObject

@property (nonatomic, copy) NSNumber *travelAdultPrice;//
@property (nonatomic, copy) NSNumber *travelAdultPerson;//

@property (nonatomic, copy) NSNumber *travelKidPrice;//
@property (nonatomic, copy) NSNumber *travelKidPriceNoBed;//
@property (nonatomic, copy) NSNumber *travelKidPersonNoBed;//

@property (nonatomic, copy) NSNumber *travelKidPerson;//

@property (nonatomic, copy) NSNumber *travelDiffPrice;//
@property (nonatomic, copy) NSString *travelTime;//

// {\"travel_adult_price\":\"2,020\",\"travel_adult_person\":\"50\",\"travel_kid_price\":\"0\",\"travel_kid_person\":\"0\",\"travel_diff_price\":\"0\",\"travel_time\":\"2015-5-20\",\"travel_kid_price_nbed\":\"0\",\"travel_kid_person_nbed\":\"0\"}

- (id)initWithDict:(NSDictionary *)dict;

@end
