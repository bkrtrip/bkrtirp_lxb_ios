//
//  CompanyTemplate.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyTemplate : NSObject

@property (nonatomic, copy) NSString *templateImgURL;//微店图片地址
@property (nonatomic, copy) NSString *templateHttpURL;//微店链接

- (id)initWithDict:(NSDictionary *)dict;

@end
