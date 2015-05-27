//
//  DeleteActionSheet.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteActionSheetDelegate <NSObject>

- (void)supportClickActionSheetWithYes;
- (void)supportClickActionSheetWithNo;


@end

@interface DeleteActionSheet : UIView

@property (nonatomic, weak) id <DeleteActionSheetDelegate>delegate;

@end
