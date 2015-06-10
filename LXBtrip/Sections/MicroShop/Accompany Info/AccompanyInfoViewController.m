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
    [_tableView registerNib:[UINib nibWithNibName:@"AccompanyInfoCell_Company" bundle:nil] forCellReuseIdentifier:@"AccompanyInfoCell_Company"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccompanyInfo_Instructions" bundle:nil] forCellReuseIdentifier:@"AccompanyInfo_Instructions"];
    _tableView.backgroundColor = BG_F5F5F5;
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = BG_F5F5F5;
    _tableView.tableFooterView = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

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
