//
//  CalendarViewController.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/17.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "NavBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "THDateDay.h"
#import "AppMacro.h"

@interface CalendarViewController : NavBaseViewController<THDateDayDelegate>

@property (nonatomic, copy) NSMutableArray *priceGroupsArray;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *currentDateColor;
@property (strong, nonatomic) UIColor *currentDateColorSelected;
@property (nonatomic) float autoCloseCancelDelay;

- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback;

/*! Enable Clear Date Button
 * \param allow should show "clear date" button
 */
- (void)setAllowClearDate:(BOOL)allow;

/*! Enable Ok Button when selected Date has already been selected
 * \param allow should show ok button
 */
- (void)setAllowSelectionOfSelectedDate:(BOOL)allow;

/*! Use Clear Date Button as "got to Today"
 * \param beTodayButton should use "clear date" button as today
 */
- (void)setClearAsToday:(BOOL)beTodayButton;

/*! Should the view be closed on selection of a date
 * \param autoClose should close view on selection
 */
- (void)setAutoCloseOnSelectDate:(BOOL)autoClose;

/*! Should it be possible to select dates in history
 * \param disableHistorySelection should it be possible?
 */
- (void)setDisableHistorySelection:(BOOL)disableHistorySelection;

/*! Should it be possible to select dates in future
 * \param disableFutureSelection should it be possible?
 */
- (void)setDisableFutureSelection:(BOOL)disableFutureSelection;

@end
