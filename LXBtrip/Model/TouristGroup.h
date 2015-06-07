//
//  TouristGroup.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouristGroup : NSObject

@property (nonatomic, copy) NSString *touristName;//
@property (nonatomic, copy) NSString *touristCode;//

- (id)initWithDict:(NSDictionary *)dict;

@end
