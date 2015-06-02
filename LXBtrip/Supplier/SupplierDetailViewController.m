//
//  SupplierDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierDetailViewController.h"
#import "TourListTableViewCell.h"
#import "SupplierDetailTopImageTableViewCell.h"
#import "Global.h"

@interface SupplierDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger pageNum;
    SupplierInfo *info;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addToOrRemoveFromMyShopButton;
- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender;

@end

@implementation SupplierDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SupplierDetailTopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"SupplierDetailTopImageTableViewCell"];
    pageNum = 0;

    info = [[SupplierInfo alloc] init];
    
    [self getSupplierDetail];
}

- (void)getSupplierDetail
{
    if ([[Global sharedGlobal] userInfo].companyId && [[Global sharedGlobal] userInfo].staffId) {
        [HTTPTool getSupplierDetailWithCompanyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId supplierId:_info.supplierId pageNum:@(pageNum) isMy:_info.supplierIsMy success:^(id result) {
            id obj = result[@"RS100016"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                _info = [[SupplierInfo alloc] initWithDict:obj];
                if (_info.supplierIsMy && [_info.supplierIsMy integerValue] == 0) {
                    [_addToOrRemoveFromMyShopButton setTitle:@"取消同步到微店" forState:UIControlStateNormal];
                } else {
                    [_addToOrRemoveFromMyShopButton setTitle:@"同步到我的微店" forState:UIControlStateNormal];
                }
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getSupplierDetailWithSupplierId:_info.supplierId pageNum:@(pageNum) isMy:_info.supplierIsMy success:^(id result) {
            id obj = result[@"RS100015"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                _info = [[SupplierInfo alloc] initWithDict:obj];
                if (_info.supplierIsMy && [_info.supplierIsMy integerValue] == 0) {
                    [_addToOrRemoveFromMyShopButton setTitle:@"取消同步到微店" forState:UIControlStateNormal];
                } else {
                    [_addToOrRemoveFromMyShopButton setTitle:@"同步到我的微店" forState:UIControlStateNormal];
                }
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return info.supplierProductsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SupplierDetailTopImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplierDetailTopImageTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierInfo:_info];
        return cell;
    }
    
    TourListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
    SupplierProduct *curProduct = _info.supplierProductsArray[indexPath.row-1];
    [cell setCellContentWithSupplierProduct:curProduct];
    return cell;
}

- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender {
    
}
@end
