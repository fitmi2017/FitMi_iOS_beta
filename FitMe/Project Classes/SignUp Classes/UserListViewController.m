//
//  UserListViewController.m
//  FitMe
//
//  Created by Debasish on 31/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UserListViewController.h"
#import "ProfileTableViewCell.h"
#import "UserInfoViewController.h"
#import "DeviceListViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "UserProfileDetails.h"
@interface UserListViewController ()
{
    UserProfileDetails *userProfileObj;
    NSString *selectedUserProfileID;
    NSUserDefaults *defaults;
    NSInteger selectedUserIndex;
    int selectedIndex;
    BOOL isDelete;
}
@end

@implementation UserListViewController

@synthesize usersArr;

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isDelete=NO;
 
    [self createTitleNavigationView:@"Users"];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
        APP_CTRL.CurrentControllerObj = self;
    
    userProfileObj=[[UserProfileDetails alloc]init];
    usersArr=[userProfileObj getUserProfileList];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    if(usersArr.count>0)
    {
        for(int i=0;i<usersArr.count;i++)
        {
            userProfileObj =  [usersArr objectAtIndex:i];
            NSString * tempID =userProfileObj.user_profile_id;
            if([tempID compare:selectedUserProfileID]==NSOrderedSame)
            {
                selectedUserIndex = i;
                break;
            }
         }
        
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        [_tblVw reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tblVw setEditing:NO];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return usersArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell *cell=nil;
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
    
    cell=(ProfileTableViewCell*)[nib objectAtIndex:0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    userProfileObj=[usersArr objectAtIndex:indexPath.row];
    cell.lblDeviceNm.text=userProfileObj.full_name;
    
     if(APP_CTRL.isShowDevice)
         cell.btnArrow.hidden=NO;
    else
        cell.btnArrow.hidden=YES;
    
    if([self isIphoneSixPlus]){
        cell.lblDeviceNm.font=[UIFont fontWithName:@"SinkinSans-200XLight" size:22];
    }

    UIImage *userImg=[self getImage:userProfileObj.user_profile_id];
    if ([userProfileObj.gender isEqualToString:@"Male"])
    {
        cell.imgVw.image=[UIImage imageNamed:@"User_Male@3x.png"];
    }
    else
    {
      cell.imgVw.image=[UIImage imageNamed:@"User_Female@3x.png"];
    }
    
    if(userImg)
        cell.imgVw.image=userImg;
    
    cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    if(selectedUserIndex==indexPath.row)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    }
    else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }

    if(indexPath.row !=usersArr.count)
    {
        UIImageView *line = [[UIImageView alloc] init];
        
        Devicefamily family = thisDeviceFamily();
        if (family == iPad)
            line.frame=CGRectMake(0, 69, 768, 1);
        else
            line.frame=CGRectMake(0, 69, 600, 1);
        
        line.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
        [cell addSubview:line];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUserIndex=indexPath.row;
    
    userProfileObj=[usersArr objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:userProfileObj.user_profile_id forKey:@"selectedUserProfileID"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    [tableView reloadData];
    
     if(APP_CTRL.isShowDevice)
     {
    DeviceListViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    mVerificationViewController.userProfileObj=userProfileObj;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
     }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        selectedUserIndex=indexPath.row;
        if(!isDelete)
        {
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Mesupro"
                                                             message:@"Are you sure to delete this User?"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Cancel",@"OK", nil];
            myAlert.tag=1001;
            [myAlert show];
    }
    }
}

 #pragma mark - callReload Method
-(void)callReload
{
    usersArr=[userProfileObj getUserProfileList];
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    if(usersArr.count>0)
    {
        for(int i=0;i<usersArr.count;i++)
        {
            userProfileObj =  [usersArr objectAtIndex:i];
            NSString * tempID =userProfileObj.user_profile_id;
            if([tempID compare:selectedUserProfileID]==NSOrderedSame)
            {
                selectedUserIndex = i;
                break;
            }
        }
        _tblVw.delegate=self;
        _tblVw.dataSource=self;
        [_tblVw reloadData];
        
    }
    
    isDelete=NO;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        if(buttonIndex==1)
        {
            isDelete=YES;
            
            userProfileObj =  [usersArr objectAtIndex:selectedUserIndex];
            NSString * tempID =userProfileObj.user_profile_id;

            BOOL isSuccess=[userProfileObj deleteUserData:tempID];
            
            if(isSuccess)
            {
                [self performSelector:@selector(callReload) withObject:nil afterDelay:1.0];
                
            }

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"%@",scrollView.superview.superview);
    //  NSLog(@"Scrolll: %@",NSStringFromCGPoint(scrollView.contentOffset));
    // if (scrollView == videoListingTable) {
   /* if (scrollView.contentOffset.y == 0) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                scrollView.contentOffset = CGPointMake(0, 40);
            } completion:NULL];
        else
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                scrollView.contentOffset = CGPointMake(0, 35);
            } completion:NULL];
    }*/
}

#pragma mark - "Add New User" Button Action
- (IBAction)btnActionAddNewUser:(id)sender
{
    UserInfoViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    mVerificationViewController.isEditProfile=NO;
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
    
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

#pragma mark - getImage Method
- (UIImage*)getImage:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *ImageNm=[NSString stringWithFormat:@"savedImage_%@.png",userID];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:ImageNm];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

@end
