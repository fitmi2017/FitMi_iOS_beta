//
//  DisplayViewController.h
//  FitMe
//
//  Created by Debasish on 18/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DisplayViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblTop;
@property (strong, nonatomic) IBOutlet UITableView *tblVw;
@property (strong, nonatomic)NSString *navClass;
@end
