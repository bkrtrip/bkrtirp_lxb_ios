//
//  HotCity.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCity : NSObject

@property (nonatomic, copy) NSNumber *hotCityKey;//
@property (nonatomic, copy) NSString *hotCityValue;//

- (id)initWithDict:(NSDictionary *)dict;

@end
