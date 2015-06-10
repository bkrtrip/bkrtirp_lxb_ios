//
//  AccompanyInfoCell_Company.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccompanyInfoCell_Company_Delegate <NSObject>

- (void)supportClickWithPhoneCall;

@end


@interface AccompanyInfoCell_Company : UITableViewCell

@property (nonatomic, weak) id <AccompanyInfoCell_Company_Delegate> delegate;

- (void)setCellContentWithSupplierName:(NSString *)supplierName;

@end
