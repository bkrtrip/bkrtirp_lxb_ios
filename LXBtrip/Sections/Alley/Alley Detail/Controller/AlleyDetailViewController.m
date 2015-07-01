//
//  AlleyDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailViewController.h"
#import "AlleyDetailCell_Top.h"
#import "AlleyDetailCell_Location.h"
#import "AlleyDetailCell_Instruction.h"
#import "AppMacro.h"

@interface AlleyDetailViewController () < UITableViewDataSource, UITableViewDelegate, AlleyDetailCell_Instruction_Delegate>
{
    NSMutableDictionary *cellHeights;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *callButton;
- (IBAction)callButtonClicked:(id)sender;
@end

@implementation AlleyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _callButton.layer.cornerRadius = 5.f;
    self.title = @"服务商信息";
    cellHeights = [[NSMutableDictionary alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Top" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Top"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Location" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Location"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AlleyDetailCell_Instruction" bundle:nil] forCellReuseIdentifier:@"AlleyDetailCell_Instruction"];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getAlleyDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

#pragma mark - AlleyDetailCell_Instruction_Delegate
- (void)instructionCellFinishedLoadingWithHeight:(CGFloat)height
{
    [cellHeights setObject:@(height) forKey:@"third_cell_height"];
    [_tableView reloadData];
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)getAlleyDetail
{
    [HTTPTool getServiceDetailWithServiceId:_alley.alleyId success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        [cellHeights removeAllObjects];
        
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100021"] succeed:^{
            _alley = [[AlleyInfo alloc] initWithDict:result[@"RS100021"]];
            
            AlleyDetailCell_Location *locationCell = [[NSBundle mainBundle]loadNibNamed:@"AlleyDetailCell_Location" owner:nil options:nil][0];
            CGFloat cellHeight = [locationCell cellHeightWithAlleyInfo:_alley distance:_distance];
            [cellHeights setObject:@(cellHeight) forKey:@"second_cell_height"];
            
            [_tableView reloadData];
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_alley) {
        return 0;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            AlleyDetailCell_Top *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Top" forIndexPath:indexPath];
            [cell setCellContentWithAlleyInfo:_alley];
            return cell;
        }
            break;
        case 1:
        {
            AlleyDetailCell_Location *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Location" forIndexPath:indexPath];
            CGFloat cellHeight = [cell cellHeightWithAlleyInfo:_alley distance:_distance];
            [cellHeights setObject:@(cellHeight) forKey:@"second_cell_height"];
            return cell;
        }
            break;
        case 2:
        {
            AlleyDetailCell_Instruction *cell = [tableView dequeueReusableCellWithIdentifier:@"AlleyDetailCell_Instruction" forIndexPath:indexPath];
            [cell setCellContentWithAlleyInfo:_alley];
            cell.delegate = self;
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
    switch (indexPath.row) {
        case 0:
            return 200.f;
            break;

        case 1:
            return [cellHeights[@"second_cell_height"] floatValue];
            break;
        case 2:
            return [cellHeights[@"third_cell_height"] floatValue];
            break;
        default:
            return 0;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)callButtonClicked:(id)sender {
    [[Global sharedGlobal] callWithPhoneNumber:_alley.alleyContactPhoneNo];
}
@end
