//
//  MySupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MySupplierViewController.h"
#import "RecentContactTableViewCell.h"
#import "MySupplierTableViewCell.h"
#import "SupplierDetailViewController.h"

@interface MySupplierViewController () <RecentContactTableViewCell_Delegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger selectedIndex; // 0~4
    NSMutableArray *tableViewsArray;
}

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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *underLineLabel;

@property (nonatomic, copy) NSMutableArray *allSectionsArray;
@property (nonatomic, copy) NSMutableArray *allMySuppliersArrayUnsorted;
@property (nonatomic, copy) NSMutableArray *allMySuppliersArrayInOrder;
@property (nonatomic, copy) NSMutableArray *allRecentSuppliersArray;

@end

@implementation MySupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allSectionsArray = [[NSMutableArray alloc] initWithObjects:[@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], nil];
    _allMySuppliersArrayUnsorted = [[NSMutableArray alloc] initWithObjects:[@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], nil];
    _allMySuppliersArrayInOrder = [[NSMutableArray alloc] initWithObjects:[@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], nil];
    _allRecentSuppliersArray = [[NSMutableArray alloc] initWithObjects:[@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], [@[] mutableCopy], nil];
    
    CGFloat yOrigin = 82.f;
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, (SCREEN_WIDTH/2.f)/3, 2)];
    _underLineLabel.backgroundColor = TEXT_4CA5FF;
    [self.view addSubview:_underLineLabel];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin - 64.f)];
    [_scrollView setContentSize:CGSizeMake(5*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    tableViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0)];
        [tableview registerNib:[UINib nibWithNibName:@"MySupplierTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySupplierTableViewCell"];
        [tableview registerNib:[UINib nibWithNibName:@"RecentContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecentContactTableViewCell"];
        tableview.dataSource = self;
        tableview.delegate = self;
        tableview.tableFooterView = [[UIView alloc] init];
        [_scrollView addSubview:tableview];
        [tableViewsArray addObject:tableview];
    }
    
    selectedIndex = 0;
    [self getMySuppliers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"我的供应商";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)getMySuppliers
{
    [HTTPTool getMySuppliersWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] lineClass:LINE_CLASS[@(selectedIndex)] success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100018"] succeed:^{
            id data = result[@"RS100018"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                //my_supplier part
                id mySuppliersData = data[@"my_supplier"];
                if ([mySuppliersData isKindOfClass:[NSArray class]]) {
                    [mySuppliersData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierInfo *info= [[SupplierInfo alloc] initWithDict:obj];
                        [_allMySuppliersArrayUnsorted[selectedIndex] addObject:info];
                    }];
                    [self sortSuppliersUsingInitialsWithUnsortedArray:_allMySuppliersArrayUnsorted[selectedIndex]];
                }
                
                //recently_company part
                id recentSuppliersData = data[@"recently_company"];
                if ([recentSuppliersData isKindOfClass:[NSArray class]]) {
                    [recentSuppliersData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierInfo *info= [[SupplierInfo alloc] initWithDict:obj];
                        [_allRecentSuppliersArray[selectedIndex] addObject:info];
                    }];
                }
            }
            [tableViewsArray[selectedIndex] reloadData];
        } fail:^(id result) {
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取我的供应商失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)sortSuppliersUsingInitialsWithUnsortedArray:(NSArray *)array
{
    NSMutableArray *tempParent = [[NSMutableArray alloc] init];
    // create unsorted keys array and values array separately
    [array enumerateObjectsUsingBlock:^(SupplierInfo *obj, NSUInteger idx, BOOL *stop) {
        if ([_allSectionsArray[selectedIndex] containsObject:obj.supplierLineTypeLetter]) {
            NSInteger index = [_allSectionsArray[selectedIndex] indexOfObject:obj.supplierLineTypeLetter];
            NSMutableArray *tempSon = tempParent[index];
            if (![tempSon containsObject:obj]) {
                [tempSon addObject:obj];
            }
        } else {
            [_allSectionsArray[selectedIndex] addObject:obj.supplierLineTypeLetter];
            NSMutableArray *tempNewSon = [[NSMutableArray alloc] init];
            [tempNewSon addObject:obj];
            [tempParent addObject:tempNewSon];
        }
    }];
    
    // sort initials array
    _allSectionsArray[selectedIndex] = [[_allSectionsArray[selectedIndex] sortedArrayUsingFunction:initialSort context:NULL] mutableCopy];
    
    // create final initial-keyed dictionaries' array
    [_allSectionsArray[selectedIndex] enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        [tempParent enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
            if ([[arr[0] supplierLineTypeLetter] isEqualToString:str]) {
                NSDictionary *temp = @{str:arr};
                [_allMySuppliersArrayInOrder[selectedIndex] addObject:temp];
            }
        }];
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_allMySuppliersArrayInOrder[selectedIndex] count] + (_allRecentSuppliersArray.count>0?1:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if ([_allMySuppliersArrayInOrder[selectedIndex] count] > 0) {
        return [[_allMySuppliersArrayInOrder[selectedIndex][section-1] objectForKey:_allSectionsArray[selectedIndex][section-1]] count];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RecentContactTableViewCell *cell = (RecentContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentContactTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierInfos:_allRecentSuppliersArray[selectedIndex]];
        cell.delegate = self;
        return cell;
    }
    
    MySupplierTableViewCell *cell = (MySupplierTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MySupplierTableViewCell" forIndexPath:indexPath];
    NSArray *subArray = [_allMySuppliersArrayInOrder[selectedIndex][indexPath.section-1] objectForKey:_allSectionsArray[selectedIndex][indexPath.section-1]];
    [cell setCellContentWithSupplierInfo:subArray[indexPath.row]];
    return cell;
}

// 索引目录
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _allSectionsArray[selectedIndex];
}

// 点击目录
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 最近联系section不显示
    return index+1;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        // jump to detail
        SupplierDetailViewController *detail = [[SupplierDetailViewController alloc] init];
        NSArray *subArray = [_allMySuppliersArrayInOrder[selectedIndex][indexPath.section-1] objectForKey:_allSectionsArray[selectedIndex][indexPath.section-1]];
        SupplierInfo *curInfo = subArray[indexPath.row];
        detail.info = curInfo;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

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
        label.text = @"最近联系";
    } else {
        label.text = _allSectionsArray[selectedIndex][section-1];
    }
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95.f;
    }
    return 58.f;
}

#pragma mark - RecentContactTableViewCell_Delegate
- (void)supportClickWithRecentContactSupplierIndex:(NSInteger)index
{
    SupplierInfo *selectedInfo = _allRecentSuppliersArray[selectedIndex][index];
    // go to supplier's page
    SupplierDetailViewController *detail = [[SupplierDetailViewController alloc] init];
    detail.info = selectedInfo;
    [self.navigationController pushViewController:detail animated:YES];
}


- (IBAction)domesticButton_zhuanXianClicked:(id)sender {
    selectedIndex = 0;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)abroadButton_zhuanXianClicked:(id)sender {
    selectedIndex = 1;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender {
    selectedIndex = 2;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)domesticButton_diJieClicked:(id)sender {
    selectedIndex = 3;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)abroadBUtton_diJieClicked:(id)sender {
    selectedIndex = 4;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
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
    if ([_allMySuppliersArrayInOrder[index] count] == 0) {
        [self getMySuppliers];
    }
}

@end
