//
//  WaterViewController.m
//  FitMe
//
//  Created by Debasish on 24/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "WaterViewController.h"
#import "DateUpperCustomView.h"
#import "SettingsViewController.h"
#import "Constant.h"
#import "DejalActivityView.h"

@interface WaterViewController ()
{
    __weak IBOutlet UIView *inputView;
    DateUpperCustomView* mDateUpperCustomView;
    __weak IBOutlet UITableView *waterIntakeTableView;
    
    __weak IBOutlet UILabel *totalQty;
    __weak IBOutlet UITextField *waterIntakeTxtView;
    NSMutableArray *arrDropDownTxt,*arrDropDownImg;
    WaterLog *waterObj;
    NSString *logTimeStr;

    __weak IBOutlet UILabel *waterLbl;
    __weak IBOutlet UILabel *unitLbl1;
    __weak IBOutlet UILabel *unitLbl2;
    __weak IBOutlet UILabel *unitLbl3;
    __weak IBOutlet UILabel *unitLbl4;
    __weak IBOutlet UILabel *my_waterLbl;
    __weak IBOutlet UIButton *logBtn;
    __weak IBOutlet UILabel *totalLbl;
    __weak IBOutlet UILabel *totalCountLbl;
    
    NSString *selectedWaterID;
    
    NSUserDefaults *defaults;
    NSString *selectedUserProfileID;
    
    BOOL isDelete;
    Devicefamily family;
    NSMutableArray *arrUnitWater;
    BOOL isUnitClk;
}

@end

@implementation WaterViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isDelete=NO;
    
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    [waterIntakeTableView reloadData];
    
    [self createNavigationView:@"Water"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    arrUnitWater=[[NSMutableArray alloc]initWithObjects:@"oz",@"ml", nil];
    
    if(!isUnitClk)
        [_btnChangeUnit setTitle:[arrUnitWater objectAtIndex:0] forState:UIControlStateNormal];

    waterIntakeTxtView.layer.borderColor= [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor];
    waterIntakeTxtView.delegate=self;
    waterIntakeTxtView.layer.borderWidth= 1.0f;
    
    UIView *paddingVwwaterIntake = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    waterIntakeTxtView.leftView = paddingVwwaterIntake;
    waterIntakeTxtView.leftViewMode = UITextFieldViewModeAlways;
    
    inputView.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:.5] CGColor];
    
    inputView.layer.borderWidth= 1.0f;
    
    waterObj=[[WaterLog alloc]init];
    _waterLogRecord=[NSMutableArray array];
  
    family = thisDeviceFamily();
    if(family==iPad)
    {
        waterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:25];
        waterIntakeTxtView.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:23];
        _btnChangeUnit.titleLabel.font=[UIFont fontWithName:@"SinkinSans-300Light" size:25];
        unitLbl1.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:21];
        unitLbl2.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:21];
        unitLbl3.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:21];
        unitLbl4.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:21];
        totalQty.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:25];
        totalLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:21];
    }
    else{
        if([self isIphoneSixPlus]){
            waterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:22];
            waterIntakeTxtView.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:19];
            _btnChangeUnit.titleLabel.font=[UIFont fontWithName:@"SinkinSans-300Light" size:22];
            unitLbl1.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            unitLbl2.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            unitLbl3.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            unitLbl4.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            totalQty.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:19];
            totalLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:17];
            
        }
        else{
            waterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:20];
            waterIntakeTxtView.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            _btnChangeUnit.titleLabel.font=[UIFont fontWithName:@"SinkinSans-300Light" size:20];
            
            unitLbl1.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
            unitLbl2.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
            unitLbl3.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
            unitLbl4.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
            totalQty.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:17];
            totalLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:15];
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray * allTheViewsInMyNIB = [[NSBundle mainBundle] loadNibNamed:[self getNibName:@"DateUpperCustomView"] owner:self options:nil];
    mDateUpperCustomView = allTheViewsInMyNIB[0];
    mDateUpperCustomView.frame = CGRectMake(0,0,self.view.frame.size.width,184);
    mDateUpperCustomView.delegate=self;
    // mDateUpperCustomView.lblHeading.text = @"Home";
    [self.view addSubview:mDateUpperCustomView];
    [mDateUpperCustomView.btnDate_Home setSelected:YES];
    [mDateUpperCustomView click_dateButton:nil];
    
    [self reloadSection];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [waterIntakeTableView setEditing:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 }

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
        
        return [_waterLogRecord count];
    
    else
        return 1;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section==0)
    {
        static NSString *simpleTableIdentifier;
        simpleTableIdentifier = @"resultheaderCell";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *myWaterLbl=(UILabel*)[cell viewWithTag:1];
        
        if(family==iPad){
            myWaterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:21];
        }
        else{
            if([self isIphoneSixPlus])
                myWaterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:19];
            else
                
                myWaterLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:17];
        }
        return cell;
    }
    
    else{
        static NSString *simpleTableIdentifier;
        
        simpleTableIdentifier = @"resultCell";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        UILabel *timeLbl=(UILabel*)[cell viewWithTag:10];
        UILabel *qtyLbl=(UILabel*)[cell viewWithTag:11];
        UILabel *unitLbl=(UILabel*)[cell viewWithTag:12];
        UIButton *btnEdit=(UIButton*)[cell viewWithTag:101];
        
        if([_waterLogRecord count]>0){
            
            NSString *currentTime=[[_waterLogRecord objectAtIndex:indexPath.row] objectForKey:@"date_added"];
            NSArray *timeArr=(NSArray*)[currentTime componentsSeparatedByString:@" "];
            NSString *timeStr=[timeArr objectAtIndex:1];
            
            NSArray *timeSplitArr=(NSArray*)[timeStr componentsSeparatedByString:@":"];
            NSString *hourStr=[timeSplitArr objectAtIndex:0];
            
            if([hourStr intValue]>12)
                hourStr=[NSString stringWithFormat:@"%d:%d pm",([hourStr intValue]-12),[[timeSplitArr objectAtIndex:1]intValue] ];
            else
                hourStr=[NSString stringWithFormat:@"%d:%d am",[hourStr intValue],[[timeSplitArr objectAtIndex:1]intValue]];
            
            timeLbl.text=[NSString stringWithFormat:@"%@",hourStr];
            NSArray *qtyArr=[NSArray array];
            qtyArr=[[[_waterLogRecord objectAtIndex:indexPath.row] objectForKey:@"oz"] componentsSeparatedByString:@" "];
            qtyLbl.text=[qtyArr objectAtIndex:0] ;
            unitLbl.text=[qtyArr objectAtIndex:1] ;
            
            if(family==iPad)
            {
                timeLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:19];
                unitLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:19];
                qtyLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:34];
            }
            else
            {
                if([self isIphoneSixPlus]){
                    timeLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:17];
                    unitLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:17];
                    qtyLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:32];
                }
                else{
                    
                    timeLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:15];
                    unitLbl.font=[UIFont fontWithName:@"SinkinSans-100Thin" size:15];
                    qtyLbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:30];
                }
            }
            [btnEdit addTarget:self action:@selector(btnActionEdit:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        cell.backgroundView=nil;
        
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(family == iPad)
            return 60;
        else
            return 43;
    }
    else{
        if(family == iPad)
            return 130;
        else
            return 100;
    }
  
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(!isDelete)
        {
            isDelete=YES;
            NSLog(@"%ld",indexPath.row);
            
            selectedWaterID=[[_waterLogRecord objectAtIndex:indexPath.row]objectForKey:@"water_id"];
            BOOL isSuccess=[waterObj deleteWaterData:selectedWaterID];
            
            if(isSuccess)
            {
                [self performSelector:@selector(reloadSection) withObject:nil afterDelay:1.0];
            }
            
        }
    }
}

#pragma mark - "Edit" Button Action
-(void)btnActionEdit:(UIButton*)sender
{
    UITableViewCell *cell=(UITableViewCell*)sender.superview.superview.superview;
    NSIndexPath *path=[waterIntakeTableView indexPathForCell:cell];
    
    NSArray *qtyArr=[NSArray array];
    qtyArr=[[[_waterLogRecord objectAtIndex:path.row] objectForKey:@"oz"] componentsSeparatedByString:@" "];
    NSString *selectedWaterQty=[qtyArr objectAtIndex:0] ;
    
    selectedWaterID=[[_waterLogRecord objectAtIndex:path.row]objectForKey:@"water_id"];
    
     //For 8.0 iOS Device
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"Edit Amount of Water Intake" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [av addTextFieldWithConfigurationHandler:nil];
        ((UITextField *)(av.textFields[0])).placeholder = @"oz";
        ((UITextField *)(av.textFields[0])).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        ((UITextField *)(av.textFields[0])).returnKeyType=UIReturnKeyDone;
        ((UITextField *)(av.textFields[0])).delegate=self;
        ((UITextField *)(av.textFields[0])).text=selectedWaterQty;
        UIView *paddingtxtFld = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        ((UITextField *)(av.textFields[0])).leftView = paddingtxtFld;
        ((UITextField *)(av.textFields[0])).leftViewMode = UITextFieldViewModeAlways;
        
        ((UITextField *)(av.textFields[0])).font=[UIFont fontWithName:@"SinkinSans-200XLight" size:14];
        
        UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
            
            if([self isValidNumeric:((UITextField *)(av.textFields[0])).text]==NO)
            {
                [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            }
            else{
                NSString *waterQtyVal=[NSString stringWithFormat:@"%@ %@",((UITextField *)(av.textFields[0])).text,_btnChangeUnit.currentTitle];
                BOOL isSuccess=[waterObj updateWaterData:selectedWaterID withWaterVal:waterQtyVal];
                
                if(isSuccess)
                {
                    [self reloadSection];
                }
            }
        }];
        [av addAction:actionCancel];
        [av addAction:actionOk];
        
        [self presentViewController:av animated:YES completion:NULL];
    }
    
    //For Lessthan 8.0 iOS Device
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Edit Amount of Water Intake" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        av.tag=1001;
        [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField *textField = [av textFieldAtIndex:0];
        textField.placeholder=@"oz";
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.returnKeyType=UIReturnKeyDone;
        textField.delegate=self;
        textField.text=selectedWaterQty;
        
        textField.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:14];
        
        UIView *paddingtxtFld = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        textField.leftView = paddingtxtFld;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        textField.textColor=[UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"oz" attributes:@{NSForegroundColorAttributeName: color}];
        }
        else
        {
            NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        }
        
        //    [av setValue:v  forKey:@"accessoryView"];
        [av show];
    }
    
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        if(buttonIndex==1)
        {
            if([self isValidNumeric:[alertView textFieldAtIndex:0].text]==NO)
            {
                [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            }
            else{
                
                NSString *waterQtyVal=[NSString stringWithFormat:@"%@ %@", [alertView textFieldAtIndex:0].text,_btnChangeUnit.currentTitle];
                BOOL isSuccess=[waterObj updateWaterData:selectedWaterID withWaterVal:waterQtyVal];
                
                if(isSuccess)
                {
                    [self reloadSection];
                }
            }
        }
    }
}

#pragma mark - "SelectQuantity" IconButton Action
- (IBAction)showQuantity:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"%@",sender.view.superview);

    UILabel *lbl1;
    NSArray *selectedQty=[NSArray array];
    
    //Select 8 oz
    if(sender.view.tag==1)
    {
        lbl1=(UILabel*)[self.view viewWithTag:10];
        selectedQty=[lbl1.text componentsSeparatedByString:@" "];
    }
    
    //Select 16.9 oz
    else if(sender.view.tag==2)
    {
        lbl1=(UILabel*)[self.view viewWithTag:20];
        selectedQty=[lbl1.text componentsSeparatedByString:@" "];
    }
    
    //Select 24.7 oz
    else if(sender.view.tag==3)
    {
        lbl1=(UILabel*)[self.view viewWithTag:30];
        selectedQty=[lbl1.text componentsSeparatedByString:@" "];
    }
    
    //Select 34.3 oz
    else
    {
        lbl1=(UILabel*)[self.view viewWithTag:40];
        selectedQty=[lbl1.text componentsSeparatedByString:@" "];
     }
    
    waterIntakeTxtView.text=[selectedQty objectAtIndex:0];
}

#pragma mark - "ChangeUnit" ToggleButton Action
- (IBAction)changeUnit:(id)sender
{
    isUnitClk=!isUnitClk;
    if(!isUnitClk)
        [_btnChangeUnit setTitle:[arrUnitWater objectAtIndex:0] forState:UIControlStateNormal];
 else
     [_btnChangeUnit setTitle:[arrUnitWater objectAtIndex:1] forState:UIControlStateNormal];
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - UITouch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"View==%@",mDateUpperCustomView.subviews);
    DSLCalendarView *calenderVw = (DSLCalendarView *)[mDateUpperCustomView viewWithTag:1001];
    calenderVw.hidden=YES;
    mDateUpperCustomView.frame = CGRectMake(0, 0, mDateUpperCustomView.frame.size.width, 110);
    
    UIButton *btn=(UIButton *)[mDateUpperCustomView viewWithTag:2001];
    if(btn.selected==NO)
    {
        [btn setSelected:YES];
    }
    else
    {
        [btn setSelected:NO];
    }
     [mDateUpperCustomView hideToday];
}

#pragma mark - "Log" Button Action
- (IBAction)logButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    if([self verify])
    {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
        NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
        
        waterObj.waterlog_user_id=[defaults objectForKey:@"user_id"];
        waterObj.waterlog_user_profile_id=[defaults valueForKey:@"selectedUserProfileID"];
        
        NSLog(@"UNIT=%@",_btnChangeUnit.currentTitle);
        NSString *waterVAL=@"";
        if([_btnChangeUnit.currentTitle isEqualToString:[arrUnitWater objectAtIndex:0]])
        {
           waterVAL= [NSString stringWithFormat:@"%@ %@",[waterIntakeTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],_btnChangeUnit.currentTitle];
        }
        else if([_btnChangeUnit.currentTitle isEqualToString:[arrUnitWater objectAtIndex:1]])
        {
           float waterVal_oz= [waterIntakeTxtView.text floatValue]*0.0338;
            waterVAL= [NSString stringWithFormat:@"%.1f %@",waterVal_oz,[arrUnitWater objectAtIndex:0]];
        }
        
        waterObj.waterlog_quantity=waterVAL;
        waterObj.waterlog_date_added=[self getCurrentDateTime];
        
        waterObj.water_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
        [waterObj saveUserWaterDataLog];
        
        [self saveWaterLogServer:waterVAL ];
        [self reloadSection];
        
        waterIntakeTxtView.text=@"";
    }
}

-(void)saveWaterLogServer:(NSString*)waterVAL
{
    //CREATE TABLE "fitmi_water_log" ("id" INTEGER PRIMARY KEY  NOT NULL , "user_id" INTEGER, "userprofile_id" INTEGER, "oz" VARCHAR, "log_time" VARCHAR, "date_added" VARCHAR)
    
    NSString *userID=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *userAccessKey=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"];
    
    NSMutableArray *arrColumnNm=[[NSMutableArray alloc]initWithObjects:@"userprofile_id", @"oz",nil];
    
    NSMutableArray *arrRowsVal=[[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"selectedUserProfileID"], waterVAL,nil];
    
    NSDictionary *dictRowsVal=@{@"":arrRowsVal};
    
    NSMutableArray *arrRows=[[NSMutableArray alloc]initWithObjects:dictRowsVal,nil];
    
    NSMutableDictionary *dictFinal=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"fitmi_water_log",@"table",@"insert_individualy",@"type",arrColumnNm, @"columns",arrRows,@"rows",nil];
    
    NSMutableArray *arrFinal=[[NSMutableArray alloc]initWithObjects:dictFinal,nil];
    
    NSLog(@"arrFinal==%@",arrFinal);
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrFinal options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString==%@",jsonString);
    NSString *newString =[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    newString = [newString stringByTrimmingCharactersInSet:whitespace];
    
    NSLog(@"newString==%@",newString);
    self.view.userInteractionEnabled = NO;
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] saveSyncLog:newString userID:userID  AccessKey:userAccessKey];

}

#pragma mark - Server Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    [DejalBezelActivityView removeViewAnimated:YES];
    
    NSLog(@"result=%@",result);
}
#pragma mark - verify Method
-(BOOL)verify
{
    BOOL success = true;
    
    if([self isValidNumeric:waterIntakeTxtView.text]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
        return false;
    }
    if(waterIntakeTxtView.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Water Amount" withAlertTag:100];
        return false;
    }
    return success;
}

#pragma mark - reload Method
-(void)reloadSection
{
    isDelete=NO;
    
    NSString *totalcal=@"";
    
    // logTimeStr=[[Utility sharedManager]getSelectedDateFormat];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSDate *dateFromString = [formatter1 dateFromString:[[Utility sharedManager] getSelectedDate]];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    logTimeStr= [dateFormatter2 stringFromDate:dateFromString];
    
    _waterLogRecord=[waterObj getAllWaterLog:logTimeStr withUserProfileID:selectedUserProfileID];
    
    if([_waterLogRecord count]>0)
    {
        waterIntakeTableView.hidden=NO;
        waterIntakeTableView.delegate=self;
        waterIntakeTableView.dataSource=self;
        [waterIntakeTableView reloadData];
        
        float total=0;
        for(int i=0;i<[_waterLogRecord count];i++){
            NSArray *qtyArr=[NSArray array];
            qtyArr=[[[_waterLogRecord objectAtIndex:i] objectForKey:@"oz"] componentsSeparatedByString:@" "];
            total=total+[[qtyArr objectAtIndex:0] floatValue];
        }
        totalcal=[NSString stringWithFormat:@"%.2f",total];
        
    }
    else{
        waterIntakeTableView.hidden=YES;
        totalcal=@"0";
    }
    
    UIFont *mediumFont;
    UIFont *LightFont ;
    if(family==iPad)
    {
        mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:22];
        LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:19];
     }
    else
    {
        if([self isIphoneSixPlus])
        {
             mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:18];
            LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:15];
        }
        else{
            mediumFont = [UIFont fontWithName:@"SinkinSans-400regular" size:16];
            LightFont = [UIFont fontWithName:@"SinkinSans-300Light" size:13];
         }
    }
    NSDictionary *mediumDict = [NSDictionary dictionaryWithObject: mediumFont forKey:NSFontAttributeName];
    NSMutableAttributedString *mediumAttrString = [[NSMutableAttributedString alloc] initWithString:totalcal attributes: mediumDict];
    
    NSDictionary *LightDict = [NSDictionary dictionaryWithObject:LightFont forKey:NSFontAttributeName];
    NSMutableAttributedString *LightAttrString = [[NSMutableAttributedString alloc]initWithString:@" ounces"  attributes:LightDict];
    
    [mediumAttrString appendAttributedString:LightAttrString];
    totalQty.attributedText=mediumAttrString;
    
}

#pragma mark - Calender Notification Method
-(void)notifySelectedDate:(NSString *)dateStr
{
    [self reloadSection];
    
}
- (void)notifyDate:(NSString *)dateStr
{
    
}

@end
