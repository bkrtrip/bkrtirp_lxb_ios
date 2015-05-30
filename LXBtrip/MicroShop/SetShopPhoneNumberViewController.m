//
//  SetShopPhoneNumberViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SetShopPhoneNumberViewController.h"
#import "AppMacro.h"

@interface SetShopPhoneNumberViewController ()
{
    BOOL cellPhonePartIsSelected;
}

// View - cell phone
@property (strong, nonatomic) IBOutlet UIButton *cellPhoneButton;
@property (strong, nonatomic) IBOutlet UILabel *cellPhoneLabel;
- (IBAction)cellPhoneButtonClicked:(id)sender;

// View - fixed line phone
@property (strong, nonatomic) IBOutlet UILabel *fixedLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *fixedLineButton;
- (IBAction)fixedLineButtonClicked:(id)sender;

// cellPhone textField
@property (strong, nonatomic) IBOutlet UITextField *cellPhoneTextField;
@property (strong, nonatomic) IBOutlet UIImageView *separator_cellPhone;

// district textField
@property (strong, nonatomic) IBOutlet UITextField *districtTextField;
@property (strong, nonatomic) IBOutlet UIImageView *separator_districtNo;

// fixed line number textField
@property (strong, nonatomic) IBOutlet UITextField *fixedLineNumberTextField;
@property (strong, nonatomic) IBOutlet UIImageView *separator_fixedLineNumber;

@end

@implementation SetShopPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存"];
    
    cellPhonePartIsSelected = YES;
    [self SetCellPhonePartSelected:cellPhonePartIsSelected];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)cellPhoneButtonClicked:(id)sender {
    cellPhonePartIsSelected = YES;
    [self SetCellPhonePartSelected:cellPhonePartIsSelected];
}
- (IBAction)fixedLineButtonClicked:(id)sender {
    cellPhonePartIsSelected = NO;
    [self SetCellPhonePartSelected:cellPhonePartIsSelected];
}







#pragma mark - Private methods
- (void)SetCellPhonePartSelected:(BOOL)selected
{
    // cell phone part
    [_cellPhoneButton setSelected:selected];
    if (selected) {
        _cellPhoneLabel.textColor = TEXT_SELECTED_COLOR;
    } else {
        _cellPhoneLabel.textColor = TEXT_666666;
    }
    
    // fixed line part
    [_fixedLineButton setSelected:!selected];
    if (!selected) {
        _fixedLineLabel.textColor = TEXT_SELECTED_COLOR;
    } else {
        _fixedLineLabel.textColor = TEXT_666666;
    }
}
- (void)setFixedLineTextFieldHidden:(BOOL)hidden
{
    // district part
    _fixedLineNumberTextField.hidden = hidden;
    _separator_districtNo.hidden = hidden;

    // fixed line number part
    _districtTextField.hidden = hidden;
    _separator_fixedLineNumber.hidden = hidden;
}
- (void)setCellPhoneTextFieldHidden:(BOOL)hidden
{
    _cellPhoneTextField.hidden = hidden;
    _separator_cellPhone.hidden = hidden;
}

@end




