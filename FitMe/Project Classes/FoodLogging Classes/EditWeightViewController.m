//
//  EditWeightViewController.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 19/01/16.
//  Copyright (c) 2016 Dreamztech Solutions. All rights reserved.
//

#import "EditWeightViewController.h"

@interface EditWeightViewController (){
    __weak IBOutlet UIView *upperView;
    __weak IBOutlet UIView *centerView;
    __weak IBOutlet UITextField *editTextView;
    __weak IBOutlet UILabel *lblTitle;


}

@end

@implementation EditWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        [_delegate notifyWeightLog:editTextView.text];
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
