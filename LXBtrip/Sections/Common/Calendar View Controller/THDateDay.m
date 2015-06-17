//
//  THDateDay.m
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//


#import "THDateDay.h"
#import "AppMacro.h"

@implementation THDateDay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentDateColor = [UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0];
        _currentDateColorSelected = [UIColor whiteColor];
    }
    return self;
}

-(void)setLightText:(BOOL)light {
    if(light) {
        UIColor * color = TEXT_CCCCD2;
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        _priceLabel.hidden = YES;
    }
    else {
        UIColor * color = TEXT_666666;
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        _priceLabel.hidden = NO;
    }
    [self setCurrentColors];
}

- (IBAction)dateButtonTapped:(id)sender {
    [self.delegate dateDayTapped:self];
}

-(void)setSelected:(BOOL)selected{
    if(selected) {
        [self.dateButton setSelected:YES];
        [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.dateButton setBackgroundColor:RED_FF0075];
        _priceLabel.textColor = [UIColor whiteColor];
    }
    else {
        [self.dateButton setSelected:NO];
        [self.dateButton setTitleColor:TEXT_666666 forState:UIControlStateNormal];
        [self.dateButton setBackgroundColor:[UIColor clearColor]];
        _priceLabel.textColor = TEXT_00AE55;
    }
    [self setCurrentColors];
}

- (void)setCurrentColors {
    if (self.currentDateColor && [self isToday]) {
        [self.dateButton setTitleColor:self.currentDateColor forState:UIControlStateNormal];
    }
    if (self.currentDateColorSelected && [self isToday]) {
        [self.dateButton setTitleColor:self.currentDateColorSelected forState:UIControlStateSelected];
    }
}

- (BOOL)isToday
{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

@end
