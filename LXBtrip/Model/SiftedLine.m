//
//  SiftedLine.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/5.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SiftedLine.h"

@implementation SiftedLine

- (id)initWithDict:(NSDictionary *)dict
{
    self.siftedLineName = [dict[@"sttr_name"] isKindOfClass:[NSNull class]]?nil:dict[@"sttr_name"];
    self.siftedLineFirstLetter = [dict[@"sttr_letter"] isKindOfClass:[NSNull class]]?nil:dict[@"sttr_letter"];
    
    self.siftedLineType= [dict[@"sttr_type"] isKindOfClass:[NSNull class]]?nil:dict[@"sttr_type"];
    
    return self;
}

@end
