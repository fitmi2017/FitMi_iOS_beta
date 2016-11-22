//
//  UnitsViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UnitsViewController.h"
#import "UnitsTableViewCell.h"
#import "UnitWeightTableViewCell.h"
#import "UnitBPTableViewCell.h"
#import "UnitsLog.h"
#import "SettingsViewController.h"
@interface UnitsViewController ()
{
    NSString *selectedHeight,*selectedWeight,*selectedBP,*selectedBP1,*selectedFoodWeight;
    UnitsLog *unitsLogObj;
    NSUserDefaults *defaults;
}
@end

@implementation UnitsViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unitsLogObj=[[UnitsLog alloc]init];
    
    defaults=[NSUserDefaults standardUserDefaults];
  
    NSMutableArray *arrUnitsLog=[unitsLogObj getAllUnitDataLog:[defaults valueForKey:@"selectedUserProfileID"]];
    
   if(arrUnitsLog.count>0)
   {
       for(int i=0;i<arrUnitsLog.count;i++)
       {
         NSDictionary *dict=[arrUnitsLog objectAtIndex:i];
           if([[dict objectForKey:@"type"] isEqualToString:@"height"])
           {
              selectedHeight=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"height"];
           }
           else if([[dict objectForKey:@"type"] isEqualToString:@"weight"])
           {
               selectedWeight=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"weight"];
           }
           else if([[dict objectForKey:@"type"] isEqualToString:@"blood_pressure"])
           {
               selectedBP=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"blood_pressure"];
           }
           else if([[dict objectForKey:@"type"] isEqualToString:@"food_weight"])
           {
               selectedFoodWeight=[unitsLogObj getUnitType:[dict objectForKey:@"unit_id"] withUnitCategory:@"food_weight"];
           }

       }
     }
   else
   {
       selectedHeight=@"ft";
       selectedWeight=@"lbs";
       selectedBP=@"mmhg";
       selectedFoodWeight=@"gm";
    }
    [self createNavigationView:@"Settings"];
    [self.navigationItem setHidesBackButton:YES animated:NO];

    if([[defaults valueForKey:@"selectedBP1"] isEqualToString:@"aha"])
    {
      selectedBP1=@"aha";
    }
    else
    {
      selectedBP1=@"who";
        
    }
    _lblTop.text=@"Units";
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==2){
        if (thisDeviceFamily() == iPad) {
            return 170;
        } else {
            return 160;
        }
    }
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitsTableViewCell *cell;
    UnitWeightTableViewCell *cell1;
    
    static NSString *simpleTableIdentifier1 = @"unitHeight";
    static NSString *simpleTableIdentifier2 = @"unitWeight";
    
    if(indexPath.row==0){
    cell = (UnitsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
     
    if (cell == nil)
        {
            NSArray *nib=[[ NSBundle  mainBundle]loadNibNamed:@"UnitsTableViewCell" owner:self options:nil];
            if (thisDeviceFamily() == iPad) {
                cell=(UnitsTableViewCell*)[nib objectAtIndex:1];
            } else {
                cell=(UnitsTableViewCell*)[nib objectAtIndex:0];
            }
            
        }
        
    }
   else if(indexPath.row==1 ){
    cell1 = (UnitWeightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier2];
        if (cell1 == nil)
        {
            NSArray *nib=[[ NSBundle  mainBundle]loadNibNamed:@"UnitWeightTableViewCell" owner:self options:nil];
            if (thisDeviceFamily() == iPad) {
                cell1=(UnitWeightTableViewCell*)[nib objectAtIndex:1];
            } else {
                cell1=(UnitWeightTableViewCell*)[nib objectAtIndex:0];
            }
            
        }
        
    }
   else if(indexPath.row==2){
        cell = (UnitsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
        
        if (cell == nil)
        {
            NSArray *nib=[[ NSBundle  mainBundle]loadNibNamed:@"UnitsTableViewCell" owner:self options:nil];
            if (thisDeviceFamily() == iPad) {
                cell=(UnitsTableViewCell*)[nib objectAtIndex:1];
            } else {
                cell=(UnitsTableViewCell*)[nib objectAtIndex:0];
            }
            
        }
        
    }

    
    if(indexPath.row==0){
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.lblTitle.text=@"Height";
       
    [cell.btnFeet setTitle: @"ft" forState: UIControlStateNormal];
    [cell.btnCm setTitle: @"cm" forState: UIControlStateNormal];

    if([selectedHeight isEqualToString:@"cm"])
    {
        [cell.btnFeet.layer setBorderWidth:1.0f];
        [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell.btnFeet.backgroundColor = [UIColor whiteColor];
        [cell.btnFeet setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
        
        [cell.btnCm.layer setBorderWidth:1.0f];
        [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell.btnCm.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
        [cell.btnCm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    }
    else
    {
        [cell.btnCm.layer setBorderWidth:1.0f];
        [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell.btnCm.backgroundColor = [UIColor whiteColor];
        [cell.btnCm setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
        
        [cell.btnFeet.layer setBorderWidth:1.0f];
        [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell.btnFeet.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
        [cell.btnFeet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    }
       
    cell.btnFeet.tag=indexPath.row+10;
    [cell.btnFeet addTarget:self action:@selector(btnActionFeet:) forControlEvents:UIControlEventTouchUpInside];
  
    cell.btnCm.tag=indexPath.row+20;
    [cell.btnCm addTarget:self action:@selector(btnActionCm:) forControlEvents:UIControlEventTouchUpInside];
        
     return cell;
        
    }
    if(indexPath.row==1 ){
    
    
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if([selectedWeight isEqualToString:@"lbs"])
        {
        [cell1.btn_st.layer setBorderWidth:1.0f];
        [cell1.btn_st.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell1.btn_st.backgroundColor = [UIColor whiteColor];
        [cell1.btn_st setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
        

        [cell1.btn_kg.layer setBorderWidth:1.0f];
        [cell1.btn_kg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell1.btn_kg.backgroundColor = [UIColor whiteColor];
        [cell1.btn_kg setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
        
        [cell1.btn_lb.layer setBorderWidth:1.0f];
        [cell1.btn_lb.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
        cell1.btn_lb.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
        [cell1.btn_lb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [cell1.btn_st.layer setBorderWidth:1.0f];
            [cell1.btn_st.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell1.btn_st.backgroundColor = [UIColor whiteColor];
            [cell1.btn_st setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
            
            
            [cell1.btn_lb.layer setBorderWidth:1.0f];
            [cell1.btn_lb.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell1.btn_lb.backgroundColor = [UIColor whiteColor];
            [cell1.btn_lb setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
            
            [cell1.btn_kg.layer setBorderWidth:1.0f];
            [cell1.btn_kg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell1.btn_kg.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
            [cell1.btn_kg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        cell1.btn_lb.tag=indexPath.row+100;
        [cell1.btn_lb addTarget:self action:@selector(btnLBTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell1.btn_kg.tag=indexPath.row+200;
        [cell1.btn_kg addTarget:self action:@selector(btnKGTapped:) forControlEvents:UIControlEventTouchUpInside];
    
        cell1.btn_st.tag=indexPath.row+300;
        [cell1.btn_st addTarget:self action:@selector(btnSTTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell1;
    
    }
    
    if(indexPath.row==2){
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text=@"Food Weight";
        
        [cell.btnFeet setTitle: @"gm" forState: UIControlStateNormal];
        [cell.btnCm setTitle: @"oz" forState: UIControlStateNormal];
        
        if([selectedFoodWeight isEqualToString:@"oz"])
        {
            [cell.btnFeet.layer setBorderWidth:1.0f];
            [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell.btnFeet.backgroundColor = [UIColor whiteColor];
            [cell.btnFeet setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
            
            [cell.btnCm.layer setBorderWidth:1.0f];
            [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell.btnCm.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
            [cell.btnCm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else
        {
            [cell.btnCm.layer setBorderWidth:1.0f];
            [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell.btnCm.backgroundColor = [UIColor whiteColor];
            [cell.btnCm setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
            
            [cell.btnFeet.layer setBorderWidth:1.0f];
            [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
            cell.btnFeet.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
            [cell.btnFeet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
        cell.btnFeet.tag=indexPath.row+10000;
        [cell.btnFeet addTarget:self action:@selector(btnActionGm:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnCm.tag=indexPath.row+20000;
        [cell.btnCm addTarget:self action:@selector(btnActionOz:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
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

#pragma mark - "Cancel" Button Action
- (IBAction)btnActionCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - "Save" Button Action
- (IBAction)btnActionSave:(id)sender
{
    [defaults setObject:selectedBP1 forKey:@"selectedBP1"];
    [defaults synchronize];
    
    NSMutableArray *arrUnitsLog=[unitsLogObj getAllUnitDataLog:[defaults valueForKey:@"selectedUserProfileID"]];
   
    for(int i=0;i<4;i++)
    {
        if(i==0)
        {
            unitsLogObj.unitlog_user_id=[defaults objectForKey:@"user_id"];
            unitsLogObj.unitlog_user_profile_id=[defaults valueForKey:@"selectedUserProfileID"];
            unitsLogObj.unit_id=[unitsLogObj getUnitTypeID:selectedHeight withUnitCategory:@"height"];
            unitsLogObj.unit_type=@"height";

            if(arrUnitsLog.count>0)
            {
                [unitsLogObj updateUserUnitDataLog:unitsLogObj.unit_type];
            }
            else
            {
             [unitsLogObj saveUserUnitDataLog];
            }
           }
       else if(i==1)
        {
            unitsLogObj.unitlog_user_id=[defaults objectForKey:@"user_id"];
            unitsLogObj.unitlog_user_profile_id=[defaults valueForKey:@"selectedUserProfileID"];
            unitsLogObj.unit_id=[unitsLogObj getUnitTypeID:selectedWeight withUnitCategory:@"weight"];
            unitsLogObj.unit_type=@"weight";
            if(arrUnitsLog.count>0)
            {
                [unitsLogObj updateUserUnitDataLog:unitsLogObj.unit_type];
            }
            else
            {
                [unitsLogObj saveUserUnitDataLog];
            }

        }

        else if(i==2)
        {
            unitsLogObj.unitlog_user_id=[defaults objectForKey:@"user_id"];
            unitsLogObj.unitlog_user_profile_id=[defaults valueForKey:@"selectedUserProfileID"];
             unitsLogObj.unit_id=[unitsLogObj getUnitTypeID:selectedBP withUnitCategory:@"blood_pressure"];
            unitsLogObj.unit_type=@"blood_pressure";
            if(arrUnitsLog.count>0)
            {
                [unitsLogObj updateUserUnitDataLog:unitsLogObj.unit_type];
            }
            else
            {
                [unitsLogObj saveUserUnitDataLog];
            }
            
         //   [self createAlertView:@"Measupro" withAlertMessage:@"Save successfully" withAlertTag:100];


        }
        else if(i==3)
        {
            unitsLogObj.unitlog_user_id=[defaults objectForKey:@"user_id"];
            unitsLogObj.unitlog_user_profile_id=[defaults valueForKey:@"selectedUserProfileID"];
            unitsLogObj.unit_id=[unitsLogObj getUnitTypeID:selectedFoodWeight withUnitCategory:@"food_weight"];
            unitsLogObj.unit_type=@"food_weight";
            
            if(arrUnitsLog.count>0)
            {
                [unitsLogObj updateUserUnitDataLog:unitsLogObj.unit_type];
            }
            else
            {
                [unitsLogObj saveUserUnitDataLog];
            }
        }

    }
    
}
-(void)btnActionFeet:(UIButton*)sender
{
    selectedHeight=@"ft";
  
    UnitsTableViewCell *cell=(UnitsTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.btnCm.layer setBorderWidth:1.0f];
    [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnCm.backgroundColor = [UIColor whiteColor];
    [cell.btnCm setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell.btnFeet.layer setBorderWidth:1.0f];
    [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnFeet.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell.btnFeet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)btnActionCm:(UIButton*)sender
{
    selectedHeight=@"cm";
  
    UnitsTableViewCell *cell=(UnitsTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.btnFeet.layer setBorderWidth:1.0f];
    [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnFeet.backgroundColor = [UIColor whiteColor];
    [cell.btnFeet setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell.btnCm.layer setBorderWidth:1.0f];
    [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnCm.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell.btnCm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)btnLBTapped:(UIButton*)sender
{
    selectedWeight=@"lbs";

    UnitWeightTableViewCell *cell1=(UnitWeightTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    
    [cell1.btn_st.layer setBorderWidth:1.0f];
    [cell1.btn_st.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_st.backgroundColor = [UIColor whiteColor];
    [cell1.btn_st setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    

    
    [cell1.btn_kg.layer setBorderWidth:1.0f];
    [cell1.btn_kg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_kg.backgroundColor = [UIColor whiteColor];
    [cell1.btn_kg setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell1.btn_lb.layer setBorderWidth:1.0f];
    [cell1.btn_lb.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_lb.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell1.btn_lb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    }
-(void)btnKGTapped:(UIButton*)sender
{
    selectedWeight=@"kg";

    UnitWeightTableViewCell *cell1=(UnitWeightTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [cell1.btn_st.layer setBorderWidth:1.0f];
    [cell1.btn_st.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_st.backgroundColor = [UIColor whiteColor];
    [cell1.btn_st setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
   
    [cell1.btn_lb.layer setBorderWidth:1.0f];
    [cell1.btn_lb.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_lb.backgroundColor = [UIColor whiteColor];
    [cell1.btn_lb setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell1.btn_kg.layer setBorderWidth:1.0f];
    [cell1.btn_kg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_kg.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell1.btn_kg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

-(void)btnSTTapped:(UIButton*)sender{
    
    UnitWeightTableViewCell *cell1=(UnitWeightTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    
    [cell1.btn_lb.layer setBorderWidth:1.0f];
    [cell1.btn_lb.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_lb.backgroundColor = [UIColor whiteColor];
    [cell1.btn_lb setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell1.btn_kg.layer setBorderWidth:1.0f];
    [cell1.btn_kg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_kg.backgroundColor = [UIColor whiteColor];
    [cell1.btn_kg setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell1.btn_st.layer setBorderWidth:1.0f];
    [cell1.btn_st.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell1.btn_st.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell1.btn_st setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)btnMMHGTapped:(UIButton*)sender{
    
    selectedBP=@"mmhg";

    UnitBPTableViewCell *cell2=(UnitBPTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    
    [cell2.btn_kpa.layer setBorderWidth:1.0f];
    [cell2.btn_kpa.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_kpa.backgroundColor = [UIColor whiteColor];
    [cell2.btn_kpa setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell2.btn_mmhg.layer setBorderWidth:1.0f];
    [cell2.btn_mmhg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_mmhg.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell2.btn_mmhg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)btnKPATapped:(UIButton*)sender{
    
     selectedBP=@"kpa";

    UnitBPTableViewCell *cell2=(UnitBPTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    [cell2.btn_mmhg.layer setBorderWidth:1.0f];
    [cell2.btn_mmhg.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_mmhg.backgroundColor = [UIColor whiteColor];
    [cell2.btn_mmhg setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell2.btn_kpa.layer setBorderWidth:1.0f];
    [cell2.btn_kpa.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_kpa.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell2.btn_kpa setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)btnAHAapped:(UIButton*)sender{
    
    selectedBP1=@"aha";
    UnitBPTableViewCell *cell2=(UnitBPTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    
     [cell2.btn_who.layer setBorderWidth:1.0f];
    [cell2.btn_who.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_who.backgroundColor = [UIColor whiteColor];
    [cell2.btn_who setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell2.btn_aha.layer setBorderWidth:1.0f];
    [cell2.btn_aha.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_aha.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell2.btn_aha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
-(void)btnWHOapped:(UIButton*)sender{
    
    selectedBP1=@"who";
    
    UnitBPTableViewCell *cell2=(UnitBPTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    
    [cell2.btn_aha.layer setBorderWidth:1.0f];
    [cell2.btn_aha.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_aha.backgroundColor = [UIColor whiteColor];
    [cell2.btn_aha setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell2.btn_who.layer setBorderWidth:1.0f];
    [cell2.btn_who.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell2.btn_who.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell2.btn_who setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
-(void)btnActionGm:(UIButton*)sender
{
    selectedFoodWeight=@"gm";
    
    UnitsTableViewCell *cell=(UnitsTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    [cell.btnCm.layer setBorderWidth:1.0f];
    [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnCm.backgroundColor = [UIColor whiteColor];
    [cell.btnCm setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell.btnFeet.layer setBorderWidth:1.0f];
    [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnFeet.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell.btnFeet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)btnActionOz:(UIButton*)sender
{
    selectedFoodWeight=@"oz";
    
    UnitsTableViewCell *cell=(UnitsTableViewCell*)[_tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    [cell.btnFeet.layer setBorderWidth:1.0f];
    [cell.btnFeet.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnFeet.backgroundColor = [UIColor whiteColor];
    [cell.btnFeet setTitleColor:[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    [cell.btnCm.layer setBorderWidth:1.0f];
    [cell.btnCm.layer setBorderColor:[[UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f] CGColor]];
    cell.btnCm.backgroundColor = [UIColor colorWithRed:48.0/255.0f green:164.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [cell.btnCm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
