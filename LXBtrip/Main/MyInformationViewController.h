//
//  MyInformationViewController.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UIImageView *headImageView;//头部的image
@property (strong, nonatomic)UIButton *supplierButton;//我的供应商按钮
@property (strong, nonatomic)UIButton *distributorButton;//我的分销商按钮
@property (strong, nonatomic)UIButton *orderFormButton;//我的订单按钮
@property (strong, nonatomic)UITableView *myTableView;//我的表示图

@end
