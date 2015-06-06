//
//  HotSearch.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSearch : NSObject

@property (nonatomic, copy) NSNumber *hotSearchKey;//
@property (nonatomic, copy) NSString *hotSearchValue;//

- (id)initWithDict:(NSDictionary *)dict;


@end
