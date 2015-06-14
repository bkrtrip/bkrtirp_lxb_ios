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
#import "AppMacro.h"
#import <CoreLocation/CoreLocation.h>
#import "Global.h"
#import "ReusableHeaderView_OnlineShop.h"
#import "ReusableHeaderView_myShop.h"
#import "YesOrNoView.h"
#import "MicroShopDetailViewController.h"
#import "SetShopNameViewController.h"
#import "MyShopWebPreviewViewController.h"

@interface MicroShopViewController ()<CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ReusableHeaderView_myShop_Delegate, MicroShopCollectionViewCell_MyShop_Delegate, YesOrNoViewDelegate>
{
    NSString *startProvince;
    NSNumber *shopIdToDelete;
    BOOL onLineListNeedsUpdate;
    BOOL myListNeedsUpdate;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) IBOutlet UIButton *onlineShopButton;
@property (strong, nonatomic) IBOutlet UIButton *myShopButton;
- (IBAction)myShopButtonClicked:(id)sender;
- (IBAction)onlineShopButtonClicked:(id)sender;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) MicroShopCollectionView *onlineShopCollectionView;
@property (nonatomic, strong) MicroShopCollectionView *myShopCollectionView;

@property (strong, nonatomic) UIControl *darkMask;
@property (nonatomic, strong) YesOrNoView *yesOrNoView;
@property (strong, nonatomic) UILabel *changeStatusLabel;

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
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopListNeedsUpdate) name:@"SHOP_LIST_NEEDS_UPDATE" object:self];
    
    CGFloat scrollViewYOrigin = 0.277*SCREEN_HEIGHT;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewYOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - scrollViewYOrigin - 49)];
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
    _changeStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.15*SCREEN_WIDTH, 0.4*SCREEN_HEIGHT, 0.7*SCREEN_WIDTH, 55.f)];
    _changeStatusLabel.backgroundColor = [UIColor whiteColor];
    _changeStatusLabel.text = @"默认";
    _changeStatusLabel.textColor = TEXT_333333;
    _changeStatusLabel.font = [UIFont systemFontOfSize:14.f];
    _changeStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_changeStatusLabel];
    _changeStatusLabel.hidden = YES;
    
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
    
    [self addLongPressGestureRecognizerForMyShop];
    [self shopListNeedsUpdate];
    
    // --TEST--
    startProvince = @"陕西";
    
    [_locationButton setTitle:@"正在定位..." forState:UIControlStateNormal];
    [self startLocation];
}

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
        MicroShopInfo *selInfo = _myShopsArray[indexPath.row];
        TemplateDefaultStatus status = [selInfo.shopIsDefault intValue];
        
        if (status == Is_Default) {
            _changeStatusLabel.textColor = TEXT_333333;
        } else {
            _changeStatusLabel.textColor = TEXT_CCCCD2;
        }
        _darkMask.alpha = 1.f;
        _changeStatusLabel.hidden = NO;

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (startProvince) {
        self.selectedIndex = _selectedIndex;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    switch (_selectedIndex) {
        case 0:
        {
            if (_onlineShopButton.selected == NO) {
                _onlineShopButton.selected = YES;
                _myShopButton.selected = NO;
            }
            if (_scrollView.contentOffset.x != 0) {
                [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, 0, 0) animated:YES];
            }
            
            if (onLineListNeedsUpdate) {
                if (!_onlineShopsArray) {
                    _onlineShopsArray = [[NSMutableArray alloc] init];
                } else {
                    [_onlineShopsArray removeAllObjects];
                }
                [self getOnlineShops];
            }
        }
            break;
        case 1:
        {
            if (_onlineShopButton.selected == YES) {
                _onlineShopButton.selected = NO;
                _myShopButton.selected = YES;
            }
            if (_scrollView.contentOffset.x != _scrollView.frame.size.width) {
                [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, _scrollView.frame.size.width, 0) animated:YES];
            }
            
            if (myListNeedsUpdate) {
                if (!_myShopsArray) {
                    _myShopsArray = [[NSMutableArray alloc] init];
                } else {
                    [_myShopsArray removeAllObjects];
                }
                [self getMyShops];
            }
        }
            break;
        default:
            break;
    }
}

- (void)shopListNeedsUpdate
{
    onLineListNeedsUpdate = YES;
    myListNeedsUpdate = YES;
}

#pragma mark - Locating part
//开始定位
- (void)startLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1.0f;
    [_locationManager startUpdatingLocation];
    
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启定位:设置 > 隐私 > 位置 > 定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//        [alert show];
    } else {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"定位失败，请开启定位:设置 > 隐私 > 位置 > 定位服务 下 XX应用" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//            [alert show];
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
//        [_locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
}

#pragma mark - CLLocationManagerDelegate

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    CLLocation *newLocation = [locations objectAtIndex:0];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            // locality(城市)
            NSLog(@"%@", test);
            startProvince = [test objectForKey:@"State"];
            if ([startProvince hasSuffix:@"省"]) {
                startProvince = [startProvince substringWithRange:NSMakeRange(0, startProvince.length-1)];
            }
            [_locationButton setTitle:startProvince forState:UIControlStateNormal];
            
            // segment initial status
            self.selectedIndex = 0;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//    [alert show];
}

#pragma mark - HTTP
- (void)getOnlineShops
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getOnlineMicroShopListWithProvince:startProvince companyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100002"] succeed:^{
                if ([result[@"RS100002"] isKindOfClass:[NSArray class]]) {
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
                            [tempDict setObject:tempArray2 forKey:@"classify_template"];
                        }
                        [_onlineShopsArray addObject:tempDict];
                    }];
                    [_onlineShopCollectionView reloadData];
                    onLineListNeedsUpdate = NO;
                    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                }
            } fail:^(id result) {
            }];
        } fail:^(NSError *error) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getOnlineMicroShopListWithProvince:startProvince success:^(id result) {
            
        } fail:^(NSError *error) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)getMyShops
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getMyMicroShopListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            if ([result[@"RS100005"] isKindOfClass:[NSArray class]]) {
                [result[@"RS100005"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                    [_myShopsArray addObject:info];
                }];
                [_myShopCollectionView reloadData];
                myListNeedsUpdate = NO;
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            }
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getMyMicroShopListWithSuccess:^(id result) {
            if ([result[@"RS100048"] isKindOfClass:[NSArray class]]) {
                [result[@"RS100048"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                    [_myShopsArray addObject:info];
                }];
                [_myShopCollectionView reloadData];
                myListNeedsUpdate = NO;
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            }
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)deleteMyShopWithShopId:(NSNumber *)shopId
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool deleteMyShopWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] shopId:shopId success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100006"] succeed:^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除模板成功" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//            [alert show];
            [self shopListNeedsUpdate];
            self.selectedIndex = _selectedIndex;
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        } fail:^(id result) {
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除模板失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _onlineShopCollectionView) {
        return _onlineShopsArray.count;
    } else if (collectionView == _myShopCollectionView) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _onlineShopCollectionView) {
        return [[_onlineShopsArray[section] objectForKey:@"classify_template"] count];
    } else if (collectionView == _myShopCollectionView) {
        return _myShopsArray.count + 1;
    } else {
        return 0;
    }
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
        MicroShopInfo *curShop = _myShopsArray[indexPath.row];
        if ([UserModel companyId] && [UserModel staffId]) {
            // go to set user info page
            if (![UserModel staffRealName] || ![UserModel staffDepartmentName]) {
                SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
                [self.navigationController pushViewController:setName animated:YES];
            } else {
                // go to webview
                MyShopWebPreviewViewController *web = [[MyShopWebPreviewViewController alloc] init];
                web.ShopURLString = [_myShopsArray[indexPath.row] shopPreviewURLString];
                [self.navigationController pushViewController:web animated:YES];
            }
        } else {
            [self.navigationController pushViewController:[[Global sharedGlobal] loginViewControllerFromSb] animated:YES];
        }
    }
    
    // add to my shop cell clicked
    if (collectionView == _myShopCollectionView && indexPath.row == _myShopsArray.count) {
        self.selectedIndex = 0;
    }
}

#pragma mark - ReusableHeaderView_myShop_Delegate
- (void)supportClickWithInstructions
{
    // go to webview
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
        [self deleteMyShopWithShopId:shopIdToDelete];
    }
}

#pragma mark - Private methods
- (void)hideDeleteActionSheet
{
    [UIView animateWithDuration:0.4 animations:^{
        _changeStatusLabel.hidden = YES;
        _darkMask.alpha = 0;
        [_yesOrNoView setFrame:CGRectOffset(_yesOrNoView.frame, 0, _yesOrNoView.containerView.frame.size.height)];
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
        [_yesOrNoView setFrame:CGRectOffset(_yesOrNoView.frame, 0, -_yesOrNoView.containerView.frame.size.height)];
    }];
}

@end
