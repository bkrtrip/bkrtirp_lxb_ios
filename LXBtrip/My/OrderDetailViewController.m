//
//  OrderDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCell_ContactInfo.h"
#import "OrderDetailCell_OrderInfo.h"
#import "OrderDetailCell_TotalAmount.h"
#import "OrderDetailCell_TouristsInfo.h"
#import "CreateOrderCell_BookHeader.h"
#import "CreateOrderCell_OrderId.h"


@interface OrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_OrderId" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_OrderId"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_ContactInfo" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_ContactInfo"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_TotalAmount" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_TotalAmount"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell_TouristsInfo" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell_TouristsInfo"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_BookHeader" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_BookHeader"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return <#expression#>
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CreateOrderCell_OrderId *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_OrderId" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:
        {
            OrderDetailCell_OrderInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_OrderInfo" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 2:
        {
            OrderDetailCell_ContactInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell_ContactInfo" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 0:
        {
            CreateOrderCell_OrderId *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_OrderId" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 0:
        {
            CreateOrderCell_OrderId *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_OrderId" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        default:
            break;
    }
    }

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
