//
//  MarketTicketGroup.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketTicketGroup : NSObject

@property (nonatomic, copy) NSString *marketAdultPrice;//成人价
@property (nonatomic, copy) NSNumber *marketAdultPerson;//成人人数

@property (nonatomic, copy) NSString *marketKidPrice;//儿童占床价
@property (nonatomic, copy) NSString *marketKidPriceNoBed;//儿童不占床价
@property (nonatomic, copy) NSNumber *marketKidPerson;//儿童人数

@property (nonatomic, copy) NSString *marketDiffPrice;//单房差
@property (nonatomic, copy) NSString *marketTime;//团期 2015-5-8

//[{"market_adult_price":"2222","market_adult_person":"0","market_kid_price":"0","market_kid_person":"0","market_diff_price":"0","market_time":"2015-5-8"}]

- (id)initWithDict:(NSDictionary *)dict;


@end
