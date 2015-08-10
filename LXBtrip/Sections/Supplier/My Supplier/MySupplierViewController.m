//
//  MySupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MySupplierViewController.h"
#import "MySupplierTableViewCell.h"
#import "SupplierDetailViewController.h"

@interface MySupplierViewController () <UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic, strong) UILabel *underLineLabel;

@property (nonatomic, copy) NSMutableArray *allSectionsArray;
@property (nonatomic, copy) NSMutableArray *allMySuppliersArray;

@property (strong, nonatomic) UIView *noSupplierView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex; // 0~4

@end

@implementation MySupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mySupplierListHasChanged) name:MY_SHOP_HAS_UPDATED object:nil];
    
    CGFloat yOrigin = 82.f;
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, (SCREEN_WIDTH/2.f)/3, 2)];
    _underLineLabel.backgroundColor = TEXT_4CA5FF;
    [self.view addSubview:_underLineLabel];
    
    // initial status
    [_zhuanXianButton setSelected:YES];
    [_diJieButton setSelected:NO];
    
    [self setUpTableViewWithYOrigin:yOrigin];
    
    _selectedIndex = 0;
    [self initializeData];
    [self getMySuppliers];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"我的供应商";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)mySupplierListHasChanged
{
    [self initializeData];
    [self getMySuppliers];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 82.f + 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)getMySuppliers
{
    [HTTPTool getMySuppliersWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] lineClass:LINE_CLASS[@(_selectedIndex)] success:^(id result) {
        
        [_noSupplierView setHidden:YES];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100018"] succeed:^{
            id data = result[@"RS100018"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                NSMutableArray *tempUngrouped = [[NSMutableArray alloc] init];
                //my_supplier part
                id mySuppliersData = data[@"my_supplier"];
                if ([mySuppliersData isKindOfClass:[NSArray class]]) {
                    [mySuppliersData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierInfo *info= [[SupplierInfo alloc] initWithDict:obj];
                        // 需要手动指定，返回参数中没有，“我的供应商”自然肯定是“我的”
                        info.supplierIsMy = @"0";
                        [tempUngrouped addObject:info];
                    }];
                    // 重新根据字母排序
                    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"supplierLineTypeLetter" ascending:YES];
                    tempUngrouped = [[tempUngrouped sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
                    
                    [tempUngrouped enumerateObjectsUsingBlock:^(SupplierInfo *info, NSUInteger idx, BOOL *stop) {
                        __block BOOL inOldSection = NO;
                        [_allSectionsArray enumerateObjectsUsingBlock:^(NSString *initial, NSUInteger idx, BOOL *stop) {
                            if ([initial isEqualToString:info.supplierLineTypeLetter]) {
                                inOldSection = YES;
                            }
                        }];
                        if (inOldSection == NO) {
                            [_allSectionsArray addObject:info.supplierLineTypeLetter];
                        }
                    }];
                    
                    [_allSectionsArray enumerateObjectsUsingBlock:^(NSString *initial, NSUInteger idx, BOOL *stop) {
                        NSMutableArray *tempUnit = [[NSMutableArray alloc] init];
                        [tempUngrouped enumerateObjectsUsingBlock:^(SupplierInfo *info, NSUInteger idx, BOOL *stop) {
                            if ([initial isEqualToString:info.supplierLineTypeLetter]) {
                                [tempUnit addObject:info];
                            }
                        }];
                        NSDictionary *tempUnitDict = @{initial:tempUnit};
                        [_allMySuppliersArray addObject:tempUnitDict];
                    }];
                } else {
                    [_noSupplierView setHidden:NO];
                    return ;
                }
            }
            [_tableView reloadData];
        }];
    } fail:^(id result) {
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取我的供应商失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allSectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_allSectionsArray.count > section) {
        return [[_allMySuppliersArray[section] objectForKey:_allSectionsArray[section]] count];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySupplierTableViewCell *cell = (MySupplierTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MySupplierTableViewCell" forIndexPath:indexPath];
    NSArray *subArray = [_allMySuppliersArray[indexPath.section] objectForKey:_allSectionsArray[indexPath.section]];
    [cell setCellContentWithSupplierInfo:subArray[indexPath.row]];
    return cell;
}

// 索引目录
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _allSectionsArray;
}

// 点击目录
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplierDetailViewController *detail = [[SupplierDetailViewController alloc] init];
    NSArray *subArray = [_allMySuppliersArray[indexPath.section] objectForKey:_allSectionsArray[indexPath.section]];
    SupplierInfo *curInfo = subArray[indexPath.row];
    detail.info = curInfo;
    detail.lineClass = LINE_CLASS[@(_selectedIndex)];
    [self.navigationController pushViewController:detail animated:YES];
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
    label.text = _allSectionsArray[section];
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.f;
}

- (IBAction)domesticButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 0;
}
- (IBAction)abroadButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 1;
}
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender {
    self.selectedIndex = 2;
}
- (IBAction)domesticButton_diJieClicked:(id)sender {
    self.selectedIndex = 3;
}
- (IBAction)abroadBUtton_diJieClicked:(id)sender {
    self.selectedIndex = 4;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex <= 2) {
        [_zhuanXianButton setSelected:YES];
        [_diJieButton setSelected:NO];
    } else {
        [_zhuanXianButton setSelected:NO];
        [_diJieButton setSelected:YES];
    }
    _selectedIndex = selectedIndex;
    [self scrollToVisibleWithSelectedIndex:_selectedIndex];
}

- (void)scrollToVisibleWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        if (index < 3) {
            [_underLineLabel setFrame:CGRectMake(index*(SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.size.height)];
        } else {
            [_underLineLabel setFrame:CGRectMake(SCREEN_WIDTH/2.0 + (index-3)*(SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.size.height)];
        }
    }];
    
    [self initializeData];
    [self getMySuppliers];
}

#pragma mark - Private
- (void)initializeData
{
    // initialize data
    if (!_allMySuppliersArray) {
        _allMySuppliersArray = [[NSMutableArray alloc] init];
        _allSectionsArray = [[NSMutableArray alloc] init];
    }
    [_allMySuppliersArray removeAllObjects];
    [_allSectionsArray removeAllObjects];

    [_tableView reloadData];
}

- (void)setUpTableViewWithYOrigin:(CGFloat)yOrigin
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin - 64.f)];
    [_tableView registerNib:[UINib nibWithNibName:@"MySupplierTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySupplierTableViewCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self setUpNoSupplierView];
}

- (void)setUpNoSupplierView
{
    _noSupplierView = [[UIView alloc] initWithFrame:CGRectOffset(_tableView.bounds, 0, 0)];
    _noSupplierView.backgroundColor = BG_E9ECF5;
    CGFloat width_height_ratio = 656.f/536.f;
    CGFloat imgHeight = 0.4*_noSupplierView.bounds.size.height;
    CGFloat imgWidth = imgHeight*width_height_ratio;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((_noSupplierView.bounds.size.width - imgWidth)/2.0, 0.1*_noSupplierView.bounds.size.height, imgWidth, imgHeight)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.image = ImageNamed(@"no_my_supplier");
    [_noSupplierView addSubview:imgView];
    // no supplier view initially hidden!
    _noSupplierView.hidden = YES;
    
    [_tableView addSubview:_noSupplierView];
}


@end
