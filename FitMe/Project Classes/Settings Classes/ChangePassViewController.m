//
//  ChangePassViewController.m
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "ChangePassViewController.h"
#import "UserProfile.h"
@interface ChangePassViewController ()
{
    UserProfile *userProfileObj;
    NSString *oldPassword;
}
@end

@implementation ChangePassViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userProfileObj=[[UserProfile alloc]init];
    oldPassword=[userProfileObj getPWD:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]];
    
    _txtFldFNm.text=oldPassword;
   
    if ([_txtFldFNm respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        _txtFldFNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Old Password" attributes:@{NSForegroundColorAttributeName: color}];
        _txtFldLNm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
        
        _txtFldEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
        
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        
    }

    UIView *paddingVwFNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 60)];
    _txtFldFNm.leftView = paddingVwFNm;
    _txtFldFNm.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVwLNm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 60)];
    _txtFldLNm.leftView = paddingVwLNm;
    _txtFldLNm.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVwEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 60)];
    _txtFldEmail.leftView = paddingVwEmail;
    _txtFldEmail.leftViewMode = UITextFieldViewModeAlways;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - "Save" Button Action
- (IBAction)btnActionSignUp:(id)sender
{
    
    BOOL isSuccess=[userProfileObj updateUserPWD:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] withPasswordVal:_txtFldEmail.text];
    
    if(isSuccess)
    {
       //[self createAlertView:@"Mesupro" withAlertMessage:@"Your changes have been saved successfully" withAlertTag:0];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
 }

#pragma mark - "Cancel" Button Action
- (IBAction)btnActionCancel:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldFNm) {
        [_txtFldFNm resignFirstResponder];
        [_txtFldLNm becomeFirstResponder];
    }
    else  if (textField == _txtFldLNm) {
        [_txtFldLNm resignFirstResponder];
        [_txtFldEmail becomeFirstResponder];
    }
    
   else {
        [_txtFldEmail resignFirstResponder];
         }
    
    return YES;
}

@end
