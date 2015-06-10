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

@interface PayListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *payTableView;

@end

@implementation PayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payTableView registerNib:[UINib nibWithNibName:@"WebChatPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"webChatPayCell"];
    
    self.payTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
