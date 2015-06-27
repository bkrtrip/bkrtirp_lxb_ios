//
//  City.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *cityName;//
@property (nonatomic, copy) NSString *cityPinYin;//
@property (nonatomic, copy) NSString *cityAcronym;//
@property (nonatomic, copy) NSString *cityInitail;//

- (id)initWithDict:(NSDictionary *)dict;

@end
