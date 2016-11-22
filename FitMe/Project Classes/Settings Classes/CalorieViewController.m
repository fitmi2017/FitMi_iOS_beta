//
//  CalorieViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "CalorieViewController.h"
#import "CalorieTableViewCell.h"
#import "UserProfileDetails.h"
#import "UserCalDetails.h"
@interface CalorieViewController ()
{
    UserProfileDetails *userProfileObj;
    UserCalDetails *userCalObj;
    NSUserDefaults *defaults;
    NSString *selectedUserProfileID;

}
@end

@implementation CalorieViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavigationView:@"Settings"];
    [self.navigationItem setHidesBackButton:YES animated:NO];

    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    userProfileObj=[[UserProfileDetails alloc]init];
//    NSMutableArray *usersArr=[userProfileObj getUserProfileDetails:selectedUserProfileID];
//    userProfileObj=[usersArr objectAtIndex:0];
    
    userCalObj=[[UserCalDetails alloc]init];
    NSMutableArray *usersArr=[userCalObj getUserCalorieDetails:selectedUserProfileID];
    userCalObj=[usersArr objectAtIndex:0];

    if([_navClass isEqualToString:@"Calories to Burn"])
    {
        _lblTop.text=@"Calories to burn";
     }
    else if([_navClass isEqualToString:@"Weight"])
    {
        _lblTop.text=@"Weight";
    }
    else if([_navClass isEqualToString:@"Sleep"])
    {
        _lblTop.text=@"Sleep";
    }
    else if([_navClass isEqualToString:@"Water"])
    {
        _lblTop.text=@"Water";
    }
    else if([_navClass isEqualToString:@"Blood Pressure"])
    {
         _lblTop.text=@"Blood Pressure";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if([_navClass isEqualToString:@"Blood Pressure"])
       return 2;
    else
       return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (thisDeviceFamily() == iPad) {
        return 80;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalorieTableViewCell *cell=nil;
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"CalorieTableViewCell" owner:self options:nil];
    
    if (thisDeviceFamily() ==  iPad)
    {
        cell=(CalorieTableViewCell*)[nib objectAtIndex:0];
    }
    else
    {
        cell=(CalorieTableViewCell*)[nib objectAtIndex:1];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (thisDeviceFamily() == iPad)
    {
        cell.lblTitle.font = [UIFont fontWithName:@"SinkinSans-300Light" size:22.0];
    }
    else
    {
        cell.lblTitle.font = [UIFont fontWithName:@"SinkinSans-300Light" size:17.0];
        cell.lblTitle.adjustsFontSizeToFitWidth = YES;
    }
    
    if([_navClass isEqualToString:@"Calories to Burn"])
    {
        cell.lblTitle.text=@"Calories to burn";
        
        if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",userCalObj.total_burned]] isEqualToString:@""])
            _val_str=cell.txtFldVal.text=userCalObj.total_burned;
        else
            _val_str=cell.txtFldVal.text=@"0";
    }
    else if([_navClass isEqualToString:@"Weight"])
    {
        cell.lblTitle.text=@"Weight";
        _val_str=cell.txtFldVal.text=[[userCalObj.weight componentsSeparatedByString:@" "]objectAtIndex:0];
    }
    else if([_navClass isEqualToString:@"Sleep"])
    {
        cell.lblTitle.text=@"Hours of Sleep";
        _val_str=cell.txtFldVal.text=[[userCalObj.sleep componentsSeparatedByString:@" "]objectAtIndex:0];
    }
    else if([_navClass isEqualToString:@"Water"])
    {
        cell.lblTitle.text=@"Cups of Water";
        _val_str=cell.txtFldVal.text=[[userCalObj.water componentsSeparatedByString:@" "]objectAtIndex:0];
    }
     else if([_navClass isEqualToString:@"Blood Pressure"])
     {
         if(indexPath.row==0)
         {
             cell.lblTitle.text=@"Blood Pressure (sys)";
             _val_str=cell.txtFldVal.text=userCalObj.bp_sys;
             cell.lblTitle.adjustsFontSizeToFitWidth = YES;
          }
         else if(indexPath.row==1)
         {
             cell.lblTitle.text=@"Blood Pressure (dia)";
             _val_str1=cell.txtFldVal.text=userCalObj.bp_dia;
             cell.lblTitle.adjustsFontSizeToFitWidth = YES;
         }
     }
    
    cell.txtFldVal.delegate=self;
    cell.txtFldVal.tag=indexPath.row+1;
    
    UIView *paddingVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    cell.txtFldVal.leftView = paddingVw;
    cell.txtFldVal.leftViewMode = UITextFieldViewModeAlways;
    cell.txtFldVal.layer.borderColor=[[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f]CGColor];
    cell.txtFldVal.layer.borderWidth=1.0;

    if(indexPath.row != 2)
    {
        UIImageView *line = [[UIImageView alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
            line.frame=CGRectMake(0, 79, 768, 1);
        else
            line.frame=CGRectMake(0, 59, 600, 1);
        
        line.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        [cell addSubview:line];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UINavigation Button Action
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight
{
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%ld",(long)textField.tag);
    if(textField.tag==1)
        _val_str=textField.text;
    else if(textField.tag==2)
        _val_str1=textField.text;
    
    return YES;
}

#pragma mark - "Save" Button Action
- (IBAction)btnActionSave:(id)sender
{
    [self.view endEditing:YES];
    
    BOOL isSuccess;
  
    if([_navClass isEqualToString:@"Calories to Burn"])
    {
        if([self verify])
        {
            isSuccess=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:_val_str withColumnNm:@"total_burned"];
         }
     }
    else if([_navClass isEqualToString:@"Weight"])
    {
    if([self verify])
    {
     NSString *weightVal=[NSString stringWithFormat:@"%@ lbs",_val_str];
     BOOL isSuccess1=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:weightVal withColumnNm:@"weight"];

    if(isSuccess1)
        isSuccess=[userProfileObj updateUserProfile:selectedUserProfileID withIntakeVal:weightVal withColumnNm:@"weight"];
        }
    }
    else if([_navClass isEqualToString:@"Sleep"])
    {
        if([self verify])
        {
        NSString *sleepVal=[NSString stringWithFormat:@"%@ hrs",_val_str];
        isSuccess=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:sleepVal withColumnNm:@"sleep"];
        }
    }
    else if([_navClass isEqualToString:@"Water"])
    {
         if([self verify])
         {
         NSString *waterVal=[NSString stringWithFormat:@"%@ cups",_val_str];
         isSuccess=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:waterVal withColumnNm:@"water"];
        }
    }

    else if([_navClass isEqualToString:@"Blood Pressure"])
    {
        if([self verify])
        {
        isSuccess=[userCalObj updateUserBP:selectedUserProfileID withsysVal:_val_str  withdiaVal:_val_str1];
        }
    }

    if(isSuccess)
     [self createAlertView:@"Mesupro" withAlertMessage:@"Your changes have been saved successfully" withAlertTag:0];
}

#pragma mark - "Cancel" Button Action
- (IBAction)btnActionCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - verify Method
-(BOOL)verify
{
    BOOL success = true;
    
    if([_navClass isEqualToString:@"Calories to Burn"])
    {
        if([self isValidNumeric:_val_str]==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(_val_str.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Calories to Burn value" withAlertTag:100];
            return false;
        }
    }
    
    else if([_navClass isEqualToString:@"Weight"])
    {
        if([self isValidNumeric:_val_str]==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(_val_str.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Weight value" withAlertTag:100];
            return false;
        }
    }
    
    else if([_navClass isEqualToString:@"Sleep"])
    {
        if([self isValidNumeric:_val_str]==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(_val_str.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Sleep value" withAlertTag:100];
            return false;
        }
    }

    else if([_navClass isEqualToString:@"Water"])
    {
        if([self isValidNumeric:_val_str]==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(_val_str.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Water value" withAlertTag:100];
            return false;
        }
    }

    else if([_navClass isEqualToString:@"Blood Pressure"])
    {
        NSScanner *scannerSys = [NSScanner scannerWithString:_val_str];
        BOOL isNumericSys = [scannerSys scanInteger:NULL] && [scannerSys isAtEnd];
        
        NSScanner *scannerDia = [NSScanner scannerWithString:_val_str1];
        BOOL isNumericDia = [scannerDia scanInteger:NULL] && [scannerDia isAtEnd];
        
        if(isNumericSys==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(isNumericDia==NO)
        {
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
            return false;
        }
        if(_val_str.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter BP SYS value" withAlertTag:100];
            return false;
        }
        if(_val_str1.length <=0){
            
            [self createAlertView:@"Measupro" withAlertMessage:@"Please enter BP DIA value" withAlertTag:100];
            return false;
        }

    }
    return success;
}

@end
