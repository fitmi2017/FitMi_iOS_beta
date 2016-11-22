//
//  UserInfoViewController.m
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ProfileViewController.h"
#import "UserInfoTableViewCell.h"
#import "Constant.h"
#import "Utility.h"
#import "DeviceListViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "Profile.h"
#import "UserProfileDetails.h"
#import "UserCalDetails.h"
#import "UnitsLog.h"
#import "YKImageCropperViewController.h"
#import "DeviceLog.h"
#define DROP_DOWN_UNIT_HEIGHT_TAG 1
#define DROP_DOWN_UNIT_WEIGHT_TAG 3
#define DROP_DOWN_GENDER_TAG 4
#define DROP_DOWN_ACTIVITYLEVEL_TAG 2
#define DROP_DOWN_DATE_TAG 11
#define daily_calorie_intake_on @"Our estimated daily calorie goal is calculated based on age, height, weight and gender. It is intended to produce the calorie goal required to meet our plan. We use the Harris Benedict Formula. This equation produce what is known as a Basal Metabolic Rate(BMR) which is the number of calories you turn at rest. Calorie goals must be between 1200 and 9000 calories per day."
#define daily_calorie_intake_off @"We recommend that you select an \"automatic\" calorie goal unless you have received specific recommendations for calorie intake from a doctor or nutritionist. You may choose to enter your own calorie goal by turning \"automatic\" calorie goals off. If you opt to set your own calorie goals, the daily calorie goal will not ajust your weight changes. You will need to manually reduce the daily calorie goal. If FitMi calculates your calorie goals, the goal will adjust your weight changes."


@interface UserInfoViewController ()
{
    NSMutableArray *arrUnitHeight,*arrUnitWeight,*arrActiLevel,*arrGender,*deviceArr;
    User *mUser;
   NSURL *localImageUrl;
    UserProfileDetails *userProfileObj;
    NSUserDefaults *defaults;
    int years;
    float BurnedVal,IntakeVal;
    NSString *selectedUserProfileID;
    UnitsLog *unitsLogObj;
    NSString *savedImagePath;
    
    UIImage *varImg;
    UserProfile *userObj;
    DeviceLog *DeviceLogObj;
    BOOL switchState;
    NSString *currentState,*oldState;
}


@end


@implementation UserInfoViewController
@synthesize selectedDate;

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    
    if([defaults valueForKey:@"currentState"]){
      oldState=[defaults valueForKey:@"currentState"];
      switchState=[oldState boolValue];
        
    }
    else{
        switchState=1;

    }
    
    currentState=[NSString stringWithFormat:@"%d",switchState];

     selectedDate=[NSDate date];
    
    userObj=[[UserProfile alloc]init];
    DeviceLogObj=[[DeviceLog alloc]init];
    
     deviceArr = [[NSMutableArray alloc] initWithObjects:@"BloodPressure Monitor",@"Kitchen Scale",nil];
  
    varImg=nil;
    
//    _txtFldUserNm.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
//    _txtFldUserNm.layer.borderWidth=1;
    
    _txtFldUserFirstNm.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    _txtFldUserFirstNm.layer.borderWidth=1;

    _txtFldUserLastNm.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    _txtFldUserLastNm.layer.borderWidth=1;

    _btnProfileImg.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    _btnProfileImg.layer.borderWidth=1;
    
    years=0;
    BurnedVal=0.0;
    IntakeVal=0.0;
    
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  mUser = [[Utility sharedManager] retriveUserDetailsFromDefault];
   // _txtFldUserNm.text=mUser.userName;

    if ([_txtFldUserFirstNm respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
      //  _txtFldUserNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User's Name" attributes:@{NSForegroundColorAttributeName: color}];
        _txtFldUserFirstNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User's First Name" attributes:@{NSForegroundColorAttributeName: color}];
        _txtFldUserLastNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User's Last Name" attributes:@{NSForegroundColorAttributeName: color}];

    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
//    UIView *paddingVwUserNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
//    _txtFldUserNm.leftView = paddingVwUserNm;
//    _txtFldUserNm.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVwUserFNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    _txtFldUserFirstNm.leftView = paddingVwUserFNm;
    _txtFldUserFirstNm.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVwUserLNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    _txtFldUserLastNm.leftView = paddingVwUserLNm;
    _txtFldUserLastNm.leftViewMode = UITextFieldViewModeAlways;

    arrUnitHeight = [[NSMutableArray alloc] initWithObjects:@"Feet",@"Cm",nil];
    arrUnitWeight= [[NSMutableArray alloc] initWithObjects:@"lbs",@"Kg",nil];
    arrActiLevel= [[NSMutableArray alloc] initWithObjects:@"Low",@"Moderate",@"High",nil];
    arrGender= [[NSMutableArray alloc] initWithObjects:@"Male",@"Female",nil];
    
     unitsLogObj=[[UnitsLog alloc]init];
    
    NSMutableArray *arrUnitsLog=[unitsLogObj getAllUnitDataLog:selectedUserProfileID];
    
    if(arrUnitsLog.count>0)
    {
        for(int i=0;i<arrUnitsLog.count;i++)
        {
            NSDictionary *dict=[arrUnitsLog objectAtIndex:i];
            if([[dict objectForKey:@"type"] isEqualToString:@"height"])
            {
            if([[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"height"] isEqualToString:@"ft"])
                {
                   _unitHeightID_str=[arrUnitHeight objectAtIndex:0];
                }
            else{
               _unitHeightID_str=[arrUnitHeight objectAtIndex:1];
               }
            }
            else if([[dict objectForKey:@"type"] isEqualToString:@"weight"])
            {
            if([[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"weight"] isEqualToString:@"lbs"])
              {
                _unitWeightID_str=[arrUnitWeight objectAtIndex:0];
              }
            else{
                _unitWeightID_str=[arrUnitWeight objectAtIndex:1];
              }
            }
        }
    }
    else
    {
    _unitHeightID_str=[arrUnitHeight objectAtIndex:0];
    _unitWeightID_str=[arrUnitWeight objectAtIndex:0];
    }
    
    _genderVal=[arrGender objectAtIndex:0];
    _actLevel_str=[arrActiLevel objectAtIndex:0];
    
    if ([defaults valueForKey:@"usersaved"]!=NULL && [[defaults valueForKey:@"usersaved"] isEqualToString:@"1"]) {
        [self createNavigationView:@"User Info"];
        [self.navigationItem setHidesBackButton:NO animated:NO];
    }
    else{
        [self createTitleNavigationView:@"User Info"];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    
    if(_isEditProfile==YES)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];

        userProfileObj=[[UserProfileDetails alloc]init];
        NSMutableArray *usersArr=[userProfileObj getUserProfileDetails:selectedUserProfileID];
        userProfileObj=[usersArr objectAtIndex:0];

        //_txtFldUserNm.text=userProfileObj.full_name;
        _txtFldUserFirstNm.text=userProfileObj.first_name;
        _txtFldUserLastNm.text=userProfileObj.last_name;
        _genderVal=userProfileObj.gender;
        
        UIImage *userImg=[self getImage];
        if ([userProfileObj.gender isEqualToString:@"Male"])
        {
            _imgVwProfile.image=[UIImage imageNamed:@"User_Male@3x.png"];
        }
        else
        {
            _imgVwProfile.image=[UIImage imageNamed:@"User_Female@3x.png"];
        }
        
       /* if(![[defaults valueForKey:@"selectedUserProfileImage"] isEqualToString:@""])
        {
            NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults valueForKey:@"selectedUserProfileImage"]]];
            userImg = [[UIImage alloc] initWithData:receivedData] ;
        }*/

        if(userImg)
        {
            _imgVwProfile.image=userImg;
            varImg=userImg;
        }
        _imgVwProfile.contentMode = UIViewContentModeScaleAspectFit;

        _weightVal_str=[[userProfileObj.weight componentsSeparatedByString:@" "]objectAtIndex:0];
        _unitWeightID_str=[[userProfileObj.weight componentsSeparatedByString:@" "]objectAtIndex:1];
        _ftVal_str=userProfileObj.height_ft;
        _inchVal_str=userProfileObj.height_in;
        _birthDay_str=userProfileObj.dob;
        _actLevel_str=userProfileObj.activity_level;
        _dailyCalIntakeVal_str=userProfileObj.daily_calorie_intake;
        switchState=[userProfileObj.cal_intake_status boolValue];
        currentState=[NSString stringWithFormat:@"%d",switchState];

        //[_tblVw reloadData];
      //  UITableViewCell *cell = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
       // UITextField *txtCal=(UITextField*)[cell viewWithTag:2];
       // txtCal.text= _dailyCalIntakeVal_str;
        
        if ([_birthDay_str rangeOfString:@"/"].location == NSNotFound)
        {
            NSLog(@"string does not contain");
        }
        else
        {
            NSLog(@"string contains");
            selectedDate=[formatter dateFromString:_birthDay_str];
        }
        
    [_tblVw reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    APP_CTRL.CurrentControllerObj = self;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - "Save" Button Action
- (IBAction)btnActionSave:(id)sender
{
    [self.view endEditing:YES];
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    [self calculateIntakeValue];

    if([self verify])
    {   //APP_CTRL.userProfileDataDataDict=[NSMutableDictionary dictionary];
        
        //if([userObj getAllProfileID].count >0 )
        //int userid=[[[[userObj getAllProfileID] objectAtIndex:0] objectForKey:@"id"] intValue]+1;
        //NSLog(@"userid=========%@", [[[userObj getAllProfileID] objectAtIndex:0] objectForKey:@"id"]);
       // [APP_CTRL.userProfileDataDataDict setValue:[NSString stringWithFormat:@"%d",userid] forKey:@"user_id"];
        //[APP_CTRL.userProfileDataDataDict setValue:@"NO" forKey:@"is_profile_pic"];
        
      /*  if([self isNetworkAvailable]==NO){
            [self createAlertView:@"Alert" withAlertMessage:ConnectionUnavailable withAlertTag:3];
        }
        else
        {*/
          // [self saveProfileServerConnection];
            if(_isEditProfile==YES)
            {
                [self updateProfileLocalDB:selectedUserProfileID];
                [self updateProfileServerConnection];
            }
            else
            {
                [self saveProfileLocalDB];
                [self saveProfileServerConnection];
            }
        //}
    }
    
    /*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"usersaved"];
    ProfileViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:mVerificationViewController animated:YES];*/

}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(switchState){
        if(section==0)
            return 6;
        else
            return 1;
    }
    else{
        
        if(section==0)
            return 6;
       else if (section==1)
            return 2;
        else
             return 1;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if(switchState)
        cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"largeCellOn"];
    else
        cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"largeCellOff"];
    

    if (thisDeviceFamily() == iPad) {
        return 100;
    }
    else{
      if(indexPath.section==2 ){
            
            UILabel *switchOnLabel;
            if(switchState)
            {
                switchOnLabel=(UILabel *)[cell viewWithTag:3];
                CGRect switchOnLabelSize=[self getLabelSize:daily_calorie_intake_on :[UIScreen mainScreen].bounds.size.width-40];
                NSLog(@"Label height=======%f",switchOnLabel.frame.size.height);
                
                NSLog(@"switchOnLabelSize===%f",switchOnLabelSize.size.height);
                
                NSLog(@"hhhhh%f",(switchOnLabelSize.size.height+91-switchOnLabel.frame.size.height) );
                return (switchOnLabelSize.size.height)>91 ?(switchOnLabelSize.size.height+91-switchOnLabel.frame.size.height):91 ;
                
            }
            else
            {
                switchOnLabel=(UILabel *)[cell viewWithTag:4];
                CGRect switchOnLabelSize=[self getLabelSize:daily_calorie_intake_off :[UIScreen mainScreen].bounds.size.width-40];
                NSLog(@"Label height=======%f",switchOnLabel.frame.size.height);
                
                NSLog(@"switchOnLabelSize===%f",switchOnLabelSize.size.height);
                
                NSLog(@"hhhhh%f",(switchOnLabelSize.size.height+91-switchOnLabel.frame.size.height) );
                return (switchOnLabelSize.size.height)>91 ?(switchOnLabelSize.size.height+91-switchOnLabel.frame.size.height):91 ;
            }
        }
        else if(indexPath.section==1)
              return 91;
        else if(indexPath.section==0){
            if(indexPath.row==5)
                return 40;
            else
          return 80.0;
        }
    }
    return 80.0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(indexPath.section==1){
        simpleTableIdentifier = @"smallCellSwitch";
        
    }
    if(!switchState){
        if(indexPath.section==1 && indexPath.row==1)
            simpleTableIdentifier = @"smallCellInput";
        
        else if(indexPath.section==2)
            simpleTableIdentifier = @"largeCellOff";
        
    }
    else{
        if(indexPath.section==2)
            simpleTableIdentifier = @"largeCellOn";
        
    }
    
    if(indexPath.section==0){
     if(indexPath.row==0)
     {
    UserInfoTableViewCell *cell=nil;
        
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil];

        if (thisDeviceFamily() == iPad) {
            cell=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
           cell=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
        
    //cell=(UserInfoTableViewCell*)[nib objectAtIndex:0];
    cell.btnBirthday.tag=indexPath.row+10000000;
    [cell.btnBirthday addTarget:self action:@selector(btnActionSelectBirthday:) forControlEvents:UIControlEventTouchUpInside];
        
    NSDictionary *dictBirthday=[self splitBirthday:_birthDay_str];
    cell.txtFldBDay_Month.text=[dictBirthday objectForKey:@"Birthday_Month"];
    cell.txtFldBDay_Day.text=[dictBirthday objectForKey:@"Birthday_Day"];
    cell.txtFldBDay_Year.text=[dictBirthday objectForKey:@"Birthday_Year"];
        
    cell.txtFldBDay_Month.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
    cell.txtFldBDay_Month.layer.borderWidth=1.0;
    cell.txtFldBDay_Day.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
    cell.txtFldBDay_Day.layer.borderWidth=1.0;
    cell.txtFldBDay_Year.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
    cell.txtFldBDay_Year.layer.borderWidth=1.0;

    UIView *paddingVwBDay_Month = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    cell.txtFldBDay_Month.leftView = paddingVwBDay_Month;
    cell.txtFldBDay_Month.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVwBDay_Day = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    cell.txtFldBDay_Day.leftView = paddingVwBDay_Day;
    cell.txtFldBDay_Day.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVwBDay_Year = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    cell.txtFldBDay_Year.leftView = paddingVwBDay_Year;
    cell.txtFldBDay_Year.leftViewMode = UITextFieldViewModeAlways;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
     else if(indexPath.row==1)
     {
    UserInfoTableViewCell *cell1=nil;
        
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell1" owner:self options:nil];

        if (thisDeviceFamily() == iPad) {
            cell1=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
            cell1=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
        
    
    cell1.btnHeightUnit.tag=indexPath.row+20000000;
    [cell1.btnHeightUnit addTarget:self action:@selector(btnActionSelectHeightUnit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell1.txtFldUnit.text=_unitHeightID_str;
        
        if([_unitHeightID_str isEqualToString:[arrUnitHeight objectAtIndex:0]])
        {
            cell1.txtFldFeet.placeholder=@"Feet";
            cell1.txtFldInch.placeholder=@"Inches";
        }
        else if([_unitHeightID_str isEqualToString:[arrUnitHeight objectAtIndex:1]])
        {
            cell1.txtFldFeet.placeholder=@"Cm";
            cell1.txtFldInch.placeholder=@"Mm";
        }
        cell1.txtFldFeet.delegate=self;
        cell1.txtFldInch.delegate=self;
        cell1.txtFldFeet.tag=101;
        cell1.txtFldInch.tag=102;
        cell1.txtFldFeet.text=_ftVal_str;
        cell1.txtFldInch.text=_inchVal_str;
        
        self.txtFldHeight_Ft=cell1.txtFldFeet;
        self.txtFldHeight_Inch=cell1.txtFldInch;
        
        cell1.txtFldFeet.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell1.txtFldFeet.layer.borderWidth=1.0;
        cell1.txtFldInch.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell1.txtFldInch.layer.borderWidth=1.0;
        cell1.txtFldUnit.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell1.txtFldUnit.layer.borderWidth=1.0;

        UIView *paddingVwFeet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell1.txtFldFeet.leftView = paddingVwFeet;
        cell1.txtFldFeet.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingVwInch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell1.txtFldInch.leftView = paddingVwInch;
        cell1.txtFldInch.leftViewMode = UITextFieldViewModeAlways;

        UIView *paddingVwUnit = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell1.txtFldUnit.leftView = paddingVwUnit;
        cell1.txtFldUnit.leftViewMode = UITextFieldViewModeAlways;

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell1;
    }
     else if(indexPath.row==2)
     {
        UserInfoTableViewCell *cell2=nil;
       
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell2" owner:self options:nil];

        if (thisDeviceFamily() == iPad) {
            cell2=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
            cell2=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
    
    cell2.btnActLevel.tag=indexPath.row+30000000;
    [cell2.btnActLevel addTarget:self action:@selector(btnActionSelectActivityLevel:) forControlEvents:UIControlEventTouchUpInside];
        
    cell2.txtFldActLevel.text=_actLevel_str;
    cell2.txtFldActLevel.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
    cell2.txtFldActLevel.layer.borderWidth=1.0;
    
        UIView *paddingVwActLevel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell2.txtFldActLevel.leftView = paddingVwActLevel;
        cell2.txtFldActLevel.leftViewMode = UITextFieldViewModeAlways;

        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell2;
    }
     else if(indexPath.row==5)
     {
    UserInfoTableViewCell *cell3=nil;
 
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell3" owner:self options:nil];

        
        if (thisDeviceFamily() == iPad) {
            cell3=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
            cell3=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell3.txtFldCalIntake.delegate=self;
//    cell3.txtFldCalIntake.tag=301;
//    cell3.txtFldCalIntake.text=_dailyCalIntakeVal_str;
//    cell3.txtFldCalIntake.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
//    cell3.txtFldCalIntake.layer.borderWidth=1.0;
      
        UIView *paddingVwCalIntake = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell3.txtFldCalIntake.leftView = paddingVwCalIntake;
        cell3.txtFldCalIntake.leftViewMode = UITextFieldViewModeAlways;

    return cell3;
    }
    
     else if(indexPath.row==3)
     {
        UserInfoTableViewCell *cell4=nil;
        
        NSArray *nib=nil;
        
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell4" owner:self options:nil];
        
        if (thisDeviceFamily() == iPad) {
            cell4=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
            cell4=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
        cell4.selectionStyle=UITableViewCellSelectionStyleNone;
        cell4.txtFldWeight.delegate=self;
        cell4.txtFldWeight.tag=401;
        cell4.txtFldWeightUnit.delegate=self;
        cell4.txtFldWeightUnit.tag=402;
      
        cell4.txtFldWeight.text=_weightVal_str;
        cell4.txtFldWeightUnit.text=_unitWeightID_str;
        
        cell4.txtFldWeight.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell4.txtFldWeight.layer.borderWidth=1.0;
        cell4.txtFldWeightUnit.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell4.txtFldWeightUnit.layer.borderWidth=1.0;

        UIView *paddingVwWeight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell4.txtFldWeight.leftView = paddingVwWeight;
        cell4.txtFldWeight.leftViewMode = UITextFieldViewModeAlways;

        UIView *paddingVwWeightUnit = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell4.txtFldWeightUnit.leftView = paddingVwWeightUnit;
        cell4.txtFldWeightUnit.leftViewMode = UITextFieldViewModeAlways;

        if([_unitWeightID_str isEqualToString:[arrUnitWeight objectAtIndex:0]])
        {
            cell4.txtFldWeight.placeholder=@"lbs";
        }
        else if([_unitWeightID_str isEqualToString:[arrUnitWeight objectAtIndex:1]])
        {
            cell4.txtFldWeight.placeholder=@"Kg";
        }

        cell4.btnWeightUnit.tag=indexPath.row+40000000;
        [cell4.btnWeightUnit addTarget:self action:@selector(btnActionSelectWeightUnit:) forControlEvents:UIControlEventTouchUpInside];

        return cell4;
    }

     else if(indexPath.row==4)
     {
        UserInfoTableViewCell *cell5=nil;
        
        NSArray *nib=nil;
        
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserInfoTableViewCell5" owner:self options:nil];
        
       // cell5=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        if (thisDeviceFamily() == iPad) {
            cell5=(UserInfoTableViewCell*)[nib objectAtIndex:1];
        }
        else{
            cell5=(UserInfoTableViewCell*)[nib objectAtIndex:0];
        }
        cell5.selectionStyle=UITableViewCellSelectionStyleNone;
        cell5.txtFldGenderVal.delegate=self;
        cell5.txtFldGenderVal.tag=501;
        
        cell5.txtFldGenderVal.text=_genderVal;
        
        cell5.txtFldGenderVal.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
        cell5.txtFldGenderVal.layer.borderWidth=1.0;

        cell5.btnGenderVal.tag=indexPath.row+50000000;
        [cell5.btnGenderVal addTarget:self action:@selector(btnActionSelectGender:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *paddingVwGenderVal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        cell5.txtFldGenderVal.leftView = paddingVwGenderVal;
        cell5.txtFldGenderVal.leftViewMode = UITextFieldViewModeAlways;

        return cell5;
    }
 }
    else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
     if(indexPath.section==1 ){
      if(indexPath.row==0 ){
        UISwitch *switchBtn=(UISwitch*)[cell viewWithTag:1];
        [switchBtn addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
        if(switchState){
           
            [switchBtn setOn:YES];

        }
        else{
            [switchBtn setOn:NO];
            UIColor *colorOff = [UIColor redColor];
            [switchBtn setTintColor:colorOff];
            switchBtn.layer.cornerRadius = 16.0f;
            switchBtn.backgroundColor = colorOff;

        }
      }
      else  if( indexPath.row==1){
            UITextField *calInputTxt=(UITextField *)[cell viewWithTag:2];
            calInputTxt.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
            calInputTxt.delegate=self;
            calInputTxt.layer.borderWidth= 1.0f;
        
            UIView *paddingVwInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
            calInputTxt.leftView = paddingVwInput;
            calInputTxt.leftViewMode = UITextFieldViewModeAlways;
          if(_dailyCalIntakeVal_str.length >0 && ![[self chkNullInputinitWithString:_dailyCalIntakeVal_str] isEqualToString:@""]){
              calInputTxt.text=_dailyCalIntakeVal_str;
          
          }
          
        }
         
     }
     else if ( indexPath.section==2){
     
         if(switchState){
             UILabel *switchOnLabel=(UILabel *)[cell viewWithTag:3];
             
             UILabel *lblCalIntakeVal=(UILabel *)[cell viewWithTag:100];
             lblCalIntakeVal.text=userProfileObj.daily_calorie_intake;
             
             NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
             style.lineSpacing=6;
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:daily_calorie_intake_on];
             [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
             switchOnLabel.attributedText = str;
         }
         else{
             
            
             UILabel *switchOFFLabel=(UILabel *)[cell viewWithTag:4];
             UILabel *lblCalIntakeVal=(UILabel *)[cell viewWithTag:100];
             lblCalIntakeVal.text=userProfileObj.daily_calorie_intake;
             
             NSMutableParagraphStyle *style=[NSMutableParagraphStyle new];
             style.lineSpacing=6;
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:daily_calorie_intake_off];
             [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
             switchOFFLabel.attributedText= str;
             
         }
     }
        
    return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


#pragma mark - "SelectBirthday" DropDown Button Action
- (IBAction)btnActionSelectBirthday:(id)sender
{
    [self.view endEditing:YES];
    [self CreateDatePicker:DROP_DOWN_DATE_TAG];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
   // NSString *dateString = [formatter stringFromDate:currDate];
    NSString *dateString = [formatter stringFromDate:self.pickDate.date];
    NSLog(@"%@",dateString);
    
    _birthDay_str=dateString;
}
#pragma mark - "SelectHeight Unit" DropDown Button Action
- (IBAction)btnActionSelectHeightUnit:(id)sender
{
     [self.view endEditing:YES];
    if(arrUnitHeight.count>0)
    {
        for(int i=0;i<arrUnitHeight.count;i++)
        {
            NSString * tempID =  [arrUnitHeight objectAtIndex:i];
            if([tempID compare:_unitHeightID_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
        }

        RadioButtonViewController *radioButtonVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RadioButtonViewController"];
        radioButtonVC.radioType=@"Select Height";
        radioButtonVC.radioBtnArr=arrUnitHeight;
        radioButtonVC.tag=DROP_DOWN_UNIT_HEIGHT_TAG;
        radioButtonVC.selectedIndex=selectedIndex;
        CGRect frame = radioButtonVC.view.frame;
        frame.size.height = self.view.frame.size.height;
        frame.origin.y=self.view.frame.origin.y;
        radioButtonVC.view.frame = frame;
        [radioButtonVC willMoveToParentViewController:self];
        radioButtonVC.delegate=self;
        [self.view addSubview:radioButtonVC.view];
        [self addChildViewController:radioButtonVC];
        [self.view bringSubviewToFront:radioButtonVC.view];

        
      /*   [self CreatePicker:DROP_DOWN_UNIT_HEIGHT_TAG];
        
        for(int i=0;i<arrUnitHeight.count;i++)
        {
            NSString * tempID =  [arrUnitHeight objectAtIndex:i];
            if([tempID compare:_unitHeightID_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
            
        }
        [self.pickItem selectRow:selectedIndex inComponent:0 animated:NO];*/
    }
    else
    {
        //   [self createAlertView:@"Alert" withAlertMessage:@"No Option to Select" withAlertTag:1];
    }
}

#pragma mark - "SelectWeight Unit" DropDown Button Action
- (IBAction)btnActionSelectWeightUnit:(id)sender
{
    [self.view endEditing:YES];
    if(arrUnitWeight.count>0)
    {
        
        for(int i=0;i<arrUnitWeight.count;i++)
        {
            NSString * tempID =  [arrUnitWeight objectAtIndex:i];
            if([tempID compare:_unitWeightID_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
            
        }

        RadioButtonViewController *radioButtonVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RadioButtonViewController"];
        radioButtonVC.radioType=@"Select Weight";
        radioButtonVC.tag=DROP_DOWN_UNIT_WEIGHT_TAG;
        radioButtonVC.selectedIndex=selectedIndex;
        radioButtonVC.radioBtnArr=arrUnitWeight;
        CGRect frame = radioButtonVC.view.frame;
        frame.size.height = self.view.frame.size.height;
        frame.origin.y=self.view.frame.origin.y;
        radioButtonVC.view.frame = frame;
        [radioButtonVC willMoveToParentViewController:self];
        radioButtonVC.delegate=self;
        [self.view addSubview:radioButtonVC.view];
        [self addChildViewController:radioButtonVC];
        [self.view bringSubviewToFront:radioButtonVC.view];

      /*  [self CreatePicker:DROP_DOWN_UNIT_WEIGHT_TAG];
        
        for(int i=0;i<arrUnitWeight.count;i++)
        {
            NSString * tempID =  [arrUnitWeight objectAtIndex:i];
            if([tempID compare:_unitWeightID_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
            
        }
        [self.pickItem selectRow:selectedIndex inComponent:0 animated:NO];*/
        
    }
    else
    {
        //   [self createAlertView:@"Alert" withAlertMessage:@"No Option to Select" withAlertTag:1];
    }
}

#pragma mark - "SelectActivity Level" DropDown Button Action
- (IBAction)btnActionSelectActivityLevel:(id)sender
{
     [self.view endEditing:YES];
    if(arrActiLevel.count>0)
    {
        for(int i=0;i<arrActiLevel.count;i++)
        {
            NSString * tempID =  [arrActiLevel objectAtIndex:i];
            if([tempID compare:_actLevel_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
          }

        RadioButtonViewController *radioButtonVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RadioButtonViewController"];
        radioButtonVC.radioType=@"Select Activity Level";
        radioButtonVC.radioBtnArr=arrActiLevel;
        radioButtonVC.tag=DROP_DOWN_ACTIVITYLEVEL_TAG;
        radioButtonVC.selectedIndex=selectedIndex;
        CGRect frame = radioButtonVC.view.frame;
        frame.size.height = self.view.frame.size.height;
        frame.origin.y=self.view.frame.origin.y;
        radioButtonVC.view.frame = frame;
        [radioButtonVC willMoveToParentViewController:self];
        radioButtonVC.delegate=self;
        [self.view addSubview:radioButtonVC.view];
        [self addChildViewController:radioButtonVC];
        [self.view bringSubviewToFront:radioButtonVC.view];

      /*  [self CreatePicker:DROP_DOWN_ACTIVITYLEVEL_TAG];
        
        for(int i=0;i<arrActiLevel.count;i++)
        {
            NSString * tempID =  [arrActiLevel objectAtIndex:i];
            if([tempID compare:_actLevel_str]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
            
        }
        [self.pickItem selectRow:selectedIndex inComponent:0 animated:NO];*/
    }
    else
    {
        //   [self createAlertView:@"Alert" withAlertMessage:@"No Option to Select" withAlertTag:1];
    }
}

#pragma mark - "Select Gender" DropDown Button Action
- (IBAction)btnActionSelectGender:(id)sender
{
    [self.view endEditing:YES];
    if(arrGender.count>0)
    {
        for(int i=0;i<arrGender.count;i++)
        {
            NSString * tempID =  [arrGender objectAtIndex:i];
            if([tempID compare:_genderVal]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
        }

        RadioButtonViewController *radioButtonVC =[self.storyboard instantiateViewControllerWithIdentifier:@"RadioButtonViewController"];
        radioButtonVC.radioType=@"Select Gender";
        radioButtonVC.radioBtnArr=arrGender;
        radioButtonVC.tag=DROP_DOWN_GENDER_TAG;
        radioButtonVC.selectedIndex=selectedIndex;
        CGRect frame = radioButtonVC.view.frame;
        frame.size.height = self.view.frame.size.height;
        frame.origin.y=self.view.frame.origin.y;
        radioButtonVC.view.frame = frame;
        [radioButtonVC willMoveToParentViewController:self];
        radioButtonVC.delegate=self;
        [self.view addSubview:radioButtonVC.view];
        [self addChildViewController:radioButtonVC];
        [self.view bringSubviewToFront:radioButtonVC.view];

      /* [self CreatePicker:DROP_DOWN_GENDER_TAG];
        
        for(int i=0;i<arrActiLevel.count;i++)
        {
            NSString * tempID =  [arrGender objectAtIndex:i];
            if([tempID compare:_genderVal]==NSOrderedSame)
            {
                selectedIndex = i;
                break;
            }
            
        }
        [self.pickItem selectRow:selectedIndex inComponent:0 animated:NO];*/
        
    }
    else
    {
        //   [self createAlertView:@"Alert" withAlertMessage:@"No Option to Select" withAlertTag:1];
    }
}

#pragma mark - CreateDatePicker Method
-(void)CreateDatePicker  :(int)tag
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        
        [self.view addSubview:_maskView];
        
        _toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 304, self.view.bounds.size.width, 44)];
        _toolBar.tag=1;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        doneButton.tag=tag;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancel:)];
        cancelButton.tag=tag;
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [_toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        [self.view addSubview:_toolBar];
        
        self.pickDate = [[UIDatePicker alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
        {
          //  self.pickDate.frame=CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 0);
            self.pickDate.frame=CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 260);
        }
        else
        {
             self.pickDate.frame=CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 260);
            //self.pickDate.frame=CGRectMake(0, self.view.bounds.size.height - 260, 0, 0);
        }
        self.pickDate.datePickerMode = UIDatePickerModeDate;
        
        self.pickDate.date =selectedDate;// [NSDate date];
        self.pickDate.tag=tag;
       // [self.pickDate setMaximumDate:[NSDate date]];
        [self.pickDate addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        
        self.vwpicker = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width,260)];
        self.vwpicker.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:self.vwpicker];
        
        [self.view addSubview:self.pickDate];
        
    }
    else
    {
        
        SHEET = [[UIActionSheet alloc] initWithTitle:@"\n \n \n \n \n \n \n \n \n \n \n \n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
        
        self.pickDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.pickDate.datePickerMode = UIDatePickerModeDate;
        self.pickDate.date =selectedDate;// [NSDate date];
        self.pickDate.tag=tag;
        //[self.pickDate setMaximumDate:[NSDate date]];
        [self.pickDate addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.tag=tag;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        doneButton.tag=tag;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancel:)];
        cancelButton.tag=tag;
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        
        self.vwpicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        [self.vwpicker addSubview:self.pickDate];
        self.vwpicker.backgroundColor=[UIColor whiteColor];
        [self.vwpicker addSubview:toolBar];
        
        [SHEET addSubview:self.vwpicker];
        [SHEET showInView:self.view];
    }
}

#pragma mark - changeDate Method (UIDatePicker)
- (void)changeDate:(UIDatePicker *)sender
{
   /* for(UITextField *aView in self.scrollVwBG.subviews){
        if([aView isKindOfClass:[UITextField class]]){
            [aView resignFirstResponder];
        }
    }*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    if(sender.tag==DROP_DOWN_DATE_TAG)
    {
        //_txtFldDueDate.text = [formatter stringFromDate:sender.date];
        _birthDay_str= [formatter stringFromDate:sender.date];
    }
}

#pragma mark - CreatePicker Method
-(void)CreatePicker  :(int)tag
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        
        [self.view addSubview:_maskView];
        
        _toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 304, self.view.bounds.size.width, 44)];
        _toolBar.tag=1;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        doneButton.tag=tag;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancel:)];
        cancelButton.tag=tag;
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [_toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        [self.view addSubview:_toolBar];
        
        self.pickItem = [[UIPickerView alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
            self.pickItem.frame=CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 0);
        else
            self.pickItem.frame=CGRectMake(0, self.view.bounds.size.height - 260, 0, 0);

        self.pickItem.tag=tag;
        [self.pickItem setDataSource: self];
        [self.pickItem setDelegate: self];
        [self.pickItem reloadAllComponents];
        self.pickItem.showsSelectionIndicator = YES;
        [self.pickItem selectRow:0 inComponent:0 animated:NO];
        
        self.vwpicker = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width,260)];
        self.vwpicker.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:self.vwpicker];
        
        [self.view addSubview:self.pickItem];
        
    }
    else
    {
        SHEET = [[UIActionSheet alloc] initWithTitle:@"\n \n \n \n \n \n \n \n \n \n \n \n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
        
        self.pickItem = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        
        self.pickItem.tag=tag;
        [self.pickItem setDataSource: self];
        [self.pickItem setDelegate: self];
        [self.pickItem reloadAllComponents];
        self.pickItem.showsSelectionIndicator = YES;
        [self.pickItem selectRow:0 inComponent:0 animated:NO];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.tag=1;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        doneButton.tag=tag;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancel:)];
        cancelButton.tag=tag;
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        
        self.vwpicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        self.vwpicker.backgroundColor=[UIColor whiteColor];
        [self.vwpicker addSubview:self.pickItem];
        [self.vwpicker addSubview:toolBar];
        
        [SHEET addSubview:self.vwpicker];
        [SHEET showInView:self.view];
    }
}

#pragma mark - Picker ToolBar Button Action Method
- (void)pickerDoneClicked:(UIBarButtonItem *)sender
{
    NSLog(@"Done Clicked");
    NSLog(@"%ld",(long)sender.tag);
    
    selectedDate=self.pickDate.date;
    [_tblVw reloadData];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        [_maskView removeFromSuperview];
        [self.pickItem removeFromSuperview];
        [self.pickDate removeFromSuperview];
        [_toolBar removeFromSuperview];
        [self.vwpicker removeFromSuperview];
    }
    else
    {
        self.vwpicker.hidden=YES;
        [SHEET dismissWithClickedButtonIndex:0 animated:YES];
    }
   // [_txtFldTitle resignFirstResponder];
    
}
- (void)pickerCancel:(UIBarButtonItem *)sender
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        [_maskView removeFromSuperview];
        [self.pickItem removeFromSuperview];
        [self.pickDate removeFromSuperview];
        [_toolBar removeFromSuperview];
        [self.vwpicker removeFromSuperview];
    }
    else
    {
        self.vwpicker.hidden=YES;
        [SHEET dismissWithClickedButtonIndex:0 animated:YES];
    }
  //  [_txtFldTitle resignFirstResponder];
    
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag==DROP_DOWN_UNIT_HEIGHT_TAG)
    {
        return arrUnitHeight.count;
    }
    else if(pickerView.tag==DROP_DOWN_UNIT_WEIGHT_TAG)
    {
        return arrUnitWeight.count;
    }
    else if(pickerView.tag==DROP_DOWN_ACTIVITYLEVEL_TAG)
    {
        return arrActiLevel.count;
    }
    else if(pickerView.tag==DROP_DOWN_GENDER_TAG)
    {
        return arrGender.count;
    }

    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str=@"";
    if(pickerView.tag==DROP_DOWN_UNIT_HEIGHT_TAG)
    {
        str= [arrUnitHeight objectAtIndex:row];
    }
    else if(pickerView.tag==DROP_DOWN_UNIT_WEIGHT_TAG)
    {
        str= [arrUnitWeight objectAtIndex:row];
    }
    else if(pickerView.tag==DROP_DOWN_ACTIVITYLEVEL_TAG)
    {
        str= [arrActiLevel objectAtIndex:row];
    }
    else if(pickerView.tag==DROP_DOWN_GENDER_TAG)
    {
        str= [arrGender objectAtIndex:row];
    }

      return  str;
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
    
    if(pickerView.tag==DROP_DOWN_UNIT_HEIGHT_TAG)
    {
        _unitHeightID_str=[NSString stringWithFormat:@"%@",[arrUnitHeight objectAtIndex:row]];
    }
    else if(pickerView.tag==DROP_DOWN_UNIT_WEIGHT_TAG)
    {
        _unitWeightID_str=[NSString stringWithFormat:@"%@",[arrUnitWeight objectAtIndex:row]];
    }
    else if(pickerView.tag==DROP_DOWN_ACTIVITYLEVEL_TAG)
    {
        _actLevel_str=[NSString stringWithFormat:@"%@",[arrActiLevel objectAtIndex:row]];
      }
    else if(pickerView.tag==DROP_DOWN_GENDER_TAG)
    {
        _genderVal=[NSString stringWithFormat:@"%@",[arrGender objectAtIndex:row]];
    }

  }

#pragma mark - splitBirthday Method
-(NSDictionary *)splitBirthday:(NSString *)strBirthday
{
    NSLog(@"%@",strBirthday);
    NSDictionary *dictBirthday;
    if ([strBirthday rangeOfString:@"/"].location == NSNotFound)
    {
        NSLog(@"string does not contain");
         dictBirthday = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"Birthday_Month", @"", @"Birthday_Day",@"", @"Birthday_Year",nil];
    }
    else
    {
        NSLog(@"string contains");
        NSArray *arrBirthday=[strBirthday componentsSeparatedByString:@"/"];
        
        NSString *strMonth=[arrBirthday objectAtIndex:0];
        NSString *strMonthNm=[self monthName:strMonth];
        
        NSString *strDay=[arrBirthday objectAtIndex:1];
        NSString *strYear=[arrBirthday objectAtIndex:2];
        
       dictBirthday = [[NSDictionary alloc] initWithObjectsAndKeys:strMonthNm, @"Birthday_Month", strDay, @"Birthday_Day",strYear, @"Birthday_Year",nil];

    }
    
    return dictBirthday;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldUserFirstNm) {
        [_txtFldUserFirstNm resignFirstResponder];
        [_txtFldUserLastNm becomeFirstResponder];
    }
    else if (textField ==_txtFldUserLastNm){
        [_txtFldUserLastNm resignFirstResponder];
    }
    else if(textField==self.txtFldHeight_Ft)
    {
        [self.txtFldHeight_Ft resignFirstResponder];
        [self.txtFldHeight_Inch becomeFirstResponder];
    }
    else if (textField ==self.txtFldHeight_Inch){
        [self.txtFldHeight_Inch resignFirstResponder];
    }

    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   /* UITableViewCell *textFieldRowCell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        textFieldRowCell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        textFieldRowCell = (UITableViewCell *) textField.superview.superview.superview;
    }
    
    NSLog(@"%f",textField.frame.origin.y);
    if([[self GetIphoneModelVersion]isEqualToString:@"6"])
    {
        NSLog(@"IPHONE6S");
        float scrolly=100.0;
      // [self.tblVw scrollToRowAtIndexPath:[self.tblVw indexPathForCell:textFieldRowCell] atScrollPosition:scrolly animated:YES];
        [self.tblVw setContentOffset:CGPointMake(0.0,50.0)];
    }*/

return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%ld",(long)textField.tag);
    if(textField.tag==101)
    {
        _ftVal_str=textField.text;
    }
    else if(textField.tag==102)
    {
        _inchVal_str=textField.text;
    }
    else if(textField.tag==301)
    {
        _dailyCalIntakeVal_str=textField.text;
    }
    else if(textField.tag==401)
    {
        _weightVal_str=textField.text;
    }
    
   // [self.tblVw setContentOffset:CGPointMake(0, 0)];
    return YES;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"ButtonIndex -- %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //-------For Camera--------
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                _camerapicker = [[UIImagePickerController alloc] init] ;
                _camerapicker.delegate = self;
                _camerapicker.allowsEditing = YES;
                _camerapicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _camerapicker.showsCameraControls = YES;
                //[camerapicker parentViewController];
                [self presentViewController:_camerapicker animated:YES completion:^{
                }];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Camera Available in the Device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }
            break;
        case 1:
        {
            //---------For Gallery----------
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    localImageUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    
    if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
        
      //  image=[Utility imageWithImage:image scaledToWidth:200];
        //  [image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
       //  [APP_CTRL.userProfileDataDataDict setValue:@"YES" forKey:@"is_profile_pic"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
        //NSLog(@"--height=%f,width=%f",image.size.height,image.size.width);
       // image=[Utility imageWithImage:image scaledToWidth:200];
      //  NSLog(@"--height=%f,width=%f",image1.size.height,image1.size.width);
        //[image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
      //  [APP_CTRL.userProfileDataDataDict setValue:@"YES" forKey:@"is_profile_pic"];

        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *squareImage = [self squareImageFromImage:image scaledToSize:320];
    // UIImage *newImage =[self upsideDownImage :img];
    //NSData *imgData = UIImageJPEGRepresentation(squareImage, 1);
    varImg=squareImage;
    _imgVwProfile.image=squareImage;
    _imgVwProfile.contentMode = UIViewContentModeScaleAspectFit;
    
   /* YKImageCropperViewController *vc = [[YKImageCropperViewController alloc] initWithImage:squareImage];
    vc.cancelHandler = ^() {
        NSLog(@"* Cancel");
    };
    vc.doneHandler = ^(UIImage *editedImage) {
        NSLog(@"* Done");
        NSLog(@"Original: %@, Edited: %@", NSStringFromCGSize(squareImage.size), NSStringFromCGSize(editedImage.size));
    };
   // [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];*/
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - saveImage Method
- (NSString*)saveImage:(UIImage*)img
{
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
  
NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%@.png",selectedUserProfileID];
savedImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];

NSData *imageData = UIImagePNGRepresentation(img);
[imageData writeToFile:savedImagePath atomically:NO];
   
return savedImagePath;
}

#pragma mark - getImage Method
- (UIImage*)getImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%@.png",selectedUserProfileID];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

#pragma mark - Select Profile Image Button Action
- (IBAction)btnActionselectProfileImg:(id)sender
{
    sheetImages = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Gallery", nil];
    [sheetImages showInView:self.view];

}

#pragma mark - "Cancel" Button Action
- (IBAction)btnActionCancel:(id)sender
{
    if(_isEditProfile==YES)
    {
        ProfileViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        mVerificationViewController.userProfileDetails=userProfileObj;
        
        [self.navigationController pushViewController:mVerificationViewController animated:YES];
    }
    else
    {
      [self.navigationController popViewControllerAnimated:YES];
    }
    
   // _txtFldUserNm.text=@"";
    _txtFldUserFirstNm.text=@"";
     _txtFldUserLastNm.text=@"";
    
    _birthDay_str=@"//";
    
    _unitHeightID_str=[arrUnitHeight objectAtIndex:0];
    _unitWeightID_str=[arrUnitWeight objectAtIndex:0];
    _genderVal=[arrGender objectAtIndex:0];
    _actLevel_str=[arrActiLevel objectAtIndex:0];
    
    _ftVal_str=@"";
    _inchVal_str=@"";
    _dailyCalIntakeVal_str=@"";
    _weightVal_str=@"";

    [_tblVw reloadData];
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

#pragma mark - Keyboard Hide/Show Notification Function
- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [_tblVw setContentInset:edgeInsets];
        [_tblVw setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [_tblVw setContentInset:edgeInsets];
        [_tblVw setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark - Save Profile Server Connection Method
-(void)saveProfileServerConnection
{
    NSLog(@"%@",savedImagePath);
     if([[self chkNullInputinitWithString:savedImagePath] isEqualToString:@""])
         savedImagePath=@"";
         
    NSString *fullNm=[NSString stringWithFormat:@"%@ %@",_txtFldUserFirstNm.text,_txtFldUserLastNm.text];
    NSString *userID=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *userAccessKey=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"];
    NSString *yearsAge=[NSString stringWithFormat:@"%d",years];
    NSString *weightVal=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
    _dailyCalIntakeVal_str=[NSString stringWithFormat:@"%.0f",IntakeVal];
    
    NSString * timestampDOB=@"";
    if(_birthDay_str)
    {
        //NSDate(String) to TimeStamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:_birthDay_str];
    timestampDOB = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    NSLog(@"timestamp=%@",timestampDOB);
   }
    
   // NSMutableArray *arrColumnNm=[[NSMutableArray alloc]initWithObjects:@"user_id",@"first_name", @"last_name",@"gender",@"full_name",@"age",@"picture",@"height_ft",@"height_in",@"weight",@"date_of_birth",@"activity_level",@"daily_calorie_intake",@"image_url",@"username",nil];
    
    //NSMutableArray *arrRowsVal=[[NSMutableArray alloc]initWithObjects:userID,_txtFldUserFirstNm.text, _txtFldUserLastNm.text,_genderVal,fullNm,yearsAge,savedImagePath,_ftVal_str,_inchVal_str,weightVal,_birthDay_str,_actLevel_str,intake,savedImagePath,fullNm,nil];
    
 /*   NSMutableArray *arrColumnNm=[[NSMutableArray alloc]initWithObjects:@"first_name", @"last_name",@"gender",@"full_name",@"age",@"picture",@"height_ft",@"height_in",@"weight",@"date_of_birth",@"activity_level",@"daily_calorie_intake",@"image_url",@"username",nil];

    NSMutableArray *arrRowsVal=[[NSMutableArray alloc]initWithObjects:_txtFldUserFirstNm.text, _txtFldUserLastNm.text,_genderVal,fullNm,yearsAge,savedImagePath,_ftVal_str,_inchVal_str,weightVal,_birthDay_str,_actLevel_str,intake,savedImagePath,fullNm,nil];
    
    NSDictionary *dictRowsVal=@{userID:arrRowsVal};
    
    NSMutableArray *arrRows=[[NSMutableArray alloc]initWithObjects:dictRowsVal,nil];
    
    NSMutableDictionary *dictFinal=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"user_profiles",@"table",@"insert_individualy",@"type",arrColumnNm, @"columns",arrRows,@"rows",nil];
    
    NSMutableArray *arrFinal=[[NSMutableArray alloc]initWithObjects:dictFinal,nil];

    NSLog(@"arrFinal==%@",arrFinal);
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrFinal options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString==%@",jsonString);
    NSString *newString =[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
   newString = [newString stringByTrimmingCharactersInSet:whitespace];
    
    NSLog(@"newString==%@",newString);*/
     self.view.userInteractionEnabled = NO;
     _connectType=@"PostUserProfileData";
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
  // [[ServerConnection sharedInstance] saveProfile:newString userID:userID  AccessKey:userAccessKey];

    [[ServerConnection sharedInstance] saveProfilePrevious:_ftVal_str Height:_inchVal_str FirstName:_txtFldUserFirstNm.text LastName:_txtFldUserLastNm.text DateofBirth:timestampDOB ActivityLevel:_actLevel_str DailyCalIntake:_dailyCalIntakeVal_str Weight:_weightVal_str WeightUnit:_unitWeightID_str Gender:_genderVal AccessKey:userAccessKey userID:userID];
}

#pragma mark - Update Profile Server Connection Method
-(void)updateProfileServerConnection
{
    NSLog(@"%@",savedImagePath);
    if([[self chkNullInputinitWithString:savedImagePath] isEqualToString:@""])
        savedImagePath=@"";
    
    NSString *fullNm=[NSString stringWithFormat:@"%@ %@",_txtFldUserFirstNm.text,_txtFldUserLastNm.text];
    NSString *userID=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *userAccessKey=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"];
    NSString *yearsAge=[NSString stringWithFormat:@"%d",years];
    NSString *weightVal=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
   _dailyCalIntakeVal_str=[NSString stringWithFormat:@"%.0f",IntakeVal];
    
    NSString * timestampDOB=@"";
    if(_birthDay_str)
    {
        //NSDate(String) to TimeStamp
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [formatter dateFromString:_birthDay_str];
        timestampDOB = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
        NSLog(@"timestamp=%@",timestampDOB);
    }

   // NSMutableArray *arrColumnNm=[[NSMutableArray alloc]initWithObjects:@"user_id",@"first_name", @"last_name",@"gender",@"full_name",@"age",@"picture",@"height_ft",@"height_in",@"weight",@"date_of_birth",@"activity_level",@"daily_calorie_intake",@"image_url",@"username",nil];
    
    //NSMutableArray *arrRowsVal=[[NSMutableArray alloc]initWithObjects:userID,_txtFldUserFirstNm.text, _txtFldUserLastNm.text,_genderVal,fullNm,yearsAge,savedImagePath,_ftVal_str,_inchVal_str,weightVal,_birthDay_str,_actLevel_str,intake,savedImagePath,fullNm,nil];
    
  /*  NSMutableArray *arrColumnNm=[[NSMutableArray alloc]initWithObjects:@"first_name", @"last_name",@"gender",@"full_name",@"age",@"picture",@"height_ft",@"height_in",@"weight",@"date_of_birth",@"activity_level",@"daily_calorie_intake",@"image_url",@"username",nil];
    
    NSMutableArray *arrRowsVal=[[NSMutableArray alloc]initWithObjects:_txtFldUserFirstNm.text, _txtFldUserLastNm.text,_genderVal,fullNm,yearsAge,savedImagePath,_ftVal_str,_inchVal_str,weightVal,_birthDay_str,_actLevel_str,intake,savedImagePath,fullNm,nil];

    NSDictionary *dictRowsVal=@{userID:arrRowsVal};
    
    NSMutableArray *arrRows=[[NSMutableArray alloc]initWithObjects:dictRowsVal,nil];
    
    NSMutableDictionary *dictFinal=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"user_profiles",@"table",@"update_individualy",@"type",arrColumnNm, @"columns",arrRows,@"rows",nil];
    
    NSMutableArray *arrFinal=[[NSMutableArray alloc]initWithObjects:dictFinal,nil];

    NSLog(@"arrFinal==%@",arrFinal);
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrFinal options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString==%@",jsonString);
    NSString *newString =[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    newString = [newString stringByTrimmingCharactersInSet:whitespace];
    
    NSLog(@"newString==%@",newString);*/
    self.view.userInteractionEnabled = NO;
    _connectType=@"PostUserProfileData";
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
   // [[ServerConnection sharedInstance] saveProfile:newString userID:userID  AccessKey:userAccessKey];
    
    [[ServerConnection sharedInstance] saveProfilePrevious:_ftVal_str Height:_inchVal_str FirstName:_txtFldUserFirstNm.text LastName:_txtFldUserLastNm.text DateofBirth:timestampDOB ActivityLevel:_actLevel_str DailyCalIntake:_dailyCalIntakeVal_str Weight:_weightVal_str WeightUnit:_unitWeightID_str Gender:_genderVal AccessKey:userAccessKey userID:userID];

}

#pragma mark - Server Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    
    NSLog(@"result=%@",result);
    
    if ([_connectType isEqualToString:@"PostUserProfileData"])
    {

    if ([result isKindOfClass:[NSError class]])
    {
        NSError *error=(NSError *)result;
        [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
        
         [DejalBezelActivityView removeViewAnimated:YES];
        return;
    }
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        if([[dict valueForKey:@"status"] isEqualToString:@"false"])
        {
            [self createAlertView:@"Mesupro" withAlertMessage:[[dict valueForKey:@"message"]objectAtIndex:0] withAlertTag:0];
             [DejalBezelActivityView removeViewAnimated:YES];
        }
        else if([[dict valueForKey:@"status"] isEqualToString:@"true"])
        {
            //[DejalBezelActivityView removeViewAnimated:YES];

           [self performSelector:@selector(postUserProfileImage) withObject:nil afterDelay:1.0];
        }
    }
  }
    
    
   else if ([_connectType isEqualToString:@"PostUserProfileImage"])
    {
          [DejalBezelActivityView removeViewAnimated:YES];
    }
}

-(void)postUserProfileImage
{
    // Convert Image to NSData
    NSData *imageData;
    if(varImg!=nil)
    {
        imageData = UIImagePNGRepresentation(_imgVwProfile.image);
    }
    //imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"yourImage"], 1.0f);

    //Process- I
    self.view.userInteractionEnabled = NO;
   /* _connectType=@"PostUserProfileImage";
    //   [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] saveProfileImage:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] AccessKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"]  ImageData:imageData];*/
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/image_upload",BASE_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:@"fe32981fa08335a8ba36cd45f4ab505d" forKey:@"access_token"];
     [request addPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"] forKey:@"access_key"];
    // Upload an NSData instance
    [request setData:imageData withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"profile_image"];
    [request setCompletionBlock:^{
        [DejalBezelActivityView removeViewAnimated:YES];
        NSString *str = [request responseString];
        
        NSLog(@"RESPONSE=%@",str);
    }];
[request setFailedBlock:^{
    [DejalBezelActivityView removeViewAnimated:YES];

}];
    [request startAsynchronous];
    //Process- II
    // Create 'POST' MutableRequest with Data and Other Image Attachment.
   /*  NSString *filename = @"ProfileImage";
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.png\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response  %@",responseString);
    if(responseString)
    {
         [DejalBezelActivityView removeViewAnimated:YES];
    }*/
}

#pragma mark - verify Method
-(BOOL)verify
{
    BOOL success = true;
    
    NSScanner *scannerFt = [NSScanner scannerWithString:_ftVal_str];
    BOOL isNumericFt = [scannerFt scanInteger:NULL] && [scannerFt isAtEnd];
    
    NSScanner *scannerInch = [NSScanner scannerWithString:_inchVal_str];
    BOOL isNumericInch = [scannerInch scanInteger:NULL] && [scannerInch isAtEnd];
    
   /* if(_txtFldUserNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide User Name" withAlertTag:100];
        return false;
        
    }*/
    
    if(_txtFldUserFirstNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide User FirstName" withAlertTag:100];
        return false;
        
    }
    if(_txtFldUserLastNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide User LastName" withAlertTag:100];
        return false;
        
    }

    
    if(_birthDay_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Birthday" withAlertTag:100];
        return false;
        
    }

    if(_ftVal_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Height" withAlertTag:100];
        return false;
        
    }
    if(isNumericFt==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value of Height" withAlertTag:100];
        return false;
    }

    if(_inchVal_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Height" withAlertTag:100];
        return false;
        
    }
    
    if(isNumericInch==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value of Height" withAlertTag:100];
        return false;
    }

    if(_actLevel_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please Select Activity Level" withAlertTag:100];
        return false;
        
    }
    
  /*  if(_dailyCalIntakeVal_str.length <=0){
        
        [self createAlertView:@"Mesupro" withAlertMessage:@"Please provide Daily Calorie Intake" withAlertTag:100];
        return false;
        
    }*/
    
    if(_weightVal_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Weight" withAlertTag:100];
        return false;
        
    }
  
    if([self isValidNumeric:_weightVal_str]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value of Weight" withAlertTag:100];
        return false;
    }

    if(_genderVal.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please Select Gender" withAlertTag:100];
        return false;
        
    }

    return success;
}

#pragma mark - saveProfileLocalDB Method
-(void)saveProfileLocalDB
{
    
    
    UITableViewCell *cell = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField *txtCal=(UITextField*)[cell viewWithTag:2];
    
    
    UITableViewCell *cell1 = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UISwitch *switchBtn=(UISwitch*)[cell1 viewWithTag:1];
    NSLog(@"txtCaltxtCaltxtCal%@",txtCal.text);
    if(currentState==nil)
        currentState=[NSString stringWithFormat:@"%d",[switchBtn isOn]];
    
    
    [defaults setValue:currentState forKey:@"currentState"];
    [defaults synchronize];

    
   /////
   userProfileObj=[[UserProfileDetails alloc]init];
    userProfileObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSLog(@"userProfileObj.user_id%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);
    userProfileObj.full_name=[NSString stringWithFormat:@"%@ %@",_txtFldUserFirstNm.text,_txtFldUserLastNm.text];//_txtFldUserNm.text;
    userProfileObj.first_name=_txtFldUserFirstNm.text;
    userProfileObj.last_name=_txtFldUserLastNm.text;
    userProfileObj.gender=_genderVal;
    userProfileObj.height_ft=_ftVal_str;
    userProfileObj.height_in=_inchVal_str;
    userProfileObj.weight=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
    userProfileObj.dob=_birthDay_str;
    userProfileObj.age=[NSString stringWithFormat:@"%d",years];
    userProfileObj.activity_level=_actLevel_str;
    userProfileObj.daily_calorie_intake=[NSString stringWithFormat:@"%.0f",IntakeVal];
    //userProfileObj.image_path=[NSString stringWithContentsOfURL:localImageUrl encoding:0 error:nil];
    userProfileObj.image_path=savedImagePath;
    userProfileObj.cal_intake_status=currentState;
    int user_profile_id=[userProfileObj saveUserProfileDetails];
    
    if(user_profile_id)
    {
       if(varImg!=nil)
       {
        //Save Image
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%d.png",user_profile_id];
        savedImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];
        
        NSData *imageData = UIImagePNGRepresentation(_imgVwProfile.image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        [userProfileObj updateUserProfileImg:user_profile_id withImagePath:savedImagePath];
       }
    UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
    userCalObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSLog(@"userProfileObj.user_id%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);
    userCalObj.user_profile_id=[NSString stringWithFormat:@"%d",user_profile_id];
    userCalObj.total_intake=[NSString stringWithFormat:@"%.0f",IntakeVal];
    userCalObj.total_burned=[NSString stringWithFormat:@"%.0f",BurnedVal];
    userCalObj.weight=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
    userCalObj.sleep=@"7 hrs";
    userCalObj.water=@"8 cups";
    userCalObj.bp_sys=@"120";
    userCalObj.bp_dia=@"80";
    
    [userCalObj saveUserCalorieDetails];
        
    [[NSUserDefaults standardUserDefaults] setObject:userCalObj.user_profile_id forKey:@"selectedUserProfileID"];
    [[NSUserDefaults standardUserDefaults]  synchronize];

        for(int i=0;i<deviceArr.count;i++)
        {
        DeviceLogObj.log_user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        DeviceLogObj.log_user_profile_id=userCalObj.user_profile_id;
        DeviceLogObj.deviceType=[deviceArr objectAtIndex:i];
        DeviceLogObj.deviceStatus=@"0";
        DeviceLogObj.log_date_added=[self getCurrentDateTime];
        DeviceLogObj.log_log_time=[self getCurrentDateTime];
          
         [DeviceLogObj saveUserDeviceDataLog];
        }
    }
    if([self verify1]){
    BOOL isSuccess3=[userProfileObj updateUserProfile:[NSString stringWithFormat:@"%d",user_profile_id] withIntakeVal:txtCal.text withColumnNm:@"daily_calorie_intake"];
    
    if(isSuccess3)
    {
        UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
        BOOL isSuccess4=[userCalObj updateUserCalorie:[NSString stringWithFormat:@"%d",user_profile_id] withIntakeVal:txtCal.text withColumnNm:@"total_intake"];
    }
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.vwHome.userInteractionEnabled=YES;
    appDelegate.tabBarController.vwHelp.userInteractionEnabled=YES;
    
    appDelegate.tabBarController.btnTabHome.alpha=1.0;
    appDelegate.tabBarController.btnTabHelp.alpha=1.0;
    
    //First Time User SetUp after Login
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]==NULL)
    {
    [appDelegate.tabBarController performSegueWithIdentifier:@"homenavigation" sender:[appDelegate.tabBarController.buttons objectAtIndex:0]];
    }
    else
    {
    ProfileViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    mVerificationViewController.userProfileDetails=userProfileObj;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
    }
    
     [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"usersaved"];
    
}

#pragma mark - updateProfileLocalDB Method
-(void)updateProfileLocalDB:(NSString *)profileID
{
    UITableViewCell *cell = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField *txtCal=(UITextField*)[cell viewWithTag:2];
    
    UITableViewCell *cell1 = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UISwitch *switchBtn=(UISwitch*)[cell1 viewWithTag:1];
    NSLog(@"txtCaltxtCaltxtCal%@",txtCal.text);
    /*if(currentState==nil)
        currentState=[NSString stringWithFormat:@"%d",[switchBtn isOn]];
    
    
    [defaults setValue:currentState forKey:@"currentState"];
    [defaults synchronize];*/
     userProfileObj=[[UserProfileDetails alloc]init];
    
    userProfileObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    userProfileObj.full_name=[NSString stringWithFormat:@"%@ %@",_txtFldUserFirstNm.text,_txtFldUserLastNm.text];//_txtFldUserNm.text;
    userProfileObj.first_name=_txtFldUserFirstNm.text;
    userProfileObj.last_name=_txtFldUserLastNm.text;

    userProfileObj.gender=_genderVal;
    userProfileObj.height_ft=_ftVal_str;
    userProfileObj.height_in=_inchVal_str;
    userProfileObj.weight=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
    userProfileObj.dob=_birthDay_str;
    userProfileObj.age=[NSString stringWithFormat:@"%d",years];
    userProfileObj.activity_level=_actLevel_str;
    userProfileObj.daily_calorie_intake=[NSString stringWithFormat:@"%.0f",IntakeVal];
    //userProfileObj.image_path=[NSString stringWithContentsOfURL:localImageUrl encoding:0 error:nil];
    userProfileObj.cal_intake_status=currentState;
    savedImagePath=[self saveImage:_imgVwProfile.image];
  userProfileObj.image_path=savedImagePath;
  
    BOOL isSuccess=[userProfileObj updateUserProfileDetails:selectedUserProfileID];
    
    if(isSuccess)
    {
    UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
    userCalObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    userCalObj.total_intake=[NSString stringWithFormat:@"%.0f",IntakeVal];
    userCalObj.total_burned=[NSString stringWithFormat:@"%.0f",BurnedVal];
    userCalObj.weight=[NSString stringWithFormat:@"%@ %@",_weightVal_str,_unitWeightID_str];
    userCalObj.sleep=@"7 hrs";
    userCalObj.water=@"8 cups";
    userCalObj.bp_sys=@"120";
    userCalObj.bp_dia=@"80";
    
    [userCalObj updateUserCalorieDetails:selectedUserProfileID];
    }
    if([self verify1]){

    BOOL isSuccess3=[userProfileObj updateUserProfile:selectedUserProfileID withIntakeVal:txtCal.text withColumnNm:@"daily_calorie_intake"];
    
    if(isSuccess3)
    {
        UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
      BOOL isSuccess4=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:txtCal.text withColumnNm:@"total_intake"];
    }
    }
    ProfileViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    mVerificationViewController.userProfileDetails=userProfileObj;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];

}

#pragma mark - calculateIntakeValue Method
-(void)calculateIntakeValue
{
    ////////////////======================   Formula For BMR:  ====================== ////////////////
    
    /*  W = weight in kilograms (weight (lbs)/2.2) =weight in kg
     H = height in centimeters (inches x 2.54) =height in cm
     A = age in years
     
     Men: BMR=66.47+ (13.75 x W) + (5.0 x H) - (6.75 x A)
     Women: BMR=665.09 + (9.56 x W) + (1.84 x H) - (4.67 x A)
     
     BMR x 1.2 for low intensity activities and leisure activities (primarily sedentary)
     BMR x 1.375 for light exercise (leisurely walking for 30-50 minutes 3-4 days/week, golfing, house chores)
     BMR x 1.55 for moderate exercise 3-5 days per week (60-70% MHR for 30-60 minutes/session)
     BMR x 1.725 for active individuals (exercising 6-7 days/week at moderate to high intensity (70-85% MHR) for 45-60 minutes/session)
     
     
     Example:-
     66.47 +(13.75 * 60) + (5 * 165) - (6.75*30)
     66.47 + 825 + 825 - 202 = 1514
     
     Low = 1514 * 1.2 = 1816 calories
     Medium = 1514 * 1.55 = 2346 calories
     High = 1514 * 1.725 = 2611 calories
     
     FitMi Calorie baseline Data (Need to show in home screen)
     ==========================================================
     Intake Req = 1816 calories
     Burned Req = (1816 - 1514) = 302 calories */
    ////////////////============================================ ////////////////
    
    float inchVal=0.0,cmVal=0.0;
    
    if([_unitHeightID_str isEqualToString:[arrUnitHeight objectAtIndex:0]])
    {
        inchVal=([_ftVal_str floatValue]*12.0)+[_inchVal_str floatValue];
        cmVal=inchVal*2.54;
    }
    else if([_unitHeightID_str isEqualToString:[arrUnitHeight objectAtIndex:1]])
    {
        cmVal=([_ftVal_str intValue]*100)+[_inchVal_str intValue];
    }
    
    NSLog(@"Height=%f",cmVal);
    
    float LbsVal=0.0,KgVal=0.0;
    
    if([_unitWeightID_str isEqualToString:[arrUnitWeight objectAtIndex:0]])
    {
        LbsVal=[_weightVal_str floatValue];
        KgVal=LbsVal/2.2;
    }
    else if([_unitWeightID_str isEqualToString:[arrUnitWeight objectAtIndex:1]])
    {
        KgVal=[_weightVal_str floatValue];
    }
    
    NSLog(@"Weight=%f",KgVal);
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:_birthDay_str]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    years = (allDays-days)/365;
    
    NSLog(@"Age=%d",years);
    
    float BMRVal=0.0;
    if([_genderVal isEqualToString:[arrGender objectAtIndex:0]])
    {
        //For Men
        BMRVal=66.47+ (13.75 * KgVal) + (5.0 * cmVal) - (6.75 * years);
    }
    else if([_genderVal isEqualToString:[arrGender objectAtIndex:1]])
    {
        //For Women
        BMRVal=665.09+ (9.56 * KgVal) + (1.84 * cmVal) - (4.67 * years);
    }
    
    if([_actLevel_str isEqualToString:[arrActiLevel objectAtIndex:0]])
    {
        //For Low Activity Level
        IntakeVal=BMRVal * 1.2;
    }
    else if([_actLevel_str isEqualToString:[arrActiLevel objectAtIndex:1]])
    {
        //For Medium Activity Level
        IntakeVal=BMRVal * 1.55;
    }
    else if([_actLevel_str isEqualToString:[arrActiLevel objectAtIndex:2]])
    {
        //For High Activity Level
        IntakeVal=BMRVal * 1.725;
    }
    
    BurnedVal=IntakeVal-BMRVal;
    
    NSLog(@"Intake=%f,Burned=%f,BMR=%f",IntakeVal,BurnedVal,BMRVal);

}

#pragma mark - Private Method
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Notify RadioButton Selection Method
-(void)notifyradioButtonLog:(NSString *)strOption withTag:(int)tag
{
    NSLog(@"strOption==%@",strOption);
    
    if(![strOption isEqualToString:@"BACK"])
    {
        if(tag==DROP_DOWN_UNIT_HEIGHT_TAG)
        {
            _unitHeightID_str=[NSString stringWithFormat:@"%@",strOption];
        }
        else if(tag==DROP_DOWN_UNIT_WEIGHT_TAG)
        {
            _unitWeightID_str=[NSString stringWithFormat:@"%@",strOption];
        }
        else if(tag==DROP_DOWN_ACTIVITYLEVEL_TAG)
        {
            _actLevel_str=[NSString stringWithFormat:@"%@",strOption];
        }
        else if(tag==DROP_DOWN_GENDER_TAG)
        {
            _genderVal=[NSString stringWithFormat:@"%@",strOption];
            
            if([_genderVal isEqualToString:[arrGender objectAtIndex:0]] &&varImg==nil)
            {
            _imgVwProfile.image=[UIImage imageNamed:@"User_Male@3x.png"];
            }
            else if([_genderVal isEqualToString:[arrGender objectAtIndex:1]]&&varImg==nil)
            {
            _imgVwProfile.image=[UIImage imageNamed:@"User_Female@3x.png"];
            }
              _imgVwProfile.contentMode = UIViewContentModeScaleAspectFit;
        }
      }
    
     [_tblVw reloadData];
}

#pragma mark - NULL checking
-(NSString *)chkNullInputinitWithString:(NSString*)InputString
{
    if( (InputString == nil) ||(InputString ==(NSString*)[NSNull null])||([InputString isEqual:nil])||([InputString length] == 0)||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@"NULL"]) ||([InputString isEqualToString:@"null"])))
        
        return @"";
    else
        return InputString ;
}
#pragma mark - UISwitch Action Method
- (IBAction)toggleSwitch:(id)sender
{
    UISwitch *switchBtn=(UISwitch*)sender;
    switchState = [sender isOn];
    UIColor *colorOn = [UIColor greenColor];
    UIColor *colorOff = [UIColor redColor];
    currentState=[NSString stringWithFormat:@"%d",switchState];
    [sender setOnTintColor:colorOn];
    [sender setTintColor:colorOff];
    switchBtn.layer.cornerRadius = 16.0f;
    switchBtn.backgroundColor = colorOff;
    [_tblVw reloadData];
    
   
}

#pragma mark - getLabelSize Method
-(CGRect)getLabelSize:(NSString *)str :(CGFloat)width
{
    CGSize maxSize = CGSizeZero;
    maxSize = CGSizeMake(width, MAXFLOAT);
    __unused float rowHeight=0.0;
    float fontSize = 0.0;
    if (thisDeviceFamily() == iPad)
    {
        fontSize = 20.0;
    }
    else
    {
        fontSize = 15.0;
    }
    
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize];
    CGRect labelRect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                NSFontAttributeName : font                                                                                                                                                                                                                                                                        }      context:nil];
    
    return labelRect;
    
}
-(BOOL)verify1
{
    UITableViewCell *cell = (UITableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField *txtCal=(UITextField*)[cell viewWithTag:2];
    

    BOOL success = true;
    if([self isValidNumeric:txtCal.text]==NO)
    {
       // [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
        return false;
    }
    if(txtCal.text.length <=0){
        
      //  [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Daily Calorie Intake value" withAlertTag:100];
        return false;
    }
    return success;
}

@end
