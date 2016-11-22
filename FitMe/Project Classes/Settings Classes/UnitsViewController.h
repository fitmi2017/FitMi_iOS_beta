//
//  UnitsViewController.h
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface UnitsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *lblTop;
- (IBAction)btnActionCancel:(id)sender;
- (IBAction)btnActionSave:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@end
