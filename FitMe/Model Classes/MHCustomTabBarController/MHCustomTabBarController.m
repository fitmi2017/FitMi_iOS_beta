/*
 * Copyright (c) 2015 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHCustomTabBarController.h"
#import "AppDelegate.h"
#import "MHTabBarSegue.h"
#import "Constant.h"
#define  TabSelectedColor [UIColor colorWithRed:49.0/255.0f green:164.0/255.0f blue:195.0/255.0f alpha:1.0]
#define  TabDeSelectedColor [UIColor colorWithRed:9.0/255.0f green:127.0/255.0f blue:155.0/255.0f alpha:1.0]
NSString *const MHCustomTabBarControllerViewControllerChangedNotification = @"MHCustomTabBarControllerViewControllerChangedNotification";
NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification = @"MHCustomTabBarControllerViewControllerAlreadyVisibleNotification";


@protocol CalenderDelegate <NSObject>

- (void)loadCalender;

@end

@interface MHCustomTabBarController ()
{
    NSUserDefaults *user_defaults;
    AppDelegate *mAppDelegate;
}

@property (nonatomic, strong) NSMutableDictionary *viewControllersByIdentifier;
@property (strong, nonatomic) NSString *destinationIdentifier;
//@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation MHCustomTabBarController
@synthesize myAlert = myAlert;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    user_defaults = User_Defaults;
    
    self.viewControllersByIdentifier = [NSMutableDictionary dictionary];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    user_defaults = User_Defaults;
    
    //    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    mAppDelegate.tabBtnArr=self.buttons;
    
    if (self.childViewControllers.count < 1)
    {
        if([[user_defaults objectForKey:@"TabBarNavStatus"] isEqualToString:@"isLoginTab"])
        {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]==NULL)
            {
                [self performSegueWithIdentifier:@"profilenavigation" sender:[self.buttons objectAtIndex:1]];
                [self changeSelectedCustomTabbar:1];
            }
            else
            {
                [self performSegueWithIdentifier:@"homenavigation" sender:[self.buttons objectAtIndex:0]];
                [self changeSelectedCustomTabbar:0];
            }
        }
        else   if([[user_defaults objectForKey:@"TabBarNavStatus"] isEqualToString:@"isSignUpTab"])
        {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"usersaved"]==NULL)
            {
                [self performSegueWithIdentifier:@"profilenavigation" sender:[self.buttons objectAtIndex:1]];
                [self changeSelectedCustomTabbar:1];
            }
            else
            {
                [self performSegueWithIdentifier:@"homenavigation" sender:[self.buttons objectAtIndex:0]];
                [self changeSelectedCustomTabbar:0];
            }
        }
    }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.destinationViewController.view.frame = self.container.bounds;
}



#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //if(!APP_CTRL.searchStart){
       // if (![segue isKindOfClass:[MHTabBarSegue class]]) {
            //[super prepareForSegue:segue sender:sender];
           // return;
       // }
        
        self.oldViewController = self.destinationViewController;
        
        //if view controller isn't already contained in the viewControllers-Dictionary
        if (![self.viewControllersByIdentifier objectForKey:segue.identifier]) {
            [self.viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
        }
        
        [self.buttons setValue:@NO forKeyPath:@"selected"];
        [sender setSelected:YES];
        self.selectedIndex = [self.buttons indexOfObject:sender];
        
        [self changeSelectedCustomTabbar:((UIButton*)sender).tag];
        self.destinationIdentifier = segue.identifier;
        self.destinationViewController = [self.viewControllersByIdentifier objectForKey:self.destinationIdentifier];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerChangedNotification object:nil];
    //}
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [[self.viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [self.viewControllersByIdentifier removeObjectForKey:key];
        }
    }];
    [super didReceiveMemoryWarning];
}
-(void)changeSelectedCustomTabbar:(int)tabBarTag
{
    switch (tabBarTag) {
        case 0:
        {
            _vwHome.backgroundColor=TabSelectedColor;
            _vwHelp.backgroundColor=TabDeSelectedColor;
            _vwProfile.backgroundColor=TabDeSelectedColor;
        }
            break;
        case 1:
        {
            _vwHome.backgroundColor=TabDeSelectedColor;
            _vwHelp.backgroundColor=TabDeSelectedColor;
            _vwProfile.backgroundColor=TabSelectedColor;
        }
            break;
        case 3:
        {
            _vwHome.backgroundColor=TabDeSelectedColor;
            _vwHelp.backgroundColor=TabSelectedColor;
            _vwProfile.backgroundColor=TabDeSelectedColor;
        }
            break;
        default:
            break;
    }
}

- (IBAction)HomeTab:(id)sender {
    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mAppDelegate.previousTab=mAppDelegate.currentTab;
    mAppDelegate.currentTab=@"home";
    
    mAppDelegate.plannerSession=@"daily";
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"EEEE, MMMM dd, yyyy";
    NSDate *today = [NSDate date];
    NSString *stringDate1 = [formatter1 stringFromDate:today];
    formatter1.dateFormat = @"yyyy-MM-dd";
    
    [[NSUserDefaults standardUserDefaults] setValue:[formatter1 stringFromDate:today] forKey:LATEST_SELECTED_DATE];
    [[Utility sharedManager] saveSelectedDate:stringDate1];
    
    
    //if(!APP_CTRL.searchStart){
        if (mAppDelegate.homeNavigation!= NULL && mAppDelegate.homeNavigation.viewControllers>0) {
            [mAppDelegate.homeNavigation popToRootViewControllerAnimated:NO];
        }
    //}
   /* else{
        myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                                                         message:@"Are you about to leave the page?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                
                                               otherButtonTitles:@"Yes", nil];
        myAlert.delegate=self;
        myAlert.tag=10;
        //[myAlert show];
        
        
    }*/
    
}
- (IBAction)ProfileTab:(id)sender {
    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mAppDelegate.previousTab=mAppDelegate.currentTab;
    mAppDelegate.currentTab=@"profile";
    
   mAppDelegate.plannerSession=@"daily";
    //if(!APP_CTRL.searchStart){
        if (mAppDelegate.profileNavigation!= NULL && mAppDelegate.profileNavigation.viewControllers>0) {
            [mAppDelegate.profileNavigation popToRootViewControllerAnimated:NO];
        }
   // }
    /*else{
        myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                                            message:@"Are you about to leave the page?"
                                           delegate:self
                                  cancelButtonTitle:@"No"
                   
                                  otherButtonTitles:@"Yes", nil];
        myAlert.delegate=self;
        myAlert.tag=11;
       // [myAlert show];
    }*/
    
}
- (IBAction)HelpTab:(id)sender {
    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mAppDelegate.previousTab=mAppDelegate.currentTab;
    mAppDelegate.currentTab=@"help";
    
    mAppDelegate.plannerSession=@"daily";
    //if(!APP_CTRL.searchStart){
        if (mAppDelegate.helpNavigation!= NULL && mAppDelegate.helpNavigation.viewControllers>0) {
            [mAppDelegate.helpNavigation popToRootViewControllerAnimated:NO];
        }
    //}
   /* else{
        
        myAlert = [[UIAlertView alloc]initWithTitle:@"Measupro"
                                            message:@"Are you about to leave the page?"
                                           delegate:self
                                  cancelButtonTitle:@"No"
                   
                                  otherButtonTitles:@"Yes", nil];
        myAlert.delegate=self;
        myAlert.tag=13;
       // [myAlert show];
        
    }*/
    
    
}


#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    mAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(alertView.tag ==10){
        if(buttonIndex==1){
                 [mAppDelegate.homeNavigation popToRootViewControllerAnimated:NO];
                //APP_CTRL.searchStart=0;
            [self performSegueWithIdentifier:@"homenavigation" sender:[self.buttons objectAtIndex:1]];
            [self changeSelectedCustomTabbar:0];

        }
        
    }
    else  if(alertView.tag ==11){
        if(buttonIndex==1){
            [mAppDelegate.profileNavigation popToRootViewControllerAnimated:NO];
            //APP_CTRL.searchStart=0;
            [self performSegueWithIdentifier:@"profilenavigation" sender:[self.buttons objectAtIndex:1]];
            [self changeSelectedCustomTabbar:1];
        }
    }
    else  if(alertView.tag ==13){
        if(buttonIndex==1){
            [mAppDelegate.profileNavigation popToRootViewControllerAnimated:NO];
            //APP_CTRL.searchStart=0;
            [self performSegueWithIdentifier:@"helpnavigation" sender:[self.buttons objectAtIndex:1]];
            [self changeSelectedCustomTabbar:3];
            
        }
        
    }

}

@end
