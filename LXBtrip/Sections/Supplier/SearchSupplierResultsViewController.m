//
//  SearchSupplierResultsViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplierResultsViewController.h"
#import "AppMacro.h"
#import "Global.h"
#import "TourListTableViewCell.h"
#import "SearchSupplier_SearchLineClassTableViewCell.h"

typedef enum DropDownType
{
    None_Type = 0,
    StartCity_Type = 1,
    Travel_Type = 2
} DropDownType;

@interface SearchSupplierResultsViewController ()
{
    NSInteger pageNum;
    NSMutableArray *searchedResultsArray;
    NSMutableArray *starCitiesArray;
    NSMutableArray *travelTypesArray;
    DropDownType dropDownType;
}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;


@property (strong, nonatomic) IBOutlet UIButton *startCityButton;
@property (strong, nonatomic) IBOutlet UIButton *travelTypeButton;
- (IBAction)startCityButtonClicked:(id)sender;
- (IBAction)travelTypeButton:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_StartCity;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_StartCity;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Closed_TravelType;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Open_TravelType;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *dropDownTableView;

@property (strong, nonatomic) UIControl *darkMask;


@end

@implementation SearchSupplierResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageNum = 0;
    dropDownType = None_Type;
    searchedResultsArray = [[NSMutableArray alloc] init];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    _mainTableView.backgroundColor = BG_E9ECF5;
    
    [_dropDownTableView registerNib:[UINib nibWithNibName:@"SearchSupplier_SearchLineClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchSupplier_SearchLineClassTableViewCell"];
    _dropDownTableView.tableFooterView = [[UIView alloc] init];
    _dropDownTableView.backgroundColor = [UIColor clearColor];
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(dismissDropDownTableView) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
    [self.view insertSubview:_darkMask belowSubview:_dropDownTableView];
}

- (void)dismissDropDownTableView
{
    if (dropDownType == StartCity_Type) {
        [self foldStartCity];
    } else if (dropDownType == Travel_Type) {
        [self foldTravelType];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _mainTableView) {
        return searchedResultsArray.count;
    }
    if (dropDownType == StartCity_Type) {
        return starCitiesArray.count;
    }
    return travelTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        TourListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierProduct:searchedResultsArray[indexPath.row]];
        return cell;
    }
    
    if (dropDownType == StartCity_Type) {
        SearchSupplier_SearchLineClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchLineClassTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithLineClassName:starCitiesArray[indexPath.row]];
        return cell;
    }
    
    SearchSupplier_SearchLineClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSupplier_SearchLineClassTableViewCell" forIndexPath:indexPath];
    [cell setCellContentWithLineClassName:travelTypesArray[indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - HTTP
- (void)getSearchedSupplierResults
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool searchSupplierListWithStartCity:_startCity lineClass:_lineClass hotTheme:_hotTheme keyword:_keyword pageNum:@(pageNum) success:^(id result) {
            id data = result[@"RS100013"];
            [[Global sharedGlobal] codeHudWithObject:data succeed:^{
                if ([data isKindOfClass:[NSArray class]]) {
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
                        [searchedResultsArray addObject:product];
                    }];
                }
                [_mainTableView reloadData];
            } fail:^(id result) {
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startCityButtonClicked:(id)sender {
    if (dropDownType == StartCity_Type) {
        [self foldStartCity];
    }
    else if (dropDownType == Travel_Type) {
        [self foldTravelType];
        [self unfoldStartCity];
    }
    else if (dropDownType == None_Type) {
        [self unfoldStartCity];
    }
}

- (IBAction)travelTypeButton:(id)sender {
    if (dropDownType == StartCity_Type) {
        [self foldStartCity];
        [self unfoldTravelType];
    }
    else if (dropDownType == Travel_Type) {
        [self foldTravelType];
    }
    else if (dropDownType == None_Type) {
        [self unfoldTravelType];
    }
}

#pragma mark - Private

- (void)unfoldStartCity
{
    [UIView animateWithDuration:0.2 animations:^{
        _imageView_Closed_StartCity.hidden = YES;
        _imageView_Open_StartCity.hidden = NO;
        _dropDownTableView.hidden = NO;
        _darkMask.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            dropDownType = StartCity_Type;
            [_dropDownTableView reloadData];
        }
    }];
}

- (void)foldStartCity
{
    [UIView animateWithDuration:0.2 animations:^{
        _imageView_Closed_StartCity.hidden = NO;
        _imageView_Open_StartCity.hidden = YES;
        _dropDownTableView.hidden = YES;
        _darkMask.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            dropDownType = None_Type;
        }
    }];
}

- (void)unfoldTravelType
{
    [UIView animateWithDuration:0.2 animations:^{
        _imageView_Closed_TravelType.hidden = YES;
        _imageView_Open_TravelType.hidden = NO;
        _dropDownTableView.hidden = NO;
        _darkMask.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            dropDownType = Travel_Type;
            [_dropDownTableView reloadData];
        }
    }];
}

- (void)foldTravelType
{
    [UIView animateWithDuration:0.2 animations:^{
        _imageView_Closed_TravelType.hidden = NO;
        _imageView_Open_TravelType.hidden = YES;
        _dropDownTableView.hidden = YES;
        _darkMask.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            dropDownType = None_Type;
        }
    }];
}

@end
