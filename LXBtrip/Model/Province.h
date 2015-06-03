//
//  Province.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

@property (nonatomic, copy) NSNumber *provinceId;//
@property (nonatomic, copy) NSNumber *countryId;//

@property (nonatomic, copy) NSString *provincePinYin;//
@property (nonatomic, copy) NSString *provinceName;//
@property (nonatomic, copy) NSString *provinceAcronym;//
@property (nonatomic, copy) NSString *provinceInitail;//
@property (nonatomic, copy) NSNumber *provinceAreaFlag;//大区标示

- (id)initWithDict:(NSDictionary *)dict;

@end
