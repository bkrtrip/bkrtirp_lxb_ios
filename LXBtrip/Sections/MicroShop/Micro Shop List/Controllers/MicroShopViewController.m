//
//  MicroShopViewController.m
//  
//
//  Created by Yang Xiaozhu on 15/5/23.
//
//

#import "MicroShopViewController.h"
#import "MicroShopCollectionView.h"
#import "MicroShopFlowLayout.h"
#import "MicroShopCollectionViewCell_OnlineShop.h"
#import "MicroShopCollectionViewCell_MyShop.h"
#import "AddShopCollectionViewCell.h"
#import "ReusableHeaderView_OnlineShop.h"
#import "ReusableHeaderView_myShop.h"
#import "YesOrNoView.h"
#import "MicroShopDetailViewController.h"
#import "SetShopNameViewController.h"
#import "SetShopContactViewController.h"
#import "MyShopWebPreviewViewController.h"

@interface MicroShopViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ReusableHeaderView_myShop_Delegate, MicroShopCollectionViewCell_MyShop_Delegate, YesOrNoViewDelegate>
{
    NSString *locationProvince;
    NSNumber *shopIdToDelete;
    UIRefreshControl *refreshControl_online;
    UIRefreshControl *refreshControl_myshop;
    MicroShopInfo *selectedShop;
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UIButton *onlineShopButton;
@property (strong, nonatomic) IBOutlet UIButton *myShopButton;
- (IBAction)myShopButtonClicked:(id)sender;
- (IBAction)onlineShopButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *colorBarImageView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) MicroShopCollectionView *onlineShopCollectionView;
@property (nonatomic, strong) MicroShopCollectionView *myShopCollectionView;

@property (strong, nonatomic) UIControl *darkMask;
@property (nonatomic, strong) YesOrNoView *yesOrNoView;
@property (strong, nonatomic) UIButton *changeStatusButton;

@property (nonatomic, copy) NSMutableArray *onlineShopsArray;
@property (nonatomic, copy) NSMutableArray *myShopsArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MicroShopViewController

- (id)init
{
    self = [super init];
    if (self) {
        // tabBarItem
        UIImage *normal = [ImageNamed(@"shop_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [ImageNamed(@"shop_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微店" image:normal selectedImage:selected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // must override superclass
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myShopListNeedsUpdate) name:@"SHOP_LIST_NEEDS_UPDATE" object:nil]; // This one is from MicroShopDetailViewController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myShopListNeedsUpdate) name:UPDATE_ALL_LIST_WITH_LOGINING_SUCCESS object:nil]; // This one is from LoginViewController
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(provinceChanged) name:PROVINCE_CHANGED object:nil];
    
    CGFloat scrollViewYOrigin = 20.f + 52.f + 3.f;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewYOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - scrollViewYOrigin - 49.f)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    // dark mask
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(hideDeleteActionSheet) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
    
    // yes or no view
    _yesOrNoView = [[NSBundle mainBundle] loadNibNamed:@"YesOrNoView" owner:nil options:nil][0];
    [_yesOrNoView setYesOrNoViewWithIntroductionString:@"删除微店后，如需再次使用，请进入在线微店重新添加到我的微店，且微店自动展示已选供应商的产品！" confirmString:@"现在是否要删除此微店？"];
    [_yesOrNoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _yesOrNoView.containerView.frame.size.height)];
    _yesOrNoView.delegate = self;
    [self.view addSubview:_yesOrNoView];
    
    // change status label
    _changeStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(0.15*SCREEN_WIDTH, 0.4*SCREEN_HEIGHT, 0.7*SCREEN_WIDTH, 55.f)];
    _changeStatusButton.backgroundColor = [UIColor whiteColor];
    [_changeStatusButton setTitle:@"默认" forState:UIControlStateNormal];
    [_changeStatusButton setTitle:@"默认" forState:UIControlStateDisabled];

    [_changeStatusButton setTitleColor:TEXT_333333 forState:UIControlStateNormal];
    [_changeStatusButton setTitleColor:TEXT_CCCCD2 forState:UIControlStateDisabled];
    _changeStatusButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_changeStatusButton addTarget:self action:@selector(changeShopLockStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeStatusButton];
    _changeStatusButton.hidden = YES;
    
    // online shop collection view
    MicroShopFlowLayout *flow_Online = [[MicroShopFlowLayout alloc] init];
    _onlineShopCollectionView = [[MicroShopCollectionView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:flow_Online];
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"MicroShopCollectionViewCell_OnlineShop" bundle:nil] forCellWithReuseIdentifier:@"MicroShopCollectionViewCell_OnlineShop"];
    
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_OnlineShop" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_OnlineShop"];
    
    _onlineShopCollectionView.dataSource = self;
    _onlineShopCollectionView.delegate = self;
    _onlineShopCollectionView.backgroundColor = [UIColor whiteColor];
    _onlineShopCollectionView.alwaysBounceVertical = YES;
    [_scrollView addSubview:_onlineShopCollectionView];
    
    // online shop collection view
    MicroShopFlowLayout *flow_MyShop = [[MicroShopFlowLayout alloc] init];

    _myShopCollectionView = [[MicroShopCollectionView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:flow_MyShop];
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"MicroShopCollectionViewCell_MyShop" bundle:nil] forCellWithReuseIdentifier:@"MicroShopCollectionViewCell_MyShop"];
    
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"AddShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddShopCollectionViewCell"];
    
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_myShop" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_myShop"];

    _myShopCollectionView.dataSource = self;
    _myShopCollectionView.delegate = self;
    _myShopCollectionView.backgroundColor = [UIColor whiteColor];
    _myShopCollectionView.alwaysBounceVertical = YES;
    [_scrollView addSubview:_myShopCollectionView];
    
    [_scrollView setContentSize:CGSizeMake(2*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    
    refreshControl_online = [[UIRefreshControl alloc] init];
    [refreshControl_online addTarget:self action:@selector(refreshCollectionViews:) forControlEvents:UIControlEventValueChanged];
    [_onlineShopCollectionView addSubview:refreshControl_online];
    
    refreshControl_myshop = [[UIRefreshControl alloc] init];
    [refreshControl_myshop addTarget:self action:@selector(refreshCollectionViews:) forControlEvents:UIControlEventValueChanged];
    [_myShopCollectionView addSubview:refreshControl_myshop];
    
    [self addLongPressGestureRecognizerForMyShop];
    
    // initial status
    locationProvince = [[Global sharedGlobal] locationProvince];
    if (!locationProvince) {
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(fetchDefaultWholeCountryData) userInfo:nil repeats:NO];
    } else {
        [self fetchDefaultWholeCountryData];
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

#pragma mark - LongPressGestureRecognizer part
- (void)addLongPressGestureRecognizerForMyShop
{
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [_myShopCollectionView addGestureRecognizer:longPressGr];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_myShopCollectionView];
        NSIndexPath * indexPath = [_myShopCollectionView indexPathForItemAtPoint:point];
        if(indexPath == nil)
            return ;
        //add your code here
        selectedShop = _myShopsArray[indexPath.row];
        NSInteger lockStatus = [selectedShop.shopIsLock intValue];
        
        if (lockStatus == 0) {
            [_changeStatusButton setEnabled:YES];;
        } else {
            [_changeStatusButton setEnabled:NO];;
        }
        _darkMask.alpha = 1.f;
        _changeStatusButton.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark - NSTimer part
- (void)fetchDefaultWholeCountryData
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

    locationProvince = [[Global sharedGlobal] locationProvince];
    if (!locationProvince) {
        locationProvince = @"全国";
        [[Global sharedGlobal] upDateLocationProvince:locationProvince];
    }
    if ([UserModel companyId] && [UserModel staffId]) {
        if ([[Global sharedGlobal] notFirstLogin] == YES) {
            self.selectedIndex = 1;
        } else {
            self.selectedIndex = 0;
        }
    } else {
        self.selectedIndex = 0;
    }
}

#pragma mark - Actions
- (void)changeShopLockStatus
{
    [HTTPTool lockMicroshopWithShopId:selectedShop.shopId companyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100044"] succeed:^{
            [self getMyShops];
            [self getOnlineShops];
            _changeStatusButton.hidden = YES;
            _darkMask.alpha = 0;
            self.tabBarController.tabBar.hidden = NO;
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"锁定微店失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}
- (void)refreshCollectionViews:(id)sender
{
    if (_selectedIndex == 0) {
        if (locationProvince) {
            [self getOnlineShops];
        } else {
            [sender endRefreshing];
        }
    }
    [self getMyShops];
}

- (void)deleteMyShopWithShopId:(NSNumber *)shopId
{
    [HTTPTool deleteMyShopWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] shopId:shopId success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100006"] succeed:^{
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除模板成功" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            //            [alert show];
            
            self.selectedIndex = _selectedIndex;
            
            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getMyShops];
            [self getOnlineShops];
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除模板失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Notification Handlers
- (void)myShopListNeedsUpdate
{
    [self getMyShops];
    [self getOnlineShops];
}

- (void)provinceChanged
{
    locationProvince = [[Global sharedGlobal] locationProvince];
    if (locationProvince) {
        [self getOnlineShops];
    }
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = SCREEN_WIDTH/(828.f/304.f) + 52.f + 3.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin - 49.f];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - HTTP
- (void)getOnlineShops
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getOnlineMicroShopListWithProvince:locationProvince companyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_online endRefreshing];
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100002"] succeed:^{
                if ([result[@"RS100002"] isKindOfClass:[NSArray class]]) {
                    
                    if (!_onlineShopsArray) {
                        _onlineShopsArray = [[NSMutableArray alloc] init];
                    } else {
                        [_onlineShopsArray removeAllObjects];
                    }
                    
                    [result[@"RS100002"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                        if ([obj[@"classify_name"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_name"]) {
                            [tempDict setObject:obj[@"classify_name"] forKey:@"classify_name"];
                        }
                        if ([obj[@"classify_template"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_template"]) {
                            
                            NSArray *tempArray = [obj[@"classify_template"] copy];
                            NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
                            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                                [tempArray2 addObject:info];
                            }];
                            tempArray2 = [[self sortOnlineShopsSectionByOrderNoAscendingWithSection:tempArray2] mutableCopy];
                            [tempDict setObject:tempArray2 forKey:@"classify_template"];
                        }
                        [_onlineShopsArray addObject:tempDict];
                    }];
                    
                    [_onlineShopCollectionView reloadData];
                }
            }];
        } fail:^(NSError *error) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_online endRefreshing];

            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getOnlineMicroShopListWithProvince:locationProvince success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_online endRefreshing];

            [[Global sharedGlobal] codeHudWithObject:result[@"RS100001"] succeed:^{
                if ([result[@"RS100001"] isKindOfClass:[NSArray class]]) {
                    
                    if (!_onlineShopsArray) {
                        _onlineShopsArray = [[NSMutableArray alloc] init];
                    } else {
                        [_onlineShopsArray removeAllObjects];
                    }
                    
                    [result[@"RS100001"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                        if ([obj[@"classify_name"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_name"]) {
                            [tempDict setObject:obj[@"classify_name"] forKey:@"classify_name"];
                        }
                        if ([obj[@"classify_template"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_template"]) {
                            
                            NSArray *tempArray = [obj[@"classify_template"] copy];
                            NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
                            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                                [tempArray2 addObject:info];
                            }];
                            tempArray2 = [[self sortOnlineShopsSectionByOrderNoAscendingWithSection:tempArray2] mutableCopy];
                            [tempDict setObject:tempArray2 forKey:@"classify_template"];
                        }
                        [_onlineShopsArray addObject:tempDict];
                    }];
                    [_onlineShopCollectionView reloadData];
                }
            }];
        } fail:^(NSError *error) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_online endRefreshing];

            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)getMyShops
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getMyMicroShopListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_myshop endRefreshing];
            
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100005"] succeed:^{
                if ([result[@"RS100005"] isKindOfClass:[NSArray class]]) {
                    
                    if (!_myShopsArray) {
                        _myShopsArray = [[NSMutableArray alloc] init];
                    } else {
                        [_myShopsArray removeAllObjects];
                    }
                    
                    [result[@"RS100005"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                        [_myShopsArray addObject:info];
                    }];
                    [_myShopCollectionView reloadData];
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_myshop endRefreshing];
            
            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getMyMicroShopListWithSuccess:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_myshop endRefreshing];

            [[Global sharedGlobal] codeHudWithObject:result[@"RS100048"] succeed:^{
                if ([result[@"RS100048"] isKindOfClass:[NSArray class]]) {
                    
                    if (!_myShopsArray) {
                        _myShopsArray = [[NSMutableArray alloc] init];
                    } else {
                        [_myShopsArray removeAllObjects];
                    }
                    
                    [result[@"RS100048"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                        [_myShopsArray addObject:info];
                    }];
                    [_myShopCollectionView reloadData];
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [refreshControl_myshop endRefreshing];

            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _onlineShopCollectionView) {
        return _onlineShopsArray.count;
    }
    
    if (collectionView == _myShopCollectionView) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _onlineShopCollectionView) {
        if (!_onlineShopsArray) {
            return 0;
        }
        return [[_onlineShopsArray[section] objectForKey:@"classify_template"] count];
    }
    
    if (collectionView == _myShopCollectionView) {
        if (!_myShopsArray) {
            return 0;
        }
        return _myShopsArray.count + 1;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // online shop
    if (collectionView == _onlineShopCollectionView) {
        MicroShopCollectionViewCell_OnlineShop *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MicroShopCollectionViewCell_OnlineShop" forIndexPath:indexPath];
        NSArray *subArray = [_onlineShopsArray[indexPath.section] objectForKey:@"classify_template"];
        MicroShopInfo *info = subArray[indexPath.row];
        [cell setCellContentWithMicroShopInfo:info];
        return cell;
    } else if (collectionView == _myShopCollectionView) {
        if (indexPath.row < _myShopsArray.count) {
            MicroShopCollectionViewCell_MyShop *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MicroShopCollectionViewCell_MyShop" forIndexPath:indexPath];
            MicroShopInfo *info = _myShopsArray[indexPath.row];
            [cell setCellContentWithMicroShopInfo:info];
            cell.delegate = self;
            return cell;
        } else if (indexPath.row == _myShopsArray.count) {
            // '+'
            AddShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddShopCollectionViewCell" forIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _onlineShopCollectionView) {
        ReusableHeaderView_OnlineShop *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_OnlineShop" forIndexPath:indexPath];
        header.sectionHeaderNameLabel.text = [_onlineShopsArray[indexPath.section] objectForKey:@"classify_name"];
        return header;
    }
    
    ReusableHeaderView_myShop *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_myShop" forIndexPath:indexPath];
    header.delegate = self;
    return header;

}

#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 50.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // jump to detail
    if (collectionView == _onlineShopCollectionView) {
        MicroShopDetailViewController *detail = [[MicroShopDetailViewController alloc] init];
        
        NSArray *subSectionArray = [_onlineShopsArray[indexPath.section] valueForKey:@"classify_template"];
        MicroShopInfo *curInfo = subSectionArray[indexPath.row];
        detail.shopId = curInfo.shopId;
        //是否使用 0：使用，1：未使用
        if (curInfo.shopIsUse) {
            if ([curInfo.shopIsUse intValue] == 0) {
                detail.isMyShop = YES;
            } else {
                detail.isMyShop = NO;
            }
        }
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    
    if (collectionView == _myShopCollectionView && indexPath.row < _myShopsArray.count) {
        if ([UserModel companyId] && [UserModel staffId]) {
            // set shop name if void
            if (![UserModel staffDepartmentName]) {
                SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
                [self.navigationController pushViewController:setName animated:YES];
                return ;
            }
            
            // set shop contact if void
            if (![UserModel staffRealName]) {
                SetShopContactViewController *setContact = [[SetShopContactViewController alloc] init];
                [self.navigationController pushViewController:setContact animated:YES];
                return ;
            }
            
            // go to webview
            MyShopWebPreviewViewController *web = [[MyShopWebPreviewViewController alloc] init];
            web.title = @"我的微店";
            web.ShopURLString = [_myShopsArray[indexPath.row] shopPreviewURLString];
            [self.navigationController pushViewController:web animated:YES];
        } else {
            [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
        }
    }
    
    // add to my shop cell clicked
    if (collectionView == _myShopCollectionView && indexPath.row == _myShopsArray.count) {
        if (![UserModel companyId] || ![UserModel staffId]) {
            [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
            return;
        }
        self.selectedIndex = 0;
    }
}

#pragma mark - ReusableHeaderView_myShop_Delegate
- (void)supportClickWithInstructions
{
    // go to webview
    MyShopWebPreviewViewController *web = [[MyShopWebPreviewViewController alloc] init];
    web.title = @"微商运营指导";
    web.ShopURLString = MICRO_SHOP_INSTRUCTIONS_URL;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - MicroShopCollectionViewCell_MyShop_Delegate
- (void)supportClickWithDeleteShopId:(NSNumber *)shopId
{
    shopIdToDelete = shopId;
    
    [self showDeleteActionSheet];
}

- (IBAction)myShopButtonClicked:(id)sender {
    self.selectedIndex = 1;
}

- (IBAction)onlineShopButtonClicked:(id)sender {
    self.selectedIndex = 0;
}

#pragma mark - YesOrNoViewDelegate
- (void)supportClickWithNo
{
    [self hideDeleteActionSheet];
}

- (void)supportClickWithYes
{
    if (shopIdToDelete) {
        [self hideDeleteActionSheet];
        
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
        [self deleteMyShopWithShopId:shopIdToDelete];
    }
}

#pragma mark - Private methods
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    switch (_selectedIndex) {
        case 0:
        {
            _colorBarImageView.image = ImageNamed(@"colorbar_left");
            if (_myShopButton.selected == YES) {
                _myShopButton.selected = NO;
            }
            _onlineShopButton.selected = YES;
            if (_scrollView.contentOffset.x != 0) {
                [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, 0, 0) animated:YES];
            }
            
            if (!_onlineShopsArray) {
                if (locationProvince) {
                    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
                    [self getOnlineShops];
                }
            }
        }
            break;
        case 1:
        {
            _colorBarImageView.image = ImageNamed(@"colorbar_right");
            if (_onlineShopButton.selected == YES) {
                _onlineShopButton.selected = NO;
            }
            _myShopButton.selected = YES;
            if (_scrollView.contentOffset.x != _scrollView.frame.size.width) {
                [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, _scrollView.frame.size.width, 0) animated:YES];
            }
            
            if (!_myShopsArray) {
                [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
                [self getMyShops];
            }
        }
            break;
        default:
            break;
    }
}

- (void)hideDeleteActionSheet
{
    [UIView animateWithDuration:0.4 animations:^{
        _changeStatusButton.hidden = YES;
        _darkMask.alpha = 0;
        [_yesOrNoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _yesOrNoView.containerView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.tabBarController.tabBar.hidden = NO;
        }
    }];
}

- (void)showDeleteActionSheet
{
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBarController.tabBar.hidden = YES;
        _darkMask.alpha = 1;
        [_yesOrNoView setFrame:CGRectMake(0, SCREEN_HEIGHT - _yesOrNoView.containerView.frame.size.height, SCREEN_WIDTH, _yesOrNoView.containerView.frame.size.height)];
    }];
}

- (NSArray *)sortOnlineShopsSectionByOrderNoAscendingWithSection:(NSArray *)section
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"shopOrderNum" ascending:YES];
    return [[section sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
}

@end
