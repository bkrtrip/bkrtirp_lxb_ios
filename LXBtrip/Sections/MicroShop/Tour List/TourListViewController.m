//
//  TourListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListViewController.h"
#import "TourListTableViewCell.h"
#import "AppMacro.h"

@interface TourListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TourListTableViewCell_Delegate>
{
    NSString *startCity;
    NSString *endCity;
    NSInteger dayNum;
    NSString *lineName;
    NSInteger pageNum;
    
    NSMutableArray *productsArray;
    NSArray *cityCategoriesArray;
    NSMutableArray *innerCitiesArray;
    NSMutableArray *outerCitiesArray;
    NSArray *walkTypesArray;
}

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchButtonClicked:(id)sender;

- (IBAction)destinationButtonClicked:(id)sender;
- (IBAction)calendarButtonClicked:(id)sender;

- (IBAction)toTopButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UITableView *leftTableView_EndCity;
@property (strong, nonatomic) IBOutlet UITableView *rightTableView_EndCity;
@property (strong, nonatomic) IBOutlet UITableView *walkTableView;

@property (nonatomic, copy) SupplierInfo *info;

@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _searchButton.layer.cornerRadius = 5.f;
    [_searchBar setImage:ImageNamed(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    
    cityCategoriesArray = @[@"国内", @"国外"];
    cityCategoriesArray = @[@"不限", @"跟团游", @"自由行", @"半自助"];
}

- (void)getTourList
{
    [HTTPTool getTourListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_templateId customId:_customId startCity:startCity endCity:endCity dayNum:@(dayNum) lineName:lineName pageNum:@(pageNum) success:^(id result) {
        id data = result[@"RS100007"];
        [[Global sharedGlobal] codeHudWithObject:data succeed:^{
            _info = [[SupplierInfo alloc] initWithDict:data];
            
            if (!productsArray) {
                productsArray = [[NSMutableArray alloc] init];
            }
            productsArray = [_info.supplierProductsArray mutableCopy];
            
            if (!innerCitiesArray) {
                innerCitiesArray = [[NSMutableArray alloc] init];
            }
            innerCitiesArray = [[_info.supplierInnerEndCity componentsSeparatedByString:@"#"] mutableCopy];
            
            if (!outerCitiesArray) {
                outerCitiesArray = [[NSMutableArray alloc] init];
            }
            outerCitiesArray = [[_info.supplierOuterEndCity componentsSeparatedByString:@"#"] mutableCopy];
            
            [_mainTableView reloadData];
            [_rightTableView_EndCity reloadData];
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TourListTableViewCell *cell = (TourListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
//    [cell setCellContentWithTourInfo:_toursArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (IBAction)locationButtonClicked:(id)sender {
}

- (IBAction)backButtonClicked:(id)sender {
}
- (IBAction)searchButtonClicked:(id)sender {
}
- (IBAction)destinationButtonClicked:(id)sender {
}

- (IBAction)calendarButtonClicked:(id)sender {
}

- (IBAction)toTopButtonClicked:(id)sender {
    
}

#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButton
{
    
}
@end
