//
//  DeleteActionSheet.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "DeleteActionSheet.h"

@implementation DeleteActionSheet

- (IBAction)yesButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickActionSheetWithYes)]) {
        [self.delegate supportClickActionSheetWithYes];
    }
}

- (IBAction)noButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickActionSheetWithNo)]) {
        [self.delegate supportClickActionSheetWithNo];
    }
}


@end
