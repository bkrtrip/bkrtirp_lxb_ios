//
//  TourListTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListTableViewCell.h"
#import "AppMacro.h"
@interface TourListTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *tourImageView;
@property (strong, nonatomic) IBOutlet UILabel *tourTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourKeywordsLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@end


@implementation TourListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)accompanyButtonClicked:(id)sender {
}
- (IBAction)previewButtonClicked:(id)sender {
}
- (IBAction)shareButtonClicked:(id)sender {
}

@end
