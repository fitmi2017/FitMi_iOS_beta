//
//  CalorieViewController.h
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CalorieViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

- (IBAction)btnActionCancel:(id)sender;
- (IBAction)btnActionSave:(id)sender;

@property(nonatomic,strong) NSString *val_str,*val_str1;
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@property (strong, nonatomic) IBOutlet UILabel *lblTop;
@property (strong, nonatomic)NSString *navClass;
@end
