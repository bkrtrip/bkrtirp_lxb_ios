//
//  TourDetailTableViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailTableViewController.h"
#import "TourDetailCell_One.h"
#import "TourDetailCell_Two.h"
#import "TourDetailCell_Three.h"
#import "TourDetailCell_Four.h"
#import "CommentsViewController.h"
#import "TourDetailWebDetailViewController.h"
#import "CalendarViewController.h"
#import "AccompanyInfoViewController.h"

@interface TourDetailTableViewController () <UITableViewDataSource, UITableViewDelegate, TourDetailCell_Four_Delegate, TourDetailCell_Two_Delegate>
{
    NSMutableDictionary *cellHeights;
    NSInteger weekday;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *startDate;

@end

@implementation TourDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDateChanged:) name:@"Start_Date_Changed" object:nil];
    
    self.title = @"线路详情";
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:nil image:ImageNamed(@"share_red")];
    
    cellHeights = [[NSMutableDictionary alloc] init];
//    [cellHeights setObject:@(25.f) forKey:@"first_cell_height"];
    
    [self setUpTableView];
    
    [self getTourDetail];
}

- (void)setUpTableView
{
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Two" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Two"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Three" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Three"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Four" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Four"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_One" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_One"];
    
    _tableView.tableFooterView = [[UIView alloc] init];
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

- (void)rightBarButtonItemClicked:(id)sender
{
    //
}

- (void)startDateChanged:(NSNotification *)note
{
    _startDate = [note userInfo][@"start_date"];
    weekday = [[note userInfo][@"weekday"] integerValue];
    [_tableView reloadData];
}

- (void)getTourDetail
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getTourDetailWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_product.productTravelGoodsId lineCode:_product.productTravelGoodsCode success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100008"] succeed:^{
            _product = [[SupplierProduct alloc] initWithDict:result[@"RS100008"]];
            
            NSString *nowDate = [self nowDateString];
            [_product.productMarketTicketGroup enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
                // 多线程不一定按顺序循环
                if ([grp.marketTime compare:nowDate] != NSOrderedAscending) {
                    if (!_startDate) {
                        _startDate = grp.marketTime;
                    } else {
                        if ([grp.marketTime compare:_startDate] == NSOrderedAscending) {
                            _startDate = grp.marketTime;
                        }
                    }
                }
            }];
            
            TourDetailCell_One *firstCell = [[NSBundle mainBundle] loadNibNamed:@"TourDetailCell_One" owner:nil options:nil][0];
            CGFloat cellHeight = [firstCell cellHeightWithSupplierProduct:_product startDate:_startDate];
            [cellHeights setObject:@(cellHeight) forKey:@"first_cell_height"];
            
            TourDetailCell_Two *secondCell = [[NSBundle mainBundle] loadNibNamed:@"TourDetailCell_Two" owner:nil options:nil][0];
            cellHeight = [secondCell cellHeightWithSupplierProduct:_product startDate:_startDate];
            [cellHeights setObject:@(cellHeight) forKey:@"second_cell_height"];
            
            [_tableView reloadData];
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            TourDetailCell_One *cell = [tableView dequeueReusableCellWithIdentifier:@"TourDetailCell_One" forIndexPath:indexPath];
            CGFloat cellHeight = [cell cellHeightWithSupplierProduct:_product startDate:_startDate];
            [cellHeights setObject:@(cellHeight) forKey:@"first_cell_height"];
            return cell;
        }
            break;
        case 1:
        {
            TourDetailCell_Two *cell = [tableView dequeueReusableCellWithIdentifier:@"TourDetailCell_Two" forIndexPath:indexPath];
            CGFloat cellHeight = [cell cellHeightWithSupplierProduct:_product startDate:_startDate];
            [cellHeights setObject:@(cellHeight) forKey:@"second_cell_height"];
            cell.delegate = self;
            return cell;
        }
            break;
        case 2:
        {
            TourDetailCell_Three *cell = [tableView dequeueReusableCellWithIdentifier:@"TourDetailCell_Three" forIndexPath:indexPath];
            [cell setCellContentWithStartDate:_startDate weekDay:weekday];
            return cell;
        }
            break;
        case 3:
        {
            TourDetailCell_Four *cell = [tableView dequeueReusableCellWithIdentifier:@"TourDetailCell_Four" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [cellHeights[@"first_cell_height"] floatValue];
            break;
        case 1:
            return [cellHeights[@"second_cell_height"] floatValue];
            break;
        case 2:
            return 70.f;
            break;
        case 3:
            return 50.f;
            break;
        default:
            return 0.f;
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        CalendarViewController *calendar = [[CalendarViewController alloc] init];
        
        [_product.productMarketTicketGroup enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
            if (grp.marketAdultPrice) {
                NSLog(@"grp.marketAdultPrice: %@", grp.marketAdultPrice);
                NSLog(@"grp.marketTime: %@", grp.marketTime);
                NSLog(@"-----------------");
            }
        }];

        
        calendar.priceGroupsArray = [_product.productMarketTicketGroup mutableCopy];
        [self.navigationController pushViewController:calendar animated:YES];
    }
}

#pragma mark - TourDetailCell_Two_Delegate
- (void)supportClickWithMoreInstructions
{
    AccompanyInfoViewController *info = [[AccompanyInfoViewController alloc] initWithNibName:@"AccompanyInfoViewController" bundle:nil];
    info.product = _product;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)supportClickWithPhoneCall
{
    
}

#pragma mark - TourDetailCell_Four_Delegate
- (void)supportClickWithDetail
{
    TourDetailWebDetailViewController *web = [[TourDetailWebDetailViewController alloc] init];
    web.detailURLString = _product.productDetailURL;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)supportClickWithTravelTourGuide
{
    TourDetailWebDetailViewController *web = [[TourDetailWebDetailViewController alloc] init];
    web.detailURLString = _product.productIntroduceURL;
    [self.navigationController pushViewController:web animated:YES];
}
- (void)supportClickWithReviews
{
    CommentsViewController *comment = [[CommentsViewController alloc] init];
    comment.product = _product;
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark - Private
- (NSString *)nowDateString
{
    NSDate *todayDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:todayDate];
    
    NSInteger cellYear = [comps year];
    NSInteger cellMonth = [comps month];
    NSInteger cellDay = [comps day];
    weekday = [comps weekday];
    
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)cellYear, (long)cellMonth, (long)cellDay];
    return nowDate;
}



@end
