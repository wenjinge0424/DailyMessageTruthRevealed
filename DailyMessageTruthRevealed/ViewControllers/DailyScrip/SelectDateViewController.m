//
//  SelectDateViewController.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/15/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "SelectDateViewController.h"
#import <JTCalendar/JTCalendar.h>

@interface SelectDateViewController ()<JTCalendarDelegate>
{
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
}
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@end

@implementation SelectDateViewController
- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dateSelected = [NSDate date];
    
    _calendarManager = [JTCalendarManager new];
    [self createMinAndMaxDate];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    _calendarManager.delegate = self;
    _calendarManager.settings.weekModeEnabled = _calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onOk:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:53/255.f green:114/255.f blue:244/255.f alpha:1.f];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor colorWithRed:232/255.f green:181/255.f blue:98/255.f alpha:1.f];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor colorWithRed:232/255.f green:181/255.f blue:98/255.f alpha:1.f];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    dayView.dotView.hidden = YES;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    if([_calendarManager.dateHelper date:_dateSelected isEqualOrAfter:_minDate andEqualOrBefore:_maxDate]){
//        [self reloadTable];
    }
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}
#pragma mark - CalendarManager delegate - Page mangement
// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}
- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar{}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar{}
@end
