//
//  OrderDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCell_ContactInfo.h"
#import "OrderDetailCell_OrderInfo.h"
#import "OrderDetailCell_TotalAmount.h"
#import "OrderDetailCell_TouristsInfo.h"
#import "CreateOrderCell_BookHeader.h"
#import "CreateOrderCell_OrderId.h"


@interface OrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_OrderId" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_OrderId"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_ContactInfo" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_ContactInfo"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_TotalAmount" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_TotalAmount"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_TouristsInfo" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_TouristsInfo"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_BookHeader" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_BookHeader"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return _item.orderTouristGroup.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CreateOrderCell_OrderId *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_OrderId" forIndexPath:indexPath];
            [cell setCellContentWithMyOrderItem:_item];
            return cell;
        }
            break;
        case 1:
        {
            OrderDetailCell_OrderInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_OrderInfo" forIndexPath:indexPath];
            [cell setCellContentWithMyOrderItem:_item];
            return cell;
        }
            break;
        case 2:
        {
            OrderDetailCell_ContactInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_ContactInfo" forIndexPath:indexPath];
            [cell setCellContentWithMyOrderItem:_item];
            return cell;
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                CreateOrderCell_BookHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_BookHeader" forIndexPath:indexPath];
                cell.headerLabel.text = @"游客信息";
                return cell;
            }
            
            TouristInfo *curTourist = _item.orderTouristGroup[indexPath.row - 1];
            OrderDetailCell_TouristsInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_TouristsInfo" forIndexPath:indexPath];
            [cell setCellContentWithTouristInfo:curTourist];
            return cell;
        }
            break;
        case 4:
        {
            OrderDetailCell_TotalAmount *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_TotalAmount" forIndexPath:indexPath];
            [cell setCellContentWithMyOrderItem:_item];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // go to product ?
    }
    
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = BG_F5F5F5;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10.f;
    }
    return 0.f;
}


@end