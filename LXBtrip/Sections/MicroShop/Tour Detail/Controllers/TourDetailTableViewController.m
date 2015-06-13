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
#import "AppMacro.h"
#import "CommentsViewController.h"
#import "TourDetailWebDetailViewController.h"

@interface TourDetailTableViewController () <UITableViewDataSource, UITableViewDelegate, TourDetailCell_Four_Delegate>
{
    NSMutableDictionary *cellHeights;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *startDate;

@end

@implementation TourDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线路详情";
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:nil image:ImageNamed(@"share_red")];
    
//    cellHeights = [@{@"first_cell_height":@(254.f), @"second_cell_height":@(150.f)} mutableCopy];
    
//    UINib *nib = [UINib nibWithNibName:@"TourDetailCell_One" bundle:nil];
    
    cellHeights = [[NSMutableDictionary alloc] init];
    [self setUpTableView];
    [self getTourDetail];
}

- (void)setUpTableView
{
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_One" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_One"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Two" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Two"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Three" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Three"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Four" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Four"];
    
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)rightBarButtonItemClicked:(id)sender
{
    //
}

- (void)getTourDetail
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getTourDetailWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_product.productTravelGoodsId lineCode:_product.productTravelGoodsCode success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100008"] succeed:^{
            NSLog(@"result[@\"RS100008\"]: %@", result[@"RS100008"]);
            _product = [[SupplierProduct alloc] initWithDict:result[@"RS100008"]];
            [_tableView reloadData];
        } fail:^(id result) {
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
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
            [cell setCellContentWithStartDate:_startDate];
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
//    DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    [self.navigationController pushViewController:detailViewController animated:YES];
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








@end
