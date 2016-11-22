//
//  ProfileViewController.m
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "UserListViewController.h"
#import "DejalActivityView.h"
#import "Utility.h"
#import "SettingsViewController.h"
#import "DeviceSynchViewController.h"
#import "DeviceLog.h"

@interface ProfileViewController ()
{
    NSMutableArray *userArr,*deviceArr,*deviceImgArr,*
    deviceStatusArr;
    User *mUser;
    Profile *mProfile;
    NSString *selectedUserProfileID;
    NSUserDefaults *user_defaults;
    UserProfileDetails *userProfileObj;
     DeviceLog *DeviceLogObj;
}

@end

@implementation ProfileViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    DeviceLogObj=[[DeviceLog alloc]init];
    deviceStatusArr=[[NSMutableArray alloc]init];
    [self callNavigate];
//    mUser = [[Utility sharedManager] retriveUserDetailsFromDefault];
//    mProfile = [[Utility sharedManager] retriveProfileDetailsFromDefault];
    
      [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
       [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        APP_CTRL.CurrentControllerObj = self;
        
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.profileNavigation=self.navigationController;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]!=NULL && [[[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"] isEqualToString:@"1"]) {
        [appDelegate.objUserInfoControl  removeFromParentViewController];
        [appDelegate.objUserInfoControl.view removeFromSuperview];
    }
 
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]==NULL)
    {
        [self createTitleNavigationView:@"User Info"];
    }
    else{
        [self createTitleNavigationView:@"Profile"];
    }
    
    user_defaults = User_Defaults;
    
    selectedUserProfileID=[user_defaults valueForKey:@"selectedUserProfileID"];
    
    _userProfileDetails=[[UserProfileDetails alloc]init];
    NSMutableArray *usersArr=[_userProfileDetails getUserProfileDetails:selectedUserProfileID];
    if(usersArr.count>0)
    {
        userArr = [[NSMutableArray alloc] initWithObjects:@"Birthday",@"Height",@"Activity Level",@"Weight",@"Gender",@"Daily Calorie Intake",nil];
        
     
        deviceArr = [[NSMutableArray alloc] initWithObjects:@"Kitchen Scale",nil];
        for(int i=0;i<deviceArr.count;i++)
        {
            DeviceLogObj.log_user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
            DeviceLogObj.log_user_profile_id=selectedUserProfileID;
            DeviceLogObj.deviceType=[deviceArr objectAtIndex:i];
            DeviceLogObj.deviceStatus=@"0";
            DeviceLogObj.log_date_added=[self getCurrentDateTime];
            DeviceLogObj.log_log_time=[self getCurrentDateTime];
            
            [DeviceLogObj saveUserDeviceDataLog];
        }
      
        deviceImgArr= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"kitchen_scale.png"],nil];

       
        deviceStatusArr=[DeviceLogObj getAllDeviceDataLog:@"" withUserProfileID:selectedUserProfileID];
        NSLog(@"deviceStatusArr=%@",deviceStatusArr);

        if (APP_CTRL.BleManagerGlobal == NULL)
        {
            for(int j=0;j<deviceArr.count;j++)
            {
              [DeviceLogObj updateDeviceData:[deviceArr objectAtIndex:j] withStatusVal:@"0" withLogDate:@"" withUserProfileID:selectedUserProfileID];
            }
            if (deviceStatusArr.count>0) {
                for (int i = 0; i<deviceStatusArr.count; i++) {
                    NSMutableDictionary *tempdic = [deviceStatusArr objectAtIndex:i];
                    [tempdic setObject:@"0" forKey:@"device_status"];
                    [deviceStatusArr replaceObjectAtIndex:i withObject:tempdic];
                }
            }
        }
        _userProfileDetails=[usersArr objectAtIndex:0];
        
//        _userProfileTblVw.delegate=self;
//        _userProfileTblVw.dataSource=self; 
//        [_userProfileTblVw reloadData];
        
        _lblUserNm.text=_userProfileDetails.full_name;
        
        _deviceTblVw.delegate=self;
        _deviceTblVw.dataSource=self;
        [_deviceTblVw reloadData];
        
        UIImage *userImg=[self getImage];
        if ([self.userProfileDetails.gender isEqualToString:@"Male"])
        {
            [_btnProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Male@3x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Female@3x.png"] forState:UIControlStateNormal];
        }
        
        /*if(![[user_defaults valueForKey:@"selectedUserProfileImage"] isEqualToString:@""])
        {
            NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[user_defaults valueForKey:@"selectedUserProfileImage"]]];
            userImg = [[UIImage alloc] initWithData:receivedData] ;
        }*/

        if(userImg)
            [_btnProfileImg setBackgroundImage:userImg forState:UIControlStateNormal];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - callNavigate Method
-(void)callNavigate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]==NULL)
    {
        
        appDelegate.tabBarController.vwHome.userInteractionEnabled=NO;
        appDelegate.tabBarController.vwHelp.userInteractionEnabled=NO;
        
        appDelegate.tabBarController.btnTabHome.alpha=0.3;
        appDelegate.tabBarController.btnTabHelp.alpha=0.3;
        
        [self createTitleNavigationView:@"User Info"];
        UserInfoViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        mVerificationViewController.isEditProfile=NO;
        appDelegate.objUserInfoControl = mVerificationViewController;
        [self addChildViewController:mVerificationViewController];
        [self.view addSubview:mVerificationViewController.view];
    }
}


#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
         if(APP_CTRL.isShowDevice)
                return deviceArr.count;
        else
            return 0;
    }
    else if (section==1)
        return userArr.count;
  /*  if(tableView.tag==1)
    {
        return deviceArr.count;
    }
    else  if(tableView.tag==2)
    {
        return userArr.count;
    }*/
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.section==0)
         return 70;
    else if (indexPath.section==1)
        return 44;
   /* if(tableView.tag==1)
    {
        return 70;
    }
    else  if(tableView.tag==2)
    {
        return 44;
    }*/
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell *cell=nil;
    if(indexPath.section==0)
    {
        NSArray *nib=nil;
        
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"ProfileDeviceTableViewCell" owner:self options:nil];
        
        cell=(ProfileTableViewCell*)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.lblDeviceNm.text=[deviceArr objectAtIndex:indexPath.row ];
      
        if(deviceStatusArr.count>0)
        {
        if([[[deviceStatusArr objectAtIndex:indexPath.row ]objectForKey:@"device_status"] isEqualToString:@"0"])
            cell.lblDeviceStatus.text=@"Not Connected";
        else if([[[deviceStatusArr objectAtIndex:indexPath.row ]objectForKey:@"device_status"] isEqualToString:@"1"])
            cell.lblDeviceStatus.text=@"Synced";
        }
        else
        {
         cell.lblDeviceStatus.text=@"Not Connected";
        }
        
        cell.imgVw.image=[deviceImgArr objectAtIndex:indexPath.row ];
        cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.imgVw.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
        cell.imgVw.layer.borderWidth=1;

       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row==0){
            
            UIImageView *line = [[UIImageView alloc] init];
            
            Devicefamily family = thisDeviceFamily();
            if (family == iPad)
                line.frame=CGRectMake(0, 0, 768, 1);
            else
                line.frame=CGRectMake(0, 0, 600, 1);
            
            line.backgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
            
            [cell addSubview:line];
            
            
        }
        
        UIImageView *line = [[UIImageView alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
            line.frame=CGRectMake(0, 69, 768, 1);
        else
            line.frame=CGRectMake(0, 69, 600, 1);
        
        line.backgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
        
        [cell addSubview:line];
    }

    else if(indexPath.section==1)
    {
        NSArray *nib=nil;
        
        nib=[[ NSBundle  mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil];
        
        cell=(ProfileTableViewCell*)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.lblName.text=[userArr objectAtIndex:indexPath.row ];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.lblVal.text=self.userProfileDetails.dob;
            }
                break;
            case 1:
            {
                cell.lblVal.text=[NSString stringWithFormat:@"%@'%@\"",self.userProfileDetails.height_ft,self.userProfileDetails.height_in];
            }
                break;
            case 2:
            {
                cell.lblVal.text=self.userProfileDetails.activity_level;
            }
                break;
            case 3:
            {
                cell.lblVal.text=self.userProfileDetails.weight;
            }
                break;

            case 4:
            {
                cell.lblVal.text=self.userProfileDetails.gender;
            }
                break;

            case 5:
            {
                cell.lblVal.text=[NSString stringWithFormat:@"%@ cal",self.userProfileDetails.daily_calorie_intake];
            }
                break;

            default:
                break;
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
     DeviceSynchViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSynchViewController"];
    mVerificationViewController.userProfileObj=self.userProfileDetails;
    mVerificationViewController.deviceNm=[deviceArr objectAtIndex:indexPath.row];
    mVerificationViewController.deviceImg=[deviceImgArr objectAtIndex:indexPath.row];
    if(deviceStatusArr.count>0)
    {
    mVerificationViewController.device_status=[[deviceStatusArr objectAtIndex:indexPath.row ]objectForKey:@"device_status"] ;
    }
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - "Log Out" Button Action
- (IBAction)btnActionLogOut:(id)sender
{
   /* if([self isNetworkAvailable]==NO){
        [self createAlertView:@"Alert" withAlertMessage:ConnectionUnavailable withAlertTag:3];
    }
    else
    {
        [self logoutServerConnection];
    }*/
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"currentState"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UserListViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
 
}

#pragma mark - "Edit Profile" Button Action
- (IBAction)btnActionEditProfile:(id)sender
{
    UserInfoViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    mVerificationViewController.isEditProfile=YES;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Log Out Server Connection Method
-(void)logoutServerConnection
{
    self.view.userInteractionEnabled = NO;
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] logout:mUser.useraccess_key];
    //[self performSelector:@selector(myTask) withObject:nil afterDelay:15.0];
}

#pragma mark - Server Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if ([result isKindOfClass:[NSError class]])
    {
        NSError *error=(NSError *)result;
        [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
        
        return;
    }
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        if([[dict valueForKey:@"status"] isEqualToString:@"false"])
        {
          //  [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
            
            [[Utility sharedManager] setUserLoginEnable:NO];
            [[Utility sharedManager] clearUserValues];
            
            [user_defaults setObject:@"" forKey:@"RemUserNm"];
            [user_defaults setObject:@"" forKey:@"RemPassword"];
            [user_defaults synchronize];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //    appDelegate.window.rootViewController = lvc;
            [appDelegate.navController popToRootViewControllerAnimated:YES];

        }
        else{
            /*User *mUser = [User new];
            if([[dict valueForKey:@"system_info"] valueForKey:@"post_data"]!=nil){
                if([[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"email_address"]!=nil){
                    [mUser setEmail:[[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"email_address"]];
                }
                if([[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"password"]!=nil){
                    [mUser setPassWord:[[[dict valueForKey:@"system_info"] valueForKey:@"post_data"] valueForKey:@"password"]];
                }
            }
            
            [mUser setUseraccess_key:[dict valueForKey:@"access_key"]];
            [[Utility sharedManager]saveUserDetailsTouserDeafult:mUser];*/
      
          //  [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
            [[Utility sharedManager] setUserLoginEnable:NO];
            [[Utility sharedManager] clearUserValues];
            
            [user_defaults setObject:@"" forKey:@"RemUserNm"];
            [user_defaults setObject:@"" forKey:@"RemPassword"];
            [user_defaults synchronize];

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //    appDelegate.window.rootViewController = lvc;
            [appDelegate.navController popToRootViewControllerAnimated:YES];
        }
    }
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

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"ButtonIndex -- %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //For Camera Selection
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
            //For Gallery Selection
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
            imagePicker.allowsEditing = NO;
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
    UIImage *image,*image1;
    
    if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary){
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        image=[Utility imageWithImage:image scaledToWidth:200];
        //  [image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera){
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"--height=%f,width=%f",image.size.height,image.size.width);
        image=[Utility imageWithImage:image scaledToWidth:200];
        NSLog(@"--height=%f,width=%f",image1.size.height,image1.size.width);
        //[image resizedImage:CGSizeMake(250, 200) interpolationQuality:kCGInterpolationHigh];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //    [_btnProfileImg setImage:image forState:UIControlStateNormal];
    //    _btnProfileImg.contentMode = UIViewContentModeScaleToFill;
    _imgVwProfile.image=image;
    _imgVwProfile.contentMode = UIViewContentModeScaleAspectFit;
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Select Profile Image Button Action
- (IBAction)btnActionselectProfileImg:(id)sender
{
//    sheetImages = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Gallery", nil];
//    [sheetImages showInView:self.view];
    
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


@end
