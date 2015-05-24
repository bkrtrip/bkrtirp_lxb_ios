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


@interface MicroShopViewController ()<CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ReusableHeaderView_myShop_Delegate, MicroShopCollectionViewCell_MyShop_Delegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) IBOutlet UIButton *onlineShopButton;
@property (strong, nonatomic) IBOutlet UIButton *myShopButton;
- (IBAction)myShopButtonClicked:(id)sender;
- (IBAction)onlineShopButtonClicked:(id)sender;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) MicroShopCollectionView *onlineShopCollectionView;
@property (nonatomic, strong) MicroShopCollectionView *myShopCollectionView;

@property (nonatomic, copy) NSMutableArray *onlineShopsArray;
@property (nonatomic, copy) NSMutableArray *myShopsArray;

@end

@implementation MicroShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _onlineShopsArray = [[NSMutableArray alloc] init];
    _myShopsArray = [[NSMutableArray alloc] init];
    
    CGFloat scrollViewYOrigin = 0.277*SCREEN_HEIGHT;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewYOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - scrollViewYOrigin)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    // online shop collection view
    _onlineShopCollectionView = [[MicroShopCollectionView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:[[MicroShopFlowLayout alloc] init]];
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"MicroShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OnlineShopCell"];
    
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_OnlineShop" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_OnlineShop"];
    
    _onlineShopCollectionView.dataSource = self;
    _onlineShopCollectionView.delegate = self;
    [_scrollView addSubview:_onlineShopCollectionView];
    
    // online shop collection view
    _myShopCollectionView = [[MicroShopCollectionView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:[[MicroShopFlowLayout alloc] init]];
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"MicroShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyShopCell"];
    
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"AddShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddShopCell"];
    
    [_myShopCollectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_myShop" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_myShop"];

    _myShopCollectionView.dataSource = self;
    _myShopCollectionView.delegate = self;
    [_scrollView addSubview:_myShopCollectionView];
    
    [_locationButton setTitle:@"正在定位..." forState:UIControlStateNormal];
    [self startLocation];
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
            [self getOnlineShops];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)getOnlineShops
{
    [HTTPTool getOnlineMicroShopListWithProvince:_locationButton.titleLabel.text companyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId success:^(id result) {
        [[Global sharedGlobal] codeHudWithDict:result succeed:^{
            NSArray *data = result[@"RS100001"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                if ([obj[@"classify_name"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_name"]) {
                    [tempDict setObject:obj[@"classify_name"] forKey:@"classify_name"];
                }
                if ([obj[@"classify_template"] isKindOfClass:[NSNull class]]?nil:obj[@"classify_template"]) {
                    
                    NSArray *tempArray = [obj[@"classify_template"] copy];
                    [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                        [_onlineShopsArray addObject:info];
                    }];
                    [tempDict setObject:tempArray forKey:@"classify_template"];
                }
                [_onlineShopsArray addObject:tempDict];
            }];
            [_onlineShopCollectionView reloadData];
        }];
    } fail:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取在线微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)getMyShops
{
    [HTTPTool getMyMicroShopListWithProvince:_locationButton.titleLabel.text companyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId success:^(id result) {
        [[Global sharedGlobal] codeHudWithDict:result succeed:^{
            NSArray *data = result[@"RS100005"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                [_myShopsArray addObject:info];
            }];
        }];
        [_myShopCollectionView reloadData];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取我的微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _onlineShopCollectionView) {
        return _onlineShopsArray.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _onlineShopCollectionView) {
        return [[_onlineShopsArray[section] objectForKey:@"classify_template"] count];
    }
    return _myShopsArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // online shop
    if (collectionView == _onlineShopCollectionView) {
        MicroShopCollectionViewCell_OnlineShop *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnlineShopCell" forIndexPath:indexPath];
        NSArray *subArray = [_onlineShopsArray[indexPath.section] objectForKey:@"classify_template"];
        MicroShopInfo *info = subArray[indexPath.row];
        [cell setCellContentWithMicroShopInfo:info];
        return cell;
    }
    
    // my shop
    if (indexPath.row < _myShopsArray.count) {
        MicroShopCollectionViewCell_OnlineShop *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyShopCell" forIndexPath:indexPath];
        MicroShopInfo *info = _myShopsArray[indexPath.row];
        [cell setCellContentWithMicroShopInfo:info];
        return cell;
    } else {// '+'
        MicroShopCollectionViewCell_OnlineShop *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddShopCell" forIndexPath:indexPath];
        return cell;
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _onlineShopCollectionView) {
        ReusableHeaderView_OnlineShop *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_OnlineShop" forIndexPath:indexPath];
        header.sectionHeaderNameLabel.text = [_onlineShopsArray[indexPath.section] objectForKey:@"classify_name"];
        return header;
    }
    
    ReusableHeaderView_OnlineShop *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_myShop" forIndexPath:indexPath];
    return header;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // jump to detail
    
    // add my shop
}

#pragma mark - ReusableHeaderView_myShop_Delegate
- (void)supportClickWithInstructions
{
    // go to webview
}
#pragma mark - MicroShopCollectionViewCell_MyShop_Delegate
- (void)supportClickWithDeleteOrLockButtonWithStatus:(NSInteger)isLock
{
    // delete or lock
}

- (IBAction)myShopButtonClicked:(id)sender {
    [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, _scrollView.frame.size.width, 0) animated:YES];
}

- (IBAction)onlineShopButtonClicked:(id)sender {
    [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, 0, 0) animated:YES];
}
@end
