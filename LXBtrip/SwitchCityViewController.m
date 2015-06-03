//
//  SwitchCityViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SwitchCityViewController.h"
#import "SwitchCityTableViewCell.h"
#import "Global.h"

@interface SwitchCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *allCitiesArrayUnsorted;
    NSMutableArray *allCitiesArrayInOrder;//contains initial-keyed dictionaries
    NSMutableArray *hotCitiesArray;
    NSMutableArray *sectionsArray;//contains all initials
    NSMutableArray *searchedCitiesArray;
    BOOL hotCitiesFetchSucceed;
    BOOL allCitiesFetchSucceed;
}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *searchedTableView;

@end

@implementation SwitchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    allCitiesArrayInOrder = [[NSMutableArray alloc] init];
    allCitiesArrayUnsorted = [[NSMutableArray alloc] init];
    hotCitiesArray = [[NSMutableArray alloc] init];
    searchedCitiesArray = [[NSMutableArray alloc] init];
    sectionsArray = [[NSMutableArray alloc] init];

    [self getAllCities];
    [self getHotCities];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    [_searchedTableView registerNib:[UINib nibWithNibName:@"SwitchCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCityTableViewCell"];
    
    // initial status
    _searchedTableView.hidden = YES;
    _mainTableView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context)
{
    return [initial_1 caseInsensitiveCompare:initial_2];
//    
//    int v1 = [num1 intValue];
//    int v2 = [num2 intValue];
//    if (v1 < v2)
//        return NSOr
//        deredAscending;
//    else if (v1 > v2)
//        return NSOrderedDescending;
//    else
//        return NSOrderedSame;
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

- (void)getAllCities
{
    [HTTPTool getCitiesWithSuccess:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100041"] succeed:^{
            id data = result[@"RS100041"];
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    City *city = [[City alloc] initWithDict:obj];
                    [allCitiesArrayUnsorted addObject:city];
                }];
            }
            [self sortCitiesUsingInitialsWithUnsortedArray:allCitiesArrayUnsorted];
            allCitiesFetchSucceed = YES;
            [self shouldReloadData];
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取所有城市失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)getHotCities
{
    // --TEST--
    hotCitiesFetchSucceed = YES;

//    [HTTPTool getHotCitiesWithSuccess:^(id result) {
//        [[Global sharedGlobal] codeHudWithObject:result[@"RS100042"] succeed:^{
//            id data = result[@"RS100042"];
//            if ([data isKindOfClass:[NSArray class]]) {
//                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    HotCity *hotcity = [[HotCity alloc] initWithDict:obj];
//                    [hotCitiesArray addObject:hotcity];
//                }];
//            }
//            hotCitiesFetchSucceed = YES;
//            [self shouldReloadData];
//        }];
//    } fail:^(id result) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取常用城市失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//        [alert show];
//    }];
}

- (void)shouldReloadData
{
    if (hotCitiesFetchSucceed && allCitiesFetchSucceed) {
        [_mainTableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _mainTableView) {
        return sectionsArray.count+2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _mainTableView) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return hotCitiesArray.count;
        }
        return [[allCitiesArrayInOrder[section-2] objectForKey:sectionsArray[section-2]] count];
    }
    return searchedCitiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        SwitchCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCityTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [cell setCellCityWithName:_curCityName isLocationCity:YES selectedStatus:YES];
            return cell;
        }
        
        if (indexPath.section == 1) {
            HotCity *hct = hotCitiesArray[indexPath.row];
            if ([hct.hotCityValue isEqualToString:_curCityName]) {
                [cell setCellCityWithName:hct.hotCityValue isLocationCity:NO selectedStatus:YES];
            } else {
                [cell setCellCityWithName:hct.hotCityValue isLocationCity:NO selectedStatus:NO];
            }
            return cell;
        }
        
        NSArray *temp = [allCitiesArrayInOrder[indexPath.section-2] objectForKey:sectionsArray[indexPath.section-2]];
        City *ct = temp[indexPath.row];
        if ([ct.cityName isEqualToString:_curCityName]) {
            [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:YES];
        } else {
            [cell setCellCityWithName:ct.cityName isLocationCity:NO selectedStatus:NO];
        }
        return cell;
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
    
    // 前两个section不显示
    return index+2;
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
    } else if (section == 1) {
        label.text = @"常用城市";
    } else {
        label.text = sectionsArray[section-2];
    }
    
    return label;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // change status
    _searchedTableView.hidden = NO;
    _mainTableView.hidden = YES;
    
    // length==1 search initial
    if (searchText.length == 1) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.cityInitail compare:searchText options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                    [_searchedTableView reloadData];
                }
            }
        }];
    }
    // length==2 search acronym_word
    else if (searchText.length == 2) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if (![searchedCitiesArray containsObject:obj]) {
                [searchedCitiesArray addObject:obj];
                [_searchedTableView reloadData];
            }
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // length==1 search initial
    if (searchBar.text.length == 1) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.cityInitail compare:searchBar.text options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                if (![searchedCitiesArray containsObject:obj]) {
                    [searchedCitiesArray addObject:obj];
                    [_searchedTableView reloadData];
                }
            }
        }];
    }
    // length==2 search acronym_word
    else if (searchBar.text.length == 2) {
        [allCitiesArrayUnsorted enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if (![searchedCitiesArray containsObject:obj]) {
                [searchedCitiesArray addObject:obj];
                [_searchedTableView reloadData];
            }
        }];
    }
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
@end
