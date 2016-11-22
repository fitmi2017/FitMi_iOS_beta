#import "DateUpperCustomView.h"
#import "Utility.h"
#import "AppDelegate.h"
@implementation DateUpperCustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addNotification];
    [self viewIni];
}

-(void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCalendar)
                                                 name:@"backTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCalendar)
                                                 name:@"forwardTapped"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCalendarView:)
                                                 name:@"closeCalendar"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectToday:)
                                                 name:@"todayBtnTapped"
                                               object:nil];
    
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"dailyNotification"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"weeklyNotification"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"monthlyNotification"
                                               object:nil];
    
}
-(void)viewIni{
    
    [self addSubview:_vwDate_Home];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    convertedDateString = [[Utility sharedManager] getSelectedDate];
    
    if(_logTimeStr)
    {
        NSDateFormatter* theDateFormatter1 = [[NSDateFormatter alloc] init];
        [theDateFormatter1 setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter1 setDateFormat:@"EEEE"];
        
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        NSDate *dt=[formatter2 dateFromString:_logTimeStr];
        
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        formatter3.dateFormat = @"MMMM dd, yyyy";

        
        NSString *weekDay =  [theDateFormatter1 stringFromDate:dt];
        NSString *string = [NSString stringWithFormat:@"%@, %@",weekDay,[formatter3 stringFromDate:dt]];
        convertedDateString=string;
        
        [_btnDate_Home setTitle:convertedDateString forState:UIControlStateNormal];
    }
    
    else
        [_btnDate_Home setTitle:convertedDateString forState:UIControlStateNormal];

       _btnDate_Home.accessibilityHint=string;
    _btnDate_Home.tag=2001;
    
    //_btnDate_Home.translatesAutoresizingMaskIntoConstraints=YES;
    _btnDate_Home.titleLabel.adjustsFontSizeToFitWidth=YES;
    _btnDate_Home.titleLabel.minimumScaleFactor=0.7;

    [self addCalendar];
    
}
-(void)addCalendar
{
    _calendarView = [[DSLCalendarView alloc] initWithFrame:CGRectMake(0, _vwDate_Home.frame.origin.y, self.frame.size.width, 117)];
    _calendarView.delegate = (id)self;
    _calendarView.hidden = YES;
    _calendarView.backgroundColor=[UIColor lightGrayColor];
    _calendarView.tag=1001;
    [self addSubview:_calendarView];
    _btnToday = [UIButton buttonWithType:UIButtonTypeCustom];
   [_btnToday addTarget:self
               action:@selector(showToday)
     forControlEvents:UIControlEventTouchUpInside];
    [_btnToday setBackgroundColor:[UIColor whiteColor]];
   [_btnToday setTitle:@"Today" forState:UIControlStateNormal];
    [_btnToday setTitleColor:[UIColor colorWithRed:(100/255.0f) green:(157/255.0f) blue:(217/255.0f) alpha:1] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTodayBtnFrame:)
                                                 name:@"setbtnframe"
                                               object:nil];
    
    _btnToday.frame = CGRectMake(0, _calendarView.frame.size.height+_vwDate_Home.frame.origin.y, self.frame.size.width, 40.0);
    
    NSLog(@"frame====%@",NSStringFromCGRect(_calendarView.frame));
    [self addSubview:_btnToday];
    [self bringSubviewToFront:_btnToday];
    _btnToday.userInteractionEnabled=true;
    _btnToday.hidden=YES;
    
}

-(void)setTodayBtnFrame:(NSNotification *)notify{
 
 NSDictionary* userInfo = notify.userInfo;
    CGRect todayBtnFrame=CGRectFromString([userInfo valueForKey:@"frame"]);
    if(_btnToday){
        _btnToday.frame = CGRectMake(0, todayBtnFrame.size.height+_vwDate_Home.frame.origin.y, self.frame.size.width, 40.0);
            
    }
}
-(void)hideToday{
    
    [_btnToday removeFromSuperview];
    _btnToday.hidden=YES;
    _btnToday=nil;
}
-(void)showToday{
    [self hideToday];
    [_calendarView removeFromSuperview];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"YYYY-MM-dd"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    // [[NSUserDefaults standardUserDefaults] setObject:date_String forKey:CURRENT_DATE];
    [[NSUserDefaults standardUserDefaults] setObject:date_String forKey:LATEST_SELECTED_DATE];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self selectToday:nil];


}
- (void)closeCalendarView:(NSNotification *) notification
{
       [_btnDate_Home setSelected:NO];
    [self hideToday];

}

- (void)selectToday:(NSNotification *) notification
{
    //[self addCalendar];
    
    [_btnDate_Home setSelected:NO];
    
    AppDelegate *mAppDelegate=App_Delegate_Instance;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if([mAppDelegate.plannerSession isEqualToString:@"daily"])
    {
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyy-MM-dd";
     
        NSString *strUpdateDate =[[NSUserDefaults standardUserDefaults] valueForKey:LATEST_SELECTED_DATE];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
      
         formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSString *stringDate = [formatter1 stringFromDate:dateFromString];//[formatter1
        [[Utility sharedManager] saveSelectedDate:stringDate];
        [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
        [_delegate notifySelectedDate:stringDate];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        formatter2.timeZone = [NSTimeZone localTimeZone];
      
        
        
       // [[NSUserDefaults standardUserDefaults] setValue:strUpdateDate forKey:LATEST_SELECTED_DATE];
       // [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
    }
    else if([mAppDelegate.plannerSession isEqualToString:@"monthly"])
    {
        
       
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyy-MM-dd";
        
        NSString *strUpdateDate =[[NSUserDefaults standardUserDefaults] valueForKey:LATEST_SELECTED_DATE];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
       
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"MMMM yyyy";
        
        NSString *stringDate = [formatter2 stringFromDate:dateFromString];
         NSString *stringDate1 = [formatter1 stringFromDate:dateFromString];
       // [[Utility sharedManager] saveSelectedDate:stringDate1];
         [[Utility sharedManager] saveSelectedDate:stringDate1];
      
        [_delegate notifySelectedDate:stringDate1];
         [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
        
        /////
       
        
    }
    
    else if([mAppDelegate.plannerSession isEqualToString:@"weekly"])
    {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat =@"yyyy-MM-dd";//@"EEEE, MMMM dd, yyyy";
        
        NSString *strUpdateDate = [[NSUserDefaults standardUserDefaults] valueForKey:LATEST_SELECTED_DATE];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
        formatter1.dateFormat =@"EEEE, MMMM dd, yyyy";
        
        NSString *stringDate1 = [formatter1 stringFromDate:dateFromString];
        NSString *stringDate2 =[self findSelectedWeekStartEnd:stringDate1];
        
        [[Utility sharedManager] saveSelectedDate:stringDate1];
        
        [_delegate notifySelectedDate:stringDate2];
        [_btnDate_Home setTitle:stringDate2 forState:UIControlStateNormal];
    }

}



- (void) receiveTestNotification:(NSNotification *) notification
{
    NSDate *today = [NSDate date];
    
    if ([[notification name] isEqualToString:@"dailyNotification"]){
        convertedDateString=nil;
        //convertedDateString = [[Utility sharedManager] getSelectedDate];
        
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"EEEE"];
        NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMMM dd, yyyy";
        NSString *string = [NSString stringWithFormat:@"%@, %@",weekDay,[formatter stringFromDate:[NSDate date]]];
        convertedDateString=string;
        
        [[Utility sharedManager] saveSelectedDate:convertedDateString];
       // mAppDelegate.plannerSession=@"daily";
    }
    
    
    if ([[notification name] isEqualToString:@"monthlyNotification"]){
        convertedDateString=nil;
        NSArray *modifiedArr=[self findWeek];
        convertedDateString =[NSString stringWithFormat:@"%@ %@",[modifiedArr objectAtIndex:0],[modifiedArr objectAtIndex:2]];
        
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSString *stringDate = [formatter1 stringFromDate:today];
        [[Utility sharedManager] saveSelectedDate:stringDate];

       // mAppDelegate.plannerSession=@"monthly";
    }
    
    if ([[notification name] isEqualToString:@"weeklyNotification"]){
        convertedDateString=nil;
        convertedDateString =[NSString stringWithFormat:@"%@",[self findWeekStartEnd]];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSString *stringDate = [formatter1 stringFromDate:today];
        [[Utility sharedManager] saveSelectedDate:stringDate];

       // mAppDelegate.plannerSession=@"weekly";
    }
    
    
   
       [_btnDate_Home setTitle:convertedDateString forState:UIControlStateNormal]; 
    
    
    
    _btnDate_Home.titleLabel.adjustsFontSizeToFitWidth=YES;
    _btnDate_Home.titleLabel.minimumScaleFactor=0.7;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy-MM-dd";
    NSString *string1 = [NSString stringWithFormat:@"%@",[formatter1 stringFromDate:[NSDate date]]];
    _btnDate_Home.accessibilityHint=string1;

 }

#pragma mark - Button methods

- (IBAction)btnActionPrevious:(id)sender
{
     AppDelegate *mAppDelegate=App_Delegate_Instance;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
   
    if([mAppDelegate.plannerSession isEqualToString:@"daily"])
    {
    [components setDay:-1];
    
    //components.month=-1;//previous month
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    
    NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
    
    NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
    
    NSString *stringDate = [formatter1 stringFromDate:yesterday];
    [[Utility sharedManager] saveSelectedDate:stringDate];
    /////
    NSDate *yeaterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
    [_delegate notifySelectedDate:stringDate];
    [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        formatter2.timeZone = [NSTimeZone localTimeZone];
        NSString *_date = [ formatter2 stringFromDate:yeaterday];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:_date forKey:LATEST_SELECTED_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        
        
    }
    else if([mAppDelegate.plannerSession isEqualToString:@"monthly"])
    {
        
        components.month=-1;//previous month
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        
        NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"MMMM yyyy";
        
        NSString *stringDate = [formatter2 stringFromDate:yesterday];
        NSString *stringDate1 = [formatter1 stringFromDate:yesterday];
        [[Utility sharedManager] saveSelectedDate:stringDate1];
        
         [_delegate notifySelectedDate:stringDate1];
        [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
        
        ///
        
    }

    else if([mAppDelegate.plannerSession isEqualToString:@"weekly"])
    {
        components.week=-1;//previous week
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        
        NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
        
        NSString *stringDate1 = [formatter1 stringFromDate:yesterday];
        NSString *stringDate2 =[self findSelectedWeekStartEnd:stringDate1];
        
        [[Utility sharedManager] saveSelectedDate:stringDate1];
        
         [_delegate notifySelectedDate:stringDate1];
        [_btnDate_Home setTitle:stringDate2 forState:UIControlStateNormal];
    }

    
}

- (IBAction)btnActionNext:(id)sender
{
    AppDelegate *mAppDelegate=App_Delegate_Instance;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if([mAppDelegate.plannerSession isEqualToString:@"daily"])
    {
    [components setDay:1];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    
    NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
    
    NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
    NSDate *tommorrow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
    
    NSString *stringDate = [formatter1 stringFromDate:tommorrow];
    [[Utility sharedManager] saveSelectedDate:stringDate];
    
    [_delegate notifySelectedDate:stringDate];
    [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        formatter2.timeZone = [NSTimeZone localTimeZone];
       NSString *_date = [ formatter2 stringFromDate:tommorrow];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:_date forKey:LATEST_SELECTED_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    else if([mAppDelegate.plannerSession isEqualToString:@"weekly"])
    {
        
        components.week=1;//next week
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        
        NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
        
        
        NSString *stringDate1 = [formatter1 stringFromDate:yesterday];
        [[Utility sharedManager] saveSelectedDate:stringDate1];
        
         [_delegate notifySelectedDate:stringDate1];
        NSString *stringDate2 =[self findSelectedWeekStartEnd:stringDate1];
        [_btnDate_Home setTitle:stringDate2 forState:UIControlStateNormal];
    }

    else if([mAppDelegate.plannerSession isEqualToString:@"monthly"])
    {
        
        components.month=1;//next month
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        
        NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
        
        NSDate *dateFromString = [formatter1 dateFromString:strUpdateDate];
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:dateFromString options:0];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"MMMM yyyy";
        
        NSString *stringDate = [formatter2 stringFromDate:yesterday];
        NSString *stringDate1 = [formatter1 stringFromDate:yesterday];
        [[Utility sharedManager] saveSelectedDate:stringDate1];
        
         [_delegate notifySelectedDate:stringDate1];
        [_btnDate_Home setTitle:stringDate forState:UIControlStateNormal];
    }

   
    

}

- (IBAction)click_dateButton:(id)sender {
    AppDelegate *mAppDelegate=App_Delegate_Instance;

    [mAppDelegate.dropDown hideDropDown:mAppDelegate.btnDropDown];

    if(_btnDate_Home.selected==NO){
        [_calendarView removeFromSuperview];
       
        [self addCalendar];
//         sleep(1);
        _calendarView.hidden = NO;
        [_btnDate_Home setSelected:YES];
        [_vwTopButtons_Home setHidden:YES];
        self.frame = CGRectMake(0, 0, self.frame.size.width, [[UIScreen mainScreen]bounds].size.height - 50);
        if(_btnToday){
            _btnToday.hidden=false;
        }
        
        NSString *strdate = [[NSUserDefaults standardUserDefaults] valueForKey:LATEST_SELECTED_DATE];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        formatter.timeZone = [NSTimeZone localTimeZone];
        NSDate *datetemp = [formatter dateFromString:strdate];
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dayComponents =
        [gregorian components:(NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:datetemp];
        
        @try {
             [_calendarView setVisibleMonth:dayComponents animated:NO];
        }
        @catch (NSException *exception) {
            NSLog(@"%@,%@",__func__,exception.description);
        }
        
       
     }
    else{
        [_btnToday removeFromSuperview];
        _btnToday=nil;
        self.frame = CGRectMake(0, 0, self.frame.size.width, 110);
        _calendarView.hidden = YES;
        [_btnDate_Home setSelected:NO];
        [_vwTopButtons_Home setHidden:YES];
    }
}

- (IBAction)click_Back:(id)sender {
    [_backNavigationController.navigationController popViewControllerAnimated:NO];
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSString *strMonth,*strHintMon,*strHintDay;
        if((long)range.startDay.month <= 9){
            strMonth =strHintMon= [NSString stringWithFormat:@"0%ld",(long)range.startDay.month];
            strMonth=[self monthName:strMonth];
        }
        else{
            strMonth =strHintMon= [NSString stringWithFormat:@"%ld",(long)range.startDay.month];
            strMonth=[self monthName:strMonth];
        }
        NSString *strDay;
        if((long)range.startDay.day <= 9){
            strDay = strHintDay=[NSString stringWithFormat:@"0%ld",(long)range.startDay.day];
        }
        else{
            strDay =strHintDay= [NSString stringWithFormat:@"%ld",(long)range.startDay.day];
        }
        
        NSString *strWeekDay;
        if((long)range.startDay.weekday <= 9){
            strWeekDay = [NSString stringWithFormat:@"0%ld",(long)range.startDay.weekday];
            strWeekDay=[self weekDayName:strWeekDay];
        }
        else{
            strWeekDay = [NSString stringWithFormat:@"%ld",(long)range.startDay.weekday];
            strWeekDay=[self weekDayName:strWeekDay];
        }
        
        [[Utility sharedManager] saveSelectedDate:[NSString stringWithFormat:@"%@, %@ %@, %ld",strWeekDay,strMonth, strDay,(long)range.startDay.year]];
        
       
        NSString *strUpdateDate = [[Utility sharedManager] getSelectedDate];
        [_btnDate_Home setTitle:strUpdateDate forState:UIControlStateNormal];
        
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyy-MM-dd";
        
       
        NSString *hint=[NSString stringWithFormat:@"%ld-%@-%@",(long)range.startDay.year,strHintMon,strHintDay];
        _btnDate_Home.accessibilityHint=hint;
        _btnDate_Home.titleLabel.adjustsFontSizeToFitWidth=YES;
        _btnDate_Home.titleLabel.minimumScaleFactor=0.7;
      
       
        NSString *selctedDate=[NSString stringWithFormat:@"%@-%ld-%ld",strDay,(long)range.startDay.month,(long)range.startDay.year];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld-%ld-%@",(long)range.startDay.year,(long)range.startDay.month,strDay] forKey:LATEST_SELECTED_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[Utility sharedManager] saveSelectedDateYMD:[NSString stringWithFormat:@"%ld-%ld-%@",(long)range.startDay.year,(long)range.startDay.month,strDay]];
        
        [_delegate notifySelectedDate:[NSString stringWithFormat:@"%ld-%ld-%@",(long)range.startDay.year,(long)range.startDay.month,strDay]];
        [_delegate notifyDate:[NSString stringWithFormat:@"%@,%@", strUpdateDate,selctedDate ] ];
        [_btnToday removeFromSuperview];
        _btnToday.hidden=YES;
        _btnToday=nil;
        self.frame = CGRectMake(0, 0, self.frame.size.width, 110);
        _calendarView.hidden = YES;
        [_btnDate_Home setSelected:NO];
        [_vwTopButtons_Home setHidden:YES];
    }
    else {
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (/* DISABLES CODE */ (NO)) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
    NSLog(@"%f", _calendarView.frame.size.height);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}


-(NSString*)monthName:(NSString *)monthVal
{
    if([monthVal isEqualToString:@"01"])
        return  @"January";
    
    if([monthVal isEqualToString:@"02"])
        return   @"February";
    
    if([monthVal isEqualToString:@"03"])
        return  @"March";
    
    if([monthVal isEqualToString:@"04"])
        return @"April";
    
    if([monthVal isEqualToString:@"05"])
        return @"May";
    
    if([monthVal isEqualToString:@"06"])
        return @"June";
    
    if([monthVal isEqualToString:@"07"])
        return   @"July";
    
    if([monthVal isEqualToString:@"08"])
        return  @"August";
    
    if([monthVal isEqualToString:@"09"])
        return @"September";
    
    if([monthVal isEqualToString:@"10"])
        return @"October";
    
    if([monthVal isEqualToString:@"11"])
        return @"November";
    
    if([monthVal isEqualToString:@"12"])
        return @"December";
    
    return nil;
}

-(NSString*)weekDayName:(NSString *)weekDayVal
{
    if([weekDayVal isEqualToString:@"01"])
        return  @"Sunday";
    
    if([weekDayVal isEqualToString:@"02"])
        return   @"Monday";
    
    if([weekDayVal isEqualToString:@"03"])
        return  @"Tuesday";
    
    if([weekDayVal isEqualToString:@"04"])
        return @"Wednesday";
    
    if([weekDayVal isEqualToString:@"05"])
        return @"Thursday";
    
    if([weekDayVal isEqualToString:@"06"])
        return @"Friday";
    
    if([weekDayVal isEqualToString:@"07"])
        return   @"Saturday";
    
    return nil;
}
#pragma mark -Custom Method
-(NSString *)findWeekStartEnd{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    [dateFormatter setDateFormat:@"MMM dd,yyyy"];
    NSString *startDt = [dateFormatter stringFromDate:startOfTheWeek];
    NSString *endDt = [dateFormatter stringFromDate:endOfWeek];
   
    NSString *finalStr=[NSString stringWithFormat:@"%@ - %@",startDt,endDt];
    return finalStr;
    
}

-(NSString *)findSelectedWeekStartEnd:(NSString*)selectedDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSDate *dateFromString = [formatter1 dateFromString:selectedDate];
    
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:dateFromString];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    [dateFormatter setDateFormat:@"MMM dd,yyyy"];
    NSString *startDt = [dateFormatter stringFromDate:startOfTheWeek];
    NSString *endDt = [dateFormatter stringFromDate:endOfWeek];
    
    NSString *finalStr=[NSString stringWithFormat:@"%@ - %@",startDt,endDt];
    return finalStr;
    
}

-(NSArray *)findWeek{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    [dateFormatter setDateFormat:@"MMMM/dd/yyyy"];
    NSString *startDt = [dateFormatter stringFromDate:startOfTheWeek];
    NSString *endDt = [dateFormatter stringFromDate:endOfWeek];
    
    NSArray *dateArr=[startDt componentsSeparatedByString:@"/"];
    return dateArr;
    
}

- (void) dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"setbtnframe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"closeCalendar" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"dailyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"weeklyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"monthlyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"setbtnframe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"closeCalendar" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"dailyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"weeklyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"monthlyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -End
@end
