//
//  TourInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TourInfo : NSObject

@property (nonatomic, copy) NSString *tourImage;
@property (nonatomic, copy) NSString *tourName;
@property (nonatomic, copy) NSString *tourKeywords;
@property (nonatomic, copy) NSString *tourCost;

- (id)initWithDict:(NSDictionary *)dict;

@end
