//
//  CommentTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userCommentLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentCreatedTimeLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithCommentInfo:(CommentInfo *)info
{
    [_userPhotoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.commentUserPhoto]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _userNameLabel.text = info.commentUserName;
    _userCommentLabel.text = info.commentContent;    
    _commentCreatedTimeLabel.text = info.commentCreatedTime;
}













@end
