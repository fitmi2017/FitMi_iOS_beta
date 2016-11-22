//
//  DateUpperCustomView.h
//  FitMi
//
//  Created by Krishnendu Ghosh on 29/06/15.
//  Copyright (c) 2015 Krishnendu Ghosh. All rights reserved.
//

/*#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface DateUpperCustomView : UIView<DSLCalendarViewDelegate>
@property (nonatomic) IBOutlet UIButton *btnWeight_Home;
@property (nonatomic) IBOutlet UIButton *btnIntake_Home;
@property (nonatomic) IBOutlet UIButton *btnBurned_Home;
@property (nonatomic) IBOutlet UIButton *btnRemain_Home;
@property (nonatomic) IBOutlet UIButton *btnNet_Home;
@property (nonatomic) IBOutlet UIView *vwDate_Home;
@property (nonatomic) IBOutlet UIView *vwTopButtons_Home;
@property (nonatomic) IBOutlet UIButton *btnDate_Home;
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;
@property (weak, nonatomic) IBOutlet UIButton *btnBack_View;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit_View;

@property (nonatomic, retain) DSLCalendarView *calendarView;
@property (nonatomic, strong) UIViewController *backNavigationController;

- (IBAction)click_dateButton:(id)sender;
- (IBAction)click_Back:(id)sender;
@end*/
#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"
@protocol DateUpperCustomViewDelegate
@optional
- (void)notifyDate:(NSString *)dateStr ;

- (void)notifySelectedDate:(NSString *)dateStr ;
@end
@interface DateUpperCustomView : UIView<DSLCalendarViewDelegate>
{
    
    NSString *convertedDateString;
    
}
@property(nonatomic,strong)NSString* logTimeStr;
@property (nonatomic, assign) id<DateUpperCustomViewDelegate> delegate;
@property (nonatomic) IBOutlet UIButton *btnWeight_Home;
@property (nonatomic) IBOutlet UIButton *btnIntake_Home;
@property (nonatomic) IBOutlet UIButton *btnBurned_Home;
@property (nonatomic) IBOutlet UIButton *btnRemain_Home;
@property (nonatomic) IBOutlet UIButton *btnNet_Home;
@property (nonatomic) IBOutlet UIView *vwDate_Home;
@property (nonatomic) IBOutlet UIView *vwTopButtons_Home;
@property (nonatomic) IBOutlet UIButton *btnDate_Home;
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;
@property (weak, nonatomic) IBOutlet UIButton *btnBack_View;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit_View;
@property (strong, nonatomic)  UIButton *btnToday;

@property (nonatomic, retain) DSLCalendarView *calendarView;
@property (nonatomic, strong) UIViewController *backNavigationController;

- (IBAction)click_dateButton:(id)sender;
- (IBAction)click_Back:(id)sender;
-(void)hideToday;
@end
