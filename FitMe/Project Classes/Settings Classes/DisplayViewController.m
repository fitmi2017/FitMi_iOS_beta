//
//  DisplayViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "DisplayViewController.h"
#import "SettingsTableViewCell.h"
#import "CalorieViewController.h"
#import "CalorieIntakeViewController.h"
#import "ChangePassViewController.h"
#import "UserInfoViewController.h"
#import "SettingsViewController.h"
@interface DisplayViewController ()
{
    NSMutableArray *arrTitle;
}

@end

@implementation DisplayViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
  
     [self createNavigationView:@"Settings"];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    if([_navClass isEqualToString:@"User Settings"])
    {
    _lblTop.text=@"User Settings";
    arrTitle= [[NSMutableArray alloc] initWithObjects:@"Change Password",@"Edit Profile",nil];
    }
   else if([_navClass isEqualToString:@"Goals"])
    {
      _lblTop.text=@"Goals";
        arrTitle= [[NSMutableArray alloc] initWithObjects:@"Daily Calorie Intake",@"Water",nil];
    }
    else if([_navClass isEqualToString:@"App Settings"])
    {
     _lblTop.text=@"App Settings";
    arrTitle= [[NSMutableArray alloc] initWithObjects:@"Display",nil];
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
    return arrTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (thisDeviceFamily() == iPad) {
        return 80;
    }
    else
    {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell=nil;
    NSArray *nib=nil;
    
    nib=[[ NSBundle  mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:self options:nil];
    
    if (thisDeviceFamily() == iPad) {
        cell=(SettingsTableViewCell*)[nib objectAtIndex:1];
    } else {
        cell=(SettingsTableViewCell*)[nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.lblTitle.text=[arrTitle objectAtIndex:indexPath.row ];
    
    if(indexPath.row != arrTitle.count)
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
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_navClass isEqualToString:@"User Settings"])
    {
        switch (indexPath.row) {
            case 0:
            {
                ChangePassViewController *add =[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassViewController"];
                [self presentViewController:add animated:YES completion:nil];

            }
                break;
            case 1:
            {
                UserInfoViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
                displayVwCont.isEditProfile=YES;
                [self.navigationController pushViewController:displayVwCont animated:YES];

            }
                break;
            default:
                break;
        }
    }
    else if([_navClass isEqualToString:@"Goals"])
    {
        switch (indexPath.row) {
            case 0:
            {
                CalorieIntakeViewController *catloryIntake = [self.storyboard instantiateViewControllerWithIdentifier:@"CalorieIntakeViewController"];
                catloryIntake.previousNav=@"Settings";
                [self.navigationController pushViewController:catloryIntake animated:YES];
            }
                break;
            case 1:
            {
                CalorieViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"CalorieViewController"];
                displayVwCont.navClass=[arrTitle objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:displayVwCont animated:YES];
             }
            break;

            default:
                break;
        }
                
      }
    else if([_navClass isEqualToString:@"App Settings"])
    {
        switch (indexPath.row) {
            case 0:
            {
                SettingsViewController *settings = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                settings.navClass=[arrTitle objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:settings animated:YES];
            }
                break;
            default:
                break;
        }
        
    }

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
@end
