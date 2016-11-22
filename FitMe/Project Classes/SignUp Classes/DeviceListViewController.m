//
//  DeviceListViewController.m
//  FitMe
//
//  Created by Debasish on 10/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "DeviceListViewController.h"
#import "ProfileTableViewCell.h"
#import "DeviceSynchViewController.h"
#import "SettingsViewController.h"
#import "Constant.h"
#import "DeviceLog.h"
@interface DeviceListViewController ()
{
    NSMutableArray *deviceArr,*deviceImgArr,*
    deviceStatusArr;
    __weak IBOutlet UIButton *btnUserProfileImg;
    __weak IBOutlet UILabel *lblUserNm;
     NSString *selectedUserProfileID;
    NSUserDefaults *user_defaults;
    
    __weak IBOutlet UILabel *synclbl;
     DeviceLog *DeviceLogObj;
}
@end

@implementation DeviceListViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DeviceLogObj=[[DeviceLog alloc]init];
    deviceStatusArr=[[NSMutableArray alloc]init];
    
    if([self isIphoneSixPlus])
    {
     lblUserNm.font=[UIFont fontWithName:@"SinkinSans-400Regular" size:24];
     synclbl.font=[UIFont fontWithName:@"SinkinSans-300Light" size:16];
    }
    user_defaults = User_Defaults;
    
    selectedUserProfileID=[user_defaults valueForKey:@"selectedUserProfileID"];
    
    lblUserNm.text=_userProfileObj.full_name;
    UIImage *userImg=[self getImage];
    if ([_userProfileObj.gender isEqualToString:@"Male"])
    {
        [btnUserProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Male@3x.png"] forState:UIControlStateNormal];
    }
    else
    {
         [btnUserProfileImg setBackgroundImage:[UIImage imageNamed:@"User_Female@3x.png"] forState:UIControlStateNormal];
    }
    
    if(userImg)
        [btnUserProfileImg setBackgroundImage:userImg forState:UIControlStateNormal];

    
  
    deviceArr = [[NSMutableArray alloc] initWithObjects:@"Kitchen Scale",nil];
    
     deviceImgArr= [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"kitchen_scale.png"],nil];

    deviceStatusArr=[DeviceLogObj getAllDeviceDataLog:@"" withUserProfileID:selectedUserProfileID];

     [self createNavigationView:@"Devices"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    APP_CTRL.CurrentControllerObj = self;
    
}
- (void)didReceiveMemoryWarning
{
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
    return deviceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (thisDeviceFamily() == iPad)
    {
         return 90;
    }
    else
    {
         return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell *cell=nil;
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
        cell.lblDeviceStatus.text=@"Not Connected";
    
    
    if([self isIphoneSixPlus]){
         cell.lblDeviceNm.font=[UIFont fontWithName:@"SinkinSans-300Light" size:16];
        cell.lblDeviceStatus.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:15];
    }
    else if (thisDeviceFamily() == iPad)
    {
        cell.lblDeviceNm.font=[UIFont fontWithName:@"SinkinSans-300Light" size:20];
        cell.lblDeviceStatus.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:18];
    }

    cell.imgVw.image=[deviceImgArr objectAtIndex:indexPath.row ];
    cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;

    cell.imgVw.layer.borderColor=[[UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0] CGColor];
    cell.imgVw.layer.borderWidth=1;
    
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
    if(indexPath.row !=deviceArr.count)
    {
        UIImageView *line = [[UIImageView alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
            line.frame=CGRectMake(0, 89, 768, 1);
        else
            line.frame=CGRectMake(0, 69, 600, 1);
        
        line.backgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
       
        [cell addSubview:line];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceSynchViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSynchViewController"];
    mVerificationViewController.userProfileObj=_userProfileObj;
    mVerificationViewController.deviceNm=[deviceArr objectAtIndex:indexPath.row];
    mVerificationViewController.deviceImg=[deviceImgArr objectAtIndex:indexPath.row];
    if(deviceStatusArr.count>0)
    {
    mVerificationViewController.device_status=[[deviceStatusArr objectAtIndex:indexPath.row ]objectForKey:@"device_status"] ;
    }
    [self.navigationController pushViewController:mVerificationViewController animated:YES];

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
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
