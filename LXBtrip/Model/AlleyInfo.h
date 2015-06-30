//
//  AlleyInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CompanyTemplate.h"

@interface AlleyInfo : NSObject

@property (nonatomic, copy) NSNumber *alleyId;//
@property (nonatomic, copy) NSString *alleyName;//
@property (nonatomic, copy) NSString *alleyLogo;//
@property (nonatomic, copy) NSString *alleyCompanyBusinessLicense;

@property (nonatomic, copy) NSString *alleyBrand;//
@property (nonatomic, copy) NSNumber *alleyServiceCost;//加盟服务费起
@property (nonatomic, copy) NSString *alleyLocation;//
@property (nonatomic, assign) CGFloat alleyDistance;

@property (nonatomic, copy) NSMutableArray *alleyCompanyTemplates;//本月加盟数
@property (nonatomic, copy) NSString *alleyCompanyAddress;
@property (nonatomic, copy) NSString *alleyServiceNotice;
@property (nonatomic, copy) NSString *alleyContactPhoneNo;


@property (nonatomic, copy) NSString *alleyServiceCreateDate;//
@property (nonatomic, copy) NSString *alleyJoinNum;//本月加盟数
@property (nonatomic, copy) NSNumber *alleyJoinStatus;//加盟状态 0：未加盟、1：待申请、 2：同意  3：拒绝  4：解除


- (id)initWithDict:(NSDictionary *)dict;

@end
