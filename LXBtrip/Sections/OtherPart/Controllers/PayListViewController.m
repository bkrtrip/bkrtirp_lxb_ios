//
//  PayListViewController.m
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PayListViewController.h"
#import "WebChatPayTableViewCell.h"
#import "PayConfigViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

@interface PayListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *payTableView;

@property (assign, nonatomic) BOOL isWebPayOpened;

@end

@implementation PayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payTableView registerNib:[UINib nibWithNibName:@"WebChatPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"webChatPayCell"];
    
    self.payTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    self.title = @"支付";
    
    [self getPaymentInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getPaymentInformation];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WebChatPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webChatPayCell"];
    [cell changePayOpenState:self.isWebPayOpened];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PayConfigViewController *viewController = [[PayConfigViewController alloc] initWithNibName:@"PayConfigViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)getPaymentInformation
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    __weak PayListViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    if ([staffDic stringValueByKey:@"staff_id"].length == 0) {
        return;
    }
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/isOpenPay", HOST_BASE_URL];
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
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100029"];
                 
                 if (resultDic && [resultDic stringValueByKey:@"error_code"].length == 0) {
                     
                     weakSelf.isWebPayOpened = YES;
                     [weakSelf.payTableView reloadData];
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
