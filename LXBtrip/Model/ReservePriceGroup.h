//
//  ReservePriceGroup.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservePriceGroup : NSObject

@property (nonatomic, copy) NSString *adultPrice;//
@property (nonatomic, copy) NSString *kidPrice;//
@property (nonatomic, copy) NSString *kidBedPrice;//
@property (nonatomic, copy) NSString *adultNum;//
@property (nonatomic, copy) NSString *kidNum;//
@property (nonatomic, copy) NSString *kidBedNum;//
@property (nonatomic, copy) NSString *diffPrice;


- (id)initWithDict:(NSDictionary *)dict;
@end
