//
//  LogOtherFoodViewController.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 14/10/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodLog.h"
#import "MasterFood.h"
#import "Utility.h"
#import "ViewController.h"
@interface LogOtherFoodViewController : ViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) NSString *logTime;
@property (strong, nonatomic) NSString *meal_id;
@property (strong, nonatomic) NSString *previous_activity;
@property (strong, nonatomic) NSString *selectedMealId;
@end
