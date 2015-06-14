//
//  AlleyDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailViewController.h"
#import "AlleyDetailCell_Top.h"
#import "AlleyDetailCell_JoinNum.h"
#import "AlleyDetailCell_Location.h"
#import "AlleyDetailCell_Instruction.h"
#import "AppMacro.h"

@interface AlleyDetailViewController () < UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *cellHeights;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)callButtonClicked:(id)sender;

@end

@implementation AlleyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务商信息";
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Top" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Top"];
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_JoinNum" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_JoinNum"];
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Location" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Location"];
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Instruction" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Instruction"];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self getAlleyDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)getAlleyDetail
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getServiceDetailWithServiceId:_alley.alleyId success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100021"] succeed:^{
            _alley = [[AlleyInfo alloc] initWithDict:result[@"RS100021"]];
            [_tableView reloadData];
        } fail:^(id result) {
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_alley.alleyServiceNotice) {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            AlleyDetailCell_Top *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Top" forIndexPath:indexPath];
            if (!cellHeights) {
                cellHeights = [[NSMutableArray alloc] init];
            }
            [cellHeights addObject:@([cell cellHeightWithAlleyInfo:_alley])];
            return cell;
        }
            break;
        case 1:
        {
            AlleyDetailCell_JoinNum *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_JoinNum" forIndexPath:indexPath];
            [cellHeights addObject:@([cell cellHeightWithAlleyInfo:_alley])];
            return cell;
        }
            break;
        case 2:
        {
            AlleyDetailCell_Location *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Location" forIndexPath:indexPath];
            [cellHeights addObject:@([cell cellHeightWithAlleyInfo:_alley])];
            return cell;
        }
            break;
        case 3:
        {
            AlleyDetailCell_Instruction *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Instruction" forIndexPath:indexPath];
            [cellHeights addObject:@([cell cellHeightWithAlleyInfo:_alley])];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [cellHeights[indexPath.row] floatValue];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)callButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _alley.alleyContactPhoneNo]]];
}
@end
