//
//  TourDetailTableViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailTableViewController.h"
#import "TourDetailCell_One.h"
#import "TourDetailCell_Two.h"
#import "TourDetailCell_Three.h"
#import "TourDetailCell_Four.h"

@interface TourDetailTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TourDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:nil image:ImageNamed(@"share_red")];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_One" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_One"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Two" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Two"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Three" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Three"];
    [_tableView registerNib:[UINib nibWithNibName:@"TourDetailCell_Four" bundle:nil] forCellReuseIdentifier:@"TourDetailCell_Four"];
    
    [self getTourDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)rightBarButtonItemClicked:(id)sender
{
    //
}

- (void)getTourDetail
{
    [HTTPTool getTourDetailWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_product.productTravelGoodsId lineCode:_product.productTravelGoodsCode success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100008"] succeed:^{
            NSLog(@"result[@\"RS100008\"]: %@", result[@"RS100008"]);
        }];
    } fail:^(id result) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            TourDetailCell_One *cell = [tableView dequeueReusableCellWithIdentifier:@"TourDetailCell_One" forIndexPath:indexPath];

        }
            break;
            
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return nil;
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
