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
#import "DeleteActionSheet.h"
#import "MicroShopDetailViewController.h"
#import "OpenMiroShopViewController.h"

@interface MicroShopViewController ()<CLLocationManagerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ReusableHeaderView_myShop_Delegate, MicroShopCollectionViewCell_MyShop_Delegate, DeleteActionSheetDelegate>

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
@property (nonatomic, strong) DeleteActionSheet *deleteActionSheet;

@property (nonatomic, copy) NSMutableArray *onlineShopsArray;
@property (nonatomic, copy) NSMutableArray *myShopsArray;

@end

@implementation MicroShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // tabBarItem
    UIImage *normal = [ImageNamed(@"shop_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selected = [ImageNamed(@"service_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微店" image:normal selectedImage:selected];
    
    _onlineShopsArray = [[NSMutableArray alloc] init];
    _myShopsArray = [[NSMutableArray alloc] init];
    
    CGFloat scrollViewYOrigin = 0.277*SCREEN_HEIGHT;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewYOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - scrollViewYOrigin - 49)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    // delete view part
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(hideDeleteActionSheet) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [APP_WINDOW addSubview:_darkMask];

    _deleteActionSheet = [[DeleteActionSheet alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - DELETE_ACTION_SHEET_HEIGHT, SCREEN_WIDTH, DELETE_ACTION_SHEET_HEIGHT)];
    
    [APP_WINDOW addSubview:_deleteActionSheet];
    
    // online shop collection view
    MicroShopFlowLayout *flow_Online = [[MicroShopFlowLayout alloc] init];
    
    _onlineShopCollectionView = [[MicroShopCollectionView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:flow_Online];
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"MicroShopCollectionViewCell_OnlineShop" bundle:nil] forCellWithReuseIdentifier:@"MicroShopCollectionViewCell_OnlineShop"];
    
    [_onlineShopCollectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_OnlineShop" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_OnlineShop"];
    
    _onlineShopCollectionView.dataSource = self;
    _onlineShopCollectionView.delegate = self;
    _onlineShopCollectionView.backgroundColor = [UIColor whiteColor];
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
    [_scrollView addSubview:_myShopCollectionView];
    
    [_scrollView setContentSize:CGSizeMake(2*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    
    // ---TEST---
    [self getOnlineShops];
    
    [_locationButton setTitle:@"正在定位..." forState:UIControlStateNormal];
    [self startLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)hideDeleteActionSheet
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_deleteActionSheet setFrame:CGRectOffset(_deleteActionSheet.frame, 0, DELETE_ACTION_SHEET_HEIGHT)];
    }];
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
    if ([[Global sharedGlobal] userInfo].companyId && [[Global sharedGlobal] userInfo].staffId) {
        [HTTPTool getOnlineMicroShopListWithProvince:_locationButton.titleLabel.text companyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId success:^(id result) {
            NSArray *data = result[@"RS100002"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
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
        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取在线微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getOnlineMicroShopListWithProvince:_locationButton.titleLabel.text success:^(id result) {
            NSArray *data = result[@"RS100001"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
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
                [_onlineShopsArray addObject:tempDict];
                [_onlineShopsArray addObject:tempDict];
                
            }];
            [_onlineShopCollectionView reloadData];

        } fail:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取在线微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)getMyShops
{
    if ([[Global sharedGlobal] userInfo].companyId && [[Global sharedGlobal] userInfo].staffId) {
        [HTTPTool getMyMicroShopListWithCompanyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId success:^(id result) {
            
            NSArray *data = result[@"RS100005"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                [_myShopsArray addObject:info];
            }];
            [_myShopCollectionView reloadData];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取我的微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getMyMicroShopListWithSuccess:^(id result) {
            NSArray *data = result[@"RS100005"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MicroShopInfo *info = [[MicroShopInfo alloc] initWithDict:obj];
                [_myShopsArray addObject:info];
            }];
            [_myShopCollectionView reloadData];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取我的微店列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
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
//        return _myShopsArray.count;
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
            [cell setCellContentWithMicroShopInfo:info isLock:NO isDefault:NO];
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
        detail.isMyShop = NO;
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    
    if (collectionView == _myShopCollectionView && indexPath.row < _myShopsArray.count) {
        OpenMiroShopViewController *open = [[OpenMiroShopViewController alloc] init];
        [self.navigationController pushViewController:open animated:YES];
        return;
    }
    
    
    // add to my shop cell clicked
    if (collectionView == _myShopCollectionView && indexPath.row == _myShopsArray.count) {
        [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, 0, 0) animated:YES];
    }
}

#pragma mark - ReusableHeaderView_myShop_Delegate
- (void)supportClickWithInstructions
{
    // go to webview
}
#pragma mark - MicroShopCollectionViewCell_MyShop_Delegate
- (void)supportClickWithDeleteButton
{
    // delete
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0.7;
        [_deleteActionSheet setFrame:CGRectOffset(_deleteActionSheet.frame, 0, -DELETE_ACTION_SHEET_HEIGHT)];
    }];
}

- (IBAction)myShopButtonClicked:(id)sender {
    [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, _scrollView.frame.size.width, 0) animated:YES];
    if (_myShopsArray.count == 0) {
        [self getMyShops];
    }
}

- (IBAction)onlineShopButtonClicked:(id)sender {
    [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, 0, 0) animated:YES];
}

#pragma mark - DeleteActionSheetDelegate
- (void)supportClickActionSheetWithYes
{
    
}

- (void)supportClickActionSheetWithNo
{
    
}

@end
