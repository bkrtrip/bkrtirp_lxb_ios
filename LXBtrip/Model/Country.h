//
//  Country.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, copy) NSNumber *countryId;//
@property (nonatomic, copy) NSString *countryName;//

@property (nonatomic, copy) NSString *countryPinYin;//
@property (nonatomic, copy) NSString *countryAcronym;//
@property (nonatomic, copy) NSString *countryInitail;//
@property (nonatomic, copy) NSNumber *countryAreaFlag;//大区标示

- (id)initWithDict:(NSDictionary *)dict;

@end
