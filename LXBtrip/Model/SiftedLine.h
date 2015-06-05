//
//  SiftedLine.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/5.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacro.h"

@interface SiftedLine : NSObject

@property (nonatomic, copy) NSString *siftedLineName;//
@property (nonatomic, copy) NSString *siftedLineFirstLetter;//
@property (nonatomic, copy) NSNumber *siftedLineType;//

- (id)initWithDict:(NSDictionary *)dict;


@end
