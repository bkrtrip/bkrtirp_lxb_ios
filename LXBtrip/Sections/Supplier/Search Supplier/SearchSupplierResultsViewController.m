//
//  SearchSupplierResultsViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplierResultsViewController.h"
#import "AppMacro.h"
#import "Global.h"
#import "TourListTableViewCell.h"
#import "TourListCell_Destination.h"
#import "TourListCell_WalkType.h"
#import "AccompanyInfoViewController.h"
#import "AccompanyInfoView.h"
#import "ShareView.h"
#import "TourWebPreviewViewController.h"
#import "TourDetailTableViewController.h"

@interface SearchSupplierResultsViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TourListTableViewCell_Delegate, AccompanyInfoView_Delegate, ShareViewDelegate>
{
    NSInteger pageNum;
    NSMutableArray *searchedResultsArray;
    NSMutableArray *starCitiesArray;
    NSArray *walkTypesArray;
    NSString *walkType;
    
    TourListCell_Destination *selectedCell_Destination;
    TourListCell_WalkType *selectedCell_WalkType;
    
    SupplierProduct *selectedProduct;
    BOOL isRefreshing;
}

- (IBAction)backButtonClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *startCityButton;
@property (strong, nonatomic) IBOutlet UIButton *walkTypeButton;
- (IBAction)startCityButtonClicked:(id)sender;
- (IBAction)walkTypeButtonClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_StartCity;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_StartCity;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_TravelType;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_TravelType;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *walkTypeTableView;
@property (strong, nonatomic) IBOutlet UITableView *startCityTableView;


@property (strong, nonatomic) IBOutlet UIControl *darkMask;
@property (nonatomic, strong) AccompanyInfoView *accompanyInfoView;
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation SearchSupplierResultsViewController

- (void)awakeFromNib
{
    _searchBar.userInteractionEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    _mainTableView.backgroundColor = BG_E9ECF5;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    UIScrollView *scrollView = (UIScrollView *)_mainTableView;
    scrollView.delegate = self;
    
    [_walkTypeTableView registerNib:[UINib nibWithNibName:@"TourListCell_WalkType" bundle:nil] forCellReuseIdentifier:@"TourListCell_WalkType"];
    
    [_startCityTableView registerNib:[UINib nibWithNibName:@"TourListCell_Destination" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination"];

    
//    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:_darkMask];

    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
    
    walkTypesArray = @[@"不限", @"跟团游", @"自由行", @"半自助"];

    [self setWalkTypeTableViewHidden:YES];
    [self setDestinationCityTableViewHidden:YES];
    
    pageNum = 1;
    isRefreshing = NO;
    if (_keyword.length > 0) {
        _searchBar.text = _keyword;
    }
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getSearchedSupplierResults];
    [self getAllCities];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)hidePopUpViews
{
    [self setDestinationCityTableViewHidden:YES];
    [self setWalkTypeTableViewHidden:YES];
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
    [self hideShareViewWithCompletionBlock:nil];
    _darkMask.alpha = 0;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        return searchedResultsArray.count;
    }
    if (tableView == _startCityTableView) {
        return starCitiesArray.count;
    }
    return walkTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        TourListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierProduct:searchedResultsArray[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    
    if (tableView == _startCityTableView) {
        TourListCell_Destination *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination" forIndexPath:indexPath];
        [cell setCellContentWithDestination:[starCitiesArray[indexPath.row] cityName]];
        return cell;
    }
    
    // _walkTypeTableView
    TourListCell_WalkType *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListCell_WalkType" forIndexPath:indexPath];
    [cell setCellContentWithWalkType:walkTypesArray[indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        return 138.f;
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        TourDetailTableViewController *detail = [[TourDetailTableViewController alloc] init];
        detail.product = searchedResultsArray[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    if (tableView == _startCityTableView) {
        [selectedCell_Destination setSelected:NO];
        selectedCell_Destination = (TourListCell_Destination *)[_startCityTableView cellForRowAtIndexPath:indexPath];
        [selectedCell_Destination setSelected:YES];
        
        _startCity = [starCitiesArray[indexPath.row] cityName];
        if (indexPath.row == 0) {
            [_startCityButton setTitle:@"出发地" forState:UIControlStateNormal];
        } else {
            [_startCityButton setTitle:_startCity forState:UIControlStateNormal];
        }
        [self hidePopUpViews];
        
        pageNum = 1;
        isRefreshing = YES;
        _hotTheme = nil;
        _keyword = nil;
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        [self getSearchedSupplierResults];
    }
    
    if (tableView == _walkTypeTableView) {
        [selectedCell_WalkType setSelected:NO];
        selectedCell_WalkType = (TourListCell_WalkType *)[_walkTypeTableView cellForRowAtIndexPath:indexPath];
        [selectedCell_WalkType setSelected:YES];
        
        WalkType walk = indexPath.row-1;
        switch (walk) {
            case All_Kinds:
            {
                walkType = nil;
                [_walkTypeButton setTitle:@"出行方式" forState:UIControlStateNormal];
            }
                break;
            case Follow_Group:
            {
                walkType = @"0";
                [_walkTypeButton setTitle:@"跟团游" forState:UIControlStateNormal];
            }
                break;
            case Free_Run:
            {
                walkType = @"1";
                [_walkTypeButton setTitle:@"自由行" forState:UIControlStateNormal];
            }
                break;
            case Half_Free:
            {
                walkType = @"2";
                [_walkTypeButton setTitle:@"半自助" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        [self hidePopUpViews];
        
        pageNum = 1;
        isRefreshing = YES;
        _hotTheme = nil;
        _keyword = nil;
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        [self getSearchedSupplierResults];
    }
}


#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButtonWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
        CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:product];
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
        _shareView.delegate = self;
        [self.view addSubview:_shareView];
    }
    
    [self showShareView];
    
}
- (void)supportClickWithPreviewButtonWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (selectedProduct.productPreviewURL) {
        TourWebPreviewViewController *web = [[TourWebPreviewViewController alloc] init];
        web.tourURLString = selectedProduct.productPreviewURL;
        [self.navigationController pushViewController:web animated:YES];
    }
}
- (void)supportClickWithAccompanyInfoWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (!_accompanyInfoView) {
        _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
        CGFloat viewHeight = [_accompanyInfoView accompanyInfoViewHeightWithSupplierName:product.productCompanyName introduce:product.productIntroduce price:product.productMarketPrice instructions:product.productPeerNotice];
        
        [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
        _accompanyInfoView.delegate = self;
        [self.view addSubview:_accompanyInfoView];
    }
    [self showAccompanyInfoView];
}

#pragma mark - AccompanyInfoView_Delegate
- (void)supportClickWithMoreInstructions
{
    [self hideAccompanyInfoViewWithCompletionBlock:^{
        AccompanyInfoViewController *info = [[AccompanyInfoViewController alloc] initWithNibName:@"AccompanyInfoViewController" bundle:nil];
        info.product = selectedProduct;
        [self.navigationController pushViewController:info animated:YES];
    }];
}
- (void)supportClickWithPhoneCall
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
}
- (void)supportClickWithShortMessage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithCancel
{
    [self hideShareViewWithCompletionBlock:nil];
}

#pragma mark - HTTP
- (void)getSearchedSupplierResults
{
    [HTTPTool searchSupplierListWithStartCity:_startCity lineClass:_lineClass hotTheme:_hotTheme keyword:_keyword walkType:walkType pageNum:@(pageNum) success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if (isRefreshing == YES) {
            pageNum = 1;
            [searchedResultsArray removeAllObjects];
            [_mainTableView reloadData];
            isRefreshing = NO;
        }
        
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100013"] succeed:^{
            
            if ([result[@"RS100013"][@"goods_list"] isKindOfClass:[NSArray class]]) {
                
//                if ([result[@"RS100013"][@"goods_list"] count] == 0) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有更多了" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//                    [alert show];
//                    return ;
//                }
                
                [result[@"RS100013"][@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
                    if (!searchedResultsArray) {
                        searchedResultsArray = [[NSMutableArray alloc] init];
                    }
                    [searchedResultsArray addObject:product];
                }];
                [_mainTableView reloadData];
                pageNum ++;
            }
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)getAllCities
{
    [HTTPTool getCitiesWithSuccess:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100041"] succeed:^{
            id data = result[@"RS100041"];
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    City *city = [[City alloc] initWithDict:obj];
                    if (!starCitiesArray) {
                        starCitiesArray = [[NSMutableArray alloc] init];
                    }
                    [starCitiesArray addObject:city];
                }];
            }
            [_startCityTableView reloadData];
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取城市失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainTableView) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getSearchedSupplierResults];
        }
    }
}

#pragma mark - Actions
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startCityButtonClicked:(id)sender {
    [self setWalkTypeTableViewHidden:YES];
    if (_startCityTableView.hidden == YES) {
        [self setDestinationCityTableViewHidden:NO];
        _darkMask.alpha = 1.0;
        
        if (!starCitiesArray) {
            [self getAllCities];
        }
        
        if (!selectedCell_Destination) {
            selectedCell_Destination = (TourListCell_Destination *)[_startCityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [selectedCell_Destination setSelected:YES];
        }
    } else {
        [self setDestinationCityTableViewHidden:YES];
        _darkMask.alpha = 0;
    }
}

- (IBAction)walkTypeButtonClicked:(id)sender {
    [self setDestinationCityTableViewHidden:YES];
    if (_walkTypeTableView.hidden == YES) {
        [self setWalkTypeTableViewHidden:NO];
        _darkMask.alpha = 1.0;
        if (!selectedCell_WalkType) {
            selectedCell_WalkType = (TourListCell_WalkType *)[_walkTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [selectedCell_WalkType setSelected:YES];
        }
    } else {
        [self setWalkTypeTableViewHidden:YES];
        _darkMask.alpha = 0;
    }
}

#pragma mark - Private
- (void)setDestinationCityTableViewHidden:(BOOL)hidden
{
    _startCityTableView.hidden = hidden;
    _imageView_Closed_StartCity.hidden = !hidden;
    _imageView_Open_StartCity.hidden = hidden;
}

- (void)setWalkTypeTableViewHidden:(BOOL)hidden
{
    _walkTypeTableView.hidden = hidden;
    _imageView_Closed_TravelType.hidden = !hidden;
    _imageView_Open_TravelType.hidden = hidden;
}

// show/hide accompanyInfoView
- (void)hideAccompanyInfoViewWithCompletionBlock:(void (^)())block
{
    if (_accompanyInfoView.frame.origin.y == SCREEN_HEIGHT) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, _accompanyInfoView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
//            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

- (void)showAccompanyInfoView
{
//    [self.view insertSubview:_darkMask aboveSubview:_walkTypeTableView];
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, -_accompanyInfoView.frame.size.height)];
    }];
}

// show/hide ShareView
- (void)showShareView
{
//    [self.view insertSubview:_darkMask aboveSubview:_walkTypeTableView];
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, -_shareView.frame.size.height)];
    }];
}

- (void)hideShareViewWithCompletionBlock:(void (^)())block
{
    if (_shareView.frame.origin.y == SCREEN_HEIGHT) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
//            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

@end
