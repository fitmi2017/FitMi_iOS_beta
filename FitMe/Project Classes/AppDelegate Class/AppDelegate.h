//
//  AppDelegate.h
//  FitMe
//
//  Created by Debasish on 24/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MHCustomTabBarController.h"
#import "UserInfoViewController.h"
#import "NIDropDown.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,assign)BOOL isEnterPlannerPopup;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,retain)UINavigationController *navController;
@property (nonatomic,retain) MHCustomTabBarController *tabBarController;
@property (nonatomic,strong) UserInfoViewController *objUserInfoControl;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property(nonatomic,retain)UINavigationController *homeNavigation,*profileNavigation,*shareNavigation,*helpNavigation,*plannerNavigation;
@property(nonatomic,retain)NSMutableDictionary *selectedFoodDict;
@property(nonatomic,retain)NSString *prevTotWeight;
@property(nonatomic,retain)UIButton *btnDropDown;
@property(nonatomic,retain)NIDropDown *dropDown;

@property (nonatomic, strong) NSString *plannerSession;
@property(nonatomic,retain)NSString *previousTab,*currentTab;


@end

