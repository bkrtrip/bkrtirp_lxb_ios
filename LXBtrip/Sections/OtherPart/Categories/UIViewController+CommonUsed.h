//
//  UIViewController+CommonUsed.h
//  lxb
//
//  Created by Sam on 3/5/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlterInforDelegate <NSObject>

- (void)finishAlterWithInfo:(NSArray *)alterResult;

@end

@interface UIViewController (UIViewController_CommonUsed)

- (UIViewController *)getViewControllerByMainStoryboardId:(NSString *)storyboardId;

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;

//- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTtilesAndActions:(NSArray *)titleActionArray;
//
//- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTtilesAndActions:(NSArray *)titleActionArray;

//- (void)showActiveIndicatiorView:(BOOL)isShow;


//- (void)showAlterInfoViewWithTitle:(NSString *)title message:(NSString *)message  ;

- (void)customizeSeparatorForTableView:(UITableView *)tableview;

- (id)jsonObjWithBase64EncodedJsonString:(NSString *)jsonString ;

@end
