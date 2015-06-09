//
//  CommentTableViewCell.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface CommentTableViewCell : UITableViewCell

- (void)setCellContentWithCommentInfo:(CommentInfo *)info;

@end
