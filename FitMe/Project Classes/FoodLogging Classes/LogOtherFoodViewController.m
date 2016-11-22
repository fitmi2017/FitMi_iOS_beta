//
//  LogOtherFoodViewController.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 14/10/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "LogOtherFoodViewController.h"

@interface LogOtherFoodViewController (){


    __weak IBOutlet UIView *upperView;
    __weak IBOutlet UIView *centerView;
    
    __weak IBOutlet UITextField *foodNameTxt;
    
    __weak IBOutlet UITextView *descriptionTxtView;
    
    __weak IBOutlet UITextField *calorieTxt;
    
    __weak IBOutlet UITextField *servingSizeTxt;
    NSString *logTimeStr,*selectedUserProfileID;
    NSUserDefaults *defaults;
}

@end

@implementation LogOtherFoodViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];
    
    foodNameTxt.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    foodNameTxt.delegate=self;
    foodNameTxt.layer.borderWidth= 1.0f;
    
    calorieTxt.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    calorieTxt.delegate=self;
    calorieTxt.layer.borderWidth= 1.0f;
     servingSizeTxt.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    servingSizeTxt.delegate=self;
    servingSizeTxt.layer.borderWidth= 1.0f;
    
    descriptionTxtView.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    descriptionTxtView.delegate=self;
    descriptionTxtView.layer.borderWidth= 1.0f;
    
    UITapGestureRecognizer *touchHold = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    
    touchHold.numberOfTouchesRequired = 1;
    [upperView addGestureRecognizer:touchHold];
    if([self.logTime isEqualToString:@" " ] || self.logTime ==nil || self.logTime.length==0)
        logTimeStr = [[Utility sharedManager] getSelectedDateFormat];
    else
        logTimeStr=self.logTime;
    
    centerView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    centerView.layer.borderWidth=1.0;
    centerView.layer.cornerRadius=25;
    centerView.layer.masksToBounds=true;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecogniz
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
       
        return NO;
    }
    
    return YES;
}

#pragma mark -IBAction
- (IBAction)saveButtonTapped:(id)sender {
    
    if([self verify])
    {

    //////////////// insert master table////////
    MasterFood *masterFoodObj=[[MasterFood alloc]init];
    NSMutableArray *allFoodID=[NSMutableArray array];
    allFoodID=[masterFoodObj findDuplicateFood];
    masterFoodObj.item_title=[foodNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    masterFoodObj.item_desc=[descriptionTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    masterFoodObj.serving_size=[servingSizeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    masterFoodObj.livestrong_id=@"0";
    masterFoodObj.cals=[calorieTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      [masterFoodObj saveUserFoodData];
    
    /////////////// insert log table////
    if([self.previous_activity isEqualToString:@"RadialTapp"]){
        FoodLog *foodLogObj=[[FoodLog alloc]init];
        foodLogObj.log_item_title=[foodNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet     whitespaceAndNewlineCharacterSet]];
        foodLogObj.log_item_desc=[descriptionTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        foodLogObj.log_cals=[calorieTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        foodLogObj.log_serving_size=[servingSizeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        foodLogObj.log_reference_food_id=@"0";
        foodLogObj.log_date_added=[self getCurrentDateTime];
        foodLogObj.log_user_id=[defaults objectForKey:@"user_id"];
        foodLogObj.log_user_profile_id=selectedUserProfileID;
        foodLogObj.log_meal_id=self.meal_id;
        foodLogObj.log_log_time=[NSString stringWithFormat:@"%@ %@",logTimeStr,[self getCurrentTime]];
        foodLogObj.log_meal_id=self.meal_id;
        [foodLogObj saveUserFoodDataLog];
       
       

    }
    
        NSMutableDictionary *foodLogDict=[[NSMutableDictionary alloc] init];
        [foodLogDict setObject:[foodNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"item_title"];
    
        [foodLogDict setObject:[descriptionTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"item_desc"];
        
        [foodLogDict setObject:[servingSizeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"serving_size"];
        [foodLogDict setObject:[calorieTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"cals"];
        
        
         [foodLogDict setObject:@"0" forKey:@"livestrong_id"];
         [defaults setObject:foodLogDict forKey:@"OtherFood"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOtherSelectedFood" object:nil];

    [self.view removeFromSuperview];
    
    [self removeFromParentViewController];
    }
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self.view removeFromSuperview];
    
    [self removeFromParentViewController];
}


-(NSString*)getCurrentDateTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"Y-M-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
-(NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    return string;
}
#pragma mark - verify Method
-(BOOL)verify
{
    BOOL success = true;
    
    if([self isValidNumeric:servingSizeTxt.text]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter proper value of Serving Size" withAlertTag:100];
        return false;
    }
    if(servingSizeTxt.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Serving Size" withAlertTag:100];
        return false;
    }
    if([self isValidNumeric:calorieTxt.text]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value of Calorie" withAlertTag:100];
        return false;
    }
    if(calorieTxt.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Calorie" withAlertTag:100];
        return false;
    }

    return success;
}

@end
