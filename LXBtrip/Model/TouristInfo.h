//
//  TouristGroup.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouristInfo : NSObject

@property (nonatomic, copy) NSString *touristName;//
@property (nonatomic, copy) NSString *touristCode;//
//@property (nonatomic, copy) NSString *userId;//
//@property (nonatomic, copy) NSString *userCredit;//


- (id)initWithDict:(NSDictionary *)dict;

@end
