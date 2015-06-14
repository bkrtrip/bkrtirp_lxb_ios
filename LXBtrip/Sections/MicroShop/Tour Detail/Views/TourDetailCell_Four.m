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
@property (nonatomic, strong) UILabel *underLineLabel;

@end

@implementation TourDetailCell_Four

- (void)awakeFromNib {
    // Initialization code
    CGFloat cellHeight = 50.f;
    CGFloat underLineHeight = 2.f;
    selectedButton = _detailButton;
    [selectedButton setSelected:YES];
    
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight - underLineHeight, SCREEN_WIDTH/3.f, underLineHeight)];
    _underLineLabel.backgroundColor = RED_FF0075;
    [self.contentView addSubview:_underLineLabel];

}

- (IBAction)detailButtonClicked:(id)sender {
    [self selectButton:_detailButton];
    if ([self.delegate respondsToSelector:@selector(supportClickWithDetail)]) {
        [self.delegate supportClickWithDetail];
    }
}
- (IBAction)introductionButtonClicked:(id)sender {
    [self selectButton:_introductionButton];
    if ([self.delegate respondsToSelector:@selector(supportClickWithTravelTourGuide)]) {
        [self.delegate supportClickWithTravelTourGuide];
    }
}
- (IBAction)reviewButtonClicked:(id)sender {
    [self selectButton:_reviewButton];
    if ([self.delegate respondsToSelector:@selector(supportClickWithReviews)]) {
        [self.delegate supportClickWithReviews];
    }
}

- (void)selectButton:(UIButton *)button
{
    selectedButton.selected = NO;
    selectedButton = button;
    selectedButton.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        [_underLineLabel setFrame:CGRectMake(button.frame.origin.x, _underLineLabel.frame.origin.y, SCREEN_WIDTH/3.f, _underLineLabel.frame.size.height)];
    }];
}

@end
