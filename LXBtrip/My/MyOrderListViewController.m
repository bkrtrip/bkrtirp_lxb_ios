//
//  MyOrderListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MyOrderListTableViewCell__Invalid.h"
#import "MyOrderListTableViewCell__Unconfirmed_Confirmed.h"

@interface MyOrderListViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MyOrderListTableViewCell__Invalid_Delegate, MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate>
{
    NSInteger selectedIndex;
    NSMutableArray *ordersArray;
    
    NSArray *pageNumsArray;
    NSMutableArray *tableViewsArray;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *orderStatusButtonsArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *orderStatusBadgeLabelsArray;

- (IBAction)orderStatusButtonClicked:(id)sender;


@end

@implementation MyOrderListViewController

- (void)awakeFromNib
{
    [_orderStatusButtonsArray enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL *stop) {
        bt.tag = idx;
    }];
    
    [_orderStatusBadgeLabelsArray enumerateObjectsUsingBlock:^(UILabel *lb, NSUInteger idx, BOOL *stop) {
        lb.layer.cornerRadius = lb.frame.size.height/2;
        lb.layer.masksToBounds = YES;
        lb.text = @"0";
        lb.hidden = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
    selectedIndex = 0;
    pageNumsArray = @[@0, @0, @0];
    ordersArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [ordersArray addObject:array];
    }
    
    tableViewsArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:_scrollView.bounds];
        if (i == 2) {
            [tableView registerNib:[UINib nibWithNibName:@"MyOrderListTableViewCell__Invalid" bundle:nil] forCellReuseIdentifier:@"MyOrderListTableViewCell__Invalid"];
        } else {
            [tableView registerNib:[UINib nibWithNibName:@"MyOrderListTableViewCell__Unconfirmed_Confirmed" bundle:nil] forCellReuseIdentifier:@"MyOrderListTableViewCell__Unconfirmed_Confirmed"];
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        [_scrollView addSubview:tableView];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ordersArray[selectedIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 2) {
        MyOrderListTableViewCell__Invalid *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderListTableViewCell__Invalid" forIndexPath:indexPath];
        MyOrderItem *item = ordersArray[selectedIndex][indexPath.row];
        [cell setCellContentWithMyOrderItem:item];
        return cell;
    }
    
    MyOrderListTableViewCell__Unconfirmed_Confirmed *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderListTableViewCell__Unconfirmed_Confirmed" forIndexPath:indexPath];
    MyOrderItem *item = ordersArray[selectedIndex][indexPath.row];
    [cell setCellContentWithMyOrderItem:item];
    return cell;
}

- (void)getMyOrderList
{
    [HTTPTool getMyOrderListWithCompanyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId status:[@(selectedIndex) stringValue] pageNum:pageNumsArray[selectedIndex] success:^(id result) {
        id data = result[@"RS100031"];
        [[Global sharedGlobal] codeHudWithObject:data succeed:^{
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    MyOrderItem *item = [[MyOrderItem alloc] initWithDict:obj];
                    [ordersArray[selectedIndex] addObject:item];
                }];
            }
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}




















- (IBAction)orderStatusButtonClicked:(id)sender {
    if (selectedIndex == [sender tag]) {
        return;
    }
}

#pragma mark - MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate
- (void)supportClickWithCancelOrder
{
    
}

- (void)supportClickWithPhoneCall
{
    
}
#pragma mark - MyOrderListTableViewCell__Invalid_Delegate

- (void)supportClickWithPhoneCall_Invalid
{
    
}










@end
