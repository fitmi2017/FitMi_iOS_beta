//
//  CalorieIntakeViewController.h
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NKColorSwitch.h"
@interface CalorieIntakeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) NSString *dailyCalIntakeVal_str,*previousNav;
@property (strong, nonatomic) IBOutlet UILabel *lblTop;

- (IBAction)btnActionSave:(id)sender;
- (IBAction)btnActionCancel:(id)sender;

@end
