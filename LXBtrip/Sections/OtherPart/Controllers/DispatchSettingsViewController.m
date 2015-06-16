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
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"

@interface DispatchSettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
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
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存" image:nil];
    
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
        return 2;
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
        
        return cell;
    }
    else {
        DispatchProfitRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dispatchProfileRateCell"];
        
        double profileRate = [(NSNumber *)[self.dSettingsDic stringValueByKey:@"value"] doubleValue] * 100;

        cell.profitRateLabel.text = [NSString stringWithFormat:@"%.2f %%", profileRate];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
