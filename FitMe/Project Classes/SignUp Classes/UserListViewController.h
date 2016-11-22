//
//  UserListViewController.h
//  FitMe
//
//  Created by Debasish on 31/07/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)btnActionAddNewUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNewUser;
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@property(strong,nonatomic)NSMutableArray *usersArr;

@end
