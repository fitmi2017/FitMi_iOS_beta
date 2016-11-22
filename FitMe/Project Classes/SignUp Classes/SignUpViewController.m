//
//  SignUpViewController.m
//  FitMe
//
//  Created by Debasish on 27/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "SignUpViewController.h"
#import "MHCustomTabBarController.h"
#import "DejalActivityView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "UserListViewController.h"
#import "UserProfile.h"
@interface SignUpViewController ()
{
    NSUserDefaults *user_defaults;
}

- (IBAction)btnActionSignUp:(id)sender;
@end

@implementation SignUpViewController

#pragma mark - UIView LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
     user_defaults = User_Defaults;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    _dicCell = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    APP_CTRL.CurrentControllerObj = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - "SignUp" Button Action
- (IBAction)btnActionSignUp:(id)sender
{
    [self.view endEditing:YES];
    
    if([self verify])
   {
       if([self isNetworkAvailable]==NO){
           [self createAlertView:@"Alert" withAlertMessage:ConnectionUnavailable withAlertTag:3];
       }
       else
       {
         [self signUpServerConnection];
       }
   }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtFldFNm) {
       // [txtFldFNm resignFirstResponder];
        [_txtFldLNm becomeFirstResponder];
    }
    else  if (textField == _txtFldLNm) {
      //  [txtFldLNm resignFirstResponder];
        [_txtFldEmail becomeFirstResponder];
    }

   else if (textField == _txtFldEmail) {
       // [txtFldEmail resignFirstResponder];
        [_txtFldPass becomeFirstResponder];
    }
    else  if (textField == _txtFldPass) {
       // [txtFldPass resignFirstResponder];
        [_txtFldConPass becomeFirstResponder];
    }
    else{
    [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Keyboard Hide/Show Notification Function
-(void)onKeyboardHide:(NSNotification *)notification
{
    /*[UIView animateWithDuration:0.3
     delay:0.0
     options: UIViewAnimationOptionCurveEaseInOut
     animations:^{
     self.view.frame=CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
     }
     completion:^(BOOL finished){
     }];*/
    
    /*UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollVwBG.contentInset = contentInsets;
    self.scrollVwBG.scrollIndicatorInsets = contentInsets;
    _bottomConstraint.constant=0;*/
    
    _bottomTblVwConst.constant=0;
}
- (void)keyboardDidShow: (NSNotification *) notif
{
    NSLog(@"Keyboard show");
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
   // NSLog(@"activeTextField%ld",(long)self.activeTextField.tag);
    
     _bottomTblVwConst.constant=keyboardSize.height;
    
     // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
  /*  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
     self.scrollVwBG .contentInset = contentInsets;
     self.scrollVwBG.scrollIndicatorInsets = contentInsets;
     
     // Step 3: Scroll the target text field into view.
     CGRect aRect = self.view.frame;
     aRect.size.height -= keyboardSize.height;
     if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
     CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - (keyboardSize.height-15));
     [self.scrollVwBG setContentOffset:scrollPoint animated:YES];
      }*/
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint buttonPosition = [textField convertPoint:CGPointZero toView:self.tblVw];
    NSIndexPath *indexPath = [self.tblVw indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"%ld", (long)indexPath.row);
    
    [self.tblVw scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
   // self.activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",textField.frame.origin.y);
    if([[self GetIphoneModelVersion]isEqualToString:@"5"])
    {
    NSLog(@"IPHONE5S");

     if(textField.frame.origin.y>139.0)
     {
   //  float scrolly=textField.frame.origin.y-90;
  //   [self.scrollVwBG setContentOffset:CGPointMake(0, scrolly)];
     }
    }
   
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%ld",(long)textField.tag);
    
//    [self.scrollVwBG setContentOffset:CGPointMake(0, 0)];
    return YES;
}

#pragma mark - verify Method
-(BOOL)verify
{
       BOOL success = true;
    
    //_txtFldFNm.text=[ _txtFldFNm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //_txtFldLNm.text=[_txtFldLNm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _txtFldEmail.text=[_txtFldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _txtFldPass.text=[_txtFldPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _txtFldConPass.text=[_txtFldConPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   BOOL isEmailValid=[self validateEmail:_txtFldEmail.text];
    
   /* if(_txtFldFNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide First Name" withAlertTag:100];
        return false;
        
    }
    if(_txtFldLNm.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Last Name" withAlertTag:100];
        return false;
        
    }*/

    if(_txtFldEmail.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Email" withAlertTag:100];
        return false;
        
    }
    
    if(isEmailValid==NO)
    {
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide valid Email" withAlertTag:100];
        return false;
    }

    if(_txtFldPass.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Password" withAlertTag:100];
        return false;
        
    }
    if(_txtFldPass.text.length <7){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Password with minimum 7 Characters" withAlertTag:100];
        return false;
        
    }

    if(_txtFldConPass.text.length <=0){
        
        [self createAlertView:@"Measupro" withAlertMessage:@"Please provide Confirm Password" withAlertTag:100];
        return false;
        
    }
    
    
     if(![_txtFldPass.text isEqualToString:_txtFldConPass.text])
     {
    [self createAlertView:@"Measupro" withAlertMessage:@"Password and Confirm Password does not match" withAlertTag:100];
    return false;
   
     }
    return success;
}

#pragma mark - SignUp Server Connection Method
-(void)signUpServerConnection
{
    self.view.userInteractionEnabled = NO;
    [DejalBezelActivityView activityViewForView:self.view];
    [[ServerConnection sharedInstance] setDelegate:self];
    [[ServerConnection sharedInstance] signup:_txtFldFNm.text Lastname:_txtFldLNm.text EmailId:_txtFldEmail.text Password:_txtFldPass.text];
    //[self performSelector:@selector(myTask) withObject:nil afterDelay:15.0];
}

#pragma mark - Service Connection Delegate
-(void)requestDidFinished:(id)result
{
    self.view.userInteractionEnabled = YES;
    [DejalBezelActivityView removeViewAnimated:YES];
    if ([result isKindOfClass:[NSError class]]) {
        NSError *error=(NSError *)result;
        [self createAlertView:@"Mesupro" withAlertMessage:error.localizedDescription withAlertTag:0];
        return;
    }
    if ([result isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary *)result;
        if([[dict valueForKey:@"status"] isEqualToString:@"false"]){
         [self createAlertView:@"Mesupro" withAlertMessage:[dict valueForKey:@"message"] withAlertTag:0];
        }
        else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0f) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"You have successfully signed up." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ActionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actionn){
                    
                    [user_defaults setObject:@"isSignUpTab" forKey:@"TabBarNavStatus"];
                    [user_defaults synchronize];
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    MHCustomTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"customTabbar"];
                    appDelegate.tabBarController=controller;
                    [self.navigationController pushViewController:controller animated:YES];
                }];
                
                
                [user_defaults setObject:[dict valueForKey:@"users_id"] forKey:@"user_id"];
                [user_defaults setObject:[dict valueForKey:@"access_key"] forKey:@"user_accessKey"];
                [user_defaults synchronize];
                NSLog(@"userid=====%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);
                /////////////////  update local db /////////
    
                UserProfile *userObj=[[UserProfile alloc]init];
                userObj.fnameString=_txtFldFNm.text;
                userObj.lnameString=_txtFldFNm.text;
                userObj.emailString=_txtFldEmail.text;
                userObj.passwordString=_txtFldPass.text;
                userObj.userID=[dict valueForKey:@"users_id"];
                [userObj saveUserData];

                [alertController addAction:ActionOk];
                [self presentViewController:alertController animated:YES completion:NULL];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:[dict valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

#pragma mark - UITouch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - "Cancel" Button Action
- (IBAction)btnActionCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(thisDeviceFamily()==iPad)
    {
        if(indexPath.row!=3)
            return 85;
        else
            return 95;
    }
    else
    {
        if(indexPath.row!=3)
            return 70;
        else
            return 70;
 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier;
    if(indexPath.row!=3)
        simpleTableIdentifier = @"TextFieldIdentifier";
    else
        simpleTableIdentifier = @"ButtonIdentifier";
    
    NSString *strKey = [NSString stringWithFormat:@"%lu_%lu",(long)indexPath.row, (long)indexPath.row];
    UITableViewCell *cell = [_dicCell valueForKey:strKey];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath ];
        UIColor *color = [UIColor colorWithRed:45.0/255.0f green:129.0/255.0f blue:163.0/255.0f alpha:1.0f];
        UITextField *txtFld =(UITextField *)[cell viewWithTag:1];
        txtFld.secureTextEntry=NO;
      /*  if(indexPath.row == 0)
        {
            _txtFldFNm=txtFld;
            
            UIView *paddingVwFNm = [[UIView alloc] init];
            if(thisDeviceFamily()==iPad)
                paddingVwFNm.frame=CGRectMake(0, 0, 10, 70);
            else
                paddingVwFNm.frame=CGRectMake(0, 0, 10, 60);
            
            txtFld.leftView = paddingVwFNm;
            txtFld.leftViewMode = UITextFieldViewModeAlways;
            
            txtFld.returnKeyType=UIReturnKeyNext;
            
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)])
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        else  if(indexPath.row == 1)
        {
            _txtFldLNm=txtFld;
            
            UIView *paddingVwLNm = [[UIView alloc] init ];
            if(thisDeviceFamily()==iPad)
                paddingVwLNm.frame=CGRectMake(0, 0, 10, 70);
            else
                paddingVwLNm.frame=CGRectMake(0, 0, 10, 60);
            
            txtFld.leftView = paddingVwLNm;
            txtFld.leftViewMode = UITextFieldViewModeAlways;
            
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)])
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        
        else*/
            
            if(indexPath.row == 0)
        {
            _txtFldEmail= txtFld;
            
            UIView *paddingVwEmail = [[UIView alloc] init ];
            if(thisDeviceFamily()==iPad)
                paddingVwEmail.frame=CGRectMake(0, 0, 10, 70);
            else
                paddingVwEmail.frame=CGRectMake(0, 0, 10, 60);
            
            txtFld.leftView = paddingVwEmail;
            txtFld.leftViewMode = UITextFieldViewModeAlways;
            
            txtFld.keyboardType=UIKeyboardTypeEmailAddress;
            
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)])
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        
        else  if(indexPath.row ==1)
        {
            _txtFldPass= txtFld;
            
            UIView *paddingVwPass = [[UIView alloc] init ];
            if(thisDeviceFamily()==iPad)
                paddingVwPass.frame=CGRectMake(0, 0, 10, 70);
            else
                paddingVwPass.frame=CGRectMake(0, 0, 10, 60);
            
            txtFld.leftView = paddingVwPass;
            txtFld.leftViewMode = UITextFieldViewModeAlways;
            
            txtFld.secureTextEntry=YES;
            
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)])
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        
        else  if(indexPath.row == 2)
        {
            _txtFldConPass= txtFld;
            
            UIView *paddingVwConPass = [[UIView alloc] init ];
            if(thisDeviceFamily()==iPad)
                paddingVwConPass.frame=CGRectMake(0, 0, 10, 70);
            else
                paddingVwConPass.frame=CGRectMake(0, 0, 10, 60);
            
            txtFld.leftView = paddingVwConPass;
            txtFld.leftViewMode = UITextFieldViewModeAlways;
            
            txtFld.secureTextEntry=YES;
            
            txtFld.returnKeyType=UIReturnKeyDone;
            
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)])
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        
        else if(indexPath.row == 3)
        {
            UIButton *btnCancel = (UIButton *)[cell viewWithTag:11];
            [btnCancel addTarget:self action:@selector(btnActionCancel:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btnSignUp = (UIButton *)[cell viewWithTag:12];
            [btnSignUp addTarget:self action:@selector(btnActionSignUp:) forControlEvents:UIControlEventTouchUpInside];
            
        }

        [_dicCell setValue:cell forKey:strKey];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
