//
//  SearchSupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplierViewController.h"
#import "AppMacro.h"
#import "SearchSupplier_HotSearchTableViewCell.h"
#import "SearchSupplier_SearchHistoryItemTableViewCell.h"
#import "SearchSupplier_SearchHistoryTitleTableViewCell.h"
#import "SearchSupplier_SearchLineClassTableViewCell.h"
#import "Global.h"

@interface SearchSupplierViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *searchHistoryArray;
    NSMutableArray *hotSearchNames;

}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *lineClassButton;
- (IBAction)lineClassButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *dropDownTableView;
@property (strong, nonatomic) UIControl *darkMask;



@end

@implementation SearchSupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchHistoryArray = [[Global sharedGlobal] searchHistory];
    hotSearchNames = [[NSMutableArray alloc] init];
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(dismissDropDownTableView) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];

    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_HotSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_HotSearchTableViewCell"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_SearchHistoryItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_SearchHistoryItemTableViewCell"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_SearchHistoryTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_SearchHistoryTitleTableViewCell"];
    _mainTableView.backgroundColor = BG_E9ECF5;
    
    [_dropDownTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_SearchLineClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_SearchLineClassTableViewCell"];
    _dropDownTableView.tableFooterView = [[UIView alloc] init];
    
    // initial status
    [self dismissDropDownTableView];
}

- (void)dismissDropDownTableView
{
    [UIView animateWithDuration:0.2 animations:^{
        _darkMask.alpha = 0;
        _imageView_Open.hidden = YES;
        _imageView_Closed.hidden = NO;
        _dropDownTableView.hidden = YES;
    }];
}

- (void)showDropDownTableView
{
    [UIView animateWithDuration:0.2 animations:^{
        _darkMask.alpha = 1;
        _imageView_Open.hidden = NO;
        _imageView_Closed.hidden = YES;
        _dropDownTableView.hidden = NO;
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _mainTableView) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return searchHistoryArray.count + 1;
        }
    }
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            SearchSupplier_HotSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_HotSearchTableViewCell" forIndexPath:indexPath];
            [cell setCellContentWithHotSearchNames:hotSearchNames];
            return cell;
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                SearchSupplier_SearchHistoryTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchHistoryTitleTableViewCell" forIndexPath:indexPath];
                return cell;
            }
            
            SearchSupplier_SearchHistoryItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchHistoryItemTableViewCell" forIndexPath:indexPath];
            [cell setCellContentWithSearchHistoryName:searchHistoryArray[indexPath.row-1]];
            return cell;
        }
    }
    
    SearchSupplier_SearchLineClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchLineClassTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell setCellContentWithLineClassName:@"国内游"];
            break;
        case 1:
            [cell setCellContentWithLineClassName:@"出境游"];
            break;
        case 2:
            [cell setCellContentWithLineClassName:@"周边游"];
            break;
        case 3:
            [cell setCellContentWithLineClassName:@"国内目的地"];
            break;
        case 4:
            [cell setCellContentWithLineClassName:@"国外目的地"];
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            return 170.f;
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 50.f;
            }
            
            return 58.f;
        }
    }
    return 46.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            return ;
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return ;
            }
            
            NSString *historyName = searchHistoryArray[indexPath.row-1];
            // go to SearchResultsController
            // ...
            return ;
        }
    }
    
    switch (indexPath.row) {
        case 0:
            [_lineClassButton setTitle:@"国内游" forState:UIControlStateNormal];
            break;
        case 1:
            [_lineClassButton setTitle:@"出境游" forState:UIControlStateNormal];
            break;
        case 2:
            [_lineClassButton setTitle:@"周边游" forState:UIControlStateNormal];
            break;
        case 3:
            [_lineClassButton setTitle:@"国内目的地" forState:UIControlStateNormal];
            break;
        case 4:
            [_lineClassButton setTitle:@"国外目的地" forState:UIControlStateNormal];
            break;
        default:
            break;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.f)];
    footer.backgroundColor = [UIColor clearColor];
    footer.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [footer setTitleColor:TEXT_4CA5FF forState:UIControlStateNormal];
    [footer setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.f;
}

#pragma mark - HTTP
- (void)getHotSearchList
{
    [HTTPTool getHotSearchListWithSuccess:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100012"] succeed:^{
            if ([result[@"RS100012"] isKindOfClass:[NSArray class]]) {
                [result[@"RS100012"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    HotSearch *hs = [[HotSearch alloc] initWithDict:obj];
                    [hotSearchNames addObject:hs];
                }];
            }
            [_mainTableView reloadData];
        } fail:^(id result) {
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取热门搜索列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)lineClassButtonClicked:(id)sender {
    if (_dropDownTableView.hidden == YES) {
        [self showDropDownTableView];
    } else {
        [self dismissDropDownTableView];
    }
}
- (IBAction)searchButtonClicked:(id)sender {
    // pass params to search results controller
    
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
@end
