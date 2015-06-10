//
//  PhotoTableViewCell.m
//  LXBtrip
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.photoImgView.layer.cornerRadius = self.photoImgView.bounds.size.width/2;
    self.photoImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
