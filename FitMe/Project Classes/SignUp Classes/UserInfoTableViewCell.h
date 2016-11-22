//
//  UserInfoTableViewCell.h
//  FitMe
//
//  Created by Debasish on 28/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnBirthday;
@property (strong, nonatomic) IBOutlet UITextField *txtFldBDay_Month;
@property (strong, nonatomic) IBOutlet UITextField *txtFldBDay_Day;
@property (strong, nonatomic) IBOutlet UITextField *txtFldBDay_Year;

@property (weak, nonatomic) IBOutlet UITextField *txtFldActLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnActLevel;

@property (weak, nonatomic) IBOutlet UITextField *txtFldFeet;
@property (weak, nonatomic) IBOutlet UITextField *txtFldInch;
@property (weak, nonatomic) IBOutlet UITextField *txtFldUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnHeightUnit;

@property (weak, nonatomic) IBOutlet UITextField *txtFldCalIntake;

@property (strong, nonatomic) IBOutlet UITextField *txtFldWeight;
@property (strong, nonatomic) IBOutlet UITextField *txtFldWeightUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnWeightUnit;

@property (strong, nonatomic) IBOutlet UITextField *txtFldGenderVal;
@property (strong, nonatomic) IBOutlet UIButton *btnGenderVal;


@end
