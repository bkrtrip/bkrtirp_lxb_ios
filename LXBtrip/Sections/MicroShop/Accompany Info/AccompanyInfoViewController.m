//
//  AccompanyInfoViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AccompanyInfoViewController.h"
#import "AccompanyInfoCell_Company.h"
#import "AccompanyInfo_Instructions.h"


@interface AccompanyInfoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat instructionCellHeight;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同行须知";
    
    AccompanyInfo_Instructions *cell = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfo_Instructions" owner:nil options:nil][0];
    instructionCellHeight = [cell cellHeightWithInstructions:_product.productPeerNotice];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AccompanyInfoCell_Company" bundle:nil] forCellReuseIdentifier:@"AccompanyInfoCell_Company"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccompanyInfo_Instructions" bundle:nil] forCellReuseIdentifier:@"AccompanyInfo_Instructions"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = SCREEN_WIDTH/(828.f/304.f) + 52.f + 3.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin - 49.f];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AccompanyInfoCell_Company *cell = [tableView dequeueReusableCellWithIdentifier:@"AccompanyInfoCell_Company" forIndexPath:indexPath];
        [cell setCellContentWithSupplierName:_product.productCompanyName];
        return cell;
    }
    
    AccompanyInfo_Instructions *cell = [tableView dequeueReusableCellWithIdentifier:@"AccompanyInfo_Instructions" forIndexPath:indexPath];
    instructionCellHeight = [cell cellHeightWithInstructions:_product.productPeerNotice];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 57.f;
    }
    return instructionCellHeight;
}

@end
