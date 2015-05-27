//
//  OpenMiroShopViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OpenMiroShopViewController.h"
#import "UploadingIconTableViewCell.h"
#import "InfoTableViewCell.h"
#import "SetShopNameViewController.h"
#import "SetShopContactViewController.h"
#import "SetShopPhoneNumberViewController.h"

@interface OpenMiroShopViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tablview;

@end

@implementation OpenMiroShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItemWithRightBarItemTitle:@"完成"];
    
    [_tablview registerNib:[UINib nibWithNibName:@"UploadingIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"UploadingIconTableViewCell"];
    
    [_tablview registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoTableViewCell"];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UploadingIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadingIconTableViewCell" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:
        {
            InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
            cell.categoryNameLabel.text = @"微店名称";
            cell.inputTextField.placeholder = @"请输入企业名称（此名称在微店头部展示）";
            return cell;
        }
            break;
        case 2:
        {
            InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
            cell.categoryNameLabel.text = @"微店联系人";
            cell.inputTextField.placeholder = @"请输入线路咨询的联系人姓名";
            return cell;
        }
            break;
        case 3:
        {
            InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
            cell.categoryNameLabel.text = @"联系电话";
            cell.inputTextField.placeholder = @"";
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 105.f;
            break;
        default:
            return 57.f;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // go to image picker
        }
            break;
        case 1:
        {
            // go to set shop name
            SetShopNameViewController *nameController = [[SetShopNameViewController alloc] init];
            [self.navigationController pushViewController:nameController animated:YES];
        }
            break;
        case 2:
        {
            // go to set shop contact
            SetShopContactViewController *contactController = [[SetShopContactViewController alloc] init];
            [self.navigationController pushViewController:contactController animated:YES];
        }
            break;
        case 3:
        {
            // go to set shop phone number
            SetShopPhoneNumberViewController *phoneController = [[SetShopPhoneNumberViewController alloc] init];
            [self.navigationController pushViewController:phoneController animated:YES];
        }
            break;
        default:
            break;
    }
}




















@end
