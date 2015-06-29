//
//  CalendarViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/17.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@property (nonatomic, assign) int weeksOnCalendar;
@property (nonatomic, assign) int bufferDaysBeginning;
@property (nonatomic, assign) int daysInMonth;
@property (nonatomic, strong) NSDate *dateNoTime;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, assign) BOOL allowClearDate;
@property (nonatomic, assign) BOOL allowSelectionOfSelectedDate;
@property (nonatomic, assign) BOOL clearAsToday;
@property (nonatomic, assign) BOOL autoCloseOnSelectDate;
@property (nonatomic, assign) BOOL disableHistorySelection;
@property (nonatomic, assign) BOOL disableFutureSelection;
@property (nonatomic, assign) BOOL (^dateHasItemsCallback)(NSDate *);


@property (nonatomic, strong) NSDate * firstOfCurrentMonth;
@property (nonatomic, strong) THDateDay * currentDay;
@property (nonatomic, strong) NSDate * internalDate;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (strong, nonatomic) IBOutlet UIView *calendarDaysView;
@property (weak, nonatomic) IBOutlet UIView *weekdaysView;


- (IBAction)nextMonthPressed:(id)sender;
- (IBAction)prevMonthPressed:(id)sender;

@end

@implementation CalendarViewController
@synthesize date = _date;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _allowClearDate = NO;
        _allowSelectionOfSelectedDate = NO;
        _clearAsToday = NO;
        _disableFutureSelection = NO;
        _disableHistorySelection = NO;
        _autoCloseCancelDelay = 1.0;
    }
    return self;
}

- (void)setAllowSelectionOfSelectedDate:(BOOL)allow {
    _allowSelectionOfSelectedDate = allow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出发日期";
    
    [self addSwipeGestures];
    [self redraw];
}

- (void)backArrowClick:(id)sender
{
//    if (_currentDay) {
//        NSDate *date = _currentDay.date;
//        NSDateComponents *comps = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
//        
//        NSInteger cellYear = [comps year];
//        NSInteger cellMonth = [comps month];
//        NSInteger cellDay = [comps day];
//        NSInteger weekday = [comps weekday];
//        
//        [_priceGroupsArray enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
//            NSString *time = grp.marketTime;
//            NSArray *temp = [time componentsSeparatedByString:@"-"];
//            if (([temp[0] integerValue] == cellYear)
//                && ([temp[1] integerValue] == cellMonth)
//                && ([temp[2] integerValue] == cellDay)) {
//                if (grp.marketAdultPrice && [grp.marketAdultPrice integerValue]!=0) {
//                    NSDictionary *info = @{@"start_date":grp.marketTime, @"weekday":@(weekday)};
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Start_Date_Changed" object:self userInfo:info];
//                    return ;
//                }
//            }
//        }];
//
//    }
    [super backArrowClick:sender];
}

- (void)addSwipeGestures{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.calendarDaysView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarDaysView addGestureRecognizer:swipeGesture2];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    //Gesture detect - swipe up/down , can be recognized direction
    if(sender.direction == UISwipeGestureRecognizerDirectionUp){
        [self incrementMonth:1];
        [self slideTransitionViewInDirection:1];
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionDown){
        [self incrementMonth:-1];
        [self slideTransitionViewInDirection:-1];
    }
}


- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback {
    _dateHasItemsCallback = callback;
}


#pragma mark - Redraw Dates

- (void)redraw {
    if(!self.firstOfCurrentMonth) [self setDisplayedMonthFromDate:[NSDate date]];
    for(UIView * view in self.calendarDaysView.subviews){ // clean view
        [view removeFromSuperview];
    }
    [self redrawDays];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *monthName = [formatter stringFromDate:self.firstOfCurrentMonth];
    self.monthLabel.text = monthName;
}

- (void)redrawDays {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-_bufferDaysBeginning];
    NSDate * date = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [offsetComponents setDay:1];
    UIView * container = self.calendarDaysView;
//    CGRect containerFrame = container.frame;
    
    CGFloat yOrigin = 57.f + 33.f + 8.f;
    CGRect containerFrame = CGRectMake(0, yOrigin, SCREEN_WIDTH, 284.f);
    int areaWidth = containerFrame.size.width;
    int areaHeight = containerFrame.size.height;
    int cellWidth = areaWidth/7;
    int cellHeight = areaHeight/_weeksOnCalendar;
    int days = _weeksOnCalendar*7;
    int curY = (areaHeight - cellHeight*_weeksOnCalendar)/2;
    int origX = (areaWidth - cellWidth*7)/2;
    int curX = origX;
    [self redrawWeekdays:cellWidth];
    for(int i = 0; i < days; i++){
        // @beginning
        if(i && !(i%7)) {
            curX = origX;
            curY += cellHeight;
        }
        
        THDateDay * day = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"THDateDay" owner:self options:nil] objectAtIndex:0];
        day.frame = CGRectMake(curX, curY, cellWidth, cellHeight);
        day.delegate = self;
        day.date = [date dateByAddingTimeInterval:0];
        if (self.currentDateColor)
            [day setCurrentDateColor:_currentDateColor];
        if (self.currentDateColorSelected)
            [day setCurrentDateColorSelected:_currentDateColorSelected];
        [day setLightText:![self dateInCurrentMonth:date]];
        [day setEnabled:![self dateInFutureAndShouldBeDisabled:date]];
        
        NSDateComponents *comps = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSInteger cellYear = [comps year];
        NSInteger cellMonth = [comps month];
        NSInteger cellDay = [comps day];
        
        [_priceGroupsArray enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
            NSString *time = grp.marketTime;
            NSArray *temp = [time componentsSeparatedByString:@"-"];
            if (([temp[0] integerValue] == cellYear)
                && ([temp[1] integerValue] == cellMonth)
                && ([temp[2] integerValue] == cellDay)) {
                if (grp.marketAdultPrice && [grp.marketAdultPrice integerValue]!=0) {
                    day.priceLabel.text = [NSString stringWithFormat:@"￥%@", grp.marketAdultPrice];
                    return ;
                }
            }
        }];
        
        [day.dateButton setTitle:[NSString stringWithFormat:@"%ld",(long)[comps day]]
                        forState:UIControlStateNormal];
        [self.calendarDaysView addSubview:day];
        if (_internalDate && ![date timeIntervalSinceDate:_internalDate]) {
            self.currentDay = day;
            [day setSelected:YES];
        }
        // @end
        date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
        curX += cellWidth;
    }
}

- (void)redrawWeekdays:(int)dayWidth {
    if(!self.weekdaysView.subviews.count) {
        CGSize fullSize = self.weekdaysView.frame.size;
        int curX = (fullSize.width - 7*dayWidth)/2;
        NSDateComponents * comps = [_calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
        NSCalendar *c = [NSCalendar currentCalendar];
        [comps setDay:[c firstWeekday]-1];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        [df setDateFormat:@"EE"];
        NSDate * date = [_calendar dateFromComponents:comps];
        for(int i = 0; i < 7; i++){
            UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(curX, 0, dayWidth, fullSize.height)];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.font = [UIFont systemFontOfSize:12];
            [self.weekdaysView addSubview:dayLabel];
            dayLabel.text = [df stringFromDate:date];
            dayLabel.textColor = [UIColor grayColor];
            date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
            curX+=dayWidth;
        }
    }
}

#pragma mark - Date Set, etc.
- (void)setDate:(NSDate *)date {
    _date = date;
    _dateNoTime = !date ? nil : [self dateWithOutTime:date];
    self.internalDate = [_dateNoTime dateByAddingTimeInterval:0];
}

- (NSDate *)date {
    if(!self.internalDate) return nil;
    else if(!_date) return self.internalDate;
    else {
        int ymd = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        NSDateComponents* internalComps = [_calendar components:ymd fromDate:self.internalDate];
        int time = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone;
        NSDateComponents* origComps = [_calendar components:time fromDate:_date];
        [origComps setDay:[internalComps day]];
        [origComps setMonth:[internalComps month]];
        [origComps setYear:[internalComps year]];
        return [_calendar dateFromComponents:origComps];
    }
}

- (void)setInternalDate:(NSDate *)internalDate{
    _internalDate = internalDate;
    if(internalDate){
        [self setDisplayedMonthFromDate:internalDate];
    } else {
        [self.currentDay setSelected:NO];
        self.currentDay =  nil;
    }
}

- (void)setDisplayedMonth:(int)month year:(int)year{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM"];
    self.firstOfCurrentMonth = [df dateFromString: [NSString stringWithFormat:@"%d-%@%d", year, (month<10?@"0":@""), month]];
    [self storeDateInformation];
}

- (void)setDisplayedMonthFromDate:(NSDate *)date{
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    [self setDisplayedMonth:(int)[comps month] year:(int)[comps year]];
}

- (void)storeDateInformation{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:self.firstOfCurrentMonth];
    NSCalendar *c = [NSCalendar currentCalendar];
#ifdef DEBUG
    //[c setFirstWeekday:FIRST_WEEKDAY];
#endif
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.firstOfCurrentMonth];
    
    int bufferDaysBeginning = (int)([comps weekday]-[c firstWeekday]);
    // % 7 is not working for negative numbers
    // http://stackoverflow.com/questions/989943/weird-objective-c-mod-behavior-for-negative-numbers
    if (bufferDaysBeginning < 0)
        bufferDaysBeginning += 7;
    int daysInMonthWithBuffer = (int)(days.length + bufferDaysBeginning);
    int numberOfWeeks = daysInMonthWithBuffer / 7;
    if(daysInMonthWithBuffer % 7) numberOfWeeks++;
    
    _weeksOnCalendar = 6;
    _bufferDaysBeginning = bufferDaysBeginning;
    _daysInMonth = (int)days.length;
}

- (void)incrementMonth:(int)incrValue{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:incrValue];
    NSDate * incrementedMonth = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [self setDisplayedMonthFromDate:incrementedMonth];
}

#pragma mark - User Events

- (void)dateDayTapped:(THDateDay *)dateDay {
    if (!_internalDate || [_internalDate timeIntervalSinceDate:dateDay.date] || _allowSelectionOfSelectedDate) { // new date selected
        [self.currentDay setSelected:NO];
        [dateDay setSelected:YES];
        BOOL dateInDifferentMonth = ![self dateInCurrentMonth:dateDay.date];
        [self setInternalDate:dateDay.date];
        [self setCurrentDay:dateDay];
        if (dateInDifferentMonth) {
            [self slideTransitionViewInDirection:[dateDay.date timeIntervalSinceDate:self.firstOfCurrentMonth]];
        }
    }
    
    __block BOOL selectDayIsValid = NO;
    
    if (_currentDay) {
        NSDate *date = _currentDay.date;
        NSDateComponents *comps = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
        
        NSInteger cellYear = [comps year];
        NSInteger cellMonth = [comps month];
        NSInteger cellDay = [comps day];
        NSInteger weekday = [comps weekday];
        
        [_priceGroupsArray enumerateObjectsUsingBlock:^(MarketTicketGroup *grp, NSUInteger idx, BOOL *stop) {
            NSString *time = grp.marketTime;
            NSArray *temp = [time componentsSeparatedByString:@"-"];
            if (([temp[0] integerValue] == cellYear)
                && ([temp[1] integerValue] == cellMonth)
                && ([temp[2] integerValue] == cellDay)) {
                if (grp.marketAdultPrice && [grp.marketAdultPrice integerValue]!=0) {
                    selectDayIsValid = YES;
                    NSDictionary *info = @{@"start_date":grp.marketTime, @"weekday":@(weekday)};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Start_Date_Changed" object:self userInfo:info];
                }
            }
        }];
    }
    
    if (selectDayIsValid == NO) {
        [self.currentDay setSelected:NO];
        return;
    } else {
        [self backArrowClick:nil];
    }
}

- (void)slideTransitionViewInDirection:(int)dir {
    dir = dir < 1 ? -1 : 1;
    CGRect origFrame = self.calendarDaysView.frame;
    CGRect outDestFrame = origFrame;
    outDestFrame.origin.y -= 20*dir;
    CGRect inStartFrame = origFrame;
    inStartFrame.origin.y += 20*dir;
    UIView *oldView = self.calendarDaysView;
    UIView *newView = self.calendarDaysView = [[UIView alloc] initWithFrame:inStartFrame];
    [oldView.superview addSubview:newView];
    [self addSwipeGestures];
    newView.alpha = 0;
    [self redraw];
    [UIView animateWithDuration:.1 animations:^{
        newView.frame = origFrame;
        newView.alpha = 1;
        oldView.frame = outDestFrame;
        oldView.alpha = 0;
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
    }];
}

- (IBAction)nextMonthPressed:(id)sender {
    [self incrementMonth:1];
    [self slideTransitionViewInDirection:1];
}

- (IBAction)prevMonthPressed:(id)sender {
    [self incrementMonth:-1];
    [self slideTransitionViewInDirection:-1];
}


#pragma mark - Date Utils

- (BOOL)dateInFutureAndShouldBeDisabled:(NSDate *)dateToCompare {
    NSDate *currentDate = [self dateWithOutTime:[NSDate date]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    currentDate = [calendar dateFromComponents:[calendar components:comps fromDate:currentDate]];
    dateToCompare = [calendar dateFromComponents:[calendar components:comps fromDate:dateToCompare]];
    NSComparisonResult compResult = [currentDate compare:dateToCompare];
    return (compResult == NSOrderedDescending && _disableHistorySelection) || (compResult == NSOrderedAscending && _disableFutureSelection);
}

- (BOOL)dateInCurrentMonth:(NSDate *)date{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [_calendar components:unitFlags fromDate:self.firstOfCurrentMonth];
    NSDateComponents* comp2 = [_calendar components:unitFlags fromDate:date];
    return [comp1 year]  == [comp2 year] && [comp1 month] == [comp2 month];
}

- (NSDate *)dateWithOutTime:(NSDate *)datDate {
    if(!datDate) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
