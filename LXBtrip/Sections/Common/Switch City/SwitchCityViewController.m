//
//  SwitchCityViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SwitchCityViewController.h"
#import "SwitchCityTableViewCell.h"

@interface SwitchCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *allCitiesArrayUnsorted;
    NSMutableArray *allCitiesArrayInOrder;//contains initial-keyed dictionaries
    NSMutableArray *hotCitiesArray;
    NSMutableArray *sectionsArray;//contains all initials
    NSMutableArray *searchedCitiesArray;
    
    NSString *locationCity;
}

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *searchedTableView;

@end

@implementation SwitchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged_SwitchCity) name:CITY_CHANGED object:nil];

    allCitiesArrayInOrder = [[NSMutableArray alloc] init];
    allCitiesArrayUnsorted = [[NSMutableArray alloc] init];
    hotCitiesArray = [[[Global sharedGlobal] hotCityHistory] mutableCopy];
    searchedCitiesArray = [[NSMutableArray alloc] init];
    sectionsArray = [[NSMutableArray alloc] init];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    [_searchedTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _searchedTableView.tableFooterView = [[UIView alloc] init];
    
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
    
    locationCity = [[Global sharedGlobal] locationCity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
    
    [self getAllCities];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)cityChanged_SwitchCity
{
    locationCity = [[Global sharedGlobal] locationCity];
    [_mainTableView reloadData];
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
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getCitiesWithSuccess:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
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
            [cell setCellCityWithName:locationCity?locationCity:@"" isLocationCity:YES selectedStatus:YES];
            return cell;
        }
        
        if (hotCitiesArray.count == 0) {
            NSArray *temp = [allCitiesArrayInOrder[indexPath.section-1] objectForKey:sectionsArray[indexPath.section-1]];
            City *ct = temp[indexPath.row];
            if (locationCity) {
                if ([ct.cityName isEqualToString:locationCity]) {
                    [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:YES];
                } else {
                    [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
                }
            } else {
                [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
            }
            return cell;
        } else {
            if (indexPath.section == 1) {
                NSString *hct = hotCitiesArray[indexPath.row];
                if (locationCity) {
                    if ([hct isEqualToString:locationCity]) {
                        [cell setCellCityWithName:hct isLocationCity:NO selectedStatus:YES];
                    } else {
                        [cell setCellCityWithName:hct isLocationCity:NO selectedStatus:NO];
                    }
                } else {
                    [cell setCellCityWithName:hct isLocationCity:NO selectedStatus:NO];
                }
                return cell;
            }
            
            NSArray *temp = [allCitiesArrayInOrder[indexPath.section-2] objectForKey:sectionsArray[indexPath.section-2]];
            City *ct = temp[indexPath.row];
            if (locationCity) {
                if ([ct.cityName isEqualToString:locationCity]) {
                    [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:YES];
                } else {
                    [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
                }
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
    if (tableView == _mainTableView) {
        return 23.f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info;
    
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            if (!locationCity) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            info = @{@"startcity":locationCity};
        } else if (hotCitiesArray.count > 0) {
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
    
    if (_isFromSupplierList) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_CITY_SUPPLIER_LIST object:self userInfo:info];
    } else if (_isFromTourList) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_CITY_TOUR_LIST object:self userInfo:info];
    } else if (_isFromSupplierSearchResults) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_CITY_SUPPLIER_SEARCH_RESULTS object:self userInfo:info];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
        
        if (_searchBar.text.length == 0) {
            [searchedCitiesArray removeAllObjects];
            [_searchedTableView reloadData];
            
            _searchedTableView.hidden = YES;
            _mainTableView.hidden = NO;
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.1 animations:^{
        [self changeSearchBarWidthWithDeltaValue:(- _cancelButton.frame.size.width)];
        _cancelButton.hidden = NO;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.1 animations:^{
        [self changeSearchBarWidthWithDeltaValue:(+ _cancelButton.frame.size.width)];
        _cancelButton.hidden = YES;
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

    // check 首字母缩写
    [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
        if (searchText.length <= obj.cityAcronym.length) {
            if ([obj.cityAcronym compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                }
            }
        }
    }];
    
    // check 城市名
    [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
        if (searchText.length <= obj.cityName.length) {
            if ([obj.cityName compare:searchText options:NSLiteralSearch range:NSMakeRange(0, searchText.length)] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                }
            }
        }
    }];
    
    // check 全拼
    [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
        if (searchText.length <= obj.cityPinYin.length) {
            if ([obj.cityPinYin compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                }
            }
        }
    }];
    
    [_searchedTableView reloadData];
}

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
    
    _searchedTableView.hidden = YES;
    _mainTableView.hidden = NO;
    
}

#pragma mark - Private
- (void)changeSearchBarWidthWithDeltaValue:(CGFloat)deltaWidth
{
    [_searchBar setFrame:CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y, _searchBar.frame.size.width + deltaWidth, _searchBar.frame.size.height)];
}

@end
