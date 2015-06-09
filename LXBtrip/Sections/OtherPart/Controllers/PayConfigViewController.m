//
//  PayConfigViewController.m
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PayConfigViewController.h"
#import "InfoConfigTableViewCell.h"

@interface PayConfigViewController ()

@end

@implementation PayConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InfoConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoConfigCell"];
    
    switch (indexPath.row) {
        case 0:
        {
            [cell initializeCellForType:WCPublicUserName];
        }
            break;
        case 1:
        {
            [cell initializeCellForType:WCPwd];
        }
            break;
        case 2:
        {
            [cell initializeCellForType:PublicAppId];
        }
            break;
        case 3:
        {
            [cell initializeCellForType:PublicSecret];
        }
            break;
        case 4:
        {
            [cell initializeCellForType:WCPayAcount];
        }
            break;
        case 5:
        {
            [cell initializeCellForType:WCPaySecret];
        }
            break;
            
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
