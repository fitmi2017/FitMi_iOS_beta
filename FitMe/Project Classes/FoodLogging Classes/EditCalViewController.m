//
//  EditCalViewController.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 18/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "EditCalViewController.h"

@interface EditCalViewController (){

    __weak IBOutlet UIView *upperView;
    __weak IBOutlet UIView *centerView;
    __weak IBOutlet UITextField *editTextView;
    __weak IBOutlet UILabel *lblTitle;
}

@end

@implementation EditCalViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([_navigateVal isEqualToString:@"activity"])
    {
        lblTitle.text=@"Edit Time";
        editTextView.placeholder=@"Enter your new time(in Mins)";
    }
    centerView.layer.cornerRadius=25;
    centerView.layer.borderColor=[[UIColor grayColor] CGColor];
    centerView.layer.borderWidth=.5;
    UILongPressGestureRecognizer *touchHold = [[UILongPressGestureRecognizer alloc] init];
    touchHold.minimumPressDuration = 1.0f;
    touchHold.numberOfTouchesRequired = 1;
    touchHold.delegate=self;
    [upperView addGestureRecognizer:touchHold];
    editTextView.layer.borderColor=[[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:2.0] CGColor];
    editTextView.delegate=self;
    editTextView.layer.borderWidth= 1.0f;
    
    UIView *paddingVwEditText = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    editTextView.leftView = paddingVwEditText;
    editTextView.leftViewMode = UITextFieldViewModeAlways;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 }

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    //[_delegate notifyEventLog:@"BACK"];
    return YES;
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveTapped:(id)sender
{
    if([self verify])
    {
    [_delegate notifyCalorieLog:editTextView.text];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    }
}

- (IBAction)cancelTapped:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - verify Method
-(BOOL)verify
{
    BOOL success = true;
    
    if([self isValidNumeric:editTextView.text]==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
        return false;
    }
    if([editTextView.text isEqualToString:@"0"])
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Proper Value" withAlertTag:100];
        return false;
    }
    if(editTextView.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please enter Calorie" withAlertTag:100];
        return false;
    }
    return success;
}

@end
