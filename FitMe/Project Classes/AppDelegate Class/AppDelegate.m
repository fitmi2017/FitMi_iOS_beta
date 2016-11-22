//
//  AppDelegate.m
//  FitMe
//
//  Created by Debasish on 24/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "DbController.h"
#import "Utility.h"
#import "FoodLogViewController.h"
#import <HockeySDK/HockeySDK.h>

@interface AppDelegate (){

    NSDictionary *dict1;
}

@end

@implementation AppDelegate

@synthesize objUserInfoControl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
   // [NSThread sleepForTimeInterval:20.0];
    //Register Local Notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                       UIUserNotificationTypeSound categories:nil]];
    }
    UILocalNotification *locationNotification = [launchOption objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
      if (locationNotification)
    {
        dict1 = [locationNotification userInfo];
        NSString *notificationTitle=locationNotification.category;
        if([notificationTitle isEqualToString:BREAKFAST]){
            [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];
            
        }
        else if ([notificationTitle isEqualToString:LUNCH]) {
            [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];
            
        }
        else if ([notificationTitle isEqualToString:DINNER]) {
            [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];
            
        }
        else{
            [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];
            
        }
   
    }
     // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;

    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    
    //For Hockey SDK
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"00aaece7d6d34d4a862cbdeb5fd430e4"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    _selectedFoodDict=[NSMutableDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isActivityNavigate"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFoodNavigate"];
    [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"selectedFoodLogMenu"];
    [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"selectedActivityLogMenu"];
    [[NSUserDefaults standardUserDefaults] setObject:@"daily" forKey:@"PlannerSession"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _plannerSession=@"daily";
    _previousTab=@"";
    _currentTab=@"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:LATEST_SELECTED_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [DbController OpenDatabase];
    _isEnterPlannerPopup=NO;
    //_isSavedUser=NO;
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    [[Utility sharedManager] saveSelectedDate:convertedDateString];
    [[Utility sharedManager] saveSelectedDateYMD:string];
    
    [self setSolidColorofUINavigationBar];
    
    if([[Utility sharedManager] isUserLoggedIn]==YES)
    {
        UIStoryboard *storyboard;
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
            NSLog(@"IPAD");
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            NSLog(@"IPHONE");
        }
        
        MHCustomTabBarController *controller = [storyboard instantiateViewControllerWithIdentifier:@"customTabbar"];
        _tabBarController=controller;
        
        self.window.rootViewController = controller;
        // [_navController pushViewController:controller animated:YES];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[[NSUserDefaults standardUserDefaults] setValue:@"" forKey:LATEST_SELECTED_DATE];
    // [[NSUserDefaults standardUserDefaults]synchronize];
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    dict1 = [notification userInfo];
    
    NSString *notificationTitle=notification.category;
    if([notificationTitle isEqualToString:BREAKFAST]){
       // [self showAlert:(NSDictionary *)dict1];
        [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];
    }
    else if ([notificationTitle isEqualToString:LUNCH])
    {
       // [self showAlert:(NSDictionary *)dict1];
        [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];

    }
    else if ([notificationTitle isEqualToString:DINNER])
    {
      //  [self showAlert:(NSDictionary *)dict1];
        [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];

    }
    else{
        //[self showAlert:(NSDictionary *)dict1];
        [self performSelector:@selector(showAlert:) withObject:(NSDictionary *)dict1 afterDelay:3.0];

    }
    application.applicationIconBadgeNumber = 0;
}
-(void)showAlert:(NSDictionary *)dict{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"Meal Reminder" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *actionLog=[UIAlertAction actionWithTitle:@"Log" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIStoryboard *storybrd=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            FoodLogViewController *objFoodlog=[storybrd instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
            objFoodlog.selected_session=[dict objectForKey:@"Session"];
            NSArray *dateArr=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"Date"] ] componentsSeparatedByString:@" "];
            NSString *dateStr=[dateArr objectAtIndex:0];
            objFoodlog.logTime=dateStr;
            objFoodlog.previous_activity=@"NotificationTapped";
            [APP_CTRL.CurrentControllerObj.navigationController pushViewController:objFoodlog animated:YES];
        }];
        UIAlertAction *actionEdit=[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIStoryboard *storybrd=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            FoodLogViewController *objFoodlog=[storybrd instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
            objFoodlog.selected_session=[dict objectForKey:@"Session"];
            NSArray *dateArr=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"Date"] ] componentsSeparatedByString:@" "];
            NSString *dateStr=[dateArr objectAtIndex:0];
            objFoodlog.logTime=dateStr;
            objFoodlog.previous_activity=@"NotificationTapped";
            [APP_CTRL.CurrentControllerObj.navigationController pushViewController:objFoodlog animated:YES];
        }];
        
        UIAlertAction *actionDelete=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *uidtodelete=[NSString stringWithFormat:@"%@",[dict valueForKey:@"uid"]];
            UIApplication *app = [UIApplication sharedApplication];
            NSArray *eventArray = [app scheduledLocalNotifications];
            for (int i=0; i<[eventArray count]; i++)
            {
                UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                NSDictionary *userInfoCurrent = oneEvent.userInfo;
                NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
                
                if ([uid isEqualToString:uidtodelete])
                {
                    //Cancelling local notification
                    [app cancelLocalNotification:oneEvent];
                    break;
                }
            }
            //  [[UIApplication sharedApplication]cancelAllLocalNotifications];
            
        }];
        [av addAction:actionCancel];
        [av addAction:actionLog];
        [av addAction:actionEdit];
        [av addAction:actionDelete];
        if(APP_CTRL.CurrentControllerObj != NULL)
            [APP_CTRL.CurrentControllerObj presentViewController:av animated:YES completion:NULL];
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meal Reminder"
                                                        message:@""
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Log",@"Edit",@"Delete",nil];
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        
        
    }
    else if (buttonIndex==2){
        UIStoryboard *storybrd=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        FoodLogViewController *objFoodlog=[storybrd instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
        objFoodlog.selected_session=[dict1 objectForKey:@"Session"];
        NSArray *dateArr=[[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"Date"] ] componentsSeparatedByString:@" "];
        NSString *dateStr=[dateArr objectAtIndex:0];
        objFoodlog.logTime=dateStr;
        objFoodlog.previous_activity=@"NotificationTapped";
        [APP_CTRL.CurrentControllerObj.navigationController pushViewController:objFoodlog animated:YES];
        
        
    }
    else if (buttonIndex==3){
        UIStoryboard *storybrd=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        FoodLogViewController *objFoodlog=[storybrd instantiateViewControllerWithIdentifier:@"FoodLogViewController"];
        objFoodlog.selected_session=[dict1 objectForKey:@"Session"];
        NSArray *dateArr=[[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"Date"] ] componentsSeparatedByString:@" "];
        NSString *dateStr=[dateArr objectAtIndex:0];
        objFoodlog.logTime=dateStr;
        objFoodlog.previous_activity=@"NotificationTapped";
        [APP_CTRL.CurrentControllerObj.navigationController pushViewController:objFoodlog animated:YES];
    }
    else{
        
        
        NSString *uidtodelete=[NSString stringWithFormat:@"%@",[dict1 valueForKey:@"uid"]];
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            
            if ([uid isEqualToString:uidtodelete])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    
    
}


#pragma mark - Set Solid Color of UINavigationbar Method
-(void)setSolidColorofUINavigationBar
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 568, 64)];
    background.backgroundColor =  [UIColor colorWithRed:(8.0f/255.0f) green:(127.0f/255.0f) blue:(155.0f/255.0f) alpha:1.0f];
    UIGraphicsBeginImageContext(background.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [background.layer renderInContext:context];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage
                                       forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dreamztech.FitMe" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FitMe" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FitMe.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
