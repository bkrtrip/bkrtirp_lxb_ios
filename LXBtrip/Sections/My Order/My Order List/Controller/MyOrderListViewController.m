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
#import "OrderDetailViewController.h"
#import "CreateOrderViewController.h"

@interface MyOrderListViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MyOrderListTableViewCell__Invalid_Delegate, MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate>
{
    NSInteger selectedIndex;
    NSMutableArray *ordersArray;
    NSMutableArray *isLoadingMoreArray;
    NSMutableArray *refreshControlsArray;
    NSMutableArray *noOrdersArray;

    NSMutableArray *pageNumsArray;
    NSMutableArray *tableViewsArray;
    OrderListType orderType;
    MyOrderItem *selectedOrder;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *underLineLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *orderStatusButtonsArray;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *orderStatusBadgeLabelsArray;

- (IBAction)orderStatusButtonClicked:(id)sender;


@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderHasConfirmed) name:@"ORDER_HAS_CONFIRMED" object:nil];
    
    self.title = @"我的订单";
    [_orderStatusButtonsArray enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL *stop) {
        bt.tag = idx;
    }];
    
    [_orderStatusBadgeLabelsArray enumerateObjectsUsingBlock:^(UILabel *lb, NSUInteger idx, BOOL *stop) {
        lb.layer.cornerRadius = lb.frame.size.height/2;
        lb.layer.masksToBounds = YES;
        lb.text = @"0";
        lb.hidden = YES;
    }];
    
    CGFloat yOrigin = 50.f;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin - 64.f)];
    [_scrollView setContentSize:CGSizeMake(3*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    refreshControlsArray = [[NSMutableArray alloc] initWithCapacity:3];
    tableViewsArray = [[NSMutableArray alloc] initWithCapacity:3];
    noOrdersArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        if (i == 2) {
            [tableView registerNib:[UINib nibWithNibName:@"MyOrderListTableViewCell__Invalid" bundle:nil] forCellReuseIdentifier:@"MyOrderListTableViewCell__Invalid"];
        } else {
            [tableView registerNib:[UINib nibWithNibName:@"MyOrderListTableViewCell__Unconfirmed_Confirmed" bundle:nil] forCellReuseIdentifier:@"MyOrderListTableViewCell__Unconfirmed_Confirmed"];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = BG_F5F5F5;
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshTableViews:) forControlEvents:UIControlEventValueChanged];
        [tableView addSubview:refreshControl];
        UIScrollView *scrollview = (UIScrollView *)tableView;
        scrollview.delegate = self;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0)];
        bgView.backgroundColor = BG_E9ECF5;
        CGFloat width_height_ratio = 385.f/350.f;
        CGFloat imgHeight = 0.2*bgView.bounds.size.height;
        CGFloat imgWidth = imgHeight*width_height_ratio;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.bounds.size.width - imgWidth)/2.0, 0.2*bgView.bounds.size.height, imgWidth, imgHeight)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.image = ImageNamed(@"no_order");
        [bgView addSubview:imgView];
        // no supplier view initially hidden!
        bgView.hidden = YES;
        
        
        [_scrollView addSubview:tableView];
        [_scrollView addSubview:bgView];
        [tableViewsArray addObject:tableView];
        [refreshControlsArray addObject:refreshControl];
        [noOrdersArray addObject:bgView];
    }
    
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, SCREEN_WIDTH/3, 2)];
    _underLineLabel.backgroundColor = RED_FF0075;
    [self.view addSubview:_underLineLabel];
    
    ordersArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [ordersArray addObject:array];
    }

    selectedIndex = 0;
    orderType = Order_Not_Confirm;
    pageNumsArray = [@[@1, @1, @1] mutableCopy];
    isLoadingMoreArray = [@[@0, @0, @0] mutableCopy];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getMyOrderList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 50.f + 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)orderHasConfirmed
{
    selectedIndex = 1;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
    pageNumsArray[selectedIndex] = @1;
    pageNumsArray[0] = @1; // 前两个列表都改变了
    isLoadingMoreArray[selectedIndex] = @0;
    isLoadingMoreArray[0] = @0; // 前两个列表都改变了
    [self getMyOrderList];
}

- (void)refreshTableViews:(id)sender
{
    pageNumsArray[selectedIndex] = @1;
    isLoadingMoreArray[selectedIndex] = @0;
    [self getMyOrderList];
}

#pragma mark - UITableViewDataSource
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
        cell.delegate = self;
        return cell;
    }
    
    MyOrderListTableViewCell__Unconfirmed_Confirmed *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderListTableViewCell__Unconfirmed_Confirmed" forIndexPath:indexPath];
    MyOrderItem *item = ordersArray[selectedIndex][indexPath.row];
    [cell setCellContentWithMyOrderItem:item];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 2) {
        return 143.f;
    }
    return 190.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 0) {
        CreateOrderViewController *create = [[CreateOrderViewController alloc] init];
        create.item = ordersArray[selectedIndex][indexPath.row];
        [self.navigationController pushViewController:create animated:YES];
        return;
    }
    
    OrderDetailViewController *detail = [[OrderDetailViewController alloc] init];
    detail.item = ordersArray[selectedIndex][indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate
- (void)supportClickPhoneCallWithOrder:(MyOrderItem *)order
{
    selectedOrder = order;
    [[Global sharedGlobal] callWithPhoneNumber:selectedOrder.orderContactPhone];
}
- (void)supportClickCancelOrderWithOrder:(MyOrderItem *)order
{
    selectedOrder = order;
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self modifyOrCancelMyOrderWithStatus:@"2"];
}

#pragma mark - MyOrderListTableViewCell__Invalid_Delegate
- (void)supportClickWithPhoneCall_InvalidWithOrder:(MyOrderItem *)order
{
    selectedOrder = order;
    [[Global sharedGlobal] callWithPhoneNumber:selectedOrder.orderContactPhone];
}

#pragma mark - HTTP
- (void)getMyOrderList
{
    [HTTPTool getMyOrderListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] status:[NSString stringWithFormat:@"%ld", (long)selectedIndex] pageNum:pageNumsArray[selectedIndex] success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [refreshControlsArray[selectedIndex] endRefreshing];

        if ([isLoadingMoreArray[selectedIndex] integerValue] == 0) {
            isLoadingMoreArray[selectedIndex] = @1;
            [ordersArray[selectedIndex] removeAllObjects];
            [tableViewsArray[selectedIndex] reloadData];
        }
        
        [noOrdersArray[selectedIndex] setHidden:YES];

        id data = result[@"RS100031"];
        [[Global sharedGlobal] codeHudWithObject:data succeed:^{
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    MyOrderItem *item = [[MyOrderItem alloc] initWithDict:obj];
                    [ordersArray[selectedIndex] addObject:item];
                }];
                
                [tableViewsArray[selectedIndex] reloadData];
                pageNumsArray[selectedIndex] = @([pageNumsArray[selectedIndex] integerValue]+1);
            } else {
                if ([pageNumsArray[selectedIndex] intValue] == 1) {
                    [noOrdersArray[selectedIndex] setHidden:NO];
                }
            }
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [refreshControlsArray[selectedIndex] endRefreshing];
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}
// status 订单状态：0：未确认 1：已确认/修改 2：已取消/取消
- (void)modifyOrCancelMyOrderWithStatus:(NSString *)status
{
    [HTTPTool modifyOrCancelMyOrderWithCompanyId:[UserModel companyId]
                                         staffId:[UserModel staffId]
                                         orderId:selectedOrder.orderLineId
                                       startDate:selectedOrder.orderStartDate
                                      returnDate:selectedOrder.orderReturnDate
                                      priceGroup:[self jsonStringFromReservePriceGroup:selectedOrder.orderReservePriceGroup]
                                   contactPerson:selectedOrder.orderContactName
                                  contactPhoneNo:selectedOrder.orderContactPhone
                                    touristGroup:[self jsonStringFromTouristGroupToDictionaryArrayWithArray:selectedOrder.orderTouristGroup]
                                      totalPrice:[selectedOrder.orderDealPrice stringValue]
                                          status:status
                                         success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100032"] succeed:^{
            
            pageNumsArray[selectedIndex] = @1;
            isLoadingMoreArray[selectedIndex] = @0;
            
//            [self getMyOrderList];

            if ([status integerValue] == 2) {
                // 直接跳转“失效”，并刷新列表
                pageNumsArray[2] = @1;
                isLoadingMoreArray[2] = @0;
                [self orderStatusButtonClicked:_orderStatusButtonsArray[2]];
            }
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Actions
- (IBAction)orderStatusButtonClicked:(id)sender {
    if (selectedIndex == [sender tag]) {
        return;
    }
    selectedIndex = [sender tag];
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}

- (void)scrollToVisibleWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, index*SCREEN_WIDTH, 0) animated:NO];
        [_underLineLabel setFrame:CGRectMake(index*SCREEN_WIDTH/3, _underLineLabel.frame.origin.y, SCREEN_WIDTH/3, _underLineLabel.frame.size.height)];
    } completion:^(BOOL finished) {
        if ([isLoadingMoreArray[index] integerValue] == 0) {
            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getMyOrderList];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
//            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getMyOrderList];
        }
    }
}

#pragma mark - Private
- (NSString *)jsonStringFromReservePriceGroup:(ReservePriceGroup *)group
{
    if (!group) {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (group.adultPrice) {
        [dict setObject:group.adultPrice forKey:@"adult_price"];
    }
    if (group.adultNum) {
        [dict setObject:group.adultNum forKey:@"adult_person"];
    }
    
    // kid no bed
    if (group.kidPrice) {
        [dict setObject:group.kidPrice forKey:@"kid_nbed_price"];
    }
    if (group.kidNum) {
        [dict setObject:group.kidNum forKey:@"kid_nbed_person"];
    }
    
    // kid with bed
    if (group.kidBedPrice) {
        [dict setObject:group.kidBedPrice forKey:@"kid_price"];
    }
    if (group.kidBedNum) {
        [dict setObject:group.kidBedNum forKey:@"kid_person"];
    }
    
    if (group.diffPrice) {
        [dict setObject:group.diffPrice forKey:@"diff_price"];
    }
    
    return [self DataTOjsonString:dict];
}

- (NSString *)jsonStringFromTouristGroupToDictionaryArrayWithArray:(NSArray *)touristsArray
{
    if (!touristsArray || touristsArray.count == 0) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [touristsArray enumerateObjectsUsingBlock:^(TouristInfo *tourist, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (tourist.touristCode) {
            [dict setObject:tourist.touristCode forKey:@"cred"];
        }
        if (tourist.touristName) {
            [dict setObject:tourist.touristName forKey:@"user"];
        }
        [arr addObject:dict];
    }];
    
    return [self DataTOjsonString:arr];
}

- (NSString *)DataTOjsonString:(id)object
{
    if (!object) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count] == 0) {
            return nil;
        }
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSArray *)sortByTimeDescendingWithOrders:(NSArray *)orders
{
    return [orders sortedArrayUsingFunction:sortOrder context:NULL];
}


@end
