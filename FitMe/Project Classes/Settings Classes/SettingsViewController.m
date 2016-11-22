//
//  SettingsViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "DisplayViewController.h"
#import "UnitsViewController.h"
#import "DeviceListViewController.h"
#import "ChangePassViewController.h"
@interface SettingsViewController ()
{
    NSMutableArray *arrTitle;
}
@end

@implementation SettingsViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([_navClass isEqualToString:@"settings"])
    {
        [self createNavigationView:@"Settings"];
        if(APP_CTRL.isShowDevice)
              arrTitle= [[NSMutableArray alloc] initWithObjects:@"Change Password",@"Edit Profile",@"Device Management",@"Units",@"Goals",@"My Notification",nil];
        else
            arrTitle= [[NSMutableArray alloc] initWithObjects:@"Change Password",@"Edit Profile",@"Units",@"Goals",@"My Notification",nil];
    }
    else if([_navClass isEqualToString:@"Display"])
    {
        [self createNavigationView:@"Display"];
        arrTitle= [[NSMutableArray alloc] initWithObjects:@"Home Page",@"Nutrition",@"Activity",@"Weight",@"Report",nil];
    }

    [self.navigationItem setHidesBackButton:YES animated:NO];

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
    if([_navClass isEqualToString:@"settings"])
    {
     if(arrTitle.count==6)
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
        case 2:
        {
            DeviceListViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
            [self.navigationController pushViewController:mVerificationViewController animated:YES];
         }
           break;
        case 3:
        {
            UnitsViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitsViewController"];
              [self.navigationController pushViewController:displayVwCont animated:YES];

        }
            break;
        case 4:
        {
            DisplayViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayViewController"];
            displayVwCont.navClass=[arrTitle objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:displayVwCont animated:YES];

        }
            break;

        case 5:
        {
        }
            break;
            
           default:
            break;
        }
     }
      else  if(arrTitle.count==5)
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
                case 2:
                {
                    UnitsViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitsViewController"];
                    [self.navigationController pushViewController:displayVwCont animated:YES];
                    
                }
                    break;
                case 3:
                {
                    DisplayViewController *displayVwCont = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayViewController"];
                    displayVwCont.navClass=[arrTitle objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:displayVwCont animated:YES];
                    
                }
                    break;
                    
                case 4:
                {
                }
                    break;
                    
                default:
                    break;
            }
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
