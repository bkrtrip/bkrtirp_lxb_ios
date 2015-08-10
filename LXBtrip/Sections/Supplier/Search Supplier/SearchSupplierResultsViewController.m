//
//  SearchSupplierResultsViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplierResultsViewController.h"
#import "TourListTableViewCell.h"
#import "TourListCell_Destination.h"
#import "TourListCell_WalkType.h"
#import "AccompanyInfoViewController.h"
#import "AccompanyInfoView.h"
#import "ShareView.h"
#import "TourWebPreviewViewController.h"
#import "TourDetailTableViewController.h"
#import "SetShopNameViewController.h"
#import "SetShopContactViewController.h"
#import "SwitchCityViewController.h"

@interface SearchSupplierResultsViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TourListTableViewCell_Delegate, AccompanyInfoView_Delegate, ShareViewDelegate>
{
    NSInteger pageNum;
    NSMutableArray *searchedResultsArray;
    NSMutableArray *siftedResultsArray;
    NSMutableArray *endCitiesArray;
    NSArray *walkTypesArray;
    NSString *walkType;
    NSString *endCity;
    
    TourListCell_Destination *selectedCell_Destination;
    TourListCell_WalkType *selectedCell_WalkType;
    
    SupplierProduct *selectedProduct;
    BOOL isRefreshing;
}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)falseSearchButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *endCityButton;
@property (strong, nonatomic) IBOutlet UIButton *walkTypeButton;
- (IBAction)endCityButtonClicked:(id)sender;
- (IBAction)walkTypeButtonClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_StartCity;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_StartCity;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_TravelType;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_TravelType;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *walkTypeTableView;
@property (strong, nonatomic) IBOutlet UITableView *endCityTableView;


@property (strong, nonatomic) IBOutlet UIControl *darkMask;

@property (strong, nonatomic) IBOutlet UIView *noSearchResultsView;

@property (nonatomic, strong) AccompanyInfoView *accompanyInfoView;
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation SearchSupplierResultsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResultsNeedsUpdate) name:UPDATE_ALL_LIST_WITH_LOGINING_SUCCESS object:nil]; // from LoginViewController, change search API after login
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCityWithCityName:) name:SWITCH_CITY_SUPPLIER_SEARCH_RESULTS object:nil];

    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    _mainTableView.backgroundColor = BG_E9ECF5;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    UIScrollView *scrollView = (UIScrollView *)_mainTableView;
    scrollView.delegate = self;
    
    NSString *startCity = [[Global sharedGlobal] locationCity];
    if (startCity) {
        [_locationButton setTitle:startCity forState:UIControlStateNormal];
    }
    
    [self setUpSearchBarAndSearchButton];
    
    [_walkTypeTableView registerNib:[UINib nibWithNibName:@"TourListCell_WalkType" bundle:nil] forCellReuseIdentifier:@"TourListCell_WalkType"];
    
    [_endCityTableView registerNib:[UINib nibWithNibName:@"TourListCell_Destination" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination"];
    
    _endCityTableView.tableFooterView = [[UIView alloc] init];

    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
    
    walkTypesArray = @[@"不限", @"跟团游", @"自由行", @"半自助"];

    [self setWalkTypeTableViewHidden:YES];
    [self setDestinationCityTableViewHidden:YES];
    
    _noSearchResultsView.hidden = YES;
    pageNum = 1;
    isRefreshing = NO;
    if (_keyword.length > 0) {
        _searchBar.text = _keyword;
    }
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getSearchedSupplierResults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)searchResultsNeedsUpdate
{
    _noSearchResultsView.hidden = YES;
    pageNum = 1;
    isRefreshing = YES;

//    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getSearchedSupplierResults];
}

- (void)setUpSearchBarAndSearchButton
{
    _searchBar.layer.borderWidth = 0.5f;
    _searchBar.layer.borderColor = TEXT_CCCCD2.CGColor;
    
    _searchBar.layer.cornerRadius = 3.f;
    _searchBar.layer.masksToBounds = YES;
    
    [_searchBar setImage:ImageNamed(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)hidePopUpViews
{
    [self setDestinationCityTableViewHidden:YES];
    [self setWalkTypeTableViewHidden:YES];
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
    [self hideShareViewWithCompletionBlock:nil];
    _darkMask.alpha = 0;
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f + 49.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        return siftedResultsArray.count;
    }
    if (tableView == _endCityTableView) {
        return endCitiesArray.count;
    }
    return walkTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        TourListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierProduct:siftedResultsArray[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    
    if (tableView == _endCityTableView) {
        TourListCell_Destination *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination" forIndexPath:indexPath];
        [cell setCellContentWithDestination:endCitiesArray[indexPath.row]];
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
    
    if (tableView == _endCityTableView) {
        [selectedCell_Destination setSelected:NO];
        selectedCell_Destination = (TourListCell_Destination *)[_endCityTableView cellForRowAtIndexPath:indexPath];
        [selectedCell_Destination setSelected:YES];
        
        if (siftedResultsArray.count == 0) {
            _noSearchResultsView.hidden = NO;
        } else {
            _noSearchResultsView.hidden = YES;
        }
        [_mainTableView reloadData];
        [self hidePopUpViews];
        
        if (indexPath.row == 0) {
            endCity = nil;
            [_endCityButton setTitle:@"全部目的地" forState:UIControlStateNormal];
        } else {
            endCity = endCitiesArray[indexPath.row];
            [_endCityButton setTitle:endCitiesArray[indexPath.row] forState:UIControlStateNormal];
        }
        
        pageNum = 1;
        isRefreshing = YES;
//        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
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
                [_walkTypeButton setTitle:@"不限" forState:UIControlStateNormal];
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
        
        pageNum = 1;
        isRefreshing = YES;
//        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        [self getSearchedSupplierResults];
        [self hidePopUpViews];
        
//        [self siftProductsWithWalkType:walk];
//        if (siftedResultsArray.count == 0) {
//            _noSearchResultsView.hidden = NO;
//        } else {
//            _noSearchResultsView.hidden = YES;
//        }
//        [_mainTableView reloadData];
//        [self hidePopUpViews];
    }
}


#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButtonWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                selectedProduct = product;
                if (!_shareView) {
                    _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
                    _shareView.delegate = self;
                    [self.view addSubview:_shareView];
                }
                CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:product];
                [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
                
                [self showShareView];
            }
        }
    }
}
- (void)supportClickWithPreviewButtonWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                selectedProduct = product;
                if (selectedProduct.productPreviewURL) {
                    TourWebPreviewViewController *web = [[TourWebPreviewViewController alloc] init];
                    web.tourURLString = selectedProduct.productPreviewURL;
                    [self.navigationController pushViewController:web animated:YES];
                }
            }
        }
    }
}
- (void)supportClickWithAccompanyInfoWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                selectedProduct = product;
                if (!_accompanyInfoView) {
                    _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
                    _accompanyInfoView.delegate = self;
                    [self.view addSubview:_accompanyInfoView];
                }
                CGFloat viewHeight = [_accompanyInfoView accompanyInfoViewHeightWithSupplierName:product.productCompanyName productName:product.productIntroduce price:product.productTravelPrice instructions:product.productPeerNotice];
                
                [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
                [self showAccompanyInfoView];
            }
        }
    }
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
    [[Global sharedGlobal] callWithPhoneNumber:selectedProduct.productCompanyContactPhone];
}
- (void)supportClickWithShortMessage
{
    [[Global sharedGlobal] sendShortTextWithPhoneNumber:selectedProduct.productCompanyContactPhone];
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaWeChatWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
    }
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaQQWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:QQ_Share_Session];
    }
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaQQWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
    }
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaSMSWithContent:[NSString stringWithFormat:@"%@\n%@", sharePrd.productTravelGoodsName, shareURL]  presentedController:self];
    }
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self supportClickWithQQWithShareObject:obj];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaYiXinWithURLString:shareURL content:sharePrd.productTravelGoodsName image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
    }
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaSinaWithURLString:shareURL content:sharePrd.productTravelGoodsName image:nil location:nil presentedController:self];
    }
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaWeChatWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
    }
}

- (void)supportClickWithCancel
{
    [self hideShareViewWithCompletionBlock:nil];
}

#pragma mark - HTTP
- (void)getSearchedSupplierResults
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool searchSupplierListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] startCity:[[Global sharedGlobal] locationCity] endCity:endCity lineClass:nil hotTheme:_hotTheme keyword:_keyword walkType:walkType pageNum:@(pageNum) success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            
            if (isRefreshing == YES) {
                pageNum = 1;
                [searchedResultsArray removeAllObjects];
                [_mainTableView reloadData];
                isRefreshing = NO;
            }
            
            _noSearchResultsView.hidden = YES;
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100049"] succeed:^{
                
                NSString *endCitiesString = result[@"RS100049"][@"end_city"];
                NSArray *temp = [endCitiesString componentsSeparatedByString:@"#"];
                
                if (!endCitiesArray) {
                    endCitiesArray = [[NSMutableArray alloc] init];
                    [endCitiesArray addObject:@"不限"];
                }
                
                [temp enumerateObjectsUsingBlock:^(NSString *new, NSUInteger idx, BOOL *stop) {
                    __block BOOL alreadyOld = NO;
                    [endCitiesArray enumerateObjectsUsingBlock:^(NSString *old, NSUInteger idx, BOOL *stop) {
                        if ([new isEqualToString:old]) {
                            alreadyOld = YES;
                        }
                    }];
                    if (alreadyOld == NO) {
                        [endCitiesArray addObject:new];
                    }
                }];
                
                [_endCityTableView reloadData];
                
                if ([result[@"RS100049"][@"goods_list"] isKindOfClass:[NSArray class]]) {
                    [result[@"RS100049"][@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
                        if (!searchedResultsArray) {
                            searchedResultsArray = [[NSMutableArray alloc] init];
                        }
                        [searchedResultsArray addObject:product];
                    }];
                    
                    siftedResultsArray = [searchedResultsArray mutableCopy];
                    [_mainTableView reloadData];
                    pageNum ++;
                } else if (searchedResultsArray.count == 0) {
                    _noSearchResultsView.hidden = NO;
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            
            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool searchSupplierListWithStartCity:[[Global sharedGlobal] locationCity] endCity:endCity lineClass:nil hotTheme:_hotTheme keyword:_keyword walkType:walkType pageNum:@(pageNum) success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            
            if (isRefreshing == YES) {
                pageNum = 1;
                [searchedResultsArray removeAllObjects];
                [_mainTableView reloadData];
                isRefreshing = NO;
            }
            
            _noSearchResultsView.hidden = YES;
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100013"] succeed:^{
                
                NSString *endCitiesString = result[@"RS100013"][@"end_city"];
                NSArray *temp = [endCitiesString componentsSeparatedByString:@"#"];
                
                if (!endCitiesArray) {
                    endCitiesArray = [[NSMutableArray alloc] init];
                    [endCitiesArray addObject:@"不限"];
                }
                
                [temp enumerateObjectsUsingBlock:^(NSString *new, NSUInteger idx, BOOL *stop) {
                    __block BOOL alreadyOld = NO;
                    [endCitiesArray enumerateObjectsUsingBlock:^(NSString *old, NSUInteger idx, BOOL *stop) {
                        if ([new isEqualToString:old]) {
                            alreadyOld = YES;
                        }
                    }];
                    if (alreadyOld == NO) {
                        [endCitiesArray addObject:new];
                    }
                }];
                
                [_endCityTableView reloadData];
                
                if ([result[@"RS100013"][@"goods_list"] isKindOfClass:[NSArray class]]) {
                    [result[@"RS100013"][@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
                        if (!searchedResultsArray) {
                            searchedResultsArray = [[NSMutableArray alloc] init];
                        }
                        [searchedResultsArray addObject:product];
                    }];
                    
                    siftedResultsArray = [searchedResultsArray mutableCopy];
                    [_mainTableView reloadData];
                    pageNum ++;
                } else if (searchedResultsArray.count == 0) {
                    _noSearchResultsView.hidden = NO;
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            
            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainTableView) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
            [self getSearchedSupplierResults];
        }
    }
}

#pragma mark - Actions
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)endCityButtonClicked:(id)sender {
    [self setWalkTypeTableViewHidden:YES];
    if (_endCityTableView.hidden == YES) {
        [self setDestinationCityTableViewHidden:NO];
        _darkMask.alpha = 1.0;
        
        if (!selectedCell_Destination) {
            selectedCell_Destination = (TourListCell_Destination *)[_endCityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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

- (IBAction)falseSearchButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)locationButtonClicked:(id)sender {
    // go to switch city
    SwitchCityViewController *switchCity = [[SwitchCityViewController alloc] init];
    switchCity.isFromSupplierList = NO;
    switchCity.isFromSupplierSearchResults = YES;
    switchCity.isFromTourList = NO;
    [self.navigationController pushViewController:switchCity animated:YES];
}

- (void)switchCityWithCityName:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    [[Global sharedGlobal] upDateLocationCity:info[@"startcity"]];
    [_locationButton setTitle:info[@"startcity"] forState:UIControlStateNormal];
    
    pageNum = 1;
    isRefreshing = YES;
    [self getSearchedSupplierResults];
}

#pragma mark - Private
- (void)setDestinationCityTableViewHidden:(BOOL)hidden
{
    _endCityTableView.hidden = hidden;
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
    if (_accompanyInfoView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
        [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _accompanyInfoView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

- (void)showAccompanyInfoView
{
    [self.view insertSubview:_darkMask aboveSubview:_endCityTableView];
    
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height-_accompanyInfoView.frame.size.height, SCREEN_WIDTH, _accompanyInfoView.frame.size.height)];
    }];
}

// show/hide ShareView
- (void)showShareView
{
    [self.view insertSubview:_darkMask aboveSubview:_endCityTableView];

    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height-_shareView.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    }];
}

- (void)hideShareViewWithCompletionBlock:(void (^)())block
{
    if (_shareView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

- (void)siftProductsWithWalkType:(WalkType)type
{
    if (type == All_Kinds) {
        siftedResultsArray = [searchedResultsArray mutableCopy];
        return;
    }
    
    [siftedResultsArray removeAllObjects];
    [searchedResultsArray enumerateObjectsUsingBlock:^(SupplierProduct *product, NSUInteger idx, BOOL *stop) {
        if ([product.productWalkType integerValue] == type) {
            [siftedResultsArray addObject:product];
        }
    }];
}

// evaluate user status
- (BOOL)ifNotLogin {
    if (![UserModel companyId] || ![UserModel staffId]) {
        // go to login page
        [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (BOOL)ifShopNameNotSet {
    if (![UserModel staffDepartmentName]) {
        SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
        [self.navigationController pushViewController:setName animated:YES];
        return NO;
    }
    return YES;
}
- (BOOL)ifShopContactNotSet {
    if (![UserModel staffRealName]) {
        SetShopContactViewController *setContact = [[SetShopContactViewController alloc] init];
        [self.navigationController pushViewController:setContact animated:YES];
        return NO;
    }
    return YES;
}


@end
