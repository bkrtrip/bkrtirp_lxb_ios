//
//  TourDetailCell_Four.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Four.h"
#import "AppMacro.h"

@interface TourDetailCell_Four()
{
    UIButton *selectedButton;
}

@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIButton *introductionButton;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton;
@property (nonatomic, strong) UIView *indicatorBarView;

@end

@implementation TourDetailCell_Four

- (void)awakeFromNib {
    // Initialization code
    CGFloat cellHeight = 50.f;
    CGFloat barViewHeight = 2.f;
    if (!_indicatorBarView) {
        _indicatorBarView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - barViewHeight, SCREEN_WIDTH/3.0, barViewHeight)];
        [self.contentView addSubview:_indicatorBarView];
    }
    selectedButton = _detailButton;
    [selectedButton setSelected:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailButtonClicked:(id)sender {
    [self selectButton:_detailButton];
    // go to webview
}
- (IBAction)introductionButtonClicked:(id)sender {
    [self selectButton:_introductionButton];
    // go to webview
}
- (IBAction)reviewButtonClicked:(id)sender {
    [self selectButton:_reviewButton];
    // go to review page
}

- (void)selectButton:(UIButton *)button
{
    selectedButton.selected = NO;
    selectedButton = button;
    selectedButton.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        [_indicatorBarView setFrame:CGRectOffset(_indicatorBarView.frame, button.frame.origin.x - _indicatorBarView.frame.origin.x, 0)];
    }];
}



@end
