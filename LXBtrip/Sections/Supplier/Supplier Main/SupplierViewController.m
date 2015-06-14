//
//  SupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppMacro.h"
#import "Global.h"
#import "SupplierCollectionView.h"
#import "SupplierCollectionViewCell.h"
#import "SupplierCollectionViewFlowLayout.h"
#import "ReusableHeaderView_Supplier.h"
#import "SupplierDetailViewController.h"
#import "SwitchCityViewController.h"
#import "SiftSupplierViewController.h"
#import "MySupplierViewController.h"
#import "SearchSupplierViewController.h"

@interface SupplierViewController () <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    NSString *startCity;
    NSString *lineClass;
    NSString *lineType;

    
    NSMutableArray *isLoadingMoresArray;
    NSMutableArray *pageNumsArray;
    NSMutableArray *collectionViewsArray;
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

@property (strong, nonatomic) CLLocationManager *locationManager;


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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCityWithCityName:) name:@"SWITCH_CITY_WITH_CITY_NAME" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siftSupplierWithLineClassAndLineType:) name:@"SIFT_SUPPLIER_WITH_LINE_CLASS_AND_LINE_TYPE" object:nil];
    
    CGFloat yOrigin = 20.f + 44.f + 82.f;
    
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, (SCREEN_WIDTH/2.f)/3, 2)];
    _underLineLabel.backgroundColor = TEXT_4CA5FF;
    [self.view addSubview:_underLineLabel];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, self.view.frame.size.height - yOrigin - 49.f)];
    [_scrollView setContentSize:CGSizeMake(5*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    collectionViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        SupplierCollectionViewFlowLayout *flow = [[SupplierCollectionViewFlowLayout alloc] init];

        SupplierCollectionView *collectionView = [[SupplierCollectionView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0) collectionViewLayout:flow];
        [collectionView registerNib:[UINib nibWithNibName:@"SupplierCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupplierCollectionViewCell"];
        
        [collectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_Supplier" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_Supplier"];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scroll = (UIScrollView *)collectionView;
        scroll.delegate = self;

        [_scrollView addSubview:collectionView];
        [collectionViewsArray addObject:collectionView];
    }

    // --TEST--
    self.selectedIndex = 0;
    startCity = @"西安";
    lineType = nil;
    
    [self refreshSupplierList];
}

- (void)refreshSupplierList
{
    _suppliersArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [_suppliersArray addObject:array];
    }
    
    pageNumsArray = [[NSMutableArray alloc] initWithObjects:@1, @1, @1, @1, @1, nil];
    isLoadingMoresArray = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, nil];
    
    [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    lineClass = LINE_CLASS[@(_selectedIndex)];
}

// passed back from SiftSupplierController
- (void)siftSupplierWithLineClassAndLineType:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    lineClass = info[@"lineclass"];
    lineType = info[@"linetype"];
    
    [self refreshSupplierList];
}

- (void)switchCityWithCityName:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    [_locationButton setTitle:info[@"startcity"] forState:UIControlStateNormal];
    startCity = info[@"startcity"];
    
    [self refreshSupplierList];
}

//开始定位
- (void)startLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1.0f;
    [_locationManager startUpdatingLocation];
    
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启定位:设置 > 隐私 > 位置 > 定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    } else {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"定位失败，请开启定位:设置 > 隐私 > 位置 > 定位服务 下 XX应用" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
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
            NSString *cityString = [test objectForKey:@"State"];
            if ([cityString hasSuffix:@"省"]) {
                cityString = [cityString substringWithRange:NSMakeRange(0, cityString.length-1)];
            }
            [_locationButton setTitle:cityString forState:UIControlStateNormal];
            
            startCity = cityString;
            [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineType];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - http
- (void)getSupplierListWithStartCity:(NSString *)city LineClass:(NSString *)class lineType:(NSString *)type
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    if ([isLoadingMoresArray[_selectedIndex] integerValue] == 0) {
        pageNumsArray[_selectedIndex] = @1;
    }
    
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getSuppliersListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] StartCity:city lineClass:class lineType:type pageNum:pageNumsArray[_selectedIndex] success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
                    [collectionViewsArray[_selectedIndex] reloadData];
                    pageNumsArray[_selectedIndex] = @([pageNumsArray[_selectedIndex] integerValue] + 1);
                }
            } fail:^(id result) {
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取供应商列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getSuppliersListWithStartCity:startCity lineClass:lineClass lineType:nil pageNum:pageNumsArray[_selectedIndex] success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
                    [collectionViewsArray[_selectedIndex] reloadData];
                    pageNumsArray[_selectedIndex] = @([pageNumsArray[_selectedIndex] integerValue] + 1);
                }
            } fail:^(id result) {
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
    return [[_suppliersArray[_selectedIndex][section] objectForKey:@"supplier_info"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupplierCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupplierCollectionViewCell" forIndexPath:indexPath];
    NSArray *subArray = [_suppliersArray[_selectedIndex][indexPath.section] objectForKey:@"supplier_info"];
    SupplierInfo *info = subArray[indexPath.row];
    [cell setCellContentWithSupplierInfo:info];
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
    // jump to detail
    SupplierDetailViewController *detail = [[SupplierDetailViewController alloc] init];
    NSArray *subSectionArray = [_suppliersArray[_selectedIndex][indexPath.section] valueForKey:@"supplier_info"];
    SupplierInfo *curInfo = subSectionArray[indexPath.row];
    detail.info = curInfo;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (fabs(delta) < 10) {
        isLoadingMoresArray[_selectedIndex] = @(YES);
        [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineType];
    }
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
    switchCity.curCityName = startCity;
    [self.navigationController pushViewController:switchCity animated:YES];
}

- (IBAction)searchProductButtonClicked:(id)sender {
    SearchSupplierViewController *search = [[SearchSupplierViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)domesticButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 0;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}
- (IBAction)abroadButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 1;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 2;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}
- (IBAction)domesticButton_diJieClicked:(id)sender {
    self.selectedIndex = 3;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}
- (IBAction)abroadBUtton_diJieClicked:(id)sender {
    self.selectedIndex = 4;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
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
    
    if ([_suppliersArray[index] count] == 0) {
        [self getSupplierListWithStartCity:startCity LineClass:lineClass lineType:lineType];
    }
}
@end
