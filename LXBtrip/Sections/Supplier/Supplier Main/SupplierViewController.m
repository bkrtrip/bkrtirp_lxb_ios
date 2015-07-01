//
//  SupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierViewController.h"
#import "SupplierCollectionView.h"
#import "SupplierCollectionViewCell.h"
#import "SupplierCollectionViewFlowLayout.h"
#import "ReusableHeaderView_Supplier.h"
#import "SupplierDetailViewController.h"
#import "SwitchCityViewController.h"
#import "SiftSupplierViewController.h"
#import "MySupplierViewController.h"
#import "SearchSupplierViewController.h"
#import "InviteSupplierTableViewCell_First.h"
#import "InviteSupplierTableViewCell_Second.h"
#import "InviteSupplierTableViewCell_Third.h"
#import "InviteSupplierTableViewCell_Fourth.h"
#import "MyShopWebPreviewViewController.h"

@interface SupplierViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, InviteSupplierTableViewCell_Fourth_Delegate>
{
    NSString *locationCity;
    NSString *startCity;
    NSString *lineClass;

    NSMutableArray *isLoadingMoresArray;
    NSMutableArray *pageNumsArray;
    NSMutableArray *collectionViewsArray;
    NSMutableArray *refreshControlsArray;
    NSMutableArray *noSuppliersArray;
    NSMutableArray *lineTypesArray;
}

//navigationbar part
- (IBAction)selectButtonClicked:(id)sender;
- (IBAction)myButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)searchProductButtonClicked:(id)sender;

//专线part
@property (strong, nonatomic) IBOutlet UIButton *zhuanXianButton;
@property (strong, nonatomic) IBOutlet UIButton *domesticButton_zhuanXian;
- (IBAction)domesticButton_zhuanXianClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *abroadButton_zhuanXian;
- (IBAction)abroadButton_zhuanXianClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nearbyButton_zhuanXian;
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender;

// 地接part
@property (strong, nonatomic) IBOutlet UIButton *diJieButton;
@property (strong, nonatomic) IBOutlet UIButton *domesticButton_diJie;
- (IBAction)domesticButton_diJieClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *abroadBUtton_diJie;
- (IBAction)abroadBUtton_diJieClicked:(id)sender;

// invite supplier table view
@property (strong, nonatomic) UIControl *darkMask;
@property (strong, nonatomic) UITableView *inviteTableView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *underLineLabel;

@property (nonatomic, copy) NSMutableArray *suppliersArray;

@property (nonatomic, assign) NSInteger selectedIndex; // 0~4

@end

@implementation SupplierViewController

- (id)init
{
    self = [super init];
    if (self) {
        // tabBarItem
        UIImage *normal = [ImageNamed(@"provider_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [ImageNamed(@"provider_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"供应商" image:normal selectedImage:selected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSupplierList) name:@"MY_SHOP_HAS_UPDATED" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCityWithCityName:) name:SWITCH_CITY_SUPPLIER_LIST object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siftSupplierWithLineClassAndLineType:) name:@"SIFT_SUPPLIER_WITH_LINE_CLASS_AND_LINE_TYPE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged_SupplierList) name:CITY_CHANGED object:nil];

    CGFloat yOrigin = 20.f + 44.f + 82.f;
    
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, (SCREEN_WIDTH/2.f)/3, 2)];
    _underLineLabel.backgroundColor = TEXT_4CA5FF;
    [self.view addSubview:_underLineLabel];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin - 49.f)];
    [_scrollView setContentSize:CGSizeMake(5*SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin - 49.f)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    lineTypesArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSString *lineType = @"";
        [lineTypesArray addObject:lineType];
    }
    collectionViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
    refreshControlsArray = [[NSMutableArray alloc] initWithCapacity:5];
    noSuppliersArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        SupplierCollectionViewFlowLayout *flow = [[SupplierCollectionViewFlowLayout alloc] init];

        SupplierCollectionView *collectionView = [[SupplierCollectionView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0) collectionViewLayout:flow];
        
        [collectionView registerNib:[UINib nibWithNibName:@"SupplierCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupplierCollectionViewCell"];
        
        [collectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_Supplier" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_Supplier"];

        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.alwaysBounceVertical = YES;
        UIScrollView *scroll = (UIScrollView *)collectionView;
        scroll.delegate = self;
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshCollectionViews:) forControlEvents:UIControlEventValueChanged];
        [collectionView addSubview:refreshControl];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0)];
        bgView.backgroundColor = BG_E9ECF5;
        CGFloat width_height_ratio = 434.f/259.f;
        CGFloat imgHeight = 0.2*bgView.bounds.size.height;
        CGFloat imgWidth = imgHeight*width_height_ratio;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.bounds.size.width - imgWidth)/2.0, 0.2*bgView.bounds.size.height, imgWidth, imgHeight)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.image = ImageNamed(@"no_supplier");
        [bgView addSubview:imgView];
        // no supplier view initially hidden!
        bgView.hidden = YES;

        [_scrollView addSubview:collectionView];
        [_scrollView addSubview:bgView];
        [collectionViewsArray addObject:collectionView];
        [refreshControlsArray addObject:refreshControl];
        [noSuppliersArray addObject:bgView];
    }
    
    // dark mask
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(hideInviteTableView) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
    
    locationCity = [[Global sharedGlobal] locationCity];
    startCity = [locationCity copy];
    if (startCity) {
        [_locationButton setTitle:startCity forState:UIControlStateNormal];
        _selectedIndex = 0;
        [self refreshSupplierList];
    }
}

- (void)refreshCollectionViews:(id)sender
{
    if (startCity) {
        pageNumsArray[_selectedIndex] = @1;
        isLoadingMoresArray[_selectedIndex] = @0;
        [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineTypesArray[_selectedIndex]];
    } else {
        [sender endRefreshing];
    }
}

#pragma mark - Notification Handler
- (void)refreshSupplierList
{
    if (startCity) {
        _suppliersArray = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [_suppliersArray addObject:array];
        }
        
        lineClass = LINE_CLASS[@(_selectedIndex)];
        pageNumsArray = [[NSMutableArray alloc] initWithObjects:@1, @1, @1, @1, @1, nil];
        isLoadingMoresArray = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, nil];
        
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineTypesArray[_selectedIndex]];
    }
}

- (void)switchCityWithCityName:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    [_locationButton setTitle:info[@"startcity"] forState:UIControlStateNormal];
    startCity = info[@"startcity"];
    
    [self refreshSupplierList];
}

// passed back from SiftSupplierController
- (void)siftSupplierWithLineClassAndLineType:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    _selectedIndex = [info[@"line_class_index"] integerValue];
    lineTypesArray[_selectedIndex] = info[@"line_type"];
    pageNumsArray[_selectedIndex] = @1;
    isLoadingMoresArray[_selectedIndex] = @0;
    
    self.selectedIndex = [info[@"line_class_index"] integerValue];
}

- (void)cityChanged_SupplierList
{
    locationCity = [[Global sharedGlobal] locationCity];
    if (locationCity) {
        startCity = [locationCity copy];
        [_locationButton setTitle:startCity forState:UIControlStateNormal];
        _selectedIndex = 0;
        [self refreshSupplierList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 20.f + 44.f + 82.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin - 49.f];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    lineClass = LINE_CLASS[@(_selectedIndex)];
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}

- (void)hideInviteTableView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_inviteTableView setFrame:CGRectOffset(_inviteTableView.frame, 0, _inviteTableView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.tabBarController.tabBar.hidden = NO;
        }
    }];
}

- (void)showInviteTableView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBarController.tabBar.hidden = YES;
        _darkMask.alpha = 1;
        [_inviteTableView setFrame:CGRectOffset(_inviteTableView.frame, 0, -_inviteTableView.frame.size.height)];
    }];
}

#pragma mark - http
- (void)getSupplierListWithStartCity:(NSString *)city LineClass:(NSString *)class lineType:(NSString *)type
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getSuppliersListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] StartCity:city lineClass:class lineType:type pageNum:pageNumsArray[_selectedIndex] success:^(id result) {
            
            if (!(SCREEN_HEIGHT > 568.0) || ([pageNumsArray[_selectedIndex] integerValue] != 1)) {
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                [refreshControlsArray[_selectedIndex] endRefreshing];
            }

            if ([isLoadingMoresArray[_selectedIndex] integerValue] == 0) {
                [_suppliersArray[_selectedIndex] removeAllObjects];
                isLoadingMoresArray[_selectedIndex] = @1;
                [collectionViewsArray[_selectedIndex] reloadData];
            }
            
            [noSuppliersArray[_selectedIndex] setHidden:YES];
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100010"] succeed:^{
                if ([result[@"RS100010"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = result[@"RS100010"];
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                        //category
                        if ([obj[@"line_type"] isKindOfClass:[NSNull class]]?nil:obj[@"line_type"]) {
                            [tempDict setObject:obj[@"line_type"] forKey:@"line_type"];
                        }
                        //first letter
                        if ([obj[@"line_type_letter"] isKindOfClass:[NSNull class]]?nil:obj[@"line_type_letter"]) {
                            [tempDict setObject:obj[@"line_type_letter"] forKey:@"line_type_letter"];
                        }
                        if ([obj[@"supplier_info"] isKindOfClass:[NSNull class]]?nil:obj[@"supplier_info"]) {
                            
                            NSArray *tempArray = [obj[@"supplier_info"] copy];
                            NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
                            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                SupplierInfo *info = [[SupplierInfo alloc] initWithDict:obj];
                                [tempArray2 addObject:info];
                            }];
                            [tempDict setObject:tempArray2 forKey:@"supplier_info"];
                        }
                        [_suppliersArray[_selectedIndex] addObject:tempDict];
                    }];
                    
                    pageNumsArray[_selectedIndex] = @([pageNumsArray[_selectedIndex] integerValue] + 1);
                    
                    if (SCREEN_HEIGHT > 568.0 && [pageNumsArray[_selectedIndex] integerValue] == 2) {
                        [self getSupplierListWithStartCity:city LineClass:class lineType:type];
                        return ;
                    }
                    
                    [collectionViewsArray[_selectedIndex] reloadData];
                    
                } else {
                    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                    [refreshControlsArray[_selectedIndex] endRefreshing];
                    if ([pageNumsArray[_selectedIndex] intValue] == 1) {
                        [noSuppliersArray[_selectedIndex] setHidden:NO];
                    }
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControlsArray[_selectedIndex] endRefreshing];
            
            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取供应商列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getSuppliersListWithStartCity:city lineClass:class lineType:type pageNum:pageNumsArray[_selectedIndex] success:^(id result) {
            
            if (!(SCREEN_HEIGHT > 568.0) || ([pageNumsArray[_selectedIndex] integerValue] != 1)) {
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                [refreshControlsArray[_selectedIndex] endRefreshing];
            }

            if ([isLoadingMoresArray[_selectedIndex] integerValue] == 0) {
                [_suppliersArray[_selectedIndex] removeAllObjects];
                isLoadingMoresArray[_selectedIndex] = @1;
                [collectionViewsArray[_selectedIndex] reloadData];
            }

            [noSuppliersArray[_selectedIndex] setHidden:YES];
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100009"] succeed:^{
                if ([result[@"RS100009"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = result[@"RS100009"];
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                        //category
                        if ([obj[@"line_type"] isKindOfClass:[NSNull class]]?nil:obj[@"line_type"]) {
                            [tempDict setObject:obj[@"line_type"] forKey:@"line_type"];
                        }
                        //first letter
                        if ([obj[@"line_type_letter"] isKindOfClass:[NSNull class]]?nil:obj[@"line_type_letter"]) {
                            [tempDict setObject:obj[@"line_type_letter"] forKey:@"line_type_letter"];
                        }
                        if ([obj[@"supplier_info"] isKindOfClass:[NSNull class]]?nil:obj[@"supplier_info"]) {
                            
                            NSArray *tempArray = [obj[@"supplier_info"] copy];
                            NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
                            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                SupplierInfo *info = [[SupplierInfo alloc] initWithDict:obj];
                                [tempArray2 addObject:info];
                            }];
                            [tempDict setObject:tempArray2 forKey:@"supplier_info"];
                        }
                        [_suppliersArray[_selectedIndex] addObject:tempDict];
                    }];
                    
                    pageNumsArray[_selectedIndex] = @([pageNumsArray[_selectedIndex] integerValue] + 1);
                    
                    if (SCREEN_HEIGHT > 568.0 && [pageNumsArray[_selectedIndex] integerValue] == 2) {
                        [self getSupplierListWithStartCity:city LineClass:class lineType:type];
                        return ;
                    }
                    
                    [collectionViewsArray[_selectedIndex] reloadData];

                } else {
                    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                    [refreshControlsArray[_selectedIndex] endRefreshing];
                    if ([pageNumsArray[_selectedIndex] intValue] == 1) {
                        [noSuppliersArray[_selectedIndex] setHidden:NO];
                    }
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControlsArray[_selectedIndex] endRefreshing];

            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取供应商列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_suppliersArray[_selectedIndex] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_suppliersArray[_selectedIndex][section] objectForKey:@"supplier_info"] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupplierCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupplierCollectionViewCell" forIndexPath:indexPath];
    if ([[_suppliersArray[_selectedIndex][indexPath.section] objectForKey:@"supplier_info"] count] > indexPath.row) {
        NSArray *subArray = [_suppliersArray[_selectedIndex][indexPath.section] objectForKey:@"supplier_info"];
        SupplierInfo *info = subArray[indexPath.row];
        [cell setCellContentWithSupplierInfo:info];
    } else {
        [cell setCellContentWithSupplierInfo:nil];
    }
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ReusableHeaderView_Supplier *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_Supplier" forIndexPath:indexPath];
    header.sectionHeaderNameLabel.text = [_suppliersArray[_selectedIndex][indexPath.section] objectForKey:@"line_type"];
    return header;
}

#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 23.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_suppliersArray[_selectedIndex][indexPath.section] objectForKey:@"supplier_info"] count] > indexPath.row) {
        // jump to detail
        SupplierDetailViewController *detail = [[SupplierDetailViewController alloc] init];
        NSArray *subSectionArray = [_suppliersArray[_selectedIndex][indexPath.section] valueForKey:@"supplier_info"];
        SupplierInfo *curInfo = subSectionArray[indexPath.row];
        detail.info = curInfo;
        [self.navigationController pushViewController:detail animated:YES];
        return ;
    }
    
    if (![UserModel companyId] || ![UserModel staffId]) {
        [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
        return;
    }
    
    if (!_inviteTableView) {
        CGFloat height = 320.f;
        _inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, height)];
        _inviteTableView.dataSource = self;
        _inviteTableView.delegate = self;
        [self.view addSubview:_inviteTableView];
        
        [_inviteTableView registerNib:[UINib nibWithNibName:@"InviteSupplierTableViewCell_First" bundle:nil] forCellReuseIdentifier:@"InviteSupplierTableViewCell_First"];
        [_inviteTableView registerNib:[UINib nibWithNibName:@"InviteSupplierTableViewCell_Second" bundle:nil] forCellReuseIdentifier:@"InviteSupplierTableViewCell_Second"];
        [_inviteTableView registerNib:[UINib nibWithNibName:@"InviteSupplierTableViewCell_Third" bundle:nil] forCellReuseIdentifier:@"InviteSupplierTableViewCell_Third"];
        [_inviteTableView registerNib:[UINib nibWithNibName:@"InviteSupplierTableViewCell_Fourth" bundle:nil] forCellReuseIdentifier:@"InviteSupplierTableViewCell_Fourth"];
    }
    
    [self showInviteTableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            InviteSupplierTableViewCell_First *cell = (InviteSupplierTableViewCell_First *)[tableView dequeueReusableCellWithIdentifier:@"InviteSupplierTableViewCell_First" forIndexPath:indexPath];
            [cell setCellContentWithInvitationCode:[UserModel userName]];
            return cell;
        }
            break;
        case 1:
        {
            InviteSupplierTableViewCell_Second *cell = (InviteSupplierTableViewCell_Second *)[tableView dequeueReusableCellWithIdentifier:@"InviteSupplierTableViewCell_Second" forIndexPath:indexPath];
            [cell setCellContentWithInvitationWords:@"邀请六家供应商，免费赠送定制版微店一套"];
            return cell;
        }
            break;
        case 2:
        {
            InviteSupplierTableViewCell_Second *cell = (InviteSupplierTableViewCell_Second *)[tableView dequeueReusableCellWithIdentifier:@"InviteSupplierTableViewCell_Second" forIndexPath:indexPath];
            [cell setCellContentWithInvitationWords:@"邀请三家供应商，免费定制设计海报一份"];
            return cell;
        }
            break;
        case 3:
        {
            InviteSupplierTableViewCell_Third *cell = (InviteSupplierTableViewCell_Third *)[tableView dequeueReusableCellWithIdentifier:@"InviteSupplierTableViewCell_Third" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 4:
        {
            InviteSupplierTableViewCell_Fourth *cell = (InviteSupplierTableViewCell_Fourth *)[tableView dequeueReusableCellWithIdentifier:@"InviteSupplierTableViewCell_Fourth" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 50.f;
            break;
        case 1:
            return 45.f;
            break;
        case 2:
            return 45.f;
            break;
        case 3:
            return 70.f;
            break;
        case 4:
            return 110.f;
            break;
        default:
            return 0;
            break;
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            // go to webview
            MyShopWebPreviewViewController *web = [[MyShopWebPreviewViewController alloc] init];
            web.title = @"邀请供应商";
            web.ShopURLString = INVITE_SIX_GIVE_SHOP_URL;
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 2:
        {
            // go to webview
            MyShopWebPreviewViewController *web = [[MyShopWebPreviewViewController alloc] init];
            web.title = @"邀请供应商";
            web.ShopURLString = INVITE_THREE_GIVE_POSTER_URL;
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideInviteTableView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
            isLoadingMoresArray[_selectedIndex] = @1;
//            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineTypesArray[_selectedIndex]];
        }
    }
}

#pragma mark - InviteSupplierTableViewCell_Fourth_Delegate
- (void)supportClickWithQQ
{
    
}
- (void)supportClickWithWeChat
{
    
}
- (void)supportClickWithPhoneCall
{
    
}
- (void)supportClickWithShortMessage
{
    
}

#pragma mark - Actions
- (IBAction)selectButtonClicked:(id)sender {
    SiftSupplierViewController *siftSupplier = [[SiftSupplierViewController alloc] init];
    siftSupplier.startCity = startCity;
    siftSupplier.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    siftSupplier.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:siftSupplier animated:YES completion:nil];
}

- (IBAction)myButtonClicked:(id)sender {
    if ([UserModel companyId]  && [UserModel staffId]) {
        MySupplierViewController *mySupplier = [[MySupplierViewController alloc] init];
        [self.navigationController pushViewController:mySupplier animated:YES];
        return;
    }
    [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
}
- (IBAction)locationButtonClicked:(id)sender {
    SwitchCityViewController *switchCity = [[SwitchCityViewController alloc] init];
    switchCity.isFromTourList = NO;
    switchCity.isFromSupplierList = YES;
    [self.navigationController pushViewController:switchCity animated:YES];
}

- (IBAction)searchProductButtonClicked:(id)sender {
    SearchSupplierViewController *search = [[SearchSupplierViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)domesticButton_zhuanXianClicked:(id)sender {
    if ([lineTypesArray[0] length] > 0) {
        lineTypesArray[0] = @"";
        pageNumsArray[0] = @1;
        isLoadingMoresArray[0] = @0;
    }
    self.selectedIndex = 0;
}
- (IBAction)abroadButton_zhuanXianClicked:(id)sender {
    if ([lineTypesArray[1] length] > 0) {
        lineTypesArray[1] = @"";
        pageNumsArray[1] = @1;
        isLoadingMoresArray[1] = @0;
    }
    self.selectedIndex = 1;
}
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender {
    if ([lineTypesArray[2] length] > 0) {
        lineTypesArray[2] = @"";
        pageNumsArray[2] = @1;
        isLoadingMoresArray[2] = @0;
    }
    self.selectedIndex = 2;
}
- (IBAction)domesticButton_diJieClicked:(id)sender {
    if ([lineTypesArray[3] length] > 0) {
        lineTypesArray[3] = @"";
        pageNumsArray[3] = @1;
        isLoadingMoresArray[3] = @0;
    }
    self.selectedIndex = 3;
}
- (IBAction)abroadBUtton_diJieClicked:(id)sender {
    if ([lineTypesArray[4] length] > 0) {
        lineTypesArray[4] = @"";
        pageNumsArray[4] = @1;
        isLoadingMoresArray[4] = @0;
    }
    self.selectedIndex = 4;
}

- (void)scrollToVisibleWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, index*SCREEN_WIDTH, 0) animated:NO];
        if (index < 3) {
            [_underLineLabel setFrame:CGRectMake(index*(SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.size.height)];
        } else {
            [_underLineLabel setFrame:CGRectMake(SCREEN_WIDTH/2.0 + (index-3)*(SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.size.height)];
        }
    }];
    
    if ([isLoadingMoresArray[index] integerValue] == 0) {
        if (startCity) {
            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineTypesArray[_selectedIndex]];
        }
    }
}
@end
