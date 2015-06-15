//
//  DispatcherTableViewCell.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "DispatcherTableViewCell.h"
#import "NSDictionary+GetStringValue.h"

@interface DispatcherTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *microShopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *admitDateLabel;


@end

@implementation DispatcherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialContactInformation:(NSDictionary *)infoDic
{
    if (infoDic) {
        self.nameLabel.text = [infoDic stringValueByKey:@"staff_real_name"];
        self.phoneNumLabel.text = [infoDic stringValueByKey:@"staff_partner_phonenum"];
        self.microShopNameLabel.text = [infoDic stringValueByKey:@"staff_departments_name"];
        
        double timeInterval = [(NSNumber *)[infoDic stringValueByKey:@"create_date"] doubleValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.admitDateLabel.text = [dateFormatter stringFromDate:date];
        
    }
}

- (IBAction)dialToContact:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:DialToDispatcher forContactIndex:self.tag];
    }
}

- (IBAction)shareShop:(id)sender {
    if (self.delegate) {
        [self.delegate responseForAction:ShareDispatcherInfo forContactIndex:self.tag];
    }
}



@end
