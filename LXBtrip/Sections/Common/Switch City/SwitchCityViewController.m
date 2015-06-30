//
//  SwitchCityViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SwitchCityViewController.h"
#import "SwitchCityTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface SwitchCityViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *allCitiesArrayUnsorted;
    NSMutableArray *allCitiesArrayInOrder;//contains initial-keyed dictionaries
    NSMutableArray *hotCitiesArray;
    NSMutableArray *sectionsArray;//contains all initials
    NSMutableArray *searchedCitiesArray;
}

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *searchedTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SwitchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];

    allCitiesArrayInOrder = [[NSMutableArray alloc] init];
    allCitiesArrayUnsorted = [[NSMutableArray alloc] init];
    hotCitiesArray = [[[Global sharedGlobal] hotCityHistory] mutableCopy];
    searchedCitiesArray = [[NSMutableArray alloc] init];
    sectionsArray = [[NSMutableArray alloc] init];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    [_searchedTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30.f)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"请输入城市名称";
    _searchBar.translucent = YES;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    // initial status
    _searchedTableView.hidden = YES;
    _mainTableView.hidden = NO;
    _cancelButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
    if (!_locationCity) {
        [self startLocation];
    } else {
        [self getAllCities];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 118.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}
- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - Locating part
//开始定位
- (void)startLocation{
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1.0f;
    [_locationManager startUpdatingLocation];
    
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启定位:设置 > 隐私 > 位置 > 定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    } else {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"定位失败，请开启定位:设置 > 隐私 > 位置 > 定位服务 下 XX应用" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        [_locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
}

#pragma mark - CLLocationManagerDelegate
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    CLLocation *newLocation = [locations objectAtIndex:0];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //
            NSLog(@"%@", test);
            _locationCity = [test objectForKey:@"City"];
            if ([_locationCity hasSuffix:@"市"]) {
                _locationCity = [_locationCity substringWithRange:NSMakeRange(0, _locationCity.length-1)];
            }
            
            [self getAllCities];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLError err = [[error domain] intValue];
    if (err != kCLErrorLocationUnknown) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    } else {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络状态不佳，正在尝试重新定位" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)sortCitiesUsingInitialsWithUnsortedArray:(NSArray *)array
{
    NSMutableArray *tempParent = [[NSMutableArray alloc] init];
    // create unsorted keys array and values array separately
    [array enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
        if ([sectionsArray containsObject:obj.cityInitail]) {
            NSInteger index = [sectionsArray indexOfObject:obj.cityInitail];
            NSMutableArray *tempSon = tempParent[index];
            if (![tempSon containsObject:obj]) {
                [tempSon addObject:obj];
            }
        } else {
            [sectionsArray addObject:obj.cityInitail];
            NSMutableArray *tempNewSon = [[NSMutableArray alloc] init];
            [tempNewSon addObject:obj];
            [tempParent addObject:tempNewSon];
        }
    }];
    
    // sort initials array
    sectionsArray = [[sectionsArray sortedArrayUsingFunction:initialSort context:NULL] mutableCopy];
    
    // create final initial-keyed dictionaries' array
    [sectionsArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        [tempParent enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
            if ([[arr[0] cityInitail] isEqualToString:str]) {
                NSDictionary *temp = @{str:arr};
                [allCitiesArrayInOrder addObject:temp];
            }
        }];
    }];
}

#pragma mark - HTTP
- (void)getAllCities
{
    [HTTPTool getCitiesWithSuccess:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100055"] succeed:^{
            id data = result[@"RS100055"];
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    City *city = [[City alloc] initWithDict:obj];
                    [allCitiesArrayUnsorted addObject:city];
                }];
            }
            [self sortCitiesUsingInitialsWithUnsortedArray:allCitiesArrayUnsorted];
            [_mainTableView reloadData];
        }];
    } fail:^(id result) {
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取城市失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _mainTableView) {
        if (hotCitiesArray.count > 0) {
            return sectionsArray.count + 2;
        } else {
            return sectionsArray.count + 1;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _mainTableView) {
        if (section == 0) {
            return 1;
        }
        if (hotCitiesArray.count == 0) {
            return [[allCitiesArrayInOrder[section-1] objectForKey:sectionsArray[section-1]] count];
        } else {
            if (section == 1) {
                return hotCitiesArray.count>5?5:hotCitiesArray.count;
            }
            return [[allCitiesArrayInOrder[section-2] objectForKey:sectionsArray[section-2]] count];
        }
    }
    return searchedCitiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        SwitchCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCityTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [cell setCellCityWithName:_locationCity isLocationCity:YES selectedStatus:YES];
            return cell;
        }
        
        if (hotCitiesArray.count == 0) {
            NSArray *temp = [allCitiesArrayInOrder[indexPath.section-1] objectForKey:sectionsArray[indexPath.section-1]];
            City *ct = temp[indexPath.row];
            if ([ct.cityName isEqualToString:_locationCity]) {
                [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:YES];
            } else {
                [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
            }
            return cell;
        } else {
            if (indexPath.section == 1) {
                NSString *hct = hotCitiesArray[indexPath.row];
                if ([hct isEqualToString:_locationCity]) {
                    [cell setCellCityWithName:hct isLocationCity:NO selectedStatus:YES];
                } else {
                    [cell setCellCityWithName:hct isLocationCity:NO selectedStatus:NO];
                }
                return cell;
            }
            
            NSArray *temp = [allCitiesArrayInOrder[indexPath.section-2] objectForKey:sectionsArray[indexPath.section-2]];
            City *ct = temp[indexPath.row];
            if ([ct.cityName isEqualToString:_locationCity]) {
                [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:YES];
            } else {
                [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
            }
            return cell;
        }
    }
    
    // searchedTableView
    SwitchCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCityTableViewCell" forIndexPath:indexPath];
    City *ct = searchedCitiesArray[indexPath.row];
    [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
    return cell;
}

// 索引目录
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _mainTableView) {
        NSMutableArray *temp = [sectionsArray mutableCopy];
        return temp;
    }
    return nil;
}

// 点击目录
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    // 前两/一个 section不显示
    if (hotCitiesArray.count == 0) {
        return index+1;
    } else {
        return index+2;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = TEXT_666666;
    label.backgroundColor = BG_F5F5F5;
    label.font = [UIFont systemFontOfSize:12.f];
    if (section == 0) {
        label.text = @"当前定位城市";
        return label;
    }
    
    if (hotCitiesArray.count == 0) {
        if (sectionsArray.count > 0) {
            label.text = sectionsArray[section-1];
            return label;
        }
    }
    
    if (section == 1) {
        label.text = @"常用城市";
    } else {
        label.text = sectionsArray[section-2];
    }
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info;
    
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            if (!_locationCity) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            info = @{@"startcity":_locationCity};
        }
        
        if (hotCitiesArray.count > 0) {
            if (indexPath.section == 1) {
                info = @{@"startcity":hotCitiesArray[indexPath.row]};
            } else {
                NSArray *temp = [allCitiesArrayInOrder[indexPath.section-2] objectForKey:sectionsArray[indexPath.section-2]];
                City *ct = temp[indexPath.row];
                info = @{@"startcity":ct.cityName};
            }
        } else {
            NSArray *temp = [allCitiesArrayInOrder[indexPath.section-1] objectForKey:sectionsArray[indexPath.section-1]];
            City *ct = temp[indexPath.row];
            info = @{@"startcity":ct.cityName};
        }
    } else if (tableView == _searchedTableView) {
        City *ct = searchedCitiesArray[indexPath.row];
        info = @{@"startcity":ct.cityName};
    }
    
    [[Global sharedGlobal] saveToHotCityHistoryWithCityName:info[@"startcity"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SWITCH_CITY_WITH_CITY_NAME" object:self userInfo:info];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.1 animations:^{
        [self changeSearchBarWidthWithDeltaValue:(- _cancelButton.frame.size.width)];
        _cancelButton.hidden = NO;
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchedCitiesArray removeAllObjects];
    
    // change status
    _searchedTableView.hidden = NO;
    _mainTableView.hidden = YES;
    
    if (searchText.length == 0) {
        [_searchedTableView reloadData];
        return;
    }
    
    // length==1 search initial
    if (searchText.length == 1) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.cityInitail compare:searchText options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                }
            }
        }];
        
        [_searchedTableView reloadData];
    }
    // length==2 search acronym_word
    else if (searchText.length >= 2) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if (obj.cityAcronym.length < searchText.length) {
                return ;
            } else {
                NSString *subString = [obj.cityAcronym substringToIndex:searchText.length];
                if ([searchText compare:subString options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    if (![searchedCitiesArray containsObject:obj]) {
                        [searchedCitiesArray addObject:obj];
                    }
                }
            }
        }];
        
        [_searchedTableView reloadData];
    }
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    // length==1 search initial
//    if (searchBar.text.length == 1) {
//        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
//            if ([obj.cityInitail compare:searchBar.text options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                if (![searchedCitiesArray containsObject:obj]) {
//                    [searchedCitiesArray addObject:obj];
//                    [_searchedTableView reloadData];
//                }
//            }
//        }];
//    }
//    // length==2 search acronym_word
//    else if (searchBar.text.length >= 2) {
//        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
//            if (obj.cityInitail.length <= searchBar.text.length) {
//                if ([searchBar.text compare:obj.cityInitail options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchBar.text.length)] == NSOrderedSame) {
//                    if (![searchedCitiesArray containsObject:obj]) {
//                        [searchedCitiesArray addObject:obj];
//                        [_searchedTableView reloadData];
//                    }
//                }
//            } else {
//                if ([obj.cityInitail compare:searchBar.text options:NSCaseInsensitiveSearch range:NSMakeRange(0, obj.cityInitail.length)] == NSOrderedSame) {
//                    if (![searchedCitiesArray containsObject:obj]) {
//                        [searchedCitiesArray addObject:obj];
//                        [_searchedTableView reloadData];
//                    }
//                }
//            }
//        }];
//    }
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // change status
    _searchedTableView.hidden = YES;
    _mainTableView.hidden = NO;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    [searchedCitiesArray removeAllObjects];
    [_searchedTableView reloadData];

    [UIView animateWithDuration:0.1 animations:^{
        [self changeSearchBarWidthWithDeltaValue:(+ _cancelButton.frame.size.width)];
        _cancelButton.hidden = YES;
    }];
    
    _searchedTableView.hidden = YES;
    _mainTableView.hidden = NO;
    
}

#pragma mark - Private
- (void)changeSearchBarWidthWithDeltaValue:(CGFloat)deltaWidth
{
    [_searchBar setFrame:CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y, _searchBar.frame.size.width + deltaWidth, _searchBar.frame.size.height)];
}

@end
