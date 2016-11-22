//
//  ViewController.m
//  FitMe
//
//  Created by Debasish on 24/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//
#import "SignUpViewController.h"
#import "ViewController.h"
#import "Constant.h"
#import "MHCustomTabBarController.h"
#import "Global.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "UserProfile.h"
#import "UserProfileDetails.h"
#import "UserCalDetails.h"
#import "DeviceLog.h"

@interface ViewController ()
{
    NSUserDefaults *user_defaults;
       UserProfileDetails *userProfileObj;
    DeviceLog *DeviceLogObj;
    NSMutableArray *deviceArr;
}
- (IBAction)btnActionSignUp:(id)sender;

@end

@implementation ViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _connectType=@"";
    
    _isChecked=NO;
    
     user_defaults = User_Defaults;
    
    deviceArr = [[NSMutableArray alloc] initWithObjects:@"BloodPressure Monitor",@"Kitchen Scale",nil];

   if([[self GetIphoneModelVersion]isEqualToString:@"4"])
   {
       NSLog(@"IPHONE4S");
       self.txtFldUserNm.translatesAutoresizingMaskIntoConstraints=YES;
       self.txtFldPass.translatesAutoresizingMaskIntoConstraints=YES;
       self.txtFldUserNm.frame=CGRectMake(self.txtFldUserNm.frame.origin.x, 120.0, 280.0, self.txtFldUserNm.frame.size.height);
       self.txtFldPass.frame=CGRectMake(self.txtFldPass.frame.origin.x, 190.0, 280.0, self.txtFldPass.frame.size.height);

       _lblRemMe.translatesAutoresizingMaskIntoConstraints=YES;
       _lblForgotPass.translatesAutoresizingMaskIntoConstraints=YES;
       
       _lblRemMe.frame=CGRectMake(_lblRemMe.frame.origin.x, 285.0, 100.0, _lblRemMe.frame.size.height);
       _lblForgotPass.frame=CGRectMake(170.0, 285.0, 150.0, _lblForgotPass.frame.size.height);
    }
    else if([[self GetIphoneModelVersion]isEqualToString:@"5"])
    {
         _lblRemMe.translatesAutoresizingMaskIntoConstraints=YES;
        _lblForgotPass.translatesAutoresizingMaskIntoConstraints=YES;

        _lblRemMe.frame=CGRectMake(_lblRemMe.frame.origin.x, _lblRemMe.frame.origin.y, 100.0, _lblRemMe.frame.size.height);
        _lblForgotPass.frame=CGRectMake(170.0, _lblForgotPass.frame.origin.y, 150.0, _lblForgotPass.frame.size.height);
        
//        _lblRemMe.adjustsFontSizeToFitWidth=YES;
//        _lblRemMe.minimumScaleFactor=0.8;
//        _lblForgotPass.adjustsFontSizeToFitWidth=YES;
//        _lblForgotPass.minimumScaleFactor=0.8;
    }
    
    if(!([[user_defaults stringForKey:@"RemUserNm"] isEqualToString:@""]))
    {
        self.txtFldUserNm.text=[user_defaults stringForKey:@"RemUserNm"];
    }
    
    if(!([[user_defaults stringForKey:@"RemPassword"] isEqualToString:@""]))
    {
        self.txtFldPass.text=[user_defaults stringForKey:@"RemPassword"];
    }

    if ([_txtFldUserNm respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        _txtFldUserNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        _txtFldPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

    }
    else
    {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        
    }
   
    
    UIView *paddingVwUserNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    _txtFldUserNm.leftView = paddingVwUserNm;
    _txtFldUserNm.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVwPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    _txtFldPass.leftView = paddingVwPass;
    _txtFldPass.leftViewMode = UITextFieldViewModeAlways;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    APP_CTRL.CurrentControllerObj = self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       appDelegate.navController=self.navigationController;
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldUserNm) {
        [_txtFldUserNm resignFirstResponder];
        [_txtFldPass becomeFirstResponder];
    }
    else if (textField ==_txtFldPass){
        [_txtFldPass resignFirstResponder];
        if([[UIScreen mainScreen] bounds].size.height==480){
            [self moveDownViewFrame:100];
        }
        else if([[UIScreen mainScreen] bounds].size.height==568){
            [self moveDownViewFrame:80];
        }
        
        id sender;
        [self btnActionLogin:sender];
    }
     else if (textField ==self.txtfldPopEmail)
     {
         [self.txtfldPopEmail resignFirstResponder];
     }
    return YES;
}

#pragma mark - "SignUp" Button Action
- (IBAction)btnActionSignUp:(id)sender
{
    SignUpViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - "Remember Me Check" Button Action
- (IBAction)btnActionChk:(id)sender
{
    if(!_isChecked)
    {
         [_btnChk setImage:[UIImage imageNamed:@"checkIconSelected"]  forState:UIControlStateNormal];
        _isChecked=YES;
        
        [user_defaults setObject:self.txtFldUserNm.text forKey:@"RemUserNm"];
        [user_defaults setObject:self.txtFldPass.text forKey:@"RemPassword"];
        [user_defaults synchronize];
    }
    else
    {
        [_btnChk setImage:[UIImage imageNamed:@"checkIcon"]  forState:UIControlStateNormal];
        _isChecked=NO;
        
        [user_defaults setObject:@"" forKey:@"RemUserNm"];
        [user_defaults setObject:@"" forKey:@"RemPassword"];
        [user_defaults synchronize];
    }

}

#pragma mark - "Forgot Password" Button Action
- (IBAction)btnActionForgotPass:(id)sender
{
    //UIAlert for iOS 8.0 & greater version
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"Please enter your email address to retrieve password" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [av addTextFieldWithConfigurationHandler:nil];
        ((UITextField *)(av.textFields[0])).placeholder = @"Enter email address";
        ((UITextField *)(av.textFields[0])).keyboardType = UIKeyboardTypeEmailAddress;
        ((UITextField *)(av.textFields[0])).returnKeyType=UIReturnKeyDone;
        ((UITextField *)(av.textFields[0])).delegate=self;
        ((UITextField *)(av.textFields[0])).textColor=[UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        if ([((UITextField *)(av.textFields[0])) respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
            ((UITextField *)(av.textFields[0])).attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        }
        UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        
        UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
            
            
            BOOL isEmailValid=[self validateEmail:((UITextField *)(av.textFields[0])).text];
            if(isEmailValid==NO)
            {
                [self createAlertView:@"Measupro" withAlertMessage:@"Please provide valid Email" withAlertTag:100];
            }
            else
            {
                 [self forgetPwdServerConnection:((UITextField *)(av.textFields[0])).text];
            }

        }];
        [av addAction:actionCancel];
        [av addAction:actionOk];
        
        [self presentViewController:av animated:YES completion:NULL];
    }
    
    //UIAlert for iOS 8.0 lower version
    else
    {

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Please enter your email address to retrieve password" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    av.tag=1001;
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
   
    UITextField *textField = [av textFieldAtIndex:0];
    textField.placeholder=@"Enter email address";
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeyDone;
    textField.delegate=self;
    textField.textColor=[UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    }
     else
    {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    

//    [av setValue:v  forKey:@"accessoryView"];
    [av show];
    }
}

#pragma mark - "Login" Button Action
- (IBAction)btnActionLogin:(id)sender
{
    if([self verify])
    {
        if([self isNetworkAvailable]==NO){
            [self createAlertView:@"Alert" withAlertMessage:ConnectionUnavailable withAlertTag:3];
        }
        else
        {
            UserProfile *userObj=[[UserProfile alloc]init];
            NSMutableArray *userCredentials=[userObj loginCheck:_txtFldUserNm.text password:_txtFldPass.text];
            
            if([userCredentials count]==0)
                [self loginServerConnection];
            else
            {
                 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                MHCustomTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"customTabbar"];
                appDelegate.tabBarController=controller;
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            
        }
    }
    

}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==1001)
    {
        BOOL isEmailValid=[self validateEmail:[alertView textFieldAtIndex:0].text];
        NSLog(@"%ld",(long)buttonIndex);
               NSLog(@"1 %@", [alertView textFieldAtIndex:0].text);
        
        
        if(buttonIndex==1)
        {
            if(isEmailValid==NO)
            {
                [self createAlertView:@"Measupro" withAlertMessage:@"Please provide valid Email" withAlertTag:100];
            }
            else
            {
                [self forgetPwdServerConnection:[alertView textFieldAtIndex:0].text];
            }
        }
    }
}

#pragma mark - verify Method
-(BOOL)verify
{
    
    BOOL success = true;
    
    BOOL isEmailValid=[self validateEmail:_txtFldUserNm.text];

    _txtFldUserNm.text=[ _txtFldUserNm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    _txtFldPass.text=[ _txtFldPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(_txtFldUserNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide User name" withAlertTag:100];
        return false;
        
    }
  
    if(isEmailValid==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide valid Email" withAlertTag:100];
        return false;
    }

    if(_txtFldPass.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Password" withAlertTag:100];
        return false;
        
    }
    return success;
}

#pragma mark - Touch Delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if([[UIScreen mainScreen] bounds].size.height==480)
    {
        [self moveDownViewFrame:100];
    }
    else if([[UIScreen mainScreen] bounds].size.height==568)
    {
        [self moveDownViewFrame:80];
    }
}

/********************************************//*!
*  @brief This function is used for Login Webservice.
***********************************************/

#pragma mark - loginServerConnection Method
-(void)loginServerConnection
{
    self.view.userInteractionEnabled = NO;
    _connectType=@"login";
  [DejalBezelActivityView activityViewForView:self.view];
     [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] login:_txtFldUserNm.text Password:_txtFldPass.text];
}

#pragma mark - forgetPwdServerConnection Method
-(void)forgetPwdServerConnection:(NSString *)strEmail
{
    self.view.userInteractionEnabled = NO;
    _connectType=@"forgotPWD";
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] forgetPassword:strEmail];
}

#pragma mark - forgetPwdServerConnection Method
-(void)getProfileImageServerConnection
{
    self.view.userInteractionEnabled = NO;
    _connectType=@"getProfileImage";
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] getProfileImage:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] AccessKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"]];
}

#pragma mark - Server Connection Delegate

-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
   
    NSLog(@"Response==%@",result);
    if ([_connectType isEqualToString:@"login"])
    {
        
        if ([result isKindOfClass:[NSError class]]) {
            NSError *error=(NSError *)result;
            [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
            
            return;
        }
        if ([result isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)result;
            if([[dict valueForKey:@"status"] isEqualToString:@"false"])
            {
                [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
                [DejalBezelActivityView removeViewAnimated:YES];

            }
            else{
                User *mUser = [User new];
                if([[dict valueForKey:@"system_info"] valueForKey:@"post_data"]!=nil){
                    if([[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"email_address"]!=nil){
                        [mUser setEmail:[[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"email_address"]];
                    }
                    if([[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"password"]!=nil){
                        [mUser setPassWord:[[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"password"]];
                    }
                }
                
                [mUser setUseraccess_key:[dict valueForKey:@"access_key"]];
                [[Utility sharedManager]saveUserDetailsTouserDeafult:mUser];
                [[Utility sharedManager] setUserLoginEnable:YES];
                /*  if(_btnSaveCredential_Login.on){
                 [[Utility sharedManager] setUserLoginEnable:YES];
                 }
                 else{
                 [[Utility sharedManager] setUserLoginEnable:NO];
                 }*/
                
                [user_defaults setObject:@"isLoginTab" forKey:@"TabBarNavStatus"];
                [user_defaults setObject:[dict valueForKey:@"users_id"] forKey:@"user_id"];
                [user_defaults setObject:[dict valueForKey:@"access_key"] forKey:@"user_accessKey"];
                [user_defaults synchronize];
                NSLog(@"userid=====%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);
                /////////////////  update local db /////////
                
                UserProfile *userObj=[[UserProfile alloc]init];
                
                userObj.emailString=_txtFldUserNm.text;
                userObj.passwordString=_txtFldPass.text;
                userObj.userID=[dict valueForKey:@"users_id"];
                [userObj saveUserData];
                /////////////////////////////////////////////
                
        
                [self performSelector:@selector(callGetUserProfile) withObject:nil afterDelay:1.0];
               
                
               /* AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                MHCustomTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"customTabbar"];
                appDelegate.tabBarController=controller;
                [self.navigationController pushViewController:controller animated:YES];*/
            }
        }

    }
    
   else if ([_connectType isEqualToString:@"forgotPWD"])
    {
        [DejalBezelActivityView removeViewAnimated:YES];

        if ([result isKindOfClass:[NSError class]]) {
            NSError *error=(NSError *)result;
            [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
            
            return;
        }
        if ([result isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)result;
            if([[dict valueForKey:@"status"] isEqualToString:@"false"])
            {
                [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
            }
            else
            {
                [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];

            }
        }
    }
    
    
   else if ([_connectType isEqualToString:@"getUserProfile"])
   {
       if ([result isKindOfClass:[NSError class]]) {
           NSError *error=(NSError *)result;
           [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
           
           return;
       }
       if ([result isKindOfClass:[NSDictionary class]]){
           NSDictionary *dict = (NSDictionary *)result;
           if([[dict valueForKey:@"status"] isEqualToString:@"false"])
           {
               [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
           }
           else
           {
                [self performSelector:@selector(getProfileImageServerConnection) withObject:nil afterDelay:1.0];
               userProfileObj=[[UserProfileDetails alloc]init];
               userProfileObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
                //userProfileObj.full_name=[NSString stringWithFormat:@"%@ %@",_txtFldUserFirstNm.text,_txtFldUserLastNm.text];//_txtFldUserNm.text;
               NSLog(@"%@",[[dict objectForKey:@"result" ]objectForKey:@"first_name"]);
            if(![[self chkNullInputinitWithString:[[dict objectForKey:@"result" ]objectForKey:@"first_name"]] isEqualToString:@""])
                userProfileObj.first_name=[[dict objectForKey:@"result" ] objectForKey:@"first_name"];
            else
               userProfileObj.first_name=@"";
               
           if(![[self chkNullInputinitWithString:[[dict objectForKey:@"result" ] objectForKey:@"last_name"]] isEqualToString:@""])
               userProfileObj.last_name=[[dict objectForKey:@"result" ] objectForKey:@"last_name"];
           else
               userProfileObj.last_name=@"";
               
               userProfileObj.full_name=[NSString stringWithFormat:@"%@ %@",userProfileObj.first_name,userProfileObj.last_name];
               userProfileObj.gender=[[dict objectForKey:@"result" ] objectForKey:@"gender"];
               userProfileObj.height_ft=[[dict objectForKey:@"result" ] objectForKey:@"height_ft"];
               userProfileObj.height_in=[[dict objectForKey:@"result" ] objectForKey:@"height_in"];
               userProfileObj.weight=[NSString stringWithFormat:@"%@ %@",[[dict objectForKey:@"result" ] objectForKey:@"weight"],[[dict objectForKey:@"result" ] objectForKey:@"weight_units"]];
               
               //TimeStamp to NSDate(String)
               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
               [formatter setDateFormat:@"MM/dd/yyyy"];
               NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[[dict objectForKey:@"result" ] objectForKey:@"date_of_birth"] intValue]];
               
               NSString *stringDate = [formatter stringFromDate:date1];

               userProfileObj.dob=stringDate;

             //  userProfileObj.dob=[[dict objectForKey:@"result" ] objectForKey:@"date_of_birth"];
               //userProfileObj.age=[NSString stringWithFormat:@"%d",years];
               userProfileObj.activity_level=[[dict objectForKey:@"result" ] objectForKey:@"activity_level"];
               userProfileObj.daily_calorie_intake=[[dict objectForKey:@"result" ] objectForKey:@"daily_calorie_intake"];
               //userProfileObj.image_path=[NSString stringWithContentsOfURL:localImageUrl encoding:0 error:nil];
//               userProfileObj.image_path=savedImagePath;
//               userProfileObj.cal_intake_status=currentState;
               
               int user_profile_id=[userProfileObj saveUserProfileDetails];
               
               for(int i=0;i<deviceArr.count;i++)
               {
                   DeviceLogObj.log_user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
                   DeviceLogObj.log_user_profile_id=[NSString stringWithFormat:@"%d",user_profile_id];
                   DeviceLogObj.deviceType=[deviceArr objectAtIndex:i];
                   DeviceLogObj.deviceStatus=@"0";
                   DeviceLogObj.log_date_added=[self getCurrentDateTime];
                   DeviceLogObj.log_log_time=[self getCurrentDateTime];
                   
                   [DeviceLogObj saveUserDeviceDataLog];
               }

               
               if(user_profile_id)
               {
                   UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
                   userCalObj.user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
                   NSLog(@"userProfileObj.user_id%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);
                   userCalObj.user_profile_id=[NSString stringWithFormat:@"%d",user_profile_id];
                   userCalObj.total_intake=[[dict objectForKey:@"result" ] objectForKey:@"daily_calorie_intake"];
                   //userCalObj.total_burned=[NSString stringWithFormat:@"%.0f",BurnedVal];
                   userCalObj.weight=[NSString stringWithFormat:@"%@ %@",[[dict objectForKey:@"result" ] objectForKey:@"weight"],[[dict objectForKey:@"result" ] objectForKey:@"weight_units"]];
                   userCalObj.sleep=@"7 hrs";
                   userCalObj.water=@"8 cups";
                   userCalObj.bp_sys=@"120";
                   userCalObj.bp_dia=@"80";
                   
                   [userCalObj saveUserCalorieDetails];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:userCalObj.user_profile_id forKey:@"selectedUserProfileID"];
                   [[NSUserDefaults standardUserDefaults]  synchronize];

                }
               
     
               [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"usersaved"];
               AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
               
               MHCustomTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"customTabbar"];
               appDelegate.tabBarController=controller;
               [self.navigationController pushViewController:controller animated:YES];
           }
       }
   }

    
    
   else if ([_connectType isEqualToString:@"getProfileImage"])
   {
       if ([result isKindOfClass:[NSError class]]) {
           NSError *error=(NSError *)result;
          // [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
           
           return;
       }
       if ([result isKindOfClass:[NSDictionary class]]){
           NSDictionary *dict = (NSDictionary *)result;
           if([[dict valueForKey:@"status"] isEqualToString:@"false"])
           {
               //[self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
           }
           else
           {
               NSLog(@"imgurl==%@",[dict valueForKey:@"imgurl"]);
               
               if(![[self chkNullInputinitWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"imgurl"]]] isEqualToString:@""])
               {
               [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:@"imgurl"] forKey:@"selectedUserProfileImage"];
                   
                   //Save Image
                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                   NSString *documentsDirectory = [paths objectAtIndex:0];
                   
                   NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%@.png",[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedUserProfileID"]];
                   NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];
                   
                   NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict valueForKey:@"imgurl"]]];
                  [imageData writeToFile:savedImagePath atomically:NO];
                   
                   [userProfileObj updateUserProfileImg:[[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedUserProfileID"]intValue] withImagePath:savedImagePath];
               }
               else
               {
                   [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"selectedUserProfileImage"];
                }
               [[NSUserDefaults standardUserDefaults]  synchronize];
           }
       }
   }
  }

-(void)callGetUserProfile
{
    self.view.userInteractionEnabled = NO;
    _connectType=@"getUserProfile";
 //   [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] getProfile:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] AccessKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_accessKey"]];
  
}




@end
