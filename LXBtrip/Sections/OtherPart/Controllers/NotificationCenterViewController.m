//
//  NotificationCenterViewController.m
//  LXBtrip
//
//  Created by C_Team on 15/6/30.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "NotificationCenterViewController.h"
#import "NotificationTableViewCell.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "CustomActivityIndicator.h"

@interface NotificationCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;

@property (retain, nonatomic) NSMutableArray *notificationsArray;

@end

@implementation NotificationCenterViewController

- (NSMutableArray *)notificationsArray
{
    if (!_notificationsArray) {
        _notificationsArray = [[NSMutableArray alloc] init];
    }
    
    return  _notificationsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"消息";
    
    self.notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.notificationTableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"notificationCell"];

    [self getAllNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getAllNotifications
{
        __weak NotificationCenterViewController *weakSelf = self;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval=10;
        
        NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
        
        NSString *partialUrl = [NSString stringWithFormat:@"%@myself/sysMsg", HOST_BASE_URL];
    
        [manager POST:partialUrl parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
             
             if (responseObject)
             {
                 id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
                 NSLog(@"%@", jsonObj);
                 
                 if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                     
                     NSArray *resultArray = [jsonObj objectForKey:@"RS100025"];
                     
                     if (resultArray && [resultArray isKindOfClass:[NSArray class]]) {
                         
//                         if (weakSelf.pageNum == 0) {
//                             [weakSelf.dispatchersArray removeAllObjects];
//                         }
//                         
//                         weakSelf.pageNum += 1;
                         
                         [weakSelf.notificationsArray addObjectsFromArray:resultArray];
                         [weakSelf.notificationTableView reloadData];
                     }
                 }
                 else if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]] && [[jsonObj stringValueByKey:@"error_code"] isEqualToString:@"90001"]) {
//                     weakSelf.isAllLoaded = YES;
                 }
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
         }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationsArray == nil ? 0 : self.notificationsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    
    NSDictionary *sysMsgDic = [self.notificationsArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [sysMsgDic stringValueByKey:@"msg_title"];
//    cell.dateLabel.text = [sysMsgDic stringValueByKey:@"msg_date"];
    
    double timeInterval = [(NSNumber *)[sysMsgDic stringValueByKey:@"msg_date"] doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
    /*
     "msg_content" = "\U6d4b\U8bd5\U5185\U5bb9";
     "msg_date" = 1434528721282;
     "msg_title" = "\U6d4b\U8bd5\U6807\U9898";
     "msg_type" = 0;
     "msg_url" = "http://www.baidu.com";
     */
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    DispaterInfoViewController *viewController = [[DispaterInfoViewController alloc] init];
//    viewController.isUpdateDispatcher = YES;
//    viewController.dispatcherDic = [self.dispatchersArray objectAtIndex:indexPath.row];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
    
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
