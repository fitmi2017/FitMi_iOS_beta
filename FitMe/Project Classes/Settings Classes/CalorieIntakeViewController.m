//
//  CalorieIntakeViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "CalorieIntakeViewController.h"
#import "UserProfileDetails.h"
#import "UserCalDetails.h"
#import "SettingsViewController.h"

#define daily_calorie_intake_on @"Our estimated daily calorie goal is calculated based on age, height, weight and gender. It is intended to produce the calorie goal required to meet our plan. We use the Harris Benedict Formula. This equation produce what is known as a Basal Metabolic Rate(BMR) which is the number of calories you turn at rest. Calorie goals must be between 1200 and 9000 calories per day."
#define daily_calorie_intake_off @"We recommend that you select an \"automatic\" calorie goal unless you have received specific recommendations for calorie intake from a doctor or nutritionist. You may choose to enter your own calorie goal by turning \"automatic\" calorie goals off. If you opt to set your own calorie goals, the daily calorie goal will not ajust your weight changes. You will need to manually reduce the daily calorie goal. If FitMi calculates your calorie goals, the goal will adjust your weight changes."

@interface CalorieIntakeViewController ()
{
    BOOL switchState;
    
    __weak IBOutlet UITableView *calorieIntakeTableView;
    UserProfileDetails *userProfileObj;
    NSUserDefaults *defaults;
     NSString *selectedUserProfileID;
}
@end

@implementation CalorieIntakeViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createNavigationView:_previousNav];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    switchState=1;
    
    defaults=[NSUserDefaults standardUserDefaults];
    selectedUserProfileID=[defaults valueForKey:@"selectedUserProfileID"];

    userProfileObj=[[UserProfileDetails alloc]init];
    NSMutableArray *usersArr=[userProfileObj getUserProfileDetails:selectedUserProfileID];
    userProfileObj=[usersArr objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if(switchState)
        cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"largeCellOn"];
    else
        cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"largeCellOff"];
    
    
    if(indexPath.section==1 && indexPath.section==1){
        
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
    else
        return 91;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier;
    if(indexPath.section==0){
        simpleTableIdentifier = @"smallCellSwitch";
        
    }
    if(!switchState){
        if(indexPath.section==0 && indexPath.row==1)
            simpleTableIdentifier = @"smallCellInput";
        
        else if(indexPath.section==1)
            simpleTableIdentifier = @"largeCellOff";
        
    }
    else{
        if(indexPath.section==1)
            simpleTableIdentifier = @"largeCellOn";
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
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
    
    UITextField *calInputTxt=(UITextField *)[cell viewWithTag:2];
    calInputTxt.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    calInputTxt.delegate=self;
    calInputTxt.layer.borderWidth= 1.0f;
    
    UIView *paddingVwInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    calInputTxt.leftView = paddingVwInput;
    calInputTxt.leftViewMode = UITextFieldViewModeAlways;

    if((indexPath.row==0 || indexPath.row==1)&& indexPath.section==0){
        [cell.contentView.layer setBorderColor:[[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:.5] CGColor]];
        [cell.contentView.layer setBorderWidth:.3f];
        
    }
    //cell.backgroundView = nil;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(switchState)
        return 1;
    else{
        if(section==0)
            return 2;
    }
    return 1;
}

#pragma mark - UINavigation Button Action
-(void)showRight
{
    SettingsViewController *mVerificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    mVerificationViewController.navClass=@"settings";
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISwitch Action Method
- (IBAction)toggleSwitch:(id)sender
{
    UISwitch *switchBtn=(UISwitch*)sender;
   
    UIColor *colorOn = [UIColor greenColor];
    UIColor *colorOff = [UIColor redColor];
    
    [sender setOnTintColor:colorOn];
    [sender setTintColor:colorOff];
    switchBtn.layer.cornerRadius = 16.0f;
    switchBtn.backgroundColor = colorOff;
    switchState = [sender isOn];
    [calorieIntakeTableView reloadData];
    
    if (switchState)
    {
        // [sender setOnTintColor:[UIColor greenColor]];
        // [sender setThumbTintColor:[UIColor greenColor]];
         //[sender setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        // [sender setTintColor:[UIColor redColor]];
        //[sender setBackgroundColor:[UIColor redColor]];
      }
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
    
    _dailyCalIntakeVal_str=textField.text;
     return YES;
}

#pragma mark - "Save" Button Action
- (IBAction)btnActionSave:(id)sender
{
    [self.view endEditing:YES];
    BOOL isSuccess1;
    if([self verify])
    {
    BOOL isSuccess=[userProfileObj updateUserProfile:selectedUserProfileID withIntakeVal:_dailyCalIntakeVal_str withColumnNm:@"daily_calorie_intake"];
    
        if(isSuccess)
        {
           UserCalDetails *userCalObj=[[UserCalDetails alloc]init];
             isSuccess1=[userCalObj updateUserCalorie:selectedUserProfileID withIntakeVal:_dailyCalIntakeVal_str withColumnNm:@"total_intake"];
        }
    }
   
    if(isSuccess1)
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
    if([self isValidNumeric:_dailyCalIntakeVal_str]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
        return false;
    }
    if(_dailyCalIntakeVal_str.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Daily Calorie Intake value" withAlertTag:100];
        return false;
    }
    return success;
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

@end
