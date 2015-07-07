//
//  DispatchersViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "DispatchersViewController.h"
#import "DispatcherTableViewCell.h"
#import "AppMacro.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "NSDictionary+GetStringValue.h"
#import "UIViewController+CommonUsed.h"
#import "DispaterInfoViewController.h"
#import "AddDispatcherViewController.h"
#import "CustomActivityIndicator.h"
#import "ShareView.h"

@interface DispatchersViewController ()<DispatcherActionDelegate, UIActionSheetDelegate, ShareViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dispatchersTableView;

@property (retain, nonatomic) NSMutableArray *dispatchersArray;
@property (assign, nonatomic) int pageNum;
@property (assign, nonatomic) BOOL isLoadingMore;
@property (assign, nonatomic) BOOL isAllLoaded;

@property (retain, nonatomic) NSDictionary *operatedDispatcherDic;

@property (strong, nonatomic) ShareView *shareView;
@property (strong, nonatomic) UIControl *darkMask;

@end

@implementation DispatchersViewController

- (NSMutableArray *)dispatchersArray
{
    if (!_dispatchersArray) {
        _dispatchersArray = [[NSMutableArray alloc] init];
    }
    
    return _dispatchersArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pageNum = 0;
    
    [self.dispatchersTableView registerNib:[UINib nibWithNibName:@"DispatcherTableViewCell" bundle:nil] forCellReuseIdentifier:@"dispatcherCell"];
    
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"添加" image:nil];

    self.title = @"我的分销商";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDispatchers:) forControlEvents:UIControlEventValueChanged];
    
    [self.dispatchersTableView addSubview:refreshControl];
    
//    [self getDispathersListForPage:self.pageNum];
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    [self refreshDispatcherList];
}

- (void)refreshDispatchers:(UIRefreshControl *)sender
{
    [sender endRefreshing];

    [self refreshDispatcherList];
}

- (void)refreshDispatcherList
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    self.pageNum = 0;
    self.isAllLoaded = NO;
    
    [self getDispathersListForPage:self.pageNum];
}

- (void)getMoreDispatchers
{
    if (!self.isAllLoaded)
    {
        [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

        [self getDispathersListForPage:self.pageNum];
    }
}


- (void)getDispathersListForPage:(int)pageNum
{
    __weak DispatchersViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/distributor", HOST_BASE_URL];
    NSDictionary *parameterDic = @{@"pagenum":[NSString stringWithFormat:@"%d", pageNum + 1], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 id resultObj = [jsonObj objectForKey:@"RS100023"];
                 
                 if (resultObj && [resultObj isKindOfClass:[NSArray class]]) {
                     
                     if (weakSelf.pageNum == 0) {
                         [weakSelf.dispatchersArray removeAllObjects];
                     }
                     
                     weakSelf.pageNum += 1;
                     
                     [weakSelf.dispatchersArray addObjectsFromArray:resultObj];
                     [weakSelf.dispatchersTableView reloadData];
                 }
                 else if (resultObj && [resultObj isKindOfClass:[NSDictionary class]] && [[resultObj stringValueByKey:@"error_code"] isEqualToString:@"90001"]) {
                     weakSelf.isAllLoaded = YES;
                 }
             }
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
     }];
}


- (void)rightBarButtonItemClicked:(id)sender
{
    AddDispatcherViewController *viewController = [[AddDispatcherViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dispatchersArray == nil ? 0 : self.dispatchersArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DispatcherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dispatcherCell"];
    
    [cell initialContactInformation:[self.dispatchersArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddDispatcherViewController *viewController = [[AddDispatcherViewController alloc] init];
    viewController.isAlterDispatcher = YES;
    viewController.dispatcherInfoDic = [self.dispatchersArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dispatchersArray.count - 1 == indexPath.row) {
        [self getMoreDispatchers];
    }
}

#pragma mark - dispatcherCell delegate

- (void)responseForAction:(Actiontypes)type forContactIndex:(NSInteger)index
{
    self.operatedDispatcherDic = [self.dispatchersArray objectAtIndex:index];
    
    switch (type) {
        case DialToDispatcher:
        {
            NSString *phoneNum = [self.operatedDispatcherDic stringValueByKey:@"staff_partner_phonenum"];
            [self showMenuSheetWithPhoneNumber:phoneNum];
        }
            break;
        case ShareDispatcherInfo:
        {
            //TODO: send_mstort_rul
            if (!_shareView) {
                _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
                _shareView.delegate = self;
                [self.view addSubview:_shareView];
            }
            CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:nil];
            [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
            
            [self showShareView];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - alert

- (void)showMenuSheetWithPhoneNumber:(NSString *)phoneNum
{
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"选择联系方式(%@)", phoneNum] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNum]]];
            ;
        }];
        
        UIAlertAction *smsAction = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:phoneNum]]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            ;
        }];
        
        [alertController addAction:telAction];
        [alertController addAction:smsAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"选择联系方式(%@)", phoneNum] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话",@"短信", nil];
        
        [actionSheet showFromRect:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0) inView:self.view animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *phoneNum = [self.operatedDispatcherDic stringValueByKey:@"staff_partner_phonenum"];
    
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNum]]];
            break;
        case 1:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:phoneNum]]];
            break;
            
        default:
            break;
    }
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaWeChatWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] title:[self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaQQWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] title:[self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self shareType:QQ_Share_Session];
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaQQWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] title:[self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaSMSWithContent:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景。请点击查看: %@", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"], [self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"]] presentedController:self];
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self supportClickWithQQWithShareObject:obj];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaYiXinWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaSinaWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self];
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareView];
    
    [[Global sharedGlobal] shareViaWeChatWithURLString:[self.operatedDispatcherDic stringValueByKey:@"send_mstort_url"] title:[self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"] content:[NSString stringWithFormat:@"%@，邀您同游，乐享世界美景", [self.operatedDispatcherDic stringValueByKey:@"staff_departments_name"]] image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
}

- (void)supportClickWithCancel
{
    [self hideShareView];
}

#pragma mark - private
- (void)hideShareView
{
    // must not delete, otherwise 'hidePopUpViews' will make the y-offset incorrect
    if (_shareView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationController.navigationBar.alpha = 1;
        }
    }];
}
- (void)showShareView
{
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height-_shareView.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    }];
}

- (void)hidePopUpViews
{
    [self hideShareView];
    _darkMask.alpha = 0;
}
@end
