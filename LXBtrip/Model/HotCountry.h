//
//  HotCountry.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCountry : NSObject

@property (nonatomic, copy) NSNumber *hotCountryKey;//
@property (nonatomic, copy) NSString *hotCountryValue;//

- (id)initWithDict:(NSDictionary *)dict;


@end
