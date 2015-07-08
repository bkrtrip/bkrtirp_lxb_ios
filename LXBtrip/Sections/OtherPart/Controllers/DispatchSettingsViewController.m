//
//  DispatchSettingsViewController.m
//  LXBtrip
//
//  Created by Sam on 6/14/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "DispatchSettingsViewController.h"
#import "DispatchSwitchTableViewCell.h"
#import "DispatchProfitRateTableViewCell.h"
#import "DSettingFooterTableViewCell.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"
#import "AlterUserInfoViewController.h"

@interface DispatchSettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UpdateUserInformationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dSettingsTableView;

@property (retain, nonatomic) NSDictionary *dSettingsDic;

@end

@implementation DispatchSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.dSettingsTableView registerNib:[UINib nibWithNibName:@"DispatchSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"dispatchSwitchCell"];

    [self.dSettingsTableView registerNib:[UINib nibWithNibName:@"DispatchProfitRateTableViewCell" bundle:nil] forCellReuseIdentifier:@"dispatchProfileRateCell"];
    
    [self.dSettingsTableView registerNib:[UINib nibWithNibName:@"DSettingFooterTableViewCell" bundle:nil] forCellReuseIdentifier:@"dSettingFooterCell"];

    [self getDispatchSettingsInfo];
    
    self.title = @"分销";
//    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存" image:nil];
    
    self.dSettingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightBarButtonItemClicked:(id)sender
{
    //TODO: save changes
}

- (void)getDispatchSettingsInfo
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    __weak DispatchSettingsViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/isOpenDistributor", HOST_BASE_URL];
    
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100054"];
                 
                 if (resultDic) {
                     weakSelf.dSettingsDic = resultDic;
                     [weakSelf.dSettingsTableView reloadData];
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}

- (BOOL)isUserOpenDispatchFunction
{
    if (self.dSettingsDic && [[self.dSettingsDic stringValueByKey:@"key"] isEqualToString:@"1"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isUserOpenDispatchFunction]) {
        return 3;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DispatchSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dispatchSwitchCell"];
        if ([self isUserOpenDispatchFunction]) {
            [cell.dispatchSwitch setOn:YES animated:YES];
        }
        else {
            [cell.dispatchSwitch setOn:NO animated:YES];
        }
        
        [cell.dispatchSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([self isUserOpenDispatchFunction]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        else {
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        }
        
        return cell;
    }
    else if (indexPath.row == 1) {
        DispatchProfitRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dispatchProfileRateCell"];
        
        double profileRate = [(NSNumber *)[self.dSettingsDic stringValueByKey:@"value"] doubleValue] * 100;

        cell.profitRateLabel.text = [NSString stringWithFormat:@"%.0f %%", profileRate];
        
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        
        return cell;
    }
    else {
        DSettingFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dSettingFooterCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);

        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 280;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        AlterUserInfoViewController *viewController = [[AlterUserInfoViewController alloc] init];
        viewController.type = DispatchRate;
        viewController.delegate = self;
        viewController.dispatchSettingDic = self.dSettingsDic;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UpdateUserInformationDelegate

- (void)informationAlteredTo:(NSString *)changedInfor forType:(AlterInfoTypes)type
{
    DispatchProfitRateTableViewCell *cell = (DispatchProfitRateTableViewCell *)[self.dSettingsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    double profileRate = [changedInfor doubleValue] * 100;
    
    cell.profitRateLabel.text = [NSString stringWithFormat:@"%.0f %%", profileRate];
    
    changedInfor = [NSString stringWithFormat:@"%.2f", [changedInfor doubleValue] / 100];
    [self updateDSettingsForOpenState:@"1" rate:changedInfor];
}

- (void)switchChanged:(UISwitch *)sender
{
    NSString *isopenState = sender.on ? @"1" : @"0";
    NSString *rate = @"0.00";
    if (self.dSettingsDic && [self.dSettingsDic stringValueByKey:@"value"].length > 0) {
        rate = [self.dSettingsDic stringValueByKey:@"value"];
    }
    
    [self updateDSettingsForOpenState:isopenState rate:rate];
}

- (void)updateDSettingsForOpenState:(NSString *)openState rate:(NSString *)rate
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    __weak DispatchSettingsViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    if (!staffDic) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/distributionSet", HOST_BASE_URL];
    
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"], @"isopen":openState, @"value":rate};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100027"];
                 
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     
                     [weakSelf getDispatchSettingsInfo];
                 }
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
