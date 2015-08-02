//
//  SearchSupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplierViewController.h"
#import "SearchSupplier_HotSearchTableViewCell.h"
#import "SearchSupplier_SearchHistoryTitleTableViewCell.h"
#import "TourListCell_Destination.h"
#import "SearchSupplierResultsViewController.h"

@interface SearchSupplierViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,  SearchSupplier_HotSearchTableViewCell_Delegate>
{
    NSMutableArray *searchHistoryArray;
    NSMutableArray *hotSearchNames;
}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation SearchSupplierViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    searchHistoryArray = [[[Global sharedGlobal] searchHistory] mutableCopy];
    hotSearchNames = [[NSMutableArray alloc] init];
    
    [self setUpSearchBar];

    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_HotSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_HotSearchTableViewCell"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListCell_Destination" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_SearchHistoryTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_SearchHistoryTitleTableViewCell"];
    _mainTableView.backgroundColor = BG_E9ECF5;
    [self setMainTableFooterView];
    
    [self getHotSearchList];
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

- (void)setUpSearchBar
{
    _searchBar.layer.borderWidth = 0.5f;
    _searchBar.layer.borderColor = TEXT_CCCCD2.CGColor;
    
    _searchBar.layer.cornerRadius = 3.f;
    _searchBar.layer.masksToBounds = YES;
    
    [_searchBar setImage:ImageNamed(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    txfSearchField.font = [UIFont systemFontOfSize:12.f];
    
    [txfSearchField setValue:[UIFont systemFontOfSize:12.f] forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)setMainTableFooterView
{
    UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.f)];
    footer.backgroundColor = [UIColor clearColor];
    footer.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [footer setTitleColor:TEXT_4CA5FF forState:UIControlStateNormal];
    [footer setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    _mainTableView.tableFooterView = footer;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return searchHistoryArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SearchSupplier_HotSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_HotSearchTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithHotSearchNames:hotSearchNames];
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.row == 0) {
        SearchSupplier_SearchHistoryTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchHistoryTitleTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    TourListCell_Destination *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination" forIndexPath:indexPath];
    [cell setCellContentWithDestination:searchHistoryArray[indexPath.row-1]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150.f;
    }
    
    if (indexPath.row == 0) {
        return 50.f;
    }
    return 58.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row > 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSString *historyName = searchHistoryArray[indexPath.row-1];
            SearchSupplierResultsViewController *results = [[SearchSupplierResultsViewController alloc] init];
            results.keyword = historyName;
            [self.navigationController pushViewController:results animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7.f)];
    view.backgroundColor = BG_E9ECF5;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 7.f;
}

#pragma mark - SearchSupplier_HotSearchTableViewCell_Delegate
- (void)supportClickHotSearchWithIndex:(NSInteger)index
{
    NSString *hotTheme = [hotSearchNames[index] hotSearchValue];
    SearchSupplierResultsViewController *results = [[SearchSupplierResultsViewController alloc] init];
    results.hotTheme = hotTheme;
    [self.navigationController pushViewController:results animated:YES];
}

#pragma mark - HTTP
- (void)getHotSearchList
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getHotSearchListWithSuccess:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100012"] succeed:^{
            if ([result[@"RS100012"] isKindOfClass:[NSArray class]]) {
                [result[@"RS100012"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    HotSearch *hs = [[HotSearch alloc] initWithDict:obj];
                    [hotSearchNames addObject:hs];
                }];
            }
            [_mainTableView reloadData];
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取热门搜索列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)searchButtonClicked:(id)sender {
    if (!_searchBar.text || _searchBar.text.length == 0) {
        return;
    }
    NSString *keywords = _searchBar.text;
    SearchSupplierResultsViewController *results = [[SearchSupplierResultsViewController alloc] init];
    results.keyword = keywords;
    [self.navigationController pushViewController:results animated:YES];
    [_searchBar resignFirstResponder];
    
    [[Global sharedGlobal] saveToSearchHistoryWithKeyword:_searchBar.text];
    
    if (!searchHistoryArray) {
        searchHistoryArray = [[NSMutableArray alloc] init];
    }
    
    __block BOOL alreadyInCache = NO;
    [searchHistoryArray enumerateObjectsUsingBlock:^(NSString *cache, NSUInteger idx, BOOL *stop) {
        if ([cache isEqualToString:_searchBar.text]) {
            alreadyInCache = YES;
        }
    }];
    if (alreadyInCache == NO) {
        [searchHistoryArray addObject:keywords];
    }
    [_mainTableView reloadData];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearSearchHistory
{
    [[Global sharedGlobal] clearSearchHistory];
    [searchHistoryArray removeAllObjects];
    [_mainTableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
