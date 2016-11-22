//
//  WaterViewController.h
//  FitMe
//
//  Created by Debasish on 24/08/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WaterLog.h"
#import "Utility.h"
#import "DateUpperCustomView.h"
#import "ServerConnection.h"
@interface WaterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DateUpperCustomViewDelegate,ServerConnectionDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIButton *btnChangeUnit;
@property (nonatomic,strong) NSMutableArray *waterLogRecord;
@end
