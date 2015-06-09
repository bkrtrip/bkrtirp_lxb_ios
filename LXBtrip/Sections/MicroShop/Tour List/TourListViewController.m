//
//  TourListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListViewController.h"
#import "TourListTableViewCell.h"

@interface TourListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TourListTableViewCell_Delegate>
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchButtonClicked:(id)sender;

- (IBAction)destinationButtonClicked:(id)sender;
- (IBAction)calendarButtonClicked:(id)sender;

- (IBAction)toTopButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *toursArray;

@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _searchButton.layer.cornerRadius = 5.f;
    [_searchBar setImage:ImageNamed(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    
    _toursArray = [[NSMutableArray alloc] init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _toursArray.count;
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
