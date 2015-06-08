//
//  UIViewController+CommonUsed.m
//  lxb
//
//  Created by Sam on 3/5/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "UIViewController+CommonUsed.h"
//#import "WZRefreshIndicatorView.h"

@implementation UIViewController (UIViewController_CommonUsed)

- (UIViewController *)getViewControllerByMainStoryboardId:(NSString *)storyboardId
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    return [mainStoryboard instantiateViewControllerWithIdentifier:storyboardId];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle
{
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            ;
        }];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
        [alertView show];
    }
}

/*
- (void)showActiveIndicatiorView:(BOOL)isShow
{
    UIView *activeIndicatorBgView = [self.view viewWithTag:99889];
    WZRefreshIndicatorView *refreshView = (WZRefreshIndicatorView *)[activeIndicatorBgView viewWithTag:kRefreshViewTag];
    if (!activeIndicatorBgView)
    {
        activeIndicatorBgView = [[UIView alloc]initWithFrame:self.view.frame];
        activeIndicatorBgView.tag = 99889;
        activeIndicatorBgView.backgroundColor = [UIColor clearColor];
        
        refreshView = [[WZRefreshIndicatorView alloc] createDefaultRefreshView];
        refreshView.center = CGPointMake(activeIndicatorBgView.bounds.size.width/2, activeIndicatorBgView.bounds.size.height/2 + 50);
        
        [activeIndicatorBgView addSubview:refreshView];
        [self.view addSubview:activeIndicatorBgView];
    }
    
    if (isShow)
    {
        activeIndicatorBgView.hidden = NO;
        [refreshView startRefreshing];
    }
    else
    {
        [refreshView stopRefreshing];
        [activeIndicatorBgView removeFromSuperview];
    }
}
*/

- (void)customizeSeparatorForTableView:(UITableView *)tableview
{
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    //works for ios8
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Private methods
- (id)jsonObjWithBase64EncodedJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:jsonString options:0];
    
    NSError *error = nil;
    id dict = [NSJSONSerialization JSONObjectWithData:decodedData options:kNilOptions error:&error];
    return dict;
}

@end























